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
					trailing: Button(
						action: {
							self.shouldShowCreatePlayerSheet = true
					}) {
						Text("add")
					}
					.sheet(isPresented: self.$shouldShowCreatePlayerSheet) {
						CreatePlayerView().environment(\.managedObjectContext, self.viewContext)
					}
			)
		}.navigationViewStyle(DoubleColumnNavigationViewStyle())
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		return ContentView()
	}
}
