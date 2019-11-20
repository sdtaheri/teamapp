//
//  ContentView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 10/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.managedObjectContext) private var viewContext

	@State
	private var shouldShowCreatePlayerSheet: Bool = false
	
	var body: some View {
		NavigationView {
			PlayersListView()
				.navigationBarTitle(Text("app_name"))
				.navigationBarItems(
					leading: EditButton(),
					trailing: Button(
						action: {
							self.shouldShowCreatePlayerSheet = true
						})
					{
						Image(systemName: "plus")
					}
					.sheet(isPresented: self.$shouldShowCreatePlayerSheet) {
						CreatePlayerView().environment(\.managedObjectContext, self.viewContext)
					}
			)
			Text("Detail view content goes here")
				.navigationBarTitle(Text("Detail"))
		}.navigationViewStyle(DoubleColumnNavigationViewStyle())
	}
}

struct DetailView: View {
	@ObservedObject var player: Player
	
	var body: some View {
		Text("\(player.name ?? "Unknown"), \(player.rating)")
			.navigationBarTitle(Text(player.name ?? "Unknown"))
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		return ContentView()
	}
}
