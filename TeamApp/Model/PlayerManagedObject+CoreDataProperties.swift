//
//  PlayerManagedObject+CoreDataProperties.swift
//  TeamApp
//
//  Created by Saeed Taheri on 4/4/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//
//

import Foundation
import CoreData


extension PlayerManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerManagedObject> {
        return NSFetchRequest<PlayerManagedObject>(entityName: "Player")
    }

    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var uuid: UUID?
}
