//
//  Player.swift
//  SpyApp
//
//  Created by morse on 2/2/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum RoleType: String, Codable {
    case spy = "Spy"
    case defender = "Defender"
}

struct Player: Codable, Equatable {
    let name: String
    let id: String = UUID().uuidString
    let role: RoleType
    var roleString: String = ""
    var eliminatedInRound: Int = 0
    var voteCount = 0
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name
    }
}
