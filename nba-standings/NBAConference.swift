//
//  NBAConference.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/25/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

enum NBAConference: String {
    case east, west
}

extension NBAConference: CustomDebugStringConvertible {
    var debugDescription: String {
        return rawValue
    }
}
