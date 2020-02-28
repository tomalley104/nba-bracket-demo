//
//  MockURLSession.swift
//  nba-standingsTests
//
//  Created by Tom OMalley on 2/27/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import Foundation
@testable import nba_standings

class MockURLSession: URLSessionType {

    var requested = [URLRequest]()
    var returnedTasks = [MockURLSessionDataTask]()

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletion) -> URLSessionDataTaskType {
        requested.append(request)

        let mock = MockURLSessionDataTask(request, completionHandler)
        returnedTasks.append(mock)

        return mock
    }
}

class MockURLSessionDataTask: URLSessionDataTaskType {

    var stubData: Data?
    var stubResponse: URLResponse?
    var stubError: Error?

    private(set) var request: URLRequest
    private(set) var completion: ((Data?, URLResponse?, Error?) -> Void)
    private(set) var resumeCalled: Bool = false

    init(_ request: URLRequest, _ completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        self.request = request
        self.completion = completion
    }

    func resume() {
        guard !resumeCalled else {
            assertionFailure("\(type(of: self)) called resume twice for request \(request)")
            return
        }

        resumeCalled = true
        if stubError != nil {
            completion(nil, nil, stubError)
        } else {
            completion(stubData, stubResponse, nil)
        }
    }
}
