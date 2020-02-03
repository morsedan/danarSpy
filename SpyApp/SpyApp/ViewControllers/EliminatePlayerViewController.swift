//
//  EliminatePlayerViewController.swift
//  SpyApp
//
//  Created by morse on 2/2/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class EliminatePlayerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var playerPickerView: UIPickerView!
    @IBOutlet weak var eliminateButton: UIButton!
    
    // MARK: - Properties
    
    var game: Game?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        playerPickerView.delegate = self
        playerPickerView.dataSource = self
        pickerView(playerPickerView, didSelectRow: 0, inComponent: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard  let game = game else { return }
        if game.gameIsOver {
            stackView.isHidden = true
            dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func eliminateTapped(_ sender: Any) {
        
        eliminatePlayer()
    }
    
    // MARK: - Private Methods
    
    private func eliminatePlayer() {
        guard let game = game else { return }
        let index = playerPickerView.selectedRow(inComponent: 0)
        let player = game.activePlayers[index]
        
        let shouldContinue = game.eliminatePlayerAndContinue(player)
        print(game.playerCount, game.activePlayers.count, game.activePlayers)
        if !shouldContinue {
            performSegue(withIdentifier: PropertyKeys.gameOverSegue, sender: self)
        } else {
            playerPickerView.reloadAllComponents()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let gameOverVC = segue.destination as? GameOverViewController else { return }
        
        gameOverVC.game = game
    }

}

// MARK: - Extensions

extension EliminatePlayerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let game = game else { return 0 }
        
        return game.activePlayers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let game = game else { return nil }
        
        let name = game.activePlayers[row].name
        
        return name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let game = game else { return }
        
        let name = game.activePlayers[row].name
        eliminateButton.setTitle("Eliminate \(name)", for: .normal)
    }
}
