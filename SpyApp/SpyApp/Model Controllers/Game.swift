//
//  Game.swift
//  SpyApp
//
//  Created by morse on 2/2/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation

protocol PassPlayersDelegate {
    func playerWasEliminated(player: String)
    func receivedRole(role: String)
    func gameFinished()
    func playerWasAdded()
}

class Game {
    
    // MARK: - Properties
    
    lazy var playerService = PlayerService()
    
    var actingAsGM: Bool = false
    var playerForDevice: Player?
    var players: [Player] = [] {
        didSet {
//            print("Game.players.didSet")
            delegate?.playerWasAdded()
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
    var roleDictionary: [String: String] = [:]
    var winner: String?
    
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
            players = players.sorted { $0.name < $1.name }
            activePlayers = players
            
            let role = currentGameItemPair.spyItem
            
            return role
        } else {
            let player = Player(name: name, role: .defender)
            if isThisDevice {
                playerForDevice = player
            }
            players.append(player)
            players = players.sorted { $0.name < $1.name }
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

// MARK: - Manager Logic

extension Game {
    func assignRoles() {
        
        // figure out roles
        // set the dict
        
        for player in players {
            if player == playerForDevice {
                roleDictionary["GM"] = player.name
                let messageData = createMessage(messageType: .assignRoles)
                playerService.send(message: messageData)
            }
        }
    }
    
    func broadcastEliminatedPlayer() {
        
        

    }
    
    func broadcastGameOver() {
        
    }
    
}

// MARK: - Client Logic

extension Game {
    func addSelfAsPlayer(named name: String) {
        addPlayer(named: name, isThisDevice: true)
        playerService.delegate = self
    }
    
    func receiveRole() {
        
        
//        roleDictionary =
    }
    
    func sendVote(for name: String) {
        
    }
    
    func eliminatePlayer() {
        
        //        guard let index = activePlayers.firstIndex(of: player) else { return true }
        //        activePlayers.remove(at: index)
    }
    func btEndGame() {
        
    }
    
    func resetGame() {
        
    }
}

extension Game: PlayerServiceDelegate {
    func parseData(_ data: Data) {
        parseMessage(data: data)
    }
    
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
        let playerNames = players.map { $0.name }
        
        if !playerNames.contains(playerName) {
            addPlayer(named: playerName, isThisDevice: false)
        } else {
            print("Did NOT add duplicate player")
        }
        
        print("Player count: \(players.count)")
    }
    
    
}

// MARK: - Messaging

enum MessageType: UInt8, Codable, CustomStringConvertible {
    case assignRoles = 0 // dict "name": "role" from GM
    
    case guessSpy = 1 // "name" if GM, tally votes-when match activePlayers.count send verdict
    case eliminatedPlayer = 2 // "name" or playerID or player if self name matches, display eliminated UI, everyone else eliminates it from activePlayers array
    case gameOver = 3 // announce winner .spy/.defender (RoleType)
    
    var description: String {
        switch  self {
        case .assignRoles: return "Assign roles"
        case .guessSpy: return "Guess Spy"
        case .eliminatedPlayer: return "Eliminate Player"
        case .gameOver: return "Next Turn"
        }
    }
}

extension Game {
    
    func createMessage(messageType: MessageType) -> Data {
        print("createMessage()")
        let messageBytes: [UInt8] = [messageType.rawValue]
        let messageTypeData = Data(messageBytes)
        var payload = Data()
        
        switch messageType {
            
        case .assignRoles:
            let encoder = JSONEncoder()
            do {
                payload = try encoder.encode(roleDictionary)
            } catch {
                print("ERROR: Failed to encode roles (\(roleDictionary)): \(error)")
            }
        case .guessSpy:
            let encoder = JSONEncoder()
            do {
                payload = try encoder.encode(players[0].name)
            } catch {
                print("ERROR: Failed to encode vote (\(players[0].name)): \(error)")
            }
            
        case .eliminatedPlayer:
            let encoder = JSONEncoder()
            do {
                payload = try encoder.encode(players[0].name)
            } catch {
                print("ERROR: Failed to encode vote (\(players[0].name)): \(error)")
            }
            
        case .gameOver:
            let encoder = JSONEncoder()
            do {
                payload = try encoder.encode(winner)
            } catch {
                print("ERROR: Failed to encode winner: \(error)")
            }
        }
        
        print("messData: \(messageTypeData as NSData)")
        print("payload: \(payload as NSData)")
        let messageData = messageTypeData + payload
        
        print(messageData as NSData)
        
        return messageData
    }
    
    func parseMessage(data: Data) {
        print("parseMessage(): data: \(data as NSData)")
        if let messageTypeData = data.first,
            let messageType = MessageType(rawValue: messageTypeData) {
            
            let payload = data.subdata(in: 1 ..< data.count)
            
            switch messageType {
                
            case .assignRoles:
                do {
                    let decoder = JSONDecoder()
                    let roles = try decoder.decode([String: String].self, from: payload)
                    
                    roleDictionary = roles
                    if let role = roleDictionary["GM"] {
                        delegate?.receivedRole(role: role)
                    }
                    
//                    for role in roles {
//                        print("\(role.key): \(role.value)")
//                    }
                    
                    // TODO: process next turn logic if gameMaster
                    
                } catch {
                    print("Error: invalid role data: \(payload as NSData)")
                }
            case .guessSpy:
                do {
                    let decoder = JSONDecoder()
                    let guess = try decoder.decode(String.self, from: payload)
                    print("My guess: \(guess)")
                    
                    // TODO: process next turn logic if gameMaster
                    
                } catch {
                    print("Error: invalid guess data: \(payload as NSData)")
                }
            case .eliminatedPlayer:
                do {
                    let decoder = JSONDecoder()
                    let playerName = try decoder.decode(String.self, from: payload)
                    print("Eliminated player: \(playerName)")
                    
                    // TODO: process next turn logic if gameMaster
                    
                } catch {
                    print("Error: invalid nextTurn data: \(payload as NSData)")
                }
                
                
            case .gameOver:
                do {
                    let decoder = JSONDecoder()
                    let winningRole = try decoder.decode(RoleType.self, from: payload)
                    let roleString = String(winningRole.rawValue)
                    print("Winning role: \(roleString.capitalized)")
                    
                    // TODO: process next turn logic if gameMaster
                    
                } catch {
                    print("Error: invalid nextTurn data: \(payload as NSData)")
                }
            }
        } else {
            print("Error: Message Type Data Missing")
        }
    }
}
