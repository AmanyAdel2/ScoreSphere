//
//  LeaguesPresenterMockedTests.swift
//  ScoreSphereTests
//
//  Created by Macos on 22/05/2025.
//

import XCTest
@testable import ScoreSphere
class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnError = false
    var mockResult: [[String: Any]] = []

    func requestLeagues(for sport: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "MockError", code: -1)))
        } else {
            completion(.success(mockResult))
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

class LeaguesPresenterTests: XCTestCase {

    var presenter: LeaguesPresenter!
    var mockView: MockLeaguesView!

    override func setUp() {
        super.setUp()
        mockView = MockLeaguesView()
        presenter = LeaguesPresenter(view: mockView)
    }

    func testUnsupportedSportShowsError() {
        // Given
        let unsupportedSport = "volleyball"

        // When
        presenter.getLeagues(for: unsupportedSport)

        // Then
        XCTAssertEqual(mockView.errorMessageShown, "Unsupported sport: \(unsupportedSport)")
    }

    
}


class LeaguesPresenterMockedTests: XCTestCase {
    var mockView: MockLeaguesView!
    var mockNetwork: MockNetworkManager!
    var presenter: LeaguesPresenter!

    override func setUp() {
        super.setUp()
        mockView = MockLeaguesView()
        mockNetwork = MockNetworkManager()
        presenter = LeaguesPresenter(view: mockView, networkManager: mockNetwork)
    }

    func testGetLeaguesSuccess() {
        mockNetwork.shouldReturnError = false
        mockNetwork.mockResult = [
            [
                "league_key": 123,
                "league_name": "Premier League",
                "country_key": 1,
                "country_name": "England"
            ]
        ]

        presenter.getLeagues(for: "football")

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockView.leaguesShown?.count, 1)
            XCTAssertEqual(self.mockView.leaguesShown?.first?.league_name, "Premier League")
        }
    }

    func testGetLeaguesFailure() {
        mockNetwork.shouldReturnError = true

        presenter.getLeagues(for: "football")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.mockView.errorMessageShown)
            XCTAssertTrue(self.mockView.errorMessageShown?.contains("Request failed") ?? false)
        }
    }
}
