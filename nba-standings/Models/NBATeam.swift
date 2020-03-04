//
//  NBATeam.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/27/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

struct NBATeam: Decodable {
    let teamId: String
    let shortName: String

    let city: String
    let nickname: String

    let fullName: String
}
