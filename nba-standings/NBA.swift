//
//  NBA.swift
//  nba-standings
//
//  Created by Tom OMalley on 12/9/19.
//  Copyright © 2019 37th Street. All rights reserved.
//

import Foundation

struct NBA {
    static let empty = NBA(year: "", timestamp: "", easternConference: [], westernConference: [])
    
    let year: String
    let timestamp: String 

    var easternConference: [Team]
    var westernConference: [Team]

    struct Team: Decodable {
        let abbreviation: String

        let city: String
        let nickname: String
        var fullName: String {
            switch abbreviation {
            // naturally LA teams have dodgy data :eyeroll:
            case "LAC": return "L.A. Clippers"
            case "LAL": return "L.A. Lakers"
            default:    return "\(city) \(nickname)"
            }
        }

        let stats: Stats

        enum CodingKeys: String, CodingKey {
            case abbreviation
            case city = "name"
            case nickname
            case stats = "team_stats"
        }
    }

    struct Stats: Decodable {
        let wins: String
        let losses: String
        let rank: String
    }
}
