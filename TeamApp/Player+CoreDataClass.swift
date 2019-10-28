//
//  Player+CoreDataClass.swift
//  TeamApp
//
//  Created by Saeed Taheri on 10/28/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Player)
public class Player: NSManagedObject {
	
}

extension Player {
	static func create(name: String, rating: Double, in managedObjectContext: NSManagedObjectContext){
        let newPlayer = self.init(context: managedObjectContext)
		newPlayer.name = name
		newPlayer.rating = rating
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension Collection where Element == Player, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        indices.forEach { managedObjectContext.delete(self[$0]) }
 
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
