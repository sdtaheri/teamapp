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
			Text("Total: \(players.map { $0.rating }.sum)")
			Text("Average: \(NumberFormatter.singleDecimal.string(from: NSNumber(value: players.map { $0.rating }.average)) ?? "0")")
		}
    }
}