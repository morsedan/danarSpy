//
//  SpyAppGameTests.swift
//  SpyAppGameTests
//
//  Created by morse on 2/2/20.
//  Copyright © 2020 morse. All rights reserved.
//

import XCTest
@testable import SpyApp

class SpyAppGameTests: XCTestCase {

    func testAddPlayerReturnsARole() {
        let game = Game()
        game.startGame(with: 6)
        let role = game.addPlayer(named: "Ed")
        
        XCTAssert(!role.isEmpty)
        XCTAssertNotEqual(role, "Error")
    }
    
    func testGameAddPlayers() {
        let game = Game()
        game.startGame(with: 6)
        createSixPlayers(in: game)
        
        XCTAssertEqual(game.players.count, 6)
    }
    
    func testSetOnePlayerAsSpy() {
        let game = Game()
        game.startGame(with: 6)
        var spyCount = 0
        var defenderCount = 0
        createSixPlayers(in: game)
        
        for player in game.players {
            if player.role == .spy {
                spyCount += 1
            } else if player.role == .defender {
                defenderCount += 1
            } else {
                print("Trouble! This player (\(player.id))is neither a spy nor a defender")
            }
        }
        
        XCTAssertEqual(spyCount, 1)
        XCTAssertEqual(defenderCount, 5)
        XCTAssertEqual(game.players.count - 1, 5)
    }
    
    func testElimnateAPlayer() {
        let game = Game()
        game.startGame(with: 6)
        createSixPlayers(in: game)
        
        var activePlayerCount = 0
        var eliminatedPlayerCount = 0
        
        for player in game.players {
            if player.isStillPlaying {
                activePlayerCount += 1
            } else {
                eliminatedPlayerCount += 1
            }
        }
        
        XCTAssertEqual(activePlayerCount, 6)
        XCTAssertEqual(eliminatedPlayerCount, 0)
        
        guard let playerToEliminate = game.players.first else {
            XCTFail()
            return
        }
        game.eliminatePlayer(playerToEliminate)
        
        activePlayerCount = 0
        for player in game.players {
            if player.isStillPlaying {
                activePlayerCount += 1
            } else {
                eliminatedPlayerCount += 1
            }
        }
        
        XCTAssertEqual(activePlayerCount, 5)
        XCTAssertEqual(eliminatedPlayerCount, 1)
    }
    
    
    
    
    
    
    
    
    
    private func createSixPlayers(in game: Game) {
        game.addPlayer(named: "Ted")
        game.addPlayer(named: "Ned")
        game.addPlayer(named: "Ed")
        game.addPlayer(named: "Red")
        game.addPlayer(named: "Jed")
        game.addPlayer(named: "Fred")
    }

}
