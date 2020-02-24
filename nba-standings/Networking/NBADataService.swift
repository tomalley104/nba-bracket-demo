//
//  NBADataService.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/20/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

class NBADataService {
    var apiClient: APIClientType = NBAAPIClient()
    
    func getStandings(_ completion: @escaping (Result<NBA, Error>) -> Void) {
        apiClient.request(NBAAPIEndpoint.standingsAll) { result in
            switch result {
            case .success(let data):
                // TODO: decode 
                print(try? JSONSerialization.jsonObject(with: data, options: []))
            case .failure(let error):
                print(error)
                completion(.failure(error))
                break
            }
        }
    }
}
