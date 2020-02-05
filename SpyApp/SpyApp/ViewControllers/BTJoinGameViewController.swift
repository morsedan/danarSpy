//
//  JoinGameViewController.swift
//  SpyApp
//
//  Created by morse on 2/4/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class BTJoinGameViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var waitingStackView: UIStackView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playersIDLabel: UILabel!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle Methods
    
    let game = Game()
    let playerService = PlayerService()
    var name: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerService.delegate = game
        game.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func waitingOKTapped(_ sender: Any) {
        
    }
    
    // MARK: - Private Methods
    
    func createOrJoinGame() {
        let userDefaults = UserDefaults.standard
        guard let name = userDefaults.string(forKey: PropertyKeys.displayNameKey) else { return }
        game.addPlayer(named: name, isThisDevice: true)
        print("game.players.count: \(game.players.count)")
        displayPlayers()
    }
    
    // MARK: - Private Methods
    
    private func displayPlayers() {
//        nameStackView.isHidden = true
        waitingStackView.isHidden = false
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let getRoleVC = segue.destination as? BTEnterNameViewController else { return }
        getRoleVC.game = game
    }
    

}

extension BTJoinGameViewController: PassPlayersDelegate {
    func playersWerePassed(players: [Player]) {
        print("playersWerePassed")
        let playerNames = players.compactMap { $0.name }
        DispatchQueue.main.async {
            self.playersIDLabel?.text = playerNames.joined(separator: ", ")
        }
    }
    
    
}

extension BTJoinGameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        createOrJoinGame()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(textField.text)
    }
}
