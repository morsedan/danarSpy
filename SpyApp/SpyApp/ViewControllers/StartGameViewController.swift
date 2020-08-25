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
        
        checkUserDefaultsName()
        //        UserDefaults.standard.setValue("", forKey: PropertyKeys.displayNameKey)
//        print(UserDefaults.standard.string(forKey: PropertyKeys.displayNameKey))
    }
    
    func setName() {
        UserDefaults.standard.set(UUID().uuidString, forKey: PropertyKeys.displayNameKey)
    }
    
    func checkUserDefaultsName() {
        guard let displayName = UserDefaults.standard.string(forKey: PropertyKeys.displayNameKey),
            let _ = UUID(uuidString: displayName) else {
                print("Changing ID")
                setName()
                return
        }
        print("ID OK")
//        if displayName.count != 36 {
//            setName()
//        }
        
        
        //        guard let domain = Bundle.main.bundleIdentifier else { return }
        //        UserDefaults.standard.removeObject(forKey: PropertyKeys.displayNameKey)
        //        UserDefaults.standard.synchronize()
//        print(UserDefaults.standard.dictionaryRepresentation().keys)
    }
    
    @IBAction func startTapped(_ sender: Any) {
        performSegue(withIdentifier: PropertyKeys.setCountSegue, sender: self)
    }
    
    
    
}

