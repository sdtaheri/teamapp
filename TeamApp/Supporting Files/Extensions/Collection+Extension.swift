//
//  Collection+Extension.swift
//  TeamApp
//
//  Created by Saeed Taheri on 4/4/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import Foundation

extension Collection where Element: Player, Index == Int {
	func remove(at indices: IndexSet, from writableDatabase: WritableDatabase) {
		var result = [Element]()
		for index in indices {
			result.append(self[index])
		}

		writableDatabase.remove(result)
	}
}

extension Collection where Element: Numeric {
	var sum: Element { return reduce(0, +) }
}

extension Collection where Element: BinaryFloatingPoint {
	/// Returns the average of all elements in the array
	var average: Double {
		return isEmpty ? 0 : Double(sum) / Double(count)
	}
}
