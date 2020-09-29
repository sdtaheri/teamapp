//
//  PlayerListItemView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/22/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct PlayerListItemViewSelectable: View {
	let player: Player
	@Binding var selectedItems: Set<Player>

	private var isSelected: Bool {
		return selectedItems.contains(player)
	}

	var body: some View {
		Button {
			withAnimation {
				if isSelected {
					selectedItems.remove(player)
				} else {
					selectedItems.insert(player)
				}
			}
		} label: {
			HStack {
				PlayerListItemView(player: player)
				if isSelected {
					Image(systemName: "checkmark.seal.fill")
						.foregroundColor(Color.accentColor)
						.font(Font.system(.body))
				}
			}
			.contentShape(Rectangle())
		}
		.buttonStyle(PlainButtonStyle())
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
		.previewLayout(PreviewLayout.sizeThatFits)
	}
}
