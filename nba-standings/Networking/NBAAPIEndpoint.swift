//
//  NBAAPIEndpoint.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/20/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

enum NBAAPIEndpoint: EndpointType {
    case standings
    case leagueMetadata
    
    var baseURL: String {
        return "https://api-nba-v1.p.rapidapi.com"
    }
    
    var path: String {
        switch self {
        case .standings:        return "/standings/standard/2019"
        case .leagueMetadata:   return "/teams/league/standard"
        }
    }
    
    var headers: [String: String]? {
        return [ // all share/need same headers
            "x-rapidapi-host": "api-nba-v1.p.rapidapi.com",
            "x-rapidapi-key": "3d080cca40msh215e1a2b59534b0p15b3a5jsn4a3f0a7ae5b4"
        ]
    }
    
    var httpMethod: HTTPMethod {
        return .get // currently only GETs
    }
}
