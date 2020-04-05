//
//  PlayerManagedObject+CoreDataClass.swift
//  TeamApp
//
//  Created by Saeed Taheri on 4/4/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Player)
public class PlayerManagedObject: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var rating: Double
    @NSManaged public var uuid: UUID?
}

extension PlayerManagedObject {
	convenience init(player: Player, insertInto context: NSManagedObjectContext) {
		self.init(context: context)
		name = player.name
		rating = player.rating
		uuid = player.id
	}
}

extension Player {
	convenience init(player: PlayerManagedObject) {
		self.init(name: player.name ?? "", rating: player.rating, id: player.uuid ?? UUID())
	}
}
