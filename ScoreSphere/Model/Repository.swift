//
//  Repository.swift
//  ScoreSphere
//
//  Created by Macos on 20/05/2025.
//

import Foundation
protocol Repository{
    func saveLeague(_ league:League)
    func fetchFavoriteLeagues()->[FavoriteLeagues]
    func deleteFavorite(_ favorite: FavoriteLeagues)
}
