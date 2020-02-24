//
//  URLSessionType.swift
//  nba-standings
//
//  Created by Tom OMalley on 2/24/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation

// Wrap what we need from `URLSession` so we can create/inject a mock when testing `APIClientType`
protocol URLSessionType {
    func dataTask(with request: URLRequest, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionDataTaskType
}

// Make `URLSession` conform 
extension URLSession: URLSessionType {
    func dataTask(with request: URLRequest, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionDataTaskType {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) 
    }
}

/* DISCUSSION:
 For testing, we _could_ mock by creating a subclass of `URLSession`,
 but that would mean the dependency would simply be `URLSession` as opposed to <user-defined type>.
 This would allow the client to freely use whatever `URLSession` has available at any given time,
 potentially breaking or completely avoiding existing tests.
 Finally, it includes unnecessary/unexpected functionality within the mock object, defeating the purpose.
 
 Conversely, by defining the interface, we strictly specify ONLY methods the client is intended to use,
 which makes creating and maintaining tests easier.
*/
