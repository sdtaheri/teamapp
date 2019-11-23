//
//  PlayerListItemView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/22/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct PlayerListItemView: View {

	@ObservedObject var player: Player

	private var ratingBinding: Binding<Int> {
		Binding(get: {
			self.player.rating.intValue
		}) { _ in
		}
	}

	var body: some View {
		HStack {
			RingView(rating: ratingBinding, ringWidth: 10)
			Text(player.name ?? "")
				.font(Font.system(.title,
								  design: .rounded))
				.padding()
				.foregroundColor(Color.primary)
		}
	}
}
