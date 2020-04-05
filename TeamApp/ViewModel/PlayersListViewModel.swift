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

	@Published private(set) var allPlayers: [Player] {
		didSet {
			dump(allPlayers)
		}
	}
	let database: Database
	private let core: TeamAppCore

	private let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector:#selector(NSString.localizedStandardCompare))]

	init(database: Database, core: TeamAppCore) {
		self.database = database
		self.core = core
		self.allPlayers = self.database.readAll(using: sortDescriptors)

		NotificationCenter.default.addObserver(self, selector: #selector(setNeedsFetch), name: .DatabaseUpdated, object: nil)
	}

	deinit {
		NotificationCenter.default.removeObserver(self, name: .DatabaseUpdated, object: nil)
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

	func makeTeams(count: Int, with players: Set<Player>) {
		self.core.makeTeams(count: count,
							from: players,
							bestFirst: Bool.random(),
							averageBased: Bool.random())
	}

	@objc private func setNeedsFetch() {
		self.allPlayers = self.database.readAll(using: sortDescriptors)
	}
}
