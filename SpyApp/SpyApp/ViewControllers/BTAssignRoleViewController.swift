//
//  AssignRoleViewController.swift
//  SpyApp
//
//  Created by morse on 2/5/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class BTAssignRoleViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var roleStackView: UIStackView!
    
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var playersLabel: UILabel!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle Methods
    
    var game: Game? {
        didSet {
            print("Got the game in assignRole!")
        }
    }
    
    var currentPlayerName: String?
//    let playerService = PlayerService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard let game = game else { return }
//        playerService.delegate = game
        game.delegate = self
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let game = game else { return }
        if game.gameIsOver {
            nameStackView.isHidden = true
            roleStackView.isHidden = true
            
            dismiss(animated: false, completion: nil)
        }
    }
    
    func updateViews() {
        roleStackView.isHidden = true
        guard let game = game else { return }
        
        
        
        let playersArray = game.players.map { $0.name }
        playersLabel.text = playersArray.joined(separator: ", ")
    }
     
    // MARK: - Actions
    
    @IBAction func playersOKTapped(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        guard let myName = userDefaults.string(forKey: PropertyKeys.displayNameKey),
            let game = game,
            let gm = game.players.first else { return }
        
        let gmName = gm.name
        
        if myName == gmName {
            game.actingAsGM = true
            game.assignRoles()
        }
        nameStackView.isHidden = true
    }
    
    @IBAction func roleOKTapped(_ sender: Any) {
        performSegue(withIdentifier: PropertyKeys.btEliminateSegue, sender: self)
    }
    
    // MARK: - Private Methods
    
    private func roleReceived(role: String) {
        DispatchQueue.main.async {
            self.nameStackView.isHidden = true
            self.roleStackView.isHidden = false
            
            self.roleLabel.text = role
        }
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let eliminateVC = segue.destination as? BTEliminatePersonViewController else { return }
        
        eliminateVC.game = game
        eliminateVC.currentPlayerName = currentPlayerName
    }
    

}

extension BTAssignRoleViewController: PassPlayersDelegate {
    func playerWasAdded() {
        guard let game = game else { return }
        let playersArray = game.players.map { $0.name }
        DispatchQueue.main.async {
            self.playersLabel.text = playersArray.joined(separator: ", ")
        }
        
    }
    
    func playerWasEliminated(player: String) {
        print("Wrong view controller")
    }
    
    func gameFinished(winner: String) {
        print("Wrong view controller")
    }
    
    func receivedRole(role: String) {
        roleReceived(role: role)
    }
    
    
    
    
}
