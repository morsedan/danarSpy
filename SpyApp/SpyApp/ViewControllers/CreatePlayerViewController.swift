//
//  CreatePlayerViewController.swift
//  SpyApp
//
//  Created by morse on 2/2/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class CreatePlayerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var roleStackView: UIStackView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var roleLabel: UILabel!
    
    
    
    // MARK: - Properties
    
    var game: Game?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        requestName()
        
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard  let game = game else { return }
        if game.gameIsOver {
            nameStackView.isHidden = true
            roleStackView.isHidden = true
            dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func okTapped(_ sender: Any) {
        
        addOrContinue()
    }
    
    // MARK: - Private Methods
    
    private func addOrContinue() {
        
        guard let game = game else {
            // TODO: add alert that something went wrong
            return
        }
        
        if game.players.count < game.playerCount {
            
            requestName()
        } else {
            print("Added all players")
            performSegue(withIdentifier: PropertyKeys.eliminateSegue, sender: self)
        }
    }
    
    private func requestName() {
        
        nameTextField.text = ""
        nameTextField.becomeFirstResponder()
        roleStackView.isHidden = true
        nameStackView.isHidden = false
    }
    
    private func addPlayer(_ player: String) {
        
        guard let game = game else {
            // TODO: add alert that something went wrong
            return
        }
        let role = game.addPlayer(named: player)
        
        displayRole(with: role)
    }
    
    private func displayRole(with role: String) {
        
        roleLabel.text = "Role: \(role)"
        roleStackView.isHidden = false
        nameStackView.isHidden = true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let eliminatePlayerVC = segue.destination as? EliminatePlayerViewController else { return }
        
        eliminatePlayerVC.game = game
    }

}

// MARK: - Extensions

extension CreatePlayerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let name = nameTextField.text,
            !name.isEmpty else {
                // TODO: Add alert telling player to enter their name
                return true
        }
        
        addPlayer(name)
        
        return true
    }
    
    
}
