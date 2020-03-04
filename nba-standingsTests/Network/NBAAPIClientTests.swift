//
//  NBAAPIClientTests.swift
//  nba-standingsTests
//
//  Created by Tom OMalley on 2/27/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import XCTest
@testable import nba_standings

// NOTE: These tests do not exhaust possible scenarios, but in light of this project being an exhibition, this intends to strike a good balance between "meaningful" and "reasonable".

class NBAAPIClientTests: XCTestCase {

    struct EndpointStub: EndpointType {
        var baseURL: String = "www.testing.me"
        var path: String = "/api/test/path"
        var httpMethod: HTTPMethod = .get
        var headers: [String : String]? = ["\(UUID())":"some value"]
    }

    struct TestError: Error { }

    var sut: NBAAPIClient!
    var session: MockURLSession!

    override func setUp() {
        session = MockURLSession()
        sut = NBAAPIClient(urlSession: session)
    }

    func testUsingInjectedSession() {
        XCTAssert(session.requested.isEmpty, "Ensuring an un-used session.")
        sut.request(EndpointStub()) { _ in }
        XCTAssert(session.requested.count == 1)
    }

    func testBuildsURLRequestFromEndpointParam() {
        let endpoint = EndpointStub()
        sut.request(endpoint, completion: { _ in })
        let request = session.requested.last!
        XCTAssertEqual(request.allHTTPHeaderFields, endpoint.headers)
        XCTAssertEqual(request.httpMethod, endpoint.httpMethod.stringValue)
        XCTAssertEqual(request.url?.absoluteString, (endpoint.baseURL + endpoint.path))
    }

    func testCallsResumeOnDataTask() {
        sut.request(EndpointStub()) { _ in }
        XCTAssertTrue(session.returnedTasks.first?.resumeCalled ?? false)
    }

    func testSucceedsWhenDataTaskReturnsData() {
        let expectSuccess = expectation(description: "DataTaskSucceeds")

        sut.request(EndpointStub()) { result in
            switch result {
                case .success:
                    expectSuccess.fulfill()
                case .failure:
                    XCTFail("Expected request to succeed given provided data")
            }
        }

        let task = session.returnedTasks.last
        task?.completeTask(Data(), nil, nil)

        waitForExpectations(timeout: 0.1)
    }

    func testsFailsImmediatelyWhenEndpointHasInvalidURL() {
        var endpoint = EndpointStub()
        endpoint.baseURL = "💩"
        sut.request(endpoint) { result in
            switch result {
                case .success:
                    XCTFail("Should not succeed")
                case .failure(let error):
                    let expected = NBAAPIClient.ClientError.invalidURL
                    XCTAssertEqual(error as? NBAAPIClient.ClientError, expected)
            }
        }
    }

    func testFailsWhenDataTaskReturnsNilData() {
        let expect = expectation(description: "Nil Data Fails")

        sut.request(EndpointStub()) { result in
            switch result {
                case .success:
                    XCTFail("Task was not provided data; should not succeed")
                case .failure:
                    expect.fulfill()
            }
        }

        let task = session.returnedTasks.last
        task?.completeTask(nil, nil, nil)

        waitForExpectations(timeout: 0.1)
    }

    func testFailsWhenDataTaskReturnsError() {
        let expect = expectation(description: "Nil Data Fails")

        sut.request(EndpointStub()) { result in
            switch result {
                case .success:
                    XCTFail("Task was not provided data; should not succeed")
                case .failure:
                    expect.fulfill()
            }
        }

        let task = session.returnedTasks.last
        task?.completeTask(Data(), nil, TestError())

        waitForExpectations(timeout: 0.1)
    }
}
