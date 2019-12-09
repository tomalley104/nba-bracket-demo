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
        case invalidJSONResponse
        case unknown
    }

    let baseURLString = "https://data.nba.net"
    let currentStandingsEndpoint = "/prod/v1/current/standings_all_no_sort_keys.json"

    func fetchCurrentLeagueStandings(completion: @escaping (Result<[NBATeam], Error>) -> Void) {

        let requestString = baseURLString + currentStandingsEndpoint
        guard let url = URL(string: requestString) else {
            assertionFailure("Invalid URL: \(requestString)")
            completion(.failure(ClientError.invalidURL))
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {
                completion(.failure(error ?? ClientError.unknown))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = json as? [String:Any],
                    let leaguesDict = jsonDict["league"] as? [String: Any],
                    let nbaDict = leaguesDict["standard"] as? [String: Any],
                    let teamsDictArray = nbaDict["teams"] as? [[String:Any]] else {
                    assertionFailure("Couldnt decode standings JSON")
                    throw ClientError.invalidJSONResponse
                }

                let teamsJSONData = try JSONSerialization.data(withJSONObject: teamsDictArray, options: [])
                let teams = try JSONDecoder().decode([NBATeam].self, from: teamsJSONData)

                completion(.success(teams))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
