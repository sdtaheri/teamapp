//
//  ContentView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 10/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.database) private var database
	@Environment(\.horizontalSizeClass) private var horizontalSizeClass

	var body: some View {
		NavigationView {
			PlayersListView(viewModel: PlayersListViewModel(database: database))
				.environment(\.horizontalSizeClass, horizontalSizeClass)
			EmptyDetailView()
		}.navigationViewStyle(DoubleColumnNavigationViewStyle())
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		return ContentView()
	}
}
