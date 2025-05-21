//
//  LeagueDetailsPresenter.swift
//  ScoreSphere
//
//  Created by Macos on 20/05/2025.
//

import Foundation

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    
    var view: LeagueDetailsViewProtocol?
    
    var upcomingFixtures: [Fixture] = []
    var latestFixtures: [Fixture] = []
    var teamStandings: [TeamsStanding] = []
    
    var sportType: SportType!
    var leagueId: String!
    
    func fetchData() {
        guard let sport = sportType, let leagueId = leagueId else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let oneWeekAhead = Calendar.current.date(byAdding: .day, value: 7, to: today)!
        let oneWeekBefore = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        
        let fromDate = dateFormatter.string(from: oneWeekBefore)
        let toDate = dateFormatter.string(from: oneWeekAhead)
        
        NetworkManager.shared.fetchFixtures(sport: sport, from: fromDate, to: toDate, leagueId: leagueId) { [weak self] fixtures in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.upcomingFixtures = fixtures.filter { fixture in
                    guard let fixtureDate = dateFormatter.date(from: fixture.event_date) else { return false }
                    return fixtureDate > today
                }
                self.latestFixtures = fixtures.filter { fixture in
                    guard let fixtureDate = dateFormatter.date(from: fixture.event_date) else { return false }
                    return fixtureDate <= today
                }
                self.view?.reloadData()
            }
        }
        
        NetworkManager.shared.fetchTeams(sport: sport, leagueId: leagueId) { [weak self] teamsResponse in
            DispatchQueue.main.async {
                self?.teamStandings = teamsResponse
                self?.view?.reloadData()
            }
        }
    }
    
    func getUpcomingFixtures() -> [Fixture] {
        return upcomingFixtures
    }
    
    func getLatestFixtures() -> [Fixture] {
        return latestFixtures
    }
    
    func getTeamStandings() -> [TeamsStanding] {
        return teamStandings
    }
}
