//
//  NBATeam.swift
//  nba-standings
//
//  Created by Tom OMalley on 12/8/19.
//  Copyright © 2019 37th Street. All rights reserved.
//

import Foundation

struct NBATeam: Decodable {
    var name: String
    var nickname: String
    var tricode: String


    var win: Int
    var loss: Int
    var gamesBehind: Double

    // var confRank: String
    // var divRank: String
    // var isWinStreak: Bool

    enum CodingKeys: String, CodingKey {
        case name = "teamName"
        case nickname = "teamNickname"
        case tricode = "teamTricode"

        case win
        case loss
        case gamesBehind

        case idSubContainer = "teamSitesOnly" // contains name, nickname, tricode
    }
//
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let idSubContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .idSubContainer)
        let name = try idSubContainer.decode(String.self, forKey: .name)
        let nickname = try idSubContainer.decode(String.self, forKey: .nickname)
        let tricode = try idSubContainer.decode(String.self, forKey: .tricode)

        let winString = try container.decode(String.self, forKey: .win)
        let lossString = try container.decode(String.self, forKey: .loss)
        let gamesBehindString = try container.decode(String.self, forKey: .gamesBehind)

        guard let win = Int(winString),
            let loss = Int(lossString),
            let gamesBehind = Double(gamesBehindString) else {
                let context = DecodingError.Context(codingPath: [CodingKeys.win, CodingKeys.loss, CodingKeys.gamesBehind],
                                                    debugDescription: "Couldn't convert win/loss from String to Int. Check raw response.")

                throw DecodingError.typeMismatch(String.self, context)
        }

        self.init(name: name, nickname: nickname, tricode: tricode, win: win, loss: loss, gamesBehind: gamesBehind)
    }

    private init(name: String,
                 nickname: String,
                 tricode: String,
                 win: Int,
                 loss: Int,
                 gamesBehind: Double) {
        self.name = name
        self.nickname = nickname
        self.tricode = tricode
        self.win = win
        self.loss = loss
        self.gamesBehind = gamesBehind
    }
}
