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
	var players: FetchedResults<Player>

	@Environment(\.managedObjectContext)
	private var viewContext

	@State
	private var shouldShowCreatePlayerSheet: Bool = false

	@State private var selectedPlayers = Set<Player>()

	var body: some View {
		ZStack {
			ZStack(alignment: .bottomTrailing) {
				List {
					ForEach(players, id: \.self) { player in
						PlayerListItemViewSelectable(player: player, selectedItems: self.$selectedPlayers)
//							.contextMenu {
//								Button(action: {
//
//								}) {
//									Text("edit")
//									Image(systemName: "pencil")
//								}
//
//								Button(action: {
//									if self.selectedPlayers.contains(player) {
//										self.selectedPlayers.remove(player)
//									} else {
//										self.selectedPlayers.insert(player)
//									}
//								}) {
//									Text(self.selectedPlayers.contains(player) ? "unselect" : "select")
//									Image(systemName: self.selectedPlayers.contains(player) ? "multiply" : "checkmark")
//								}
//
//								Button(action: {
//
//								}) {
//									Text("delete")
//									Image(systemName: "trash")
//								}
//							}
					}.onDelete { indices in
						self.selectedPlayers.removeAll()
						self.players.delete(at: indices, from: self.viewContext)
					}
				}
				.listStyle(GroupedListStyle())

				NavigationLink(destination: CalculatedTeamsView(players: $selectedPlayers)) {
					HStack {
						Text("lets_play")
							.fontWeight(.medium)
						Image(systemName: "\(selectedPlayers.count).circle.fill")
					}
					.font(.system(.headline, design: .rounded))
				}
				.buttonStyle(ActionButtonBackgroundStyle())
				.opacity(selectedPlayers.isEmpty ? 0 : 1)
				.blur(radius: selectedPlayers.isEmpty ? 10 : 0)
				.padding(.vertical)
			}

			if players.isEmpty {
				Button(action: {
					self.shouldShowCreatePlayerSheet = true
				}) {
					VStack {
						Image(systemName: "plus.circle").font(.system(size: 60))
							.padding()
						Text("try_adding_player")
							.multilineTextAlignment(.center)
							.font(.system(.body))
					}.padding()
				}
			}
		}
		.navigationBarTitle(Text("app_name"), displayMode: players.isEmpty ? .inline : .large)
		.navigationBarItems(leading:
			Button(action: {
				self.selectedPlayers.removeAll()
			}) {
				Text("clear")
			}
			.opacity(self.selectedPlayers.isEmpty ? 0 : 1)
			,trailing: Button(
				action: {
					self.shouldShowCreatePlayerSheet = true
			}) {
				Text("add")
			}
		)
			.sheet(isPresented: self.$shouldShowCreatePlayerSheet) {
				CreatePlayerView().environment(\.managedObjectContext, self.viewContext)
		}
		.animation(Animation.default)
	}
}

struct PlayersListView_Previews: PreviewProvider {
	static var previews: some View {
		PlayersListView()
	}
}
