//
//  SetPlayerCountViewController.swift
//  SpyApp
//
//  Created by morse on 2/2/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class SetPlayerCountViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var playerCountPickerView: UIPickerView!
    
    // MARK: - Properties
    
    let game = Game()
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        playerCountPickerView.dataSource = self
        playerCountPickerView.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func playTapped(_ sender: Any) {
        let playerCount = playerCountPickerView.selectedRow(inComponent: 0) + 3
        print(playerCount)
        game.startGame(with: playerCount)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let createPlayerVC = segue.destination as? CreatePlayerViewController else { return }
        
        
    }

}

extension SetPlayerCountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 8
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 3)
    }
    
}
