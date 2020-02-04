//
//  Player.swift
//  SpyApp
//
//  Created by morse on 2/2/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation

enum RoleType: String, Codable {
    case spy = "Spy"
    case defender = "Defender"
}

struct Player: Codable, Equatable {
    let name: String
    let id: String = UUID().uuidString
    let role: RoleType
    var isStillPlaying: Bool
    var eliminatedInRound: Int = 0
}
