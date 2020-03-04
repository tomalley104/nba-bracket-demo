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

    var dispatchQueue = DispatchQueue(label: "MockSession", qos: .background)
    var requested = [URLRequest]()
    var returnedTasks = [MockURLSessionDataTask]()

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletion) -> URLSessionDataTaskType {
        requested.append(request)

        let mock = MockURLSessionDataTask(request, completionHandler, dispatchQueue)
        returnedTasks.append(mock)

        return mock
    }
}

class MockURLSessionDataTask: URLSessionDataTaskType {

    private(set) var request: URLRequest
    private(set) var completion: (URLSessionType.DataTaskCompletion)
    private(set) var resumeCalled: Bool = false
    private(set) var dispatchQueue: DispatchQueue

    init(_ request: URLRequest, _ completion: @escaping (URLSessionType.DataTaskCompletion),  _ dispatchQueue: DispatchQueue) {
        self.request = request
        self.completion = completion
        self.dispatchQueue  = dispatchQueue
    }

    func resume() {
        guard !resumeCalled else {
            assertionFailure("\(type(of: self)) called resume twice for request \(request)")
            return
        }

        resumeCalled = true
    }

    func completeTask(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        dispatchQueue.async { [weak self] in
            // hand it all over; expect consumer to handle
            self?.completion(data, response, error)
        }

    }
}
