//
//  Database+CoreData.swift
//  TeamApp
//
//  Created by Saeed Taheri on 3/27/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import CoreData

extension NSManagedObjectContext: Database {

	func read<T>(with id: String) -> T? where T : PlayerProtocol {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
		request.predicate = NSPredicate(format: "id = %@", id)

		do {
			let results = try self.fetch(request) as? [Player]
			return results?.first as? T
		} catch {
			print("Failed fetching Player with id: \(id)")
			return nil
		}
	}

	func readAll<T>(using sortDescriptors: [NSSortDescriptor]) -> [T] where T : PlayerProtocol {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
		request.sortDescriptors = sortDescriptors

		do {
			return ((try self.fetch(request) as? [Player]) ?? []) as [T]
		} catch {
			print("Failed fetching all Players")
			return []
		}
	}

	func create<T>(_ object: T) where T : PlayerProtocol {
		let newPlayer = Player(context: self)
		newPlayer.uuid = object.id
		newPlayer.name = object.name
		newPlayer.rating = object.rating

		saveContext()
	}

	func update<T>(_ object: T) where T : PlayerProtocol {
		if let player: Player = read(with: object.id.uuidString) {
			player.name = object.name
			player.rating = object.rating
		} else {
			print("Player with id: \(object.id) does not exist.")
			return
		}

		saveContext()
	}

	func remove<T>(_ object: T) where T : PlayerProtocol {
		if let player: Player = read(with: object.id.uuidString) {
			player.delete(from: self)
		} else {
			print("Player with id: \(object.id) does not exist.")
			return
		}

		saveContext()
	}

	func remove<T>(_ objects: [T]) where T : PlayerProtocol {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
		request.predicate = NSPredicate(format: "id IN %@", objects.map {$0.id.uuidString})

		do {
			let results = (try self.fetch(request) as? [Player]) ?? []
			results.forEach { $0.delete(from: self) }
		} catch {
			print("Failed removing provided objects")
			return
		}

		saveContext()
	}

	func removeAll() {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
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
}

extension Player: PlayerProtocol {
	public var id: UUID {
		return uuid ?? UUID()
	}
}
