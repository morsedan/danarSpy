//
//  EliminatePersonViewController.swift
//  SpyApp
//
//  Created by morse on 2/4/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit



class BTEliminatePersonViewController: UIViewController {
    
    // MARK: - Outlets

    
    @IBOutlet weak var nameRoleLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var eliminateButton: UIButton!
    
    // MARK: - Properties
    
    var game: Game?
    var playersToPotentiallyEliminate: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
                self.eliminateButton.isHidden = false
                if self.playersToPotentiallyEliminate == ["You were eliminated"] {
                    self.eliminateButton.isHidden = true
                }
            }
        }
    }
    var winner = ""
    var currentPlayerName: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        game?.delegate = self
        
        nameRoleLabel.text = "\(currentPlayerName ?? "")"
        setUpPlayersToEliminate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let game = game else { return }
        if game.gameIsOver {
            pickerView.isHidden = true
            eliminateButton.isHidden = true
            
            dismiss(animated: false, completion: nil)
        }
    }
    
    func setUpPlayersToEliminate() {
        
        guard let game = game else { return }
        
        
        let allThePlayers = game.players.map { $0.name }
        
        playersToPotentiallyEliminate = allThePlayers.filter { $0 != game.playerForDevice?.name }
        
//        for player in game.players {
//            if player.name == game.playerForDevice?.name {
//
//            }
//        }
    }
    
    @IBAction func eliminateTapped(_ sender: Any) {
        eliminateButton.isHidden = true
        let playerIndex = pickerView.selectedRow(inComponent: 0)
        let player = playersToPotentiallyEliminate[playerIndex]
        guard let game = game else { return }
        if game.actingAsGM {
            game.gmRecieveVote(for: player)
        } else {
            game.sendVote(for: player)
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameOverVC = segue.destination as? BTGameOverViewController else { return }
        
        gameOverVC.game = game
        gameOverVC.winner = winner
    }

}

extension BTEliminatePersonViewController: PassPlayersDelegate {
    func playerWasAdded() {
        print("no")
    }
    
    func gameFinished(winner: String) {
        
        self.winner = winner
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: PropertyKeys.btGameOverSegue, sender: self)
        }
    }
    
    func playerWasEliminated(player: String) {
        // TODO display who was eliminated
        if let playerIndex = playersToPotentiallyEliminate.firstIndex(of: player) {
            let removedPlayer = playersToPotentiallyEliminate.remove(at: playerIndex)
            print("Actually removed \(removedPlayer)")
        } else {
            playersToPotentiallyEliminate = ["You were eliminated"]
            return
        }
        print("VC playerWasEliminated(\(player))")
    }
    
    func receivedRole(role: String) {
        print("Wrong, this is the eliminate view controller.")
    }
}

extension BTEliminatePersonViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return playersToPotentiallyEliminate.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let rowtext = playersToPotentiallyEliminate[row]
//        return NSAttributedString(string: rowText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//
//
//    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let rowtext = playersToPotentiallyEliminate[row]
        return NSAttributedString(string: rowtext, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
}
