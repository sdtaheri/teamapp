//
//  CalculatedTeamsView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/23/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct CalculatedTeamsView: View {

	private let core: TeamAppCore

	@Binding private var players: Set<Player>
	private let initialTeams: [(index: Int, players: [Player])]
	@State private var teams = [(index: Int, players: [Player])]()
	@State private var numberOfTeams = 2

	@State private var shouldShowShareSheet = false

	init(players: Binding<Set<Player>>) {
		self._players = players
		let core = TeamAppCore(players: players.wrappedValue)
		self.initialTeams = core.makeTeams(count: 2,
										   bestFirst: Bool.random(),
										   averageBased: Bool.random())
		self.core = core
	}

	var body: some View {
		return ZStack {
			if self.players.count < 2 {
				VStack {
					Image(systemName: "person.badge.minus").font(.system(size: 60))
						.padding()
					Text("you_seem_very_lonely")
						.multilineTextAlignment(.center)
						.font(.system(.body))
				}.padding()
			} else {
				VStack(spacing: 0) {
					List {
						ForEach(teams.isEmpty ? initialTeams : teams, id: \.self.0) { index, team in
							Section(header: Text("team_index \(index + 1)"),
									footer: TeamFooterView(index: index, players: team)) {
										ForEach(team) {
											PlayerListItemView(player: $0)
										}
							}
						}
					}.listStyle(PlainListStyle())

					Divider()

					VStack {
						HStack {
							Button(action: {
								self.generateNewTeams()
							}) {
								Text("again")
									.fontWeight(.medium)
									.font(.system(.headline, design: .rounded))
							}
							.buttonStyle(ActionButtonBackgroundStyle())

							Spacer()

							Stepper(value: $numberOfTeams,
									in: 2...self.players.count,
									onEditingChanged: { didEdit in
										if !didEdit {
											self.generateNewTeams(originatingFromStepper: true)
										}
							}) {
								Text("team_count \(numberOfTeams)")
									.font(.system(.body, design: .rounded))
							}
							.padding(.horizontal)
							.fixedSize()
						}

						if self.players.count == 2 {
							HStack {
								Image(systemName: "person.2")
								Text("you_seem_very_smart")
							}
							.font(.system(.subheadline))
						}
					}.padding(.vertical)
				}
			}
		}
		.navigationBarTitle(Text("teams"), displayMode: .automatic)
		.navigationBarItems(trailing:
			Button(action: {
				self.shouldShowShareSheet = true
			}) {
				Image(systemName: "square.and.arrow.up")
			}
			.opacity(self.players.count >= 2 ? 1 : 0)
		)
			.sheet(isPresented: $shouldShowShareSheet) {
//			.popover(isPresented: $shouldShowShareSheet,
//					 attachmentAnchor: PopoverAttachmentAnchor.point(.topTrailing),
//					 arrowEdge: .top) {
						ShareSheet(activityItems: [self.core.textualRepresentation(teams: self.teams.isEmpty ? self.initialTeams : self.teams)])
		}

	}

	private func generateNewTeams(originatingFromStepper: Bool = false) {
		if originatingFromStepper && self.teams.count == numberOfTeams {
			return
		}

		let teams = core.makeTeams(count: numberOfTeams,
								   bestFirst: Bool.random(),
								   averageBased: Bool.random())

		var teamsAreTheSame = false

		if teams.count == self.teams.count {
			let new = teams.map { $0.players }.flatMap { $0 }.compactMap { $0.uuid }
			let old = self.teams.map { $0.players }.flatMap { $0 }.compactMap { $0.uuid }
			teamsAreTheSame = (new == old)
		}

		if teamsAreTheSame {
			generateNewTeams()
		} else {
			self.teams = teams
		}
	}
}
