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
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
            
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(identifier: "WalkthroughViewController") as? WalkthroughViewController {
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func startTapped(_ sender: Any) {
        performSegue(withIdentifier: PropertyKeys.setCountSegue, sender: self)
    }
    
    @IBAction func localPlayerTapped(_ sender: Any) {
        performSegue(withIdentifier: PropertyKeys.btAssignRolesSegue, sender: self)
    }


}

