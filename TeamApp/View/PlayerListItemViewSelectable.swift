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
		guard player.uuid != nil else {
			return false
		}
		return selectedItems.contains(player)
	}

	private var ratingBinding: Binding<Int> {
		Binding(get: {
			self.player.rating.intValue
		}) { _ in
		}
	}

	var body: some View {
		Button(action: {
			guard self.player.uuid != nil else { return }
			if self.isSelected {
				self.selectedItems.remove(self.player)
			} else {
				self.selectedItems.insert(self.player)
			}
		}) {
			HStack {
				PlayerListItemView(player: player)
				if isSelected {
					Spacer()
					Image(systemName: "checkmark.seal.fill")
						.foregroundColor(Color.accentColor)
						.font(Font.system(.body))
						
				}
			}
		}
	}
}
