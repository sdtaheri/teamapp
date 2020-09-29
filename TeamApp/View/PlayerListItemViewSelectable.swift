//
//  PlayerListItemView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/22/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct PlayerListItemViewSelectable: View {
	@ObservedObject var player: Player
	@Binding var selectedItems: Set<Player>

	private var isSelected: Bool {
		return selectedItems.contains(player)
	}

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
			PlayerListItemView(player: player)
			if isSelected {
				Image(systemName: "checkmark.seal.fill")
					.foregroundColor(Color.accentColor)
					.font(Font.system(.body))
			}
		}
		.contentShape(Rectangle())
		.onTapGesture {
			if self.isSelected {
				self.selectedItems.remove(self.player)
			} else {
				self.selectedItems.insert(self.player)
			}
		}
	}
}

struct PlayerListItemViewSelectable_Previews: PreviewProvider {
	static var previews: some View {
		let player = Player.dummy()
		let selectedBinding = Binding.constant(Set([player]))
		return PlayerListItemViewSelectable(
			player: player,
			selectedItems: selectedBinding
		)
	}
}
