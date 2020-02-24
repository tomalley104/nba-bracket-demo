//
//  URLSessionDataTaskType.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/24/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

// Wrap URLSessionDataTask for testability/mocking (see URLSessionType.swift)
protocol URLSessionDataTaskType {    
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskType { }

