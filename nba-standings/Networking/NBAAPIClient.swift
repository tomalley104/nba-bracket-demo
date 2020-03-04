//
//  NBAAPIClient.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/20/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

class NBAAPIClient: APIClientType {
    static func `default`() -> NBAAPIClient {
        let session = URLSession(configuration: .default)
        return NBAAPIClient(urlSession: session)
    }
    
    enum ClientError: Error {
        case invalidURL
        case unknown
    }
    
    private let urlSession: URLSessionType
    var cachePolicy: URLRequest.CachePolicy?
    var timeoutInterval: Double?
    
    // MARK: Init
    
    init(urlSession: URLSessionType) {
        self.urlSession = urlSession
    }
    
    // MARK: Public
    
    func request(_ endpoint: EndpointType, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = buildURLRequest(from: endpoint) else {
            completion(.failure(ClientError.invalidURL))
            return
        }
        
        urlSession.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(ClientError.unknown))
            }
        }.resume()
    }
    
    // MARK: Helper
    
    private func buildURLRequest(from endpoint: EndpointType) -> URLRequest? {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else { return nil }
        
        var request = URLRequest(url: url,
                                 cachePolicy: cachePolicy ?? .useProtocolCachePolicy,
                                 timeoutInterval: timeoutInterval ?? 10.0)
        
        request.httpMethod = endpoint.httpMethod.stringValue
        request.allHTTPHeaderFields = endpoint.headers
        return request
    }
}
