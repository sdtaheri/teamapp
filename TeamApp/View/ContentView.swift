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

	var body: some View {
		NavigationView {
			PlayersListView()

			VStack {
				Image(systemName: "arrowshape.turn.up.left").font(.system(size: 60))
					.padding()
				Text("choose_from_left_column")
					.multilineTextAlignment(.center)
					.font(.system(.body))
			}.padding()

		}.navigationViewStyle(DoubleColumnNavigationViewStyle())
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		return ContentView()
	}
}
