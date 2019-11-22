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

	@State private var selectedItems = Set<UUID>()

	var body: some View {
		ZStack(alignment: .bottomTrailing) {
			List(selection: $selectedItems) {
				ForEach(players, id: \.self) { player in
					PlayerListItemView(player: player, selectedItems: self.$selectedItems)
				}.onDelete { indices in
					self.players.delete(at: indices, from: self.viewContext)
				}
			}
			.listStyle(GroupedListStyle())

			Button(action: {

			}) {
				HStack {
					Text("lets_play")
						.fontWeight(.medium)
					Image(systemName: "\(selectedItems.count).circle.fill")
				}
				.font(.title)
			}
			.buttonStyle(ActionButtonBackgroundStyle())
			.opacity(selectedItems.isEmpty ? 0 : 1)
			.blur(radius: selectedItems.isEmpty ? 10 : 0)
		}
		.animation(Animation.default)
	}
}

struct PlayersListView_Previews: PreviewProvider {
	static var previews: some View {
		PlayersListView()
	}
}
