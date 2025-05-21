//
//  TeamStanding.swift
//  ScoreSphere
//
//  Created by Macos on 19/05/2025.
//


import Foundation

struct TeamsStanding: Codable {
    let teamKey: Int?
    let teamName: String?
    let teamLogo: String?

    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
    }
}

struct TeamResponse: Codable {
    let success: Int?
    let result: [TeamsStanding]?
}

