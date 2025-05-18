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

    private let baseURL = "https://apiv2.allsportsapi.com/football/"
    private let apiKey = "d2010d67eec8cc2b8a8d2eae218bff8d51a1be45296edd8a468f4f23cc7c0dfd"

    func fetchFixtures(from: String, to: String, leagueId: String, completion: @escaping ([Fixture]) -> Void) {
        let params: [String: Any] = [
            "met": "Fixtures",
            "APIkey": apiKey,
            "from": from,
            "to": to,
            "leagueId": leagueId
        ]

        AF.request(baseURL, parameters: params).responseDecodable(of: FixturesResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(data.result ?? [])
            case .failure(let error):
                print("Error fetching fixtures:", error)
                completion([])
            }
        }
    }

    func fetchStandings(leagueId: String, completion: @escaping ([Standing]) -> Void) {
        let params: [String: Any] = [
            "met": "Standings",
            "APIkey": apiKey,
            "leagueId": leagueId
        ]

        AF.request(baseURL, parameters: params).responseDecodable(of: StandingsResponse.self) { response in
            switch response.result {
            case .success(let data):
                // Flatten the dictionary values arrays into a single array
                if let result = data.result {
                    let allStandings = result.values.flatMap { $0 }
                    completion(allStandings)
                } else {
                    completion([])
                }
            case .failure(let error):
                print("Error fetching standings:", error)
                completion([])
            }
        }
    }
}
