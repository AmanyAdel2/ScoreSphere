//
//  Fixture.swift
//  ScoreSphere
//
//  Created by Macos on 17/05/2025.
//

import Foundation

struct FixturesResponse: Codable {
    let result: [Fixture]?
}

struct Fixture: Codable {
    let event_date: String
    let event_time: String
    let event_home_team: String
    let event_away_team: String
    let event_final_result: String?
    let home_team_logo: String?
    let away_team_logo: String?
}

