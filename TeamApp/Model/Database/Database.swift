//
//  Database.swift
//  TeamApp
//
//  Created by Saeed Taheri on 3/27/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import Foundation

protocol ReadableDatabase {
    func read<T: PlayerConvertible>(with id: String) -> T?
	func readAll<T: PlayerConvertible>(using sortDescriptors: [NSSortDescriptor]) -> [T]
}

protocol WritableDatabase {
    func create<T: PlayerConvertible>(_ object: T)
	func update<T: PlayerConvertible>(_ object: T)
	func remove<T: PlayerConvertible>(_ object: T)
	func remove<T: PlayerConvertible>(_ objects: [T])
	func removeAll()

	func cleanup()
}

typealias Database = ReadableDatabase & WritableDatabase

extension Collection where Element: PlayerConvertible, Index == Int {
	func remove(at indices: IndexSet, from writableDatabase: WritableDatabase) {
		var result = [Element]()
		for index in indices {
			result.append(self[index])
		}

		writableDatabase.remove(result)
	}
}
