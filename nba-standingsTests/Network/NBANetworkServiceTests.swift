//
//  nba_standingsTests.swift
//  nba-standingsTests
//
//  Created by Tom OMalley on 12/7/19.
//  Copyright © 2019 37th Street. All rights reserved.
//

import XCTest
@testable import nba_standings

class NBANetworkServiceTests: XCTestCase {

    var sut: NBANetworkService!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
        mockAPIClient = MockAPIClient()
        sut = NBANetworkService(apiClient: mockAPIClient)
    }

    func testGetStandingsBuildsCorrectRequest() {
        sut.getStandings { _ in }
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
