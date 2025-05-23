//
//  TeamPresente.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import Foundation
import Alamofire
protocol TeamView: AnyObject {
    func showTeams(_ teams: [Team])
    func showError(_ message: String)
}
class TeamPresenter {
    weak var view: TeamView?

    init(view: TeamView) {
        self.view = view
    }

    func fetchTeams(forLeagueId id: String) {
        let apiKey = "d2010d67eec8cc2b8a8d2eae218bff8d51a1be45296edd8a468f4f23cc7c0dfd"
        let url = "https://apiv2.allsportsapi.com/football/?met=Teams&leagueId=\(id)&APIkey=\(apiKey)"

        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let dict = value as? [String: Any],
                      let success = dict["success"] as? Int, success == 1,
                      let result = dict["result"] as? [[String: Any]] else {
                    self.view?.showError("Parsing error")
                    return
                }

                let teams = result.map {
                    Team(
                        name: $0["team_name"] as? String ?? "No Name",
                        logoURL: $0["team_logo"] as? String
                    )
                }
                self.view?.showTeams(teams)

            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }
}
