//
//  NBADataService.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/20/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

class NBAAPIService {
    var apiClient = NBAAPIClient() // : APIClientType = NBAAPIClient()
    
    func getStandings(_ completion: @escaping (Result<NBA, Error>) -> Void) {
        apiClient.request(NBAAPIEndpoint.standings) { result in
            switch result {
            case .success(let data):
                do {
                    let standingsResponse = try JSONDecoder().decode(StandingsResponse.self, from: data)
                    print(standingsResponse.rawTeams)
                } catch {
                    print(error)
                    print("")
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
                break
            }
        }
        
        
    }
}

private extension NBAAPIService {
    
    struct RawTeam: Decodable {
        let teamId: String
        let win: String
        let loss: String
        let conference: RawConference
        struct RawConference: Decodable {
            let name: String
            let rank: String
        }
    }

    struct StandingsResponse: Decodable {
        enum CodingKeys: String, CodingKey {
            case api
            case standings
        }
        
        let rawTeams: [RawTeam]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let api = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .api)
            self.rawTeams = try api.decode([RawTeam].self, forKey: .standings)
        }
    }
}

private extension NBAAPIService {
    struct TeamMetaData {
        
    }
    
    struct TeamMetaDataResponse: Decodable {
        
    }
}
