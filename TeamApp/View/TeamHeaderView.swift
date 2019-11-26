//
//  TeamHeaderView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/23/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct TeamFooterView: View {
	let index: Int
	let players: [Player]

    var body: some View {
		HStack {
			Text("players_count \(Int(players.map { $0.rating }.sum))")
			Text("team_average \(NumberFormatter.singleDecimal.string(from: NSNumber(value: players.map { $0.rating }.average)) ?? "0")")
		}
    }
}

struct TeamFooterView_Previews: PreviewProvider {
	static var previews: some View {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let player = Player.dummyPlayer(in: context)

		return TeamFooterView(index: 1,
							  players: [player])
	}
}
