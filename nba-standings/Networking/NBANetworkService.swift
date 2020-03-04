//
//  NBANetworkService.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/20/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

class NBANetworkService: NBANetworkServiceType {

    static func `default`() -> NBANetworkService {
        return NBANetworkService(apiClient: NBAAPIClient.default())
    }

    private let apiClient: APIClientType
    private var cachedTeams: [NBATeam]?

    // MARK: Init

    init(apiClient: APIClientType, cachedTeams: [NBATeam]? = nil) {
        self.apiClient = apiClient
        self.cachedTeams = cachedTeams
    }

    // MARK: Public Functions

    func getStandings(_ completion: @escaping (Result<[NBAStanding], Error>) -> Void) {
        guard let cached = cachedTeams else {
            // NBAEndpoint.standings only returns teamId, conference, rank, and W/L
            // Must combine raw info with NBATeam to get a full `NBAStanding`

            getTeams { [weak self] result in
                switch result {
                    case .success(let teams): // cache and re-call
                        self?.cachedTeams = teams
                        self?.getStandings(completion)
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
            return
        }
        // TODO: Validate cachedTeams

        getRawStandings { standingsResult in
            switch standingsResult {
                case .success(let rawStandings):

                    let standings: [NBAStanding] = rawStandings.compactMap({ raw in
                        guard let team = cached.first(where: { $0.teamId == raw.teamId }) else { return nil }
                        return NBAStanding(team: team, raw: raw)
                    })
                    // TODO: Validate
                    completion(.success(standings))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    // MARK: Private Functions

    private func getTeams(_ completion: @escaping (Result<[NBATeam], Error>) -> Void) {
        apiClient.request(NBAAPIEndpoint.teams) { result in
            switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(TeamsResponse.self, from: data)
                        completion(.success(response.teams))
                    } catch {
                        completion(.failure(error))
                }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    private func getRawStandings(_ completion: @escaping (Result<[StandingsResponse.RawStanding], Error>) -> Void) {
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
            }
        }
    }
}

// MARK: Decoding Responses

private extension NBANetworkService {

    // MARK: /standings

    struct StandingsResponse: Decodable {

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

        let rawStandings: [RawStanding]

        // MARK: Decodable

        enum CodingKeys: String, CodingKey {
            case api, standings
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let api = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .api)
            rawStandings = try api.decode([RawStanding].self, forKey: .standings)
        }
    }

    // MARK: /teams

    struct TeamsResponse: Decodable {

        let teams: [NBATeam]

        // MARK: Decodable

        enum CodingKeys: String, CodingKey {
            case api, teams
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let api = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .api)
            teams = try api.decode([NBATeam].self, forKey: .teams)
        }
    }
}

// MARK: Model-Building

private extension NBAStanding {
    init?(team: NBATeam, raw: NBANetworkService.StandingsResponse.RawStanding) {
        guard
            let rank = Int(raw.conference.rank),
            let conference = NBAConference(rawValue: raw.conference.name) else {
                assertionFailure("RawConference somehow decoded without matching rank/name. \(raw)")
                return nil
        }
        self.init(team: team,
                  conference: conference,
                  rank: rank,
                  win: raw.win,
                  loss: raw.loss)
    }
}
