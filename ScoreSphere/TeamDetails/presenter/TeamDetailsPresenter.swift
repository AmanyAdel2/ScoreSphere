//
//  TeamDetailsPresenter.swift
//  ScoreSphere
//
//  Created by Macos on 22/05/2025.
//

import Foundation

class TeamDetailsPresenter: TeamDetailsPresenterProtocol {
    
    weak var view: TeamDetailsViewProtocol?
    var sport: SportType!
    var teamId: Int!
    
    func fetchTeamDetails() {
        NetworkManager.shared.fetchTeamDetails(sport: sport, teamId: teamId) { [weak self] team in
            guard let self = self, let team = team else { return }
            DispatchQueue.main.async {
                self.view?.showTeamDetails(team)
                self.view?.reloadData()
            }
        }
    }
}

