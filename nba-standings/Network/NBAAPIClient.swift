//
//  NBAAPIClient.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/20/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

class NBAAPIClient: NBAAPIClientType {
    
    enum ClientError: Error {
        case invalidURL
        case unknown
    }
    
    func request(_ endpoint: NBAAPIEndpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = endpoint.buildURLRequest() else {
            assertionFailure("Invalid URL: \(endpoint.baseURL) + \(endpoint.path)")
            completion(.failure(ClientError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(error ?? ClientError.unknown))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
