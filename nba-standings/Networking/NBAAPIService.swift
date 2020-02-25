//
//  NBADataService.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/20/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

class NBAAPIService {
    var apiClient: APIClientType = NBAAPIClient.default
    
    func getStandings(_ completion: @escaping (Result<[NBAStanding], Error>) -> Void) {
        getRawStandings { [weak self] standingsResult in
            switch standingsResult {
                case .success(let rawStandings):

                    self?.getLeagueMetaData() { metaResult in
                        switch metaResult {
                            case .success(let teamsMeta):

                                let standings: [NBAStanding] = rawStandings.compactMap({ raw in
                                    guard let meta = teamsMeta.first(where: { $0.teamId == raw.teamId }) else { return nil }
                                    return NBAStanding(raw, meta)
                                })

                                completion(.success(standings))
                            case .failure(let error):
                                completion(.failure(error))
                        }
                }
                
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
}

// MARK: Decoding League Standings Response

private extension NBAAPIService {

    struct StandingsResponse: Decodable {
        enum CodingKeys: String, CodingKey {
            case api, standings
        }
        
        let rawStandings: [RawStanding]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let api = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .api)
            rawStandings = try api.decode([RawStanding].self, forKey: .standings)
        }
    }
    
    struct RawStanding: Decodable {
        struct RawConference: Decodable {
            let name: String
            let rank: String
        }
        
        let teamId: String
        let win: String
        let loss: String
        let conference: RawConference
    }
    
    private func getRawStandings(_ completion: @escaping (Result<[RawStanding], Error>) -> Void) {
        apiClient.request(NBAAPIEndpoint.standings) { result in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(StandingsResponse.self, from: data)
                        completion(.success(response.rawStandings))
                    } catch {
                        completion(.failure(error))
                }
                case .failure(let error):
                    completion(.failure(error))
                    break
            }
        }
    }
}

// MARK: Decoding League Meta Data Response

private extension NBAAPIService {
    
    struct LeagueMetaDataResponse: Decodable {
        enum CodingKeys: String, CodingKey {
            case api, teams
        }
        
        let teamsMetaData: [TeamMetaData]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let api = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .api)
            let allTeamsMeta = try api.decode([TeamMetaData].self, forKey: .teams)
            teamsMetaData = allTeamsMeta.filter { $0.nbaFranchise == "1" }
        }
    }
    
    struct TeamMetaData: Decodable {
        let city: String
        let fullName: String
        let teamId: String
        let nickname: String
        let shortName: String
        let nbaFranchise: String
    }
    
    private func getLeagueMetaData(_ completion: @escaping (Result<[TeamMetaData], Error>) -> Void) {
        apiClient.request(NBAAPIEndpoint.leagueMetadata) { result in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(LeagueMetaDataResponse.self, from: data)
                        completion(.success(response.teamsMetaData))
                    } catch {
                        completion(.failure(error))
                    }
                    break
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

// MARK: Model Building

private extension NBAStanding {
    
    init?(_ raw: NBAAPIService.RawStanding, _ meta: NBAAPIService.TeamMetaData) {
        guard
            let rank = Int(raw.conference.rank),
            let conference = NBAConference(rawValue: raw.conference.name) else {
                assertionFailure() // TODO:
                return nil
        }
        self.rank = rank
        self.conference = conference
        
        teamId = meta.teamId
        shortName = meta.shortName
        city = meta.city
        nickname = meta.nickname
        fullName = meta.fullName
        win = raw.win
        loss = raw.loss
    }
}

/* NBAAPIClientTests:
    - check using injected:
        - session (mock)
            - var dataTaskWithRequestCalled: Bool
        - cachePolicy
        - timeoutInterval
    - defaults to:
        - cachePolicy: .useProtocolCachePolicy
        - timeoutInterval: 10.0
    - behavior:
        - builds URLRequest with all endpoint params
        - calls resume() on dataTask
        - succeeds when:
            - dataTask returns non-nil data
        - fails when:
            - url is invalid (returns ClientError.invalidURL)
            - dataTask returns nil data
            - dataTask returns dataTask's error
*/
