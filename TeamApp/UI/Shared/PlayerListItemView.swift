//
//  PlayerListItemView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/22/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct PlayerListItemView: View {
	let player: Player

	private var ratingBinding: Binding<Double> {
		Binding(
			get: {
				player.rating
			},
			set: { _ in
			}
		)
	}

	var body: some View {
		HStack {
			RingView(rating: ratingBinding, ringWidth: 8)
			Text(player.name)
				.font(Font.system(.body, design: .rounded))
				.padding()
				.foregroundColor(Color.primary)
			Spacer()
		}
	}
}

struct PlayerListItemView_Previews: PreviewProvider {
	static var previews: some View {
		let player = Player.dummy()
		return PlayerListItemView(player: player)
			.previewLayout(PreviewLayout.sizeThatFits)
	}
}
