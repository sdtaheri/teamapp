//
//  Player+Extension.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import CoreData

struct PlayerValueWrapper: Identifiable {
	let wrappedValue: Player
	var id: UUID {
		wrappedValue.id
	}
}

extension Player {
	static func create(name: String, rating: Double, in managedObjectContext: NSManagedObjectContext) {
		let newPlayer = self.init(context: managedObjectContext)
		newPlayer.uuid = UUID()
		newPlayer.name = name
		newPlayer.rating = rating
		
		do {
			try managedObjectContext.save()
		} catch {
			// Replace this implementation with code to handle the error appropriately.
			// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}
	}

	static func dummyPlayer(in managedObjectContext: NSManagedObjectContext) -> Player {
		let newPlayer = self.init(context: managedObjectContext)
		newPlayer.uuid = UUID()
		newPlayer.name = "John Doe + \(Date())"
		newPlayer.rating = Double(Int.random(in: 0...20)) * 0.5

		do {
			try managedObjectContext.save()
		} catch {
			// Replace this implementation with code to handle the error appropriately.
			// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}

		return newPlayer
	}

	static func deleteAll(from managedObjectContext: NSManagedObjectContext) {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
		fetchRequest.includesPropertyValues = false

		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		deleteRequest.resultType = .resultTypeObjectIDs

		do {
			let result = try managedObjectContext.execute(deleteRequest) as? NSBatchDeleteResult
			let objectIDArray = result?.result as? [NSManagedObjectID]
			if let array = objectIDArray, !array.isEmpty {
				let changes = [NSDeletedObjectsKey : array]
				NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [managedObjectContext])
			}
		} catch let error {
			print("Failed to delete all players: \(error.localizedDescription)")
		}
	}

	func delete(from managedObjectContext: NSManagedObjectContext) {
		managedObjectContext.delete(self)

		do {
			try managedObjectContext.save()
		} catch {
			// Replace this implementation with code to handle the error appropriately.
			// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}
	}

	func edit(name: String, rating: Double, in managedObjectContext: NSManagedObjectContext) {
		self.name = name
		self.rating = rating

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

extension Collection where Element == Player, Index == Int {
	func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
		for index in indices {
			managedObjectContext.delete(self[index])
		}

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
