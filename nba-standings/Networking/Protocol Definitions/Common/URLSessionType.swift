//
//  URLSessionType.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/24/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

/* DISCUSSION:
 For testing, we _could_ mock by creating a subclass of `URLSession`,
 but that would allow client/tests to freely use whatever `URLSession` has available at any given time.
 This also introduces unnecessary/unexpected functionality within the mock object, kinda defeating the purpose.

 Conversely, by defining the interface, we strictly specify ONLY methods the client is intended to use.
 By narrowing focus, ideally tests are easier to create and maintain.
 */


// Wrap what we need from `URLSession` so we can create/inject a mock when testing `APIClientType`
protocol URLSessionType {
    typealias DataTaskCompletion = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletion) -> URLSessionDataTaskType
}

extension URLSession: URLSessionType {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletion) -> URLSessionDataTaskType {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask)
    }
}

// Defined here as it is only relevant in relation to URLSessionType
protocol URLSessionDataTaskType {
    func resume()
}
extension URLSessionDataTask: URLSessionDataTaskType { }
