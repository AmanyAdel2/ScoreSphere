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

protocol TeamDetailsViewProtocol: AnyObject {
    func showTeamDetails(_ teamDetails: TeamDetails)
    func reloadData()
}

protocol TeamDetailsPresenterProtocol: AnyObject {
    var teamId: Int! { get set }
    var sport: SportType! { get set }
    var view: TeamDetailsViewProtocol? { get set }
    
    func fetchTeamDetails()
}
protocol NetworkManagerProtocol {
    func requestLeagues(for sport: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void)
}


