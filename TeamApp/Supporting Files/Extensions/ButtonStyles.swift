//
//  ButtonStyles.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/23/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct ActionButtonBackgroundStyle: ButtonStyle {
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.padding()
			.foregroundColor(.white)
			.background(Color.accentColor)
			.clipShape(Capsule())
			.padding([.horizontal])
			.shadow(radius: configuration.isPressed ? 2.0 : 6.0)
			.scaleEffect(configuration.isPressed ? 0.95 : 1)
	}
}
