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
	@State private var rating: Int = 5
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					VStack {
						RingView(rating: $rating)
						Stepper("rating", value: $rating, in: 0...10)
					}
				}
				Section {
					TextField("name", text: $name)
						.disableAutocorrection(true)
				}
			}
			.navigationBarTitle("add_player")
			.navigationBarItems(leading:
				Button(action: {
					self.presentationMode.wrappedValue.dismiss()
				}) {
					Text("cancel")
				}
				,trailing: Button(action: {
					Player.create(name: self.name, rating: self.rating, in: self.viewContext)
					self.presentationMode.wrappedValue.dismiss()
				}) {
					Text("save").fontWeight(.bold)
				}.disabled(name.isEmpty))
		}.navigationViewStyle(StackNavigationViewStyle())
		
	}
}

struct CreatePlayerView_Previews: PreviewProvider {
	static var previews: some View {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		return CreatePlayerView().environment(\.managedObjectContext, context)
	}
}
