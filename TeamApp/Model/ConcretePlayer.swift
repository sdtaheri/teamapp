//
//  ConcretePlayer.swift
//  TeamApp
//
//  Created by Saeed Taheri on 3/27/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import Foundation

struct ConcretePlayer: PlayerProtocol {
	let name: String?
	let rating: Double
	let id: UUID = UUID()
}

extension WritableDatabase {
	func create(name: String, rating: Double) {
		let player = ConcretePlayer(name: name, rating: rating)
		create(player)
	}
}

extension ConcretePlayer {
	static func dummy() -> Self {
		let player = ConcretePlayer(name: "John Doe + \(Date())", rating: Double(Int.random(in: 0...20)))
		return player
	}
}
