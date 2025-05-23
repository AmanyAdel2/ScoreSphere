//
//  LeaguesPresenter.swift
//  ScoreSphere
//
//  Created by Macos on 18/05/2025.
//

import Foundation
import Alamofire

class LeaguesPresenter: LeaguesPresenterProtocol {
    weak var view: LeaguesViewProtocol?
    private let networkManager: NetworkManagerProtocol

    init(view: LeaguesViewProtocol, networkManager: NetworkManagerProtocol = RealNetworkManager()) {
        self.view = view
        self.networkManager = networkManager
    }

    func getLeagues(for sportName: String) {
        guard ["football", "basketball", "cricket", "tennis"].contains(sportName.lowercased()) else {
            self.view?.showError("Unsupported sport: \(sportName)")
            return
        }

        networkManager.requestLeagues(for: sportName) { result in
            switch result {
            case .success(let resultArray):
                let leagues = resultArray.map {
                    League(
                        league_key: $0["league_key"] as? Int ?? 0,
                        league_name: $0["league_name"] as? String ?? "Unknown League",
                        country_key: $0["country_key"] as? Int ?? 0,
                        country_name: $0["country_name"] as? String ?? "Unknown Country",
                        league_logo: $0["league_logo"] as? String,
                        country_logo: $0["country_logo"] as? String
                    )
                }
                DispatchQueue.main.async {
                    self.view?.showLeagues(leagues)
                }
            case .failure(let error):
                self.view?.showError("Request failed: \(error.localizedDescription)")
            }
        }
    }
}
