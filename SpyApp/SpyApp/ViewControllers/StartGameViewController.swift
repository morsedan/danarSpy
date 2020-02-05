//
//  ViewController.swift
//  SpyApp
//
//  Created by morse on 2/2/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class StartGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        clearUserDefaults()
//        UserDefaults.standard.setValue("", forKey: PropertyKeys.displayNameKey)
    }
    
    func clearUserDefaults() {
        
//        guard let domain = Bundle.main.bundleIdentifier else { return }
//        UserDefaults.standard.removeObject(forKey: PropertyKeys.displayNameKey)
//        UserDefaults.standard.synchronize()
//        print(UserDefaults.standard.dictionaryRepresentation().keys)
    }
    
    @IBAction func startTapped(_ sender: Any) {
        performSegue(withIdentifier: PropertyKeys.setCountSegue, sender: self)
    }
    


}

