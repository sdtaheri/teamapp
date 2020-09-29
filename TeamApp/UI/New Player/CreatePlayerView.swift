//
//  CreatePlayerView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct CreatePlayerView: View {
	@Environment(\.writableDatabase) private var database
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
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button {
						self.presentationMode.wrappedValue.dismiss()
					} label: {
						Image(systemName: "xmark.circle")
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button {
						if let player = self.player {
							self.database.update(Player(name: self.name, rating: self.rating, id: player.id))
						} else {
							self.database.create(name: self.name, rating: self.rating)
						}
						NotificationCenter.default.post(name: .databaseUpdated, object: nil)
						self.presentationMode.wrappedValue.dismiss()
					} label: {
						Text("save")
							.fontWeight(.bold)
					}
					.disabled(name.isEmpty)
				}
			}
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.onAppear {
			if let player = self.player {
				self.name = player.name
				self.rating = player.rating
			}
		}
	}
}

struct CreatePlayerView_Previews: PreviewProvider {
	static var previews: some View {
		return CreatePlayerView()
	}
}
