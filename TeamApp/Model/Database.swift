//
//  Database.swift
//  TeamApp
//
//  Created by Saeed Taheri on 3/27/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import Foundation

protocol ReadableDatabase {
    func read<T: PlayerProtocol>(with id: String) -> T?
	func readAll<T: PlayerProtocol>(using sortDescriptors: [NSSortDescriptor]) -> [T]
}

protocol WritableDatabase {
    func create<T: PlayerProtocol>(_ object: T)
	func update<T: PlayerProtocol>(_ object: T)
	func remove<T: PlayerProtocol>(_ object: T)
	func remove<T: PlayerProtocol>(_ objects: [T])
	func removeAll()

	func cleanup()
}

typealias Database = ReadableDatabase & WritableDatabase

extension Collection where Element: PlayerProtocol, Index == Int {
	func remove(at indices: IndexSet, from writableDatabase: WritableDatabase) {
		var result = [Element]()
		for index in indices {
			result.append(self[index])
		}

		writableDatabase.remove(result)
	}
}
