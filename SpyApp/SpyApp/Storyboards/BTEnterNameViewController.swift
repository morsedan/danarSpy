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
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var nameStackView: UIStackView!
    
    // MARK: - Properties
    
    let game = Game()
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        requestName()
        checkForPeers()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if game.gameIsOver {
            nameStackView.isHidden = true
//            game.deinit
            dismiss(animated: false, completion: nil)
        }
    }
    
    func checkForPeers() {
//        let connectedPeers = game.playerService.session.connectedPeers
//        let userDefaults = UserDefaults.standard
//        let myPeerName = userDefaults.string(forKey: PropertyKeys.displayNameKey)
//
//        if !connectedPeers.isEmpty {
//            for connectedPeer in connectedPeers {
//                print(connectedPeer)
//                if connectedPeer.displayName == myPeerName {
//                    self.performSegue(withIdentifier: PropertyKeys.btAssignRolesSegue, sender: self)
//                }
//            }
//        }
    }
    

    func setPeerIDName() {

        guard let name = nameTextField.text,
            !name.isEmpty else { return }
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(name, forKey: PropertyKeys.displayNameKey)
        
        game.addSelfAsPlayer(named: name)
//        game.addPlayer(named: name, isThisDevice: true)
//        print(userDefaults.string(forKey: PropertyKeys.displayNameKey))
    }
    
    private func requestName() {
        
        nameTextField.text = ""
        nameTextField.becomeFirstResponder()
//        roleStackView.isHidden = true
        nameStackView.isHidden = false
    }
    
//    private func displayRole(with role: String) {
//
//        roleLabel.text = "Role: \(role)"
//        roleStackView.isHidden = false
//        nameStackView.isHidden = true
//    }
//
    // MARK: - Actions
    
    @IBAction func okTapped(_ sender: Any) {
//        performSegue(withIdentifier: PropertyKeys.btEliminateSegue, sender: self)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: PropertyKeys.btAssignRolesSegue, sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let roleVC = segue.destination as? BTAssignRoleViewController else { return }
        
        roleVC.game = game
    }
    

}

extension BTEnterNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        setPeerIDName()
        performSegue(withIdentifier: PropertyKeys.btAssignRolesSegue, sender: self)
        return true
    }
}
