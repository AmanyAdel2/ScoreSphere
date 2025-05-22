//
//  NetworkManagerTests.swift
//  ScoreSphereTests
//
//  Created by Macos on 22/05/2025.
//

import XCTest
import Foundation
@testable import ScoreSphere
import Alamofire




func makeMockSession() -> Session {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return Session(configuration: configuration)
}


final class MockURLProtocol: URLProtocol {
    static var testData: Data?
    static var testError: Error?

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = MockURLProtocol.testError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let data = MockURLProtocol.testData {
                client?.urlProtocol(self, didLoad: data)
            }
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}




final class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()
        let session = makeMockSession()
        networkManager = NetworkManager(session: session)
        MockURLProtocol.testData = nil
        MockURLProtocol.testError = nil
    }

    // MARK: - Helper: Create mock Alamofire session

    func makeMockSession() -> Session {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return Session(configuration: config)
    }

    // MARK: - fetchFixtures Tests

    func testFetchFixturesSuccess() {
        let json = """
        {
          "result": [
            {
              "event_date": "2025-05-21",
              "event_time": "18:00",
              "event_home_team": "Team A",
              "event_away_team": "Team B",
              "event_final_result": null,
              "home_team_logo": null,
              "away_team_logo": null
            }
          ]
        }
        """
        MockURLProtocol.testData = json.data(using: .utf8)

        let expectation = self.expectation(description: "Fixtures success")

        networkManager.fetchFixtures(sport: .football, from: "2025-05-01", to: "2025-05-31", leagueId: "123") { fixtures in
            XCTAssertEqual(fixtures.count, 1)
            XCTAssertEqual(fixtures.first?.event_home_team, "Team A")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testFetchFixturesFailure() {
        MockURLProtocol.testError = NSError(domain: "Network", code: -1, userInfo: nil)

        let expectation = self.expectation(description: "Fixtures failure")

        networkManager.fetchFixtures(sport: .football, from: "2025-05-01", to: "2025-05-31", leagueId: "123") { fixtures in
            XCTAssertTrue(fixtures.isEmpty)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    // MARK: - fetchTeams Tests

    func testFetchTeamsSuccess() {
        let json = """
        {
          "result": [
            {
              "team_key": 1,
              "team_name": "Team X"
            }
          ]
        }
        """
        MockURLProtocol.testData = json.data(using: .utf8)

        let expectation = self.expectation(description: "Teams success")

        networkManager.fetchTeams(sport: .football, leagueId: "123") { teams in
            XCTAssertEqual(teams.count, 1)
            XCTAssertEqual(teams.first?.teamName, "Team X")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testFetchTeamsFailure() {
        MockURLProtocol.testError = NSError(domain: "Network", code: -1, userInfo: nil)

        let expectation = self.expectation(description: "Teams failure")

        networkManager.fetchTeams(sport: .football, leagueId: "123") { teams in
            XCTAssertTrue(teams.isEmpty)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    // MARK: - fetchTeamDetails Tests

    func testFetchTeamDetailsSuccess() {
        let json = """
        {
          "result": [
            {
              "team_key": 1,
              "team_name": "Team Detail",
              "team_logo": "logo_url"
            }
          ]
        }
        """
        MockURLProtocol.testData = json.data(using: .utf8)

        let expectation = self.expectation(description: "TeamDetails success")

        networkManager.fetchTeamDetails(sport: .football, teamId: 1) { teamDetail in
            XCTAssertNotNil(teamDetail)
            XCTAssertEqual(teamDetail?.team_name, "Team Detail")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    func testFetchTeamDetailsFailure() {
        MockURLProtocol.testError = NSError(domain: "Network", code: -1, userInfo: nil)

        let expectation = self.expectation(description: "TeamDetails failure")

        networkManager.fetchTeamDetails(sport: .football, teamId: 1) { teamDetail in
            XCTAssertNil(teamDetail)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }
}
