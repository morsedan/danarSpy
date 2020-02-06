//
//  BTGameOverViewController.swift
//  SpyApp
//
//  Created by morse on 2/5/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class BTGameOverViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var wonLabel: UILabel!
    
    // MARK: - Properties
    
    var game: Game?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func updateViews() {
        switch game?.winningTeam {
        case .defender:
            wonLabel.text = "Defenders win!"
        case .spy:
            wonLabel.text = "Spy wins!"
        case .none:
            wonLabel.text = ""
        }
    }
    
    @IBAction func playAgainTapped(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
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
