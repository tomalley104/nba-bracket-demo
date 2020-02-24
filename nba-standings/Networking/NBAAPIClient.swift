//
//  NBAAPIClient.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/20/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

class NBAAPIClient: APIClientType {
    
    enum ClientError: Error {
        case invalidURL
        case unknown
    }
    
    var urlSession: URLSessionType = URLSession(configuration: .default)
    
    // MARK: Init    
    
    func request(_ endpoint: EndpointType, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = buildURLRequest(from: endpoint) else {
            assertionFailure("Invalid URL: \(endpoint.baseURL) + \(endpoint.path)")
            completion(.failure(ClientError.invalidURL))
            return
        }
        
        urlSession.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(error ?? ClientError.unknown))
                return
            }
            completion(.success(data))
        }.resume()
    }
    
    // MARK: Helper
    
    func buildURLRequest(from endpoint: EndpointType) -> URLRequest? {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else { return nil }
        
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadRevalidatingCacheData, // NOTE: unsure how API-NBA caches
                                 timeoutInterval: 10.0)
        
        request.httpMethod = endpoint.httpMethod.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        return request
    }
}
