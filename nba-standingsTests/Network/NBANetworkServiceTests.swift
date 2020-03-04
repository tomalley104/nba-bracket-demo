//
//  nba_standingsTests.swift
//  nba-standingsTests
//
//  Created by Tom OMalley on 12/7/19.
//  Copyright © 2019 37th Street. All rights reserved.
//

import XCTest
@testable import nba_standings

// NOTE: These tests do not exhaust possible scenarios, but in light of this project being an exhibition, this intends to strike a good balance between "meaningful" and "reasonable".

class NBANetworkServiceTests: XCTestCase {
    struct TestError: Error { }

    var sut: NBANetworkService!
    var apiClient: MockAPIClient!

    override func setUp() {
        apiClient = MockAPIClient()
        sut = NBANetworkService(apiClient: apiClient)
    }

    func testGetStandingsDoesntFetchTeamsIfAlreadyProvided() {
        // populate "teams" array
        let teams = createStubbedTeams()

        // create new NBANetworkService and inject cachedTeams
        let api = MockAPIClient()
        let sut2 = NBANetworkService(apiClient: api, cachedTeams: teams)

        // kick off fetch
        sut2.getStandings { _ in }

        // check first endpoint requested == .standings
        let endpoint = api.capturedRequestArgs.first?.endpoint
        _XCTAssert(endpoint, is: .standings)
    }

    func testGetStandingsFirstFetchesTeamsThenStandings() {
        // kick off fetch
        sut.getStandings { _ in }

        // check first and only endpoint requested == .teams
        XCTAssert(apiClient.capturedRequestArgs.count == 1)
        let firstEP = apiClient.capturedRequestArgs.first?.endpoint
        _XCTAssert(firstEP, is: .teams)

        // complete teams request
        let teamsCompletion = apiClient.capturedRequestArgs.first?.completion
        let stubData = loadStubbedTeamsResponseData()
        teamsCompletion?(.success(stubData))

        // check that it then requests standings
        let secondEP = apiClient.capturedRequestArgs[1].endpoint
        _XCTAssert(secondEP, is: .standings)
    }

    func testGetStandingsFailsIfTeamsRequestFails() {

        // create expectation and kick off fetch
        let expectFailure = expectation(description: "StandingsFailure")
        sut.getStandings { result in
            switch result {
                case .success:
                    XCTFail("getStandings should not succeed after getTeams fails")
                case .failure:
                    expectFailure.fulfill()
            }
        }

        // check first and only endpoint requested == .teams
        XCTAssert(apiClient.capturedRequestArgs.count == 1)
        let firstEP = apiClient.capturedRequestArgs.first?.endpoint
        _XCTAssert(firstEP, is: .teams)

        // complete teams request with failure
        let teamsCompletion = apiClient.capturedRequestArgs.first?.completion
        teamsCompletion?(.failure(TestError()))

        waitForExpectations(timeout: 0.1)
    }


    // MARK: Helper

    func _XCTAssert(_ endpoint: EndpointType?, is nbaEndpoint: NBAAPIEndpoint) {
        if let casted = endpoint as? NBAAPIEndpoint {
            XCTAssertEqual(casted, nbaEndpoint)
        } else {
            XCTFail("NBANetworkService didn't use expected endpoint \(nbaEndpoint)")
        }

    }

    func createStubbedTeams(_ count: Int = 5) -> [NBATeam] {
        let stub = NBATeam(teamId: "", shortName: "", city: "", nickname: "", fullName: "")
        return [NBATeam](repeating: stub, count: count)
    }

    func loadStubbedTeamsResponseData() -> Data {
        let fileName = "StubbedNBAAPITeamsResponse"
        let ext = "txt"
        let testBundle = Bundle(for: type(of: self))
        guard let url = testBundle.url(forResource: fileName, withExtension: ext) else {
            fatalError("Test Broken -Unable to load \(fileName)")
        }

        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Test Broken -Unable to load \(fileName)")
        }
    }
}
