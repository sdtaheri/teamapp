//
//  PlayerDetailView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/22/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct PlayerDetailView: View {
	@ObservedObject var player: Player
	
	var body: some View {
		VStack(alignment: .center) {
			RingView(rating: Binding.constant(Int(player.rating)))
			Text(player.name ?? "")
				.font(Font.system(size: 80, weight: .bold, design: .rounded))
				.offset(x: 0, y: -32)
				.multilineTextAlignment(.center)
		}
	}
}
