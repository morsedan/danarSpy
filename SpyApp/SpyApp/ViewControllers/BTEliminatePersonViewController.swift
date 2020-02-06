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

    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Properties
    
    var game: Game?
    var playersToPotentiallyEliminate: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        game?.delegate = self
        
        setUpPlayersToEliminate()
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
    }

}

extension BTEliminatePersonViewController: PassPlayersDelegate {
    func playerWasAdded() {
        print("no")
    }
    
    func gameFinished() {
        performSegue(withIdentifier: PropertyKeys.btGameOverSegue, sender: self)
    }
    
    func playerWasEliminated(player: String) {
        // TODO display who was eliminated
        guard let playerIndex = playersToPotentiallyEliminate.firstIndex(of: player) else { return }
        
        playersToPotentiallyEliminate.remove(at: playerIndex)
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return playersToPotentiallyEliminate[row]
    }
}
