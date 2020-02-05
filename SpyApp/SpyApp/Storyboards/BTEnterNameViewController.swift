//
//  BTEnterNameViewController.swift
//  SpyApp
//
//  Created by morse on 2/4/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class BTEnterNameViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var roleLabel: UILabel!
    
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var roleStackView: UIStackView!
    
    // MARK: - Properties
    
    let game = Game()
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        requestName()
    }
    

    func createOrJoinGame() {
        guard let name = nameTextField.text,
            !name.isEmpty else { return }
        let role = game.addPlayer(named: name, isThisDevice: true)
        print("game.players.count: \(game.players.count)")
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(name, forKey: PropertyKeys.displayNameKey)
        
        displayRole(with: role)
    }
    
    private func requestName() {
        
        nameTextField.text = ""
        nameTextField.becomeFirstResponder()
        roleStackView.isHidden = true
        nameStackView.isHidden = false
    }
    
    private func displayRole(with role: String) {
        
        roleLabel.text = "Role: \(role)"
        roleStackView.isHidden = false
        nameStackView.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func okTapped(_ sender: Any) {
        performSegue(withIdentifier: PropertyKeys.btEliminateSegue, sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let eliminateVC = segue.destination as? BTEliminatePersonViewController else { return }
        
        eliminateVC.game = game
    }
    

}

extension BTEnterNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        createOrJoinGame()
        return true
    }
}