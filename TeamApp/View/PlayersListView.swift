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
	
	@State private var selectionKeeper = Set<Player>()
	
	var body: some View {
		List(selection: $selectionKeeper) {
			ForEach(players, id: \.self) { player in
				NavigationLink(
					destination: DetailView(player: player)
				) {
					Text("\(player.name ?? "Unknown"), \(player.rating)")
				}
			}.onDelete { indices in
				self.players.delete(at: indices, from: self.viewContext)
			}
		}.listStyle(GroupedListStyle())
	}
}

struct PlayersListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayersListView()
    }
}
