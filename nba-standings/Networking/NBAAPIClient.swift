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
    
    let urlSession: URLSessionType
    var cachePolicy: URLRequest.CachePolicy?
    var timeoutInterval: Double?
    
    // MARK: Init
    
    init(urlSession: URLSessionType) {
        self.urlSession = urlSession
    }
    
    // MARK: Public
    
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
        - builds URLRequest w/ ALL Endpoint-provided params
        - calls resume() on dataTask
        - succeeds when:
            - dataTask returns non-nil data
        - fails when:
            - url is invalid (returns ClientError.invalidURL)
            - dataTask returns nil data
            - dataTask returns dataTask's error
*/

