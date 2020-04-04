//
//  Player.swift
//  TeamApp
//
//  Created by Saeed Taheri on 3/27/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import Foundation
import CoreData

final class Player: PlayerConvertible {
	let name: String?
	let rating: Double
	let id: UUID

	init(name: String?, rating: Double, id: UUID = UUID()) {
		self.name = name
		self.rating = rating
		self.id = id
	}
}

extension Player: Equatable {
	static func == (lhs: Player, rhs: Player) -> Bool {
		return lhs.id == rhs.id
	}
}

extension Player: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(name)
		hasher.combine(rating)
		hasher.combine(id)
	}
}

extension Player: ObservableObject {
	
}

extension Player {
	static func dummy() -> Player {
		let player = Player(name: "John Doe at \(DateFormatter.shortTime.string(from: Date()))", rating: Double(Int.random(in: 0...20)))
		return player
	}
}

extension WritableDatabase {
	func create(name: String, rating: Double) {
		let player = Player(name: name, rating: rating)
		create(player)
	}
}
