//
//  ViewModifiers.swift
//  TeamApp
//
//  Created by Saeed Taheri on 3/23/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct BetterTappableIcon: ViewModifier {
	let alignment: Alignment

	func body(content: Content) -> some View {
		content
			.imageScale(.large)
			.frame(minWidth: 32.0, minHeight: 44.0, alignment: alignment)
	}
}
