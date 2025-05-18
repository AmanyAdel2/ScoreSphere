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

    init(view: LeaguesViewProtocol) {
        self.view = view
    }

    private func apiPath(for sport: String) -> String? {
        switch sport.lowercased() {
        case "football":
            return "football"
        case "basketball":
            return "basketball"
        case "cricket":
            return "cricket"
        case "tennis":
            return "tennis"
        default:
            return nil
        }
    }

    func getLeagues(for sportName: String) {
        guard let sportPath = apiPath(for: sportName) else {
            self.view?.showError("Unsupported sport: \(sportName)")
            return
        }

        let apiKey = "d2010d67eec8cc2b8a8d2eae218bff8d51a1be45296edd8a468f4f23cc7c0dfd"
        let encodedSport = sportName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? sportName
        let url = "https://apiv2.allsportsapi.com/\(sportPath)/?met=Leagues&APIkey=\(apiKey)&sport=\(encodedSport)"
        print("Request URL:", url)

        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let dict = value as? [String: Any] else {
                    self.view?.showError("Invalid response format")
                    return
                }

                guard let success = dict["success"] as? Int, success == 1 else {
                    let message = dict["message"] as? String ?? "API returned failure"
                    self.view?.showError(message)
                    return
                }

                guard let result = dict["result"] as? [[String: Any]], !result.isEmpty else {
                    self.view?.showError("No leagues found for \(sportName)")
                    return
                }

                let leagues = result.map { leagueDict -> League in
                    return League(
                        league_key: leagueDict["league_key"] as? Int ?? 0,
                        league_name: leagueDict["league_name"] as? String ?? "Unknown League",
                        country_key: leagueDict["country_key"] as? Int ?? 0,
                        country_name: leagueDict["country_name"] as? String ?? "Unknown Country",
                        league_logo: leagueDict["league_logo"] as? String,
                        country_logo: leagueDict["country_logo"] as? String
                    )
                }
                print("Parsed leagues count for \(sportName): \(leagues.count)")
                DispatchQueue.main.async {
                    self.view?.showLeagues(leagues)
                }

            case .failure(let error):
                self.view?.showError("Request failed: \(error.localizedDescription)")
            }
        }
    }
}
