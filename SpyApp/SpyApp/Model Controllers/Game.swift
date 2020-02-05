//
//  Game.swift
//  SpyApp
//
//  Created by morse on 2/2/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation

protocol PassPlayersDelegate {
    func playersWerePassed(players: [Player])
}

class Game {`
    
    // MARK: - Properties
    
    var actingAsGM: Bool = false
    var playerForDevice: Player?
    var players: [Player] = [] {
        didSet {
            print("Game.players.didSet")
            
            delegate?.playersWerePassed(players: players)
        }
    }
    lazy var activePlayers: [Player] = []
    var playerCount: Int = 0
    var gameIsOver = false
    private var spyPlayerIndex: Int = 0
    private let itemPairs = [ItemPair(spyItem: "Pie", defenderItem: "Cake"),
                             ItemPair(spyItem: "Oak Tree", defenderItem: "Pine Tree"),
                             ItemPair(spyItem: "Taxi", defenderItem: "Bus"),
                             ItemPair(spyItem: "Leaf", defenderItem: "Flower"),
                             ItemPair(spyItem: "Dog", defenderItem: "Cat"),
                             ItemPair(spyItem: "Car", defenderItem: "Truck"),
                             ItemPair(spyItem: "Motorcycle", defenderItem: "Car"),
                             ItemPair(spyItem: "Coupe", defenderItem: "Sedan"),
                             ItemPair(spyItem: "Cat", defenderItem: "Mouse"),
                             ItemPair(spyItem: "Paw", defenderItem: "Hand"),
                             ItemPair(spyItem: "Table", defenderItem: "Chair"),
                             ItemPair(spyItem: "Plate", defenderItem: "Bowl"),
                             ItemPair(spyItem: "Textbook", defenderItem: "Notebook"),
                             ItemPair(spyItem: "Lion", defenderItem: "Tiger"),
                             ItemPair(spyItem: "Horse", defenderItem: "Mule"),
                             ItemPair(spyItem: "Apple", defenderItem: "Orange")]
    private var itemPairsToChooseFrom: [ItemPair] = []
    lazy private var currentGameItemPair: ItemPair = {
        
        print("Setting currentGameItemPair!")
        if itemPairsToChooseFrom.isEmpty {
            itemPairsToChooseFrom = itemPairs
        }
        let index = Int.random(in: 0..<itemPairsToChooseFrom.count)
        
        return itemPairsToChooseFrom.remove(at: index)
    }()// TODO: Change this to be dynamic
    var winningTeam: RoleType?
    var delegate: PassPlayersDelegate?
    
    // MARK: - Game Methods
    
    func startGame(with playerCount: Int) {
        // TODO: This needs to be broken up for beginning a BT game
        gameIsOver = false
        players = []
        activePlayers = []
        self.playerCount = playerCount
        self.spyPlayerIndex = Int.random(in: 0..<playerCount)
        currentGameItemPair = setItemPair()
    }
    
    @discardableResult func addPlayer(named name: String, isThisDevice: Bool) -> String {
        // TODO: This needs to be broken up for beginning a BT game
//        currentGameItemPair = setItemPair()
        
        
        if players.count == spyPlayerIndex {
            let player =  Player(name: name, role: .spy)
            if isThisDevice {
                playerForDevice = player
            }
            players.append(player)
            activePlayers = players
            
            let role = currentGameItemPair.spyItem
            
            return role
        } else {
            let player = Player(name: name, role: .defender)
            if isThisDevice {
                playerForDevice = player
            }
            players.append(player)
            activePlayers = players
            
            let role = currentGameItemPair.defenderItem
            
            return role
        }
    }
    
    func eliminatePlayerAndContinue(_ player: Player) -> Bool {
        
        //        guard let index = players.firstIndex(of: player) else { return false }
        //        players[index].isStillPlaying = false
        
        guard let index = activePlayers.firstIndex(of: player) else { return true }
        activePlayers.remove(at: index)
        
        guard let playerIndex = players.firstIndex(of: player) else { return true }
        players[playerIndex].eliminatedInRound = players.count - activePlayers.count
        
        if player.role == .spy {
            endGame()
            return false
        } else if activePlayers.count <= 2 {
            winningTeam = .defender
            endGame()
            return false
        }
        return true
    }
    
    func endGame() {
        gameIsOver = true
        print("endGame.activePlayers: \(activePlayers)")
        let spyCount = activePlayers.filter { $0.role == .spy }.count
        if spyCount >= 1 {
            winningTeam = .spy
            print("Spy wins!")
        } else {
            winningTeam = .defender
            print("Defenders win!")
        }
    }
    
    // MARK: - Private Methods
    
    private func setItemPair() -> ItemPair {
        if itemPairsToChooseFrom.isEmpty {
            itemPairsToChooseFrom = itemPairs
        }
        let index = Int.random(in: 0..<itemPairsToChooseFrom.count)
        
        return itemPairsToChooseFrom.remove(at: index)
    }
    
    
    
    
    
    
    
    
    
}

extension Game: PlayerServiceDelegate {
    func connectedDevicesChanged(manager: PlayerService, connectedDevices: [String]) {
        print("connectedDevicesChanged: \(connectedDevices.count)")
        for connectedDevice in connectedDevices {
            addPlayer(named: connectedDevice, isThisDevice: false)
        }

        let nameArray = players.compactMap { $0.name }
        let names = Array(Set<String>(nameArray))
        var tempPlayers: [Player] = []
        for name in names {
            if let playerIndex = names.firstIndex(of: name) {
                tempPlayers.append(players[playerIndex])
            }
        }
        players = tempPlayers.sorted { $0.name < $1.name } // Set spyPlayerIndex?
        print(players.compactMap { $0.name })
        
    }
    
    func playersChanged(manager: PlayerService, players: /*(*/[Player]/*, ItemPair)*/) {
//        self.players = players
//        print(players)
    }
    
    func newPlayerJoined(playerName: String) {
        addPlayer(named: playerName, isThisDevice: false)
    }
    
    
}
