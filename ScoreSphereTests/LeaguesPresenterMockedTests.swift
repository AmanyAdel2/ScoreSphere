//
//  LeaguesPresenterTests.swift
//  ScoreSphereTests
//

import XCTest
@testable import ScoreSphere

// MARK: - Mocks

class MockNetworkManager: NetworkManagerProtocol {
    var shouldFail = false
    var mockData: [[String: Any]] = []
    var error: Error = NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock failure"])

    func requestLeagues(for sport: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        if shouldFail {
            completion(.failure(error))
        } else {
            completion(.success(mockData))
        }
    }
}

class MockLeaguesView: LeaguesViewProtocol {
    var leaguesShown: [League]?
    var errorMessageShown: String?

    func showLeagues(_ leagues: [League]) {
        leaguesShown = leagues
    }

    func showError(_ message: String) {
        errorMessageShown = message
    }
}

// MARK: - Tests

final class LeaguesPresenterTests: XCTestCase {
    var presenter: LeaguesPresenter!
    var mockView: MockLeaguesView!
    var mockNetwork: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockView = MockLeaguesView()
        mockNetwork = MockNetworkManager()
        presenter = LeaguesPresenter(view: mockView, networkManager: mockNetwork)
    }

    func testUnsupportedSportShowsError() {
        presenter.getLeagues(for: "volleyball")
        XCTAssertEqual(mockView.errorMessageShown, "Unsupported sport: volleyball")
    }

    func testSuccessfulLeaguesParsing() {
        mockNetwork.shouldFail = false
        mockNetwork.mockData = [
            [
                "league_key": 100,
                "league_name": "Champions League",
                "country_key": 50,
                "country_name": "Europe",
                "league_logo": "https://example.com/logo.png",
                "country_logo": "https://example.com/country.png"
            ]
        ]

        let expectation = self.expectation(description: "Wait for async league show")

        presenter.getLeagues(for: "football")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockView.leaguesShown?.count, 1)
            XCTAssertEqual(self.mockView.leaguesShown?.first?.league_name, "Champions League")
            XCTAssertEqual(self.mockView.leaguesShown?.first?.country_name, "Europe")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testEmptyLeagueArrayReturnsEmptyList() {
        mockNetwork.shouldFail = false
        mockNetwork.mockData = []

        let expectation = self.expectation(description: "Empty list shown")

        presenter.getLeagues(for: "cricket")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockView.leaguesShown?.count, 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testMissingFieldsUseDefaultValues() {
        mockNetwork.shouldFail = false
        mockNetwork.mockData = [
            [:]  // Missing all fields
        ]

        let expectation = self.expectation(description: "Use defaults for missing fields")

        presenter.getLeagues(for: "tennis")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let league = self.mockView.leaguesShown?.first
            XCTAssertEqual(league?.league_key, 0)
            XCTAssertEqual(league?.league_name, "Unknown League")
            XCTAssertEqual(league?.country_key, 0)
            XCTAssertEqual(league?.country_name, "Unknown Country")
            XCTAssertNil(league?.league_logo)
            XCTAssertNil(league?.country_logo)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testNetworkFailureShowsErrorMessage() {
        mockNetwork.shouldFail = true
        mockNetwork.error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Connection timeout"])

        presenter.getLeagues(for: "basketball")

        XCTAssertEqual(mockView.errorMessageShown, "Request failed: Connection timeout")
    }
}
