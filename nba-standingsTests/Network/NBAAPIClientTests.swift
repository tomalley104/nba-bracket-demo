//
//  NBAAPIClientTests.swift
//  nba-standingsTests
//
//  Created by Tom OMalley on 2/27/20.
//  Copyright © 2020 37th Street. All rights reserved.
//

import XCTest
@testable import nba_standings

class NBAAPIClientTests: XCTestCase {

    var sut: NBAAPIClient!
    var mockSession: MockURLSession!

    override func setUp() {
        mockSession = MockURLSession()
        sut = NBAAPIClient(urlSession: mockSession)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        - builds URLRequest with all endpoint params
        - calls resume() on dataTask
        - succeeds when:
            - dataTask returns non-nil data
        - fails when:
            - url is invalid (returns ClientError.invalidURL)
            - dataTask returns nil data
            - dataTask returns dataTask's error
*/
