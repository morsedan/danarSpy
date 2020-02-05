//
//  BTTypeNameViewController.swift
//  SpyApp
//
//  Created by morse on 2/4/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class BTTypeNameViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
    }
    
    func setName() {
//        guard let name = nameTextField.text,
//            !name.isEmpty else { return }
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(name, forKey: PropertyKeys.displayNameKey)
    }
    
    @IBAction func okTapped(_ sender: Any) {
//        let userDefaults = UserDefaults.standard
//        let name = userDefaults.string(forKey: PropertyKeys.displayNameKey)
//        print(name)
        performSegue(withIdentifier: PropertyKeys.showWaitingSegue, sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BTTypeNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
//        createOrJoinGame()
        okTapped(textField)
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        print(text)
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(text, forKey: PropertyKeys.displayNameKey)
    }
}
