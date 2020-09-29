//
//  ProgressBarView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/28/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct ProgressBarView: View {
	let height: CGFloat
	@Binding var progress: Double

	var body: some View {
		let normalizedProgress = Binding(
			get: {
				max(0, min(1, self.progress))
			},
			set: {
				self.progress = $0
			}
		)

		return Rectangle()
			.fill(Color(UIColor.systemGray4))
			.clipShape(Capsule())
			.frame(height: height)
			.overlay(GeometryReader { proxy in
				Rectangle()
					.fill(Color("Color\(Int(round(normalizedProgress.wrappedValue * 10)))"))
					.frame(
						width: proxy.size.width * CGFloat(normalizedProgress.wrappedValue),
						height: self.height
					)
					.clipShape(Capsule())
					.position(
						CGPoint(
							x: 0.5 * proxy.size.width * CGFloat( normalizedProgress.wrappedValue),
							y: 0.5 * proxy.size.height
						)
					)
					.shadow(radius: round(0.125 * self.height))
					.animation(.default)
			})
	}
}

struct ProgressBarView_Previews: PreviewProvider {
	static var previews: some View {
		ProgressBarView(height: 30, progress: Binding.constant(0.8))
			.padding()
			.previewLayout(PreviewLayout.sizeThatFits)
	}
}
