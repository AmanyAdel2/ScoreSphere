//
//   Protocols.swift
//  ScoreSphere
//
//  Created by Macos on 18/05/2025.
//

import Foundation
protocol LeaguesViewProtocol: AnyObject {
    func showLeagues(_ leagues: [League])
    func showError(_ message: String)
}

protocol LeaguesPresenterProtocol {
    func getLeagues(for sportName: String)
}



protocol LeagueDetailsViewProtocol: AnyObject {
    func reloadData()
}

protocol LeagueDetailsPresenterProtocol: AnyObject {
    func fetchData()
    
    func getUpcomingFixtures() -> [Fixture]
    func getLatestFixtures() -> [Fixture]
    func getTeamStandings() -> [TeamsStanding]
}

