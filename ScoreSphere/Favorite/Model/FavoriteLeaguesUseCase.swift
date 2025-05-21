//
//  FavoriteLeaguesUseCase.swift
//  ScoreSphere
//
//  Created by Macos on 20/05/2025.
//

import Foundation
class FavoriteLeaguesUseCase {
    private let repo : Repository
    init(repo: Repository) {
        self.repo = repo
    }
    func saveToFavorite(_ league: League, sportType: SportType) {
            repo.saveLeague(league, sportType: sportType)
        }
    func getFavorites()->[FavoriteLeagues]{
        repo.fetchFavoriteLeagues()
    }
    func deleteFavorite(_ favorite: FavoriteLeagues) {
        repo.deleteFavorite(favorite)
    }

}
