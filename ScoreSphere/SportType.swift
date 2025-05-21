//
//  SportType.swift
//  ScoreSphere
//
//  Created by Macos on 20/05/2025.
//

import Foundation


enum SportType: String {
    case football
    case basketball
    case tennis
    case cricket
    
    var baseURL: String {
        let url = "https://apiv2.allsportsapi.com/\(self.rawValue)"
        return url.hasSuffix("/") ? url : url + "/"
    }
}
