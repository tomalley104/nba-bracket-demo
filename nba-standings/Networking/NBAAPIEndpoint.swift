//
//  NBAAPIEndpoint.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/20/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

enum NBAAPIEndpoint: EndpointType {
    case standingsAll
    case standingsEast
    case standingsWest
    
    var baseURL: String {
        return "https://api-nba-v1.p.rapidapi.com"
    }
    
    var path: String {
        switch self {
        case .standingsAll:  return "/standings/standard/2019"
        case .standingsEast: return "/standings/standard/2019/conference/east"
        case .standingsWest: return "/standings/standard/2019/conference/west"
        }
    }
    
    var headers: [String: String]? {
        // all share/need same headers
        return [
            "x-rapidapi-host": "api-nba-v1.p.rapidapi.com",
            "x-rapidapi-key": "3d080cca40msh215e1a2b59534b0p15b3a5jsn4a3f0a7ae5b4"
        ]
    }
    
    var httpMethod: HTTPMethod {
        return .get // currently all GET requests
    }
}
