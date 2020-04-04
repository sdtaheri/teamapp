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
	@Binding var players: Set<PlayerManagedObject>

	@Environment(\.horizontalSizeClass) private var horizontalSizeClass

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
							Section(header: TeamHeaderView(index: index, players: team)) {
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
							Stepper(value: $desiredTeamCount,
									in: 2...self.playersCount,
									onEditingChanged: { didEdit in
										if !didEdit {
											self.generateNewTeams(originatingFromStepper: true)
										}
							}) {
								EmptyView()
							}
							.padding(.leading)
							.fixedSize()

							Text("team_count \(desiredTeamCount)")
								.font(.system(.body, design: .rounded))

							Spacer()

							Button(action: {
								self.generateNewTeams()
							}) {
								Text("again")
									.fontWeight(.medium)
									.font(.system(.headline, design: .rounded))
							}
							.modifier(ActionButtonModifier())
						}
					}
					.padding(.vertical)
					.navigationBarTitle(Text("teams"), displayMode: .automatic)
				}
			}
		}
		.navigationBarItems(trailing:
			Group {
				if self.playersCount >= 2 {
					#if targetEnvironment(macCatalyst)
					Button(action: {
						let pasteboard = UIPasteboard.general
						pasteboard.string = TeamAppCore.textualRepresentation(of: self.core.teams)
					}) {
						Image(systemName: "doc.on.doc")
					}
					.modifier(BetterTappableIcon())
					#else
					if horizontalSizeClass == .regular {
						ShareButton(shouldShowShareSheet: $shouldShowShareSheet)
							.popover(isPresented: $shouldShowShareSheet) {
								ShareSheet(activityItems: [TeamAppCore.textualRepresentation(of: self.core.teams)])
									.frame(minWidth: 375.0, minHeight: 375.0)
						}
					} else {
						ShareButton(shouldShowShareSheet: $shouldShowShareSheet)
							.sheet(isPresented: $shouldShowShareSheet) {
								ShareSheet(activityItems: [TeamAppCore.textualRepresentation(of: self.core.teams)])
									.frame(minWidth: 375.0, minHeight: 375.0)
						}
					}
					#endif
				} else {
					EmptyView()
				}
			}
		)
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

#if DEBUG
struct CalculatedTeamsView_Previews: PreviewProvider {
	static var previews: some View {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let player1 = PlayerManagedObject.dummyPlayer(in: context)
		let player2 = PlayerManagedObject.dummyPlayer(in: context)
		let core = TeamAppCore()

		return CalculatedTeamsView(core: core,
								   desiredTeamCount: Binding.constant(2),
								   players: Binding.constant(Set([player1, player2])))
	}
}
#endif
