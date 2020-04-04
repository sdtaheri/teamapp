//
//  Player.swift
//  TeamApp
//
//  Created by Saeed Taheri on 3/27/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import Foundation

class Player: PlayerConvertible {
	let name: String?
	let rating: Double
	let id: UUID

	init(name: String?, rating: Double, id: UUID = UUID()) {
		self.name = name
		self.rating = rating
		self.id = id
	}
}

extension WritableDatabase {
	func create(name: String, rating: Double) {
		let player = Player(name: name, rating: rating)
		create(player)
	}
}

extension Player {
	static func dummy() -> Player {
		let player = Player(name: "John Doe + \(Date())", rating: Double(Int.random(in: 0...20)))
		return player
	}
}
