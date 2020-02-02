//
//  Game.swift
//  SpyApp
//
//  Created by morse on 2/2/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation

class Game {
    var players: [Player] = []
        lazy var activePlayers = players.filter { $0.isStillPlaying }
        var playerCount: Int = 0
        private var spyPlayerIndex: Int = 0
        private let itemPairs = [ItemPair(spyItem: "Pie", defenderItem: "Cake"),
                         ItemPair(spyItem: "Oak Tree", defenderItem: "Pine Tree"),
                         ItemPair(spyItem: "Taxi", defenderItem: "Bus"),
                         ItemPair(spyItem: "Leaf", defenderItem: "Flower"),
                         ItemPair(spyItem: "Dog", defenderItem: "Cat"),
                         ItemPair(spyItem: "Car", defenderItem: "Truck"),
                         ItemPair(spyItem: "Motercycle", defenderItem: "Car"),
                         ItemPair(spyItem: "Coupe", defenderItem: "Sedan"),
                         ItemPair(spyItem: "Cat", defenderItem: "Mouse"),
                         ItemPair(spyItem: "Paw", defenderItem: "Hand"),
                         ItemPair(spyItem: "Table", defenderItem: "Chair"),
                         ItemPair(spyItem: "Plate", defenderItem: "Bowl"),
                         ItemPair(spyItem: "Textbood", defenderItem: "Notebook"),
                         ItemPair(spyItem: "Lion", defenderItem: "Tiger"),
                         ItemPair(spyItem: "Horse", defenderItem: "Mule"),
                         ItemPair(spyItem: "Apple", defenderItem: "Orange")]
        private var itemPairsToChooseFrom: [ItemPair] = []
        private var currentGameItemPair: ItemPair?
        
    //    init(playerCount: Int) {
    //        self.playerCount = playerCount
    //        self.spyPlayerIndex = Int.random(in: 0..<playerCount)
    //    }
        
        func startGame(with playerCount: Int) {
            players = []
            self.playerCount = playerCount
            self.spyPlayerIndex = Int.random(in: 0..<playerCount)
            currentGameItemPair = setItemPair()
        }
        
        func addPlayer(named name: String) -> String {
            
            guard let itemPair = currentGameItemPair else { return "Error"}
            
            if players.count == spyPlayerIndex {
                let player = Player(name: name, role: .spy, isStillPlaying: true)
                players.append(player)
                
                let role = itemPair.spyItem
                
                return role
            } else {
                let player = Player(name: name, role: .defender, isStillPlaying: true)
                players.append(player)
                
                let role = itemPair.defenderItem
                
                return role
            }
        }
        
        func eliminatePlayer(_ player: Player) {
            
            guard let index = players.firstIndex(of: player) else { return }
            players[index].isStillPlaying = false
            
            if player.role == .spy {
                endGame()
            } else if activePlayers.count <= 2 {
                endGame()
            }
            // TODO: Check if <= 2 active players and end if true
        }
        
        func endGame() {
            let spyCount = activePlayers.filter { $0.role == .spy }.count
            if spyCount <= 1 {
                print("Spy wins!")
            } else {
                print("Defenders win!")
            }
        }
        
        
        
        
        private func setItemPair() -> ItemPair {
            if itemPairsToChooseFrom.isEmpty {
                itemPairsToChooseFrom = itemPairs
            }
            let index = Int.random(in: 0..<itemPairsToChooseFrom.count)
            
            return itemPairsToChooseFrom.remove(at: index)
        }
}
