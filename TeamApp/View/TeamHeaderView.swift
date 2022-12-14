//
//  TeamHeaderView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/23/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct TeamHeaderView: View {
	let index: Int
	let players: [Player]

	private var teamAverage: Double {
		players.map { $0.rating }.average
	}

	var body: some View {
		GeometryReader { proxy in
			HStack {
				Text("team_index \(self.index + 1)")
					.bold()
				Text("total \(Int(self.players.map { $0.rating }.sum))")
				Spacer()
				Text(NumberFormatter.singleDecimal.string(from: NSNumber(value: self.teamAverage)) ?? "0")
				ProgressBarView(height: 10, progress: Binding.constant(self.teamAverage / 20.0))
					.frame(width: proxy.size.width / 3.0)
			}
		}
	}
}

#if DEBUG
struct TeamHeaderView_Previews: PreviewProvider {
	static var previews: some View {
		let player = Player.dummy()
		return TeamHeaderView(index: 1,
							  players: [player])
	}
}
#endif
