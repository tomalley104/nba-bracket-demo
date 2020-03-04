//
//  NBAStanding.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/25/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

struct NBAStanding {
    let team: NBATeam
    let conference: NBAConference
    let rank: Int
    
    let win: String
    let loss: String
}

// Not complex enough for its own file; only relevant here. 
enum NBAConference: String {
    case east, west
}

extension NBAConference: CustomDebugStringConvertible {
    var debugDescription: String {
        return rawValue
    }
}

