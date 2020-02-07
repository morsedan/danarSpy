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
    var winner = ""
    
    // MARK: - Properties
    
    var game: Game?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        game?.gameIsOver = true
    }
    
    func updateViews() {
        
        switch winner {
        case "Defenders":
            wonLabel.text = "Defenders win!"
        case "Spy":
            wonLabel.text = "Spy wins!"
        default:
            wonLabel.text = ""
        }
    }
    
    @IBAction func playAgainTapped(_ sender: Any) {
        game?.resetGame()
//        game.
        dismiss(animated: true, completion: nil)
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
