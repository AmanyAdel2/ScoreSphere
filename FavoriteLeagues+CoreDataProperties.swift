//
//  FavoriteLeagues+CoreDataProperties.swift
//  ScoreSphere
//
//  Created by Macos on 20/05/2025.
//
//

import Foundation
import CoreData


extension FavoriteLeagues {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteLeagues> {
        return NSFetchRequest<FavoriteLeagues>(entityName: "FavoriteLeagues")
    }

    @NSManaged public var country_logo: String?
    @NSManaged public var country_name: String?
    @NSManaged public var league_key: Int64
    @NSManaged public var league_logo: String?
    @NSManaged public var league_name: String?

}

extension FavoriteLeagues : Identifiable {

}
