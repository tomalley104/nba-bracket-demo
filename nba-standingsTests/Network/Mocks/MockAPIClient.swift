//
//  MockAPIClient.swift
//  nba-standingsTests
//
//  Created by Tom OMalley on 2/27/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation
@testable import nba_standings

class MockAPIClient: APIClientType {
    typealias Completion = (Result<Data, Error>) -> Void
    typealias RequestArgs = (endpoint: EndpointType, completion: Completion)

    var capturedRequestArgs = [RequestArgs]()

    func request(_ endpoint: EndpointType, completion: @escaping (Result<Data, Error>) -> Void) {
        capturedRequestArgs.append(RequestArgs(endpoint, completion))
    }
}
