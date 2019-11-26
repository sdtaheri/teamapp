//
//  CreatePlayerView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct EditPlayerView: View {
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.presentationMode) private var presentationMode
	
	@State private var name: String = ""
	@State private var rating: Int = 5

	@ObservedObject var player: Player

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
						Stepper("rating", value: $rating, in: 0...10)
					}
				}
			}
			.navigationBarTitle("add_player")
			.navigationBarItems(
				leading:
				Button(action: {
					self.presentationMode.wrappedValue.dismiss()
				}) {
					Text("cancel")
				}
				, trailing:
				Button(action: {
					self.player.edit(name: self.name, rating: self.rating, in: self.viewContext)
					self.presentationMode.wrappedValue.dismiss()
				}) {
					Text("save").fontWeight(.bold)
				}.disabled(name.isEmpty)
			)
		}.navigationViewStyle(StackNavigationViewStyle())
		
	}
}

struct EditPlayerView_Previews: PreviewProvider {
	static var previews: some View {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let player = Player.dummyPlayer(in: context)
		return EditPlayerView(player: player).environment(\.managedObjectContext, context)
	}
}
