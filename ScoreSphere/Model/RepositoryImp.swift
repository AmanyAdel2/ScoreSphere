//
//  RepositoryImp.swift
//  ScoreSphere
//
//  Created by Macos on 20/05/2025.
//

import Foundation
import UIKit
import CoreData
class RepositoryImp : Repository{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveLeague( _ league : League , sportType: SportType) {
        let favorite = FavoriteLeagues(context: context)
        favorite.league_name = league.league_name
        favorite.league_logo = league.league_logo
        favorite.country_name = league.country_name
        favorite.country_logo = league.country_logo
        favorite.league_key = Int64(league.league_key)
        favorite.sport_type = sportType.rawValue
        
        do{
            try context.save()
        }catch{
            print("error \(error.localizedDescription)")
        }
    }
    
    func fetchFavoriteLeagues() -> [FavoriteLeagues] {
        let request : NSFetchRequest<FavoriteLeagues> = FavoriteLeagues.fetchRequest()
        do{
            return try context.fetch(request)
        }catch{
            print("FETCH FAILLED \(error.localizedDescription)")
            return []
        }
    }
    func deleteFavorite(_ favorite: FavoriteLeagues) {
        guard let context = favorite.managedObjectContext else { return }
        context.delete(favorite)
        do {
            try context.save()
        } catch {
            print("Failed to delete favorite: \(error)")
        }
    }

    
    
}
