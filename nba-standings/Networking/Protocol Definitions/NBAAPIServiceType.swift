//
//  NBAAPIServiceType.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/20/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

protocol NBAAPIServiceType {
    var apiClient: APIClientType { get }
    
    func getStandings(_ completion: @escaping (Result<[NBAStanding], Error>) -> Void) 
}
