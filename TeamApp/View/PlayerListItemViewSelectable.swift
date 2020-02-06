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

	private var ratingBinding: Binding<Double> {
		Binding(get: {
			self.player.rating
		}) { _ in
		}
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
			guard self.player.uuid != nil else { return }
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
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let player = Player.dummyPlayer(in: context)
		let selectedBinding = Binding.constant(Set([player]))
		return PlayerListItemViewSelectable(player: player,
											selectedItems: selectedBinding)
	}
}
