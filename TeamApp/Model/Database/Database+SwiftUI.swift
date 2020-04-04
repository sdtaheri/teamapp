//
//  Database+SwiftUI.swift
//  TeamApp
//
//  Created by Saeed Taheri on 4/4/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import SwiftUI
import CoreData

struct ReadableDatabaseKey: EnvironmentKey {
	static let defaultValue: ReadableDatabase = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
}

struct WritableDatabaseKey: EnvironmentKey {
	static let defaultValue: WritableDatabase = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
}

struct DatabaseKey: EnvironmentKey {
	static let defaultValue: Database = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
}

extension EnvironmentValues {
	var readableDatabase: ReadableDatabase {
		get {
			return self[ReadableDatabaseKey.self]
		}
		set {
			self[ReadableDatabaseKey.self] = newValue
		}
	}

	var writableDatabase: WritableDatabase {
		get {
			return self[WritableDatabaseKey.self]
		}
		set {
			self[WritableDatabaseKey.self] = newValue
		}
	}

	var database: Database {
		get {
			return self[DatabaseKey.self]
		}
		set {
			self[DatabaseKey.self] = newValue
		}
	}
}
