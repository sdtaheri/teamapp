//
//  PlayersListViewModel.swift
//  TeamApp
//
//  Created by Saeed Taheri on 4/5/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import Foundation
import Combine

final class PlayersListViewModel: ObservableObject {
	@Published private(set) var allPlayers: [Player]
	let database: Database

	private let sortDescriptors = [
		NSSortDescriptor(
			key: "name",
			ascending: true,
			selector: #selector(NSString.localizedStandardCompare)
		)
	]

	init(database: Database) {
		self.database = database
		self.allPlayers = self.database.readAll(using: sortDescriptors)

		NotificationCenter.default.addObserver(self, selector: #selector(setNeedsFetch), name: .databaseUpdated, object: nil)
	}

	func removePlayer(at index: Int) {
		let player = allPlayers[index]
		database.remove(player)
		setNeedsFetch()
	}

	func removePlayers(at indices: IndexSet) {
		allPlayers.remove(at: indices, from: database)
		setNeedsFetch()
	}

	func removeAllPlayers() {
		self.database.removeAll()
		setNeedsFetch()
	}

	func createDummyPlayers(count: Int) {
		for _ in 0..<count {
			self.database.create(Player.dummy())
		}
		setNeedsFetch()
	}

	@objc private func setNeedsFetch() {
		self.allPlayers = self.database.readAll(using: sortDescriptors)
	}
}
