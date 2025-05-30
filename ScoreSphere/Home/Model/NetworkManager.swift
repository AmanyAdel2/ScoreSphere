//
//  NetworkManager.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private let session: Session

        
        init(session: Session = .default) {
            self.session = session
        }

    
    private let apiKey = "d2010d67eec8cc2b8a8d2eae218bff8d51a1be45296edd8a468f4f23cc7c0dfd"
    
    func fetchFixtures(
        sport: SportType,
        from: String,
        to: String,
        leagueId: String,
        completion: @escaping ([Fixture]) -> Void
    ) {
        let params: [String: Any] = [
            "met": "Fixtures",
            "APIkey": apiKey,
            "from": from,
            "to": to,
            "leagueId": leagueId
        ]
        
//        AF.request(sport.baseURL, parameters: params)
//            .responseDecodable(of: FixturesResponse.self) { response in
//                switch response.result {
//                case .success(let data):
//                    completion(data.result ?? [])
//                case .failure(let error):
//                    print("Error fetching fixtures:", error)
//                    completion([])
//                }
//            }
        session.request(sport.baseURL, parameters: params)
                    .responseDecodable(of: FixturesResponse.self) { response in
                        switch response.result {
                        case .success(let data):
                            completion(data.result ?? [])
                        case .failure:
                            completion([])
                        }
                    }
        
    }
    
    func fetchTeams(
        sport: SportType,
        leagueId: String,
        completion: @escaping ([TeamsStanding]) -> Void
    ) {
        let params: [String: Any] = [
            "met": "Teams",
            "APIkey": apiKey,
            "leagueId": leagueId
        ]
        
        session.request(sport.baseURL, parameters: params)
            .responseDecodable(of: TeamResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data.result ?? [])
                case .failure(let error):
                    print("Error fetching teams:", error)
                    completion([])
                }
        }
    }
    
    func fetchTeamDetails(
        sport: SportType,
        teamId: Int,
        completion: @escaping (TeamDetails?) -> Void
    ) {
        let params: [String: Any] = [
            "met": "Teams",
            "APIkey": apiKey,
            "teamId": teamId
        ]
        
        session.request(sport.baseURL, parameters: params)
            .responseDecodable(of: TeamDetailsResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(data.result?.first) 
                case .failure(let error):
                    print("Error fetching team details:", error)
                    completion(nil)
                }
            }
        
    }

}
