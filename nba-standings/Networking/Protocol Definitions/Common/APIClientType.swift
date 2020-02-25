//
//  APIClientType.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/20/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

protocol APIClientType {
    var urlSession: URLSessionType { get }
    var cachePolicy: URLRequest.CachePolicy? { get }
    var timeoutInterval: Double? { get }
    
    func request(_ endpoint: EndpointType, completion: @escaping (Result<Data, Error>) -> Void)
}
