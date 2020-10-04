//
//  CalculatedTeamsView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/23/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct CalculatedTeamsView: View {
	let players: Set<Player>

	@ObservedObject private var core: TeamAppCore
	@State private var desiredTeamCount: Int = 2
	@State private var canAnimate: Bool = false

	init(players: Set<Player>) {
		self.players = players
		self.core = TeamAppCore(players: players)
		generateNewTeams()
	}

	var body: some View {
		if players.isEmpty {
			EmptyDetailView()
				.navigationBarTitle(Text(""), displayMode: .inline)
		} else if players.count == 1 {
			BigImageInfoView(
				systemImageName: "person.badge.minus",
				localizedStringKey: "you_seem_very_lonely"
			)
			.navigationBarTitle(Text(""), displayMode: .inline)
		} else {
			VStack(spacing: 0) {
				if core.teams.isEmpty {
					Spacer()
						.onAppear {
							desiredTeamCount = 2
						}
				} else {
					List {
						ForEach(core.teams, id: \.self.0) { index, team in
							Section(
								header: TeamHeaderView(index: index, players: team)
									.padding(.top)
									.padding(.bottom, 8)
							) {
								ForEach(team) {
									PlayerListItemView(player: $0)
								}
							}
						}
					}
					.animation(canAnimate ? .default : nil)
					.listStyle(InsetGroupedListStyle())
					.onAppear {
						DispatchQueue.main.async {
							canAnimate = true
						}
					}
				}

				Divider()

				VStack {
					if players.count == 2 {
						HStack {
							Image(systemName: "person.2")
							Text("you_seem_very_smart")
						}
						.font(.system(.subheadline))
					}

					HStack {
						Stepper(
							value: $desiredTeamCount,
							in: 2...players.count,
							onEditingChanged: { didEdit in
								if !didEdit {
									generateNewTeams(originatingFromStepper: true)
								}
							},
							label: {
								EmptyView()
							}
						)
						.padding(.leading)
						.fixedSize()

						Text("team_count \(desiredTeamCount)")
							.font(.system(.body, design: .rounded))

						Spacer()

						Button {
							generateNewTeams()
						} label: {
							Text("again")
								.fontWeight(.medium)
								.font(.system(.headline, design: .rounded))
						}
						.modifier(ActionButtonModifier())
						.animation(canAnimate ? .default : nil)
					}
				}
				.padding(.vertical)
			}
			.navigationBarTitle(Text("teams"), displayMode: .automatic)
			.toolbar {
				ToolbarItem(
					placement: .navigationBarTrailing) {
					if players.count >= 2 {
						#if targetEnvironment(macCatalyst)
						Button {
							let pasteboard = UIPasteboard.general
							pasteboard.string = TeamAppCore.textualRepresentation(of: self.core.teams)
						} label: {
							Image(systemName: "doc.on.doc")
						}
						#else
						ShareButton(
							activityItems: [
								TeamAppCore.textualRepresentation(of: core.teams)
							]
						)
						#endif
					} else {
						EmptyView()
					}
				}
			}
			.ignoresSafeArea(.keyboard)
		}
	}

	private func generateNewTeams(originatingFromStepper: Bool = false) {
		if originatingFromStepper && core.teams.count == desiredTeamCount {
			return
		}

		core.makeTeams(
			count: desiredTeamCount,
			bestFirst: Bool.random(),
			averageBased: Bool.random()
		)
	}
}

struct CalculatedTeamsView_Previews: PreviewProvider {
	static var previews: some View {
		var players: Set<Player> = []
		for _ in 0 ..< 8 {
			players.insert(Player.dummy())
		}

		return CalculatedTeamsView(players: players)
	}
}
