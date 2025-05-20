//
//  FavoriteLeaguesPresenter.swift
//  ScoreSphere
//
//  Created by Macos on 20/05/2025.
//

import Foundation
protocol FavoriteLeaguesViewProtocol : AnyObject{
    func showFavoriteLeague(_ favoriteLeague:[FavoriteLeagues])
    
}
class FavoriteLeaguesPresenter{
    weak var view : (FavoriteLeaguesViewProtocol)?
    private let useCase : FavoriteLeaguesUseCase
    init(view: FavoriteLeaguesViewProtocol, useCase: FavoriteLeaguesUseCase) {
        self.view = view
        self.useCase = useCase
    }
    func loadFavorites(){
        let fav = useCase.getFavorites()
        let uniqueFavorites = Array(Set(fav.map { $0.league_name })).compactMap { name in
                fav.first { $0.league_name == name }
            }

            print("Filtered to \(uniqueFavorites.count) unique favorite leagues")
            view?.showFavoriteLeague(uniqueFavorites)
    }
    func deleteFavorite(at index: Int, from favorites: [FavoriteLeagues]) {
        let favorite = favorites[index]
        useCase.deleteFavorite(favorite)
        loadFavorites()
    }


}
