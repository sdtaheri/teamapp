//
//  BigImageInfoView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/24/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct BigImageInfoView: View {
	let systemImageName: String
	let localizedStringKey: LocalizedStringKey

	var body: some View {
		VStack {
			Image(systemName: systemImageName)
				.font(.system(size: 60))
				.padding()
				.flipsForRightToLeftLayoutDirection(true)
			Text(localizedStringKey)
				.multilineTextAlignment(.center)
				.font(.system(.body))
		}
		.padding()
	}
}

struct BigImageInfoView_Previews: PreviewProvider {
    static var previews: some View {
		BigImageInfoView(
			systemImageName: "arrowshape.turn.up.left",
			localizedStringKey: "choose_from_left_column"
		)
    }
}
