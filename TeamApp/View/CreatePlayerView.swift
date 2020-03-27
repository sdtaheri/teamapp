//
//  CreatePlayerView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct CreatePlayerView: View {
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.presentationMode) private var presentationMode
	
	@State private var name: String = ""
	@State private var rating: Double = 5

	var player: Player?

	var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("name", text: $name)
						.disableAutocorrection(true)
						.autocapitalization(.words)
				}
				Section {
					VStack {
						RingView(rating: $rating)
						Stepper("rating", value: $rating, in: 0...20)
					}
				}
			}
			.navigationBarTitle(self.player != nil ? "edit_player" : "add_player", displayMode: .inline)
			.navigationBarItems(
				leading:
				Button(action: {
					self.presentationMode.wrappedValue.dismiss()
				}) {
					Image(systemName: "xmark.circle")
				}
				.modifier(BetterTappableIcon())
				, trailing:
				Button(action: {
					if let player = self.player {
						player.edit(name: self.name, rating: self.rating, in: self.viewContext)
					} else {
						Player.create(name: self.name, rating: self.rating, in: self.viewContext)
					}
					self.presentationMode.wrappedValue.dismiss()
				}) {
					Text("save").fontWeight(.bold)
				}
				.modifier(BetterTappableIcon())
				.disabled(name.isEmpty)
			)
		}.navigationViewStyle(StackNavigationViewStyle())
			.onAppear {
				if let player = self.player {
					self.name = player.name ?? ""
					self.rating = player.rating
				}
		}
		
	}
}

struct CreatePlayerView_Previews: PreviewProvider {
	static var previews: some View {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		return CreatePlayerView().environment(\.managedObjectContext, context)
	}
}
