//
//  NBAStanding.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/25/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

struct NBAStanding {
    let teamId: String
    let shortName: String
    
    let city: String
    let nickname: String
    
    let fullName: String
    
    let conference: NBAConference
    let rank: Int
    
    let win: String
    let loss: String
}
