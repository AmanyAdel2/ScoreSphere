//
//  TeamDetails.swift
//  ScoreSphere
//
//  Created by Macos on 22/05/2025.
//

import Foundation

struct TeamDetailsResponse: Codable {
    let result: [TeamDetails]?
}

struct TeamDetails: Codable {
    let team_key: Int
    let team_name: String
    let team_logo: String?
    let players: [Player]?
    let coaches: [Coach]?
}

struct Player: Codable {
    let player_name: String
    let player_number: String?
    let player_type: String?
    let player_image: String?
}

struct Coach: Codable {
    let coach_name: String
}

