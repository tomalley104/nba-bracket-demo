//
//  NBADataClient.swift
//  nba-standings
//
//  Created by Tom OMalley on 12/8/19.
//  Copyright © 2019 37th Street. All rights reserved.
//

import Foundation

class NBADataClient {

    enum ClientError: Error {
        case invalidURL
        case unknown
    }

    private let baseURLString = "https://data.nba.net"
    private let conferenceStandingsEndpoint = "/15m/json/cms/2019/standings/conference.json"

    func fetchCurrentLeagueStandings(completion: @escaping (Result<NBA, Error>) -> Void) {

        let requestString = baseURLString + conferenceStandingsEndpoint
        guard let url = URL(string: requestString) else {
            assertionFailure("Invalid URL: \(requestString)")
            completion(.failure(ClientError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {
                completion(.failure(error ?? ClientError.unknown))
                return
            }

            do {
                let nba = try JSONDecoder().decode(RawStandingsResponse.self, from: data).toNBA()
                completion(.success(nba))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

private extension NBADataClient {

    struct RawStandingsResponse: Decodable {
        let year: String
        let timestamp: String
        let east: [NBA.Team]
        let west: [NBA.Team]

        enum CodingKeys: String, CodingKey {
            case sports_content
            case sports_meta
            case date_time
            case season_meta
            case season_year
            case standings
            case conferences
            case east = "East"
            case west = "West"
            case team
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let sports_content = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .sports_content)

            let sports_meta = try sports_content.nestedContainer(keyedBy: CodingKeys.self, forKey: .sports_meta)
            self.timestamp = try sports_meta.decode(String.self, forKey: .date_time)

            let season_meta = try sports_meta.nestedContainer(keyedBy: CodingKeys.self, forKey: .season_meta)
            self.year = try season_meta.decode(String.self, forKey: .season_year)

            let conferences = try sports_content
                .nestedContainer(keyedBy: CodingKeys.self, forKey: .standings)
                .nestedContainer(keyedBy: CodingKeys.self, forKey: .conferences)

            self.east = try conferences.nestedContainer(keyedBy: CodingKeys.self, forKey: .east).decode([NBA.Team].self, forKey: .team)
            self.west = try conferences.nestedContainer(keyedBy: CodingKeys.self, forKey: .west).decode([NBA.Team].self, forKey: .team)
        }

        func toNBA() -> NBA {
            return NBA(year: year,
                       timestamp: timestamp,
                       easternConference: east,
                       westernConference: west)
        }
    }
}
