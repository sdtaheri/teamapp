//
//  ShareButton.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/28/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct ShareButton: View {

	let alignment: Alignment
	@Binding var shouldShowShareSheet: Bool

	var body: some View {
		Button(action: {
			self.shouldShowShareSheet = true
		}) {
			Image(systemName: "square.and.arrow.up")
				.modifier(BetterTappableIcon(alignment: alignment))
		}
	}
}

struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
		ShareButton(alignment: .center, shouldShowShareSheet: Binding.constant(true))
    }
}
