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
    
    @IBAction func startTapped(_ sender: Any) {
        performSegue(withIdentifier: PropertyKeys.createPlayerSegue, sender: self)
    }
    


}

