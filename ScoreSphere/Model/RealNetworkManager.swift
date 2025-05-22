//
//  RealNetworkManager.swift
//  ScoreSphere
//
//  Created by Macos on 22/05/2025.
//

import Foundation
import Alamofire
class RealNetworkManager: NetworkManagerProtocol {
    func requestLeagues(for sport: String, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        guard let path = sport.lowercased().addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            return
        }

        let apiKey = "d2010d67eec8cc2b8a8d2eae218bff8d51a1be45296edd8a468f4f23cc7c0dfd"
        let url = "https://apiv2.allsportsapi.com/\(path)/?met=Leagues&APIkey=\(apiKey)&sport=\(sport)"

        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let dict = value as? [String: Any],
                   let result = dict["result"] as? [[String: Any]] {
                    completion(.success(result))
                } else {
                    completion(.failure(NSError(domain: "", code: -2, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

