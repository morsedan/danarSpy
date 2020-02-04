//
//  EliminatePersonViewController.swift
//  SpyApp
//
//  Created by morse on 2/4/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit



class BTEliminatePersonViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var playersIDLabel: UILabel!
    
    // MARK: - Properties
    
    var game: Game?
    let playerService = PlayerService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerService.delegate = game
        game?.delegate = self
//        print(playerService.delegate.debugDescription)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension BTEliminatePersonViewController: PassPlayersDelegate {
    func playersWerePassed(players: [Player]) {
        print("playersWerePassed")
        DispatchQueue.main.async {
            self.playersIDLabel.text = String(players.count)
            players.map { print($0.name) }
        }
    }
    
    
}
