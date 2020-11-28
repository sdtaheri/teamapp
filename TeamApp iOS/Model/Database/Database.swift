//
//  Database.swift
//  TeamApp
//
//  Created by Saeed Taheri on 3/27/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import Foundation

protocol ReadableDatabase {
	func read<T: Model>(with id: String) -> T?
	func readAll<T: Model>(using sortDescriptors: [NSSortDescriptor]) -> [T]
}

protocol WritableDatabase {
	func create<T: Model>(_ object: T)
	func update<T: Model>(_ object: T)
	func remove<T: Model>(_ object: T)
	func remove<T: Model>(_ objects: [T])
	func removeAll()

	func cleanup()
}

typealias Database = ReadableDatabase & WritableDatabase
