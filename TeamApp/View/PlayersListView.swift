//
//  PlayersListView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct PlayersListView: View {

	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Player.name, ascending: true)],
		animation: .default)
	private var players: FetchedResults<Player>

	@Environment(\.managedObjectContext) private var viewContext
	@EnvironmentObject var core: TeamAppCore

	@State private var shouldShowCreatePlayerSheet: Bool = false
	@State private var shouldShowComingSoonAlert: Bool = false
	@State private var selectedPlayers = Set<Player>()
	@State private var desiredTeamCount = 2

	var body: some View {

		let selectedPlayersBinding = Binding<Set<Player>>(get: {
			self.selectedPlayers
		}) {
			self.selectedPlayers = $0
			self.desiredTeamCount = min(max(2, $0.count), self.desiredTeamCount)
			self.core.makeTeams(count: self.desiredTeamCount,
								from: $0,
								bestFirst: Bool.random(),
								averageBased: Bool.random())
		}

		return Group {
			if players.isEmpty {
				Button(action: {
					self.shouldShowCreatePlayerSheet = true
				}) {
					BigImageInfoView(systemImageName: "plus.circle",
									 localizedStringKey: "try_adding_player")
				}
			} else {
				ZStack(alignment: .bottomTrailing) {
					List {
						Section(footer: Text("tap_to_select_players")) {
							ForEach(players, id: \.id) { player in
								PlayerListItemViewSelectable(player: player, selectedItems: selectedPlayersBinding)
									.contextMenu {
										Button(action: {
											self.shouldShowComingSoonAlert = true
										}) {
											Text("edit")
											Image(systemName: "pencil")
										}

										Button(action: {
											if let index = self.players.firstIndex(of: player) {
												DispatchQueue.main.async {
													selectedPlayersBinding.wrappedValue.remove(player)
													self.players[index].delete(from: self.viewContext)
												}
											}
										}) {
											Text("delete")
											Image(systemName: "trash")
										}
								}
                                .listRowBackground(selectedPlayersBinding.wrappedValue.contains(player) ? Color(UIColor.systemFill) : nil)
							}.onDelete { indices in
								for index in indices {
									let player = self.players[index]
									selectedPlayersBinding.wrappedValue.remove(player)
								}
								self.players.delete(at: indices, from: self.viewContext)
							}
						}
					}
					.listStyle(GroupedListStyle())

					NavigationLink(destination:
						CalculatedTeamsView(core: self.core,
											desiredTeamCount: self.$desiredTeamCount,
											players: selectedPlayersBinding)
						) {
						HStack {
							Text("lets_teamup")
								.fontWeight(.medium)
							Image(systemName: "\(selectedPlayersBinding.wrappedValue.count).circle.fill")
						}
						.font(.system(.headline, design: .rounded))
					}
					.buttonStyle(ActionButtonBackgroundStyle())
					.opacity(selectedPlayersBinding.wrappedValue.isEmpty ? 0 : 1)
					.blur(radius: selectedPlayersBinding.wrappedValue.isEmpty ? 10 : 0)
					.padding(.vertical)
				}
			}
		}
		.navigationBarTitle(Text("app_name"),
							displayMode: players.isEmpty ? .inline : .large)
		.navigationBarItems(leading:
			Button(action: {
				selectedPlayersBinding.wrappedValue.removeAll()
			}) {
				Text("clear")
			}
			.opacity(selectedPlayersBinding.wrappedValue.isEmpty ? 0 : 1)
			,trailing:
			HStack {
//				#if DEBUG
//				Button("Add-Debug") {
//						for i in 0..<20 {
//							Player.create(name: "Player \(i + 1)",
//								rating: (0...10).randomElement() ?? 0,
//								in: self.viewContext)
//						}
//					}
//				#endif
//
				Button(
					action: {
						self.shouldShowCreatePlayerSheet = true
				}) {
					Text("add")
				}
			}
		)
		.animation(Animation.default)
		.alert(isPresented: self.$shouldShowComingSoonAlert) {
			Alert(title: Text("coming_soon"),
				  message: Text("will_come_in_later_release"))
		}
		.sheet(isPresented: self.$shouldShowCreatePlayerSheet) {
			CreatePlayerView()
				.environment(\.managedObjectContext, self.viewContext)
		}
	}
}

struct PlayersListView_Previews: PreviewProvider {
	static var previews: some View {
		PlayersListView()
	}
}
