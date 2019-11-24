//
//  CalculatedTeamsView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/23/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct CalculatedTeamsView: View {

	@ObservedObject var core: TeamAppCore
	@Binding var desiredTeamCount: Int
	@Binding var players: Set<Player>

	private var playersCount: Int {
		return self.players.count
	}

	@State private var shouldShowShareSheet = false

	var body: some View {
		Group {
			if playersCount == 0 {
				EmptyDetailView()
					.navigationBarTitle(Text(""), displayMode: .inline)
			} else if playersCount == 1 {
				BigImageInfoView(systemImageName: "person.badge.minus",
								 localizedStringKey: "you_seem_very_lonely")
					.navigationBarTitle(Text(""), displayMode: .inline)
			} else {
				VStack(spacing: 0) {
					List {
						ForEach(core.teams, id: \.self.0) { index, team in
							Section(header: Text("team_index \(index + 1)"),
									footer: TeamFooterView(index: index, players: team)) {
										ForEach(team) {
											PlayerListItemView(player: $0)
										}
							}
						}
					}
					.listStyle(GroupedListStyle())

					Divider()

					VStack {
						if self.playersCount == 2 {
							HStack {
								Image(systemName: "person.2")
								Text("you_seem_very_smart")
							}
							.font(.system(.subheadline))
						}

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

							Stepper(value: $desiredTeamCount,
									in: 2...self.playersCount,
									onEditingChanged: { didEdit in
										if !didEdit {
											self.generateNewTeams(originatingFromStepper: true)
										}
							}) {
								Text("team_count \(desiredTeamCount)")
									.font(.system(.body, design: .rounded))
							}
							.padding(.horizontal)
							.fixedSize()
						}
					}
					.padding(.vertical)
					.navigationBarTitle(Text("teams"), displayMode: .automatic)
				}
			}
		}
		.navigationBarItems(trailing:
			Button(action: {
				self.shouldShowShareSheet = true
			}) {
				Image(systemName: "square.and.arrow.up")
			}
			.opacity(self.playersCount >= 2 ? 1 : 0)
		)
			.sheet(isPresented: $shouldShowShareSheet) {
				ShareSheet(activityItems: [TeamAppCore.textualRepresentation(of: self.core.teams)])
		}
	}

	private func generateNewTeams(originatingFromStepper: Bool = false) {
		if originatingFromStepper && self.core.teams.count == desiredTeamCount {
			return
		}

		core.makeTeams(count: desiredTeamCount,
					   from: players,
					   bestFirst: Bool.random(),
					   averageBased: Bool.random())
	}
}
