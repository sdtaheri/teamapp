//
//  RingView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/22/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct RingView: View {
	
	private let colors = Gradient(colors: [Color.red, Color.yellow, Color.green, Color.red])

	@Binding var rating: Int
	@State var ringWidth: CGFloat = 30

	var body: some View {
		ZStack {
			Circle()
				.stroke(style: StrokeStyle(
					lineWidth: ringWidth,
					lineCap: .round,
					lineJoin: .round))
				.fill(Color(UIColor.systemGray4))

			Circle()
				.trim(from: 0, to: CGFloat(rating) / 10.0)
				.stroke(style: StrokeStyle(
					lineWidth: ringWidth,
					lineCap: .round,
					lineJoin: .round))
				.fill(AngularGradient(gradient: colors, center: .center, startAngle: .degrees(36), endAngle: .degrees(396)))
				.shadow(radius: round(0.125 * ringWidth))
				.animation(Animation.default)

			Text("\(rating)")
				.font(Font.system(size: round(ringWidth * 3 - 8),
								  weight: .bold,
								  design: .rounded))
				.rotationEffect(.degrees(90))
				.foregroundColor(Color.primary)
		}
		.rotationEffect(.degrees(270))
		.padding(round(ringWidth * 0.8))
		.frame(width: round(ringWidth * 6.5),
			   height: round(ringWidth * 6.5))


	}
}

struct RingView_Previews: PreviewProvider {
	static var previews: some View {
		RingView(rating: Binding.constant(5))
	}
}
