//
//  Player+CoreDataProperties.swift
//  TeamApp
//
//  Created by Saeed Taheri on 10/28/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var name: String
    @NSManaged public var rating: Double
}
