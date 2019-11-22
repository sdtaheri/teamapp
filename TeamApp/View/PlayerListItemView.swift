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
	@Binding var selectedItems: Set<UUID>

	private var isSelected: Bool {
		if let uuid = player.uuid {
			return selectedItems.contains(uuid)
		}
		return false
	}

	private var ratingBinding: Binding<Int> {
		Binding(get: {
			self.player.rating.intValue
		}) { _ in
		}
	}

	var body: some View {
		Button(action: {
			guard let uuid = self.player.uuid else { return }
			if self.isSelected {
				self.selectedItems.remove(uuid)
			} else {
				self.selectedItems.insert(uuid)
			}
		}) {
			HStack {
				RingView(rating: ratingBinding, ringWidth: 10)
				Text(player.name ?? "")
					.font(Font.system(.title,
									  design: .rounded))
					.padding()
					.foregroundColor(Color.primary)
				if isSelected {
					Spacer()
					Image(systemName: "checkmark.shield.fill")
						.foregroundColor(Color.accentColor)
						.font(Font.system(.title))
						
				}
			}
		}
	}
}
