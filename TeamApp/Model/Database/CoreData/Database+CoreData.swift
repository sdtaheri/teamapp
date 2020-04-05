//
//  Database+CoreData.swift
//  TeamApp
//
//  Created by Saeed Taheri on 3/27/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import CoreData

fileprivate let playerEntity = "Player"

extension NSManagedObjectContext: Database {

	func read<T>(with id: String) -> T? where T : Model {
		guard T.self is Player.Type else {
			return nil
		}

		if let mop = readPlayer(id: id) {
			return Player(player: mop) as? T
		}

		return nil
	}

	func readAll<T>(using sortDescriptors: [NSSortDescriptor]) -> [T] where T : Model {
		guard T.self is Player.Type else {
			return []
		}

		let request = NSFetchRequest<NSFetchRequestResult>(entityName: playerEntity)
		request.sortDescriptors = sortDescriptors

		do {
			if let players = try self.fetch(request) as? [PlayerManagedObject] {
				return players.map(Player.init) as! [T]
			}
		} catch {
			print("Failed fetching all Players")
		}

		return []
	}

	func create<T>(_ object: T) where T : Model {
		guard let player = object as? Player else {
			return
		}

		let newPlayer = PlayerManagedObject(context: self)
		newPlayer.uuid = player.id
		newPlayer.name = player.name
		newPlayer.rating = player.rating

		saveContext()
	}

	func update<T>(_ object: T) where T : Model {
		guard let o = object as? Player else {
			return
		}

		if let player = readPlayer(id: o.id.uuidString) {
			player.name = o.name
			player.rating = o.rating
		} else {
			print("Player with id: \(o.id) does not exist.")
			return
		}

		saveContext()
	}

	func remove<T>(_ object: T) where T : Model {
		guard let o = object as? Player else {
			return
		}

		if let player = readPlayer(id: o.id.uuidString) {
			self.delete(player)
		} else {
			print("Player with id: \(o.id) does not exist.")
			return
		}

		saveContext()
	}

	func remove<T>(_ objects: [T]) where T : Model {
		guard T.self is Player.Type else {
			return
		}

		let request = NSFetchRequest<NSFetchRequestResult>(entityName: playerEntity)
		request.predicate = NSPredicate(format: "uuid IN %@", objects.map {($0 as! Player).id.uuidString})

		do {
			let results = (try self.fetch(request) as? [PlayerManagedObject]) ?? []
			results.forEach { self.delete($0) }
		} catch {
			print("Failed removing provided objects")
			return
		}

		saveContext()
	}

	func removeAll() {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: playerEntity)
		fetchRequest.includesPropertyValues = false

		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		deleteRequest.resultType = .resultTypeObjectIDs

		do {
			let result = try self.execute(deleteRequest) as? NSBatchDeleteResult
			let objectIDArray = result?.result as? [NSManagedObjectID]
			if let array = objectIDArray, !array.isEmpty {
				let changes = [NSDeletedObjectsKey : array]
				NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
			}
		} catch {
			print("Failed to delete all players")
		}
	}

	func cleanup() {
	    if self.hasChanges {
	        do {
	            try self.save()
	        } catch {
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}
}

extension NSManagedObjectContext {
	private func saveContext() {
		do {
			try self.save()
		} catch {
			let nserror = error as NSError
			fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
		}
	}

	private func readPlayer(id: String) -> PlayerManagedObject? {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: playerEntity)
		request.predicate = NSPredicate(format: "uuid = %@", id)

		do {
			let results = try self.fetch(request) as? [PlayerManagedObject]
			return results?.first
		} catch {
			print("Failed fetching Player with id: \(id)")
		}

		return nil
	}
}
