//
//  ShareButton.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/28/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct ShareButton: View {
	let activityItems: [Any]

	@State private var shouldShowShareSheet = false

	var body: some View {
		Button {
			shouldShowShareSheet = true
		} label: {
			Image(systemName: "square.and.arrow.up")
		}
		.sheet(isPresented: $shouldShowShareSheet) {
			ShareSheet(activityItems: activityItems) { _, _, _, _ in
				shouldShowShareSheet = false
			}
		}
	}
}

struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
		ShareButton(activityItems: [])
			.previewLayout(PreviewLayout.sizeThatFits)
    }
}
