//
//  ButtonStyles.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/23/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct ActionButtonModifier: ViewModifier {
	@State private var isHovered = false

	func body(content: Content) -> some View {
		content
			.buttonStyle(ActionButtonBackgroundStyle())
			.scaleEffect(self.isHovered ? 1.05 : 1)
			.animation(.default)
			.onHover {
				self.isHovered = $0
			}
	}
}

struct BetterTappableIcon: ViewModifier {
	func body(content: Content) -> some View {
		content
			.imageScale(.large)
			.frame(minWidth: 36.0, minHeight: 36.0)
			.contentShape(Rectangle())
			.hoverEffect()
	}
}

private struct ActionButtonBackgroundStyle: ButtonStyle {
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
