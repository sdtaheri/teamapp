//
//  RingView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/22/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct RingView: View {
	@Environment(\.layoutDirection) private var layoutDirection

    @Binding var rating: Double
    @State var ringWidth: CGFloat = 30

	@State private var newRating: Double = 0.0

    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(
                    lineWidth: ringWidth,
                    lineCap: .round,
                    lineJoin: .round))
                .fill(Color(UIColor.systemGray4))

            Circle()
                .trim(from: 0, to: CGFloat(rating) / 20.0)
                .stroke(style: StrokeStyle(
                    lineWidth: ringWidth,
                    lineCap: .round,
                    lineJoin: .round))
                .fill(Color.gray)
				.blur(radius: round(0.075 * ringWidth))
				.animation(.default)

            Circle()
                .trim(from: 0, to: CGFloat(rating) / 20.0)
                .stroke(style: StrokeStyle(
                    lineWidth: ringWidth,
                    lineCap: .round,
                    lineJoin: .round))
				.fill(Color("Color\(Int((rating / 2.0).rounded()))"))
				.animation(.default)
			Text(String(Int(rating.rounded())))
				.font(
					Font.system(
						size: round(ringWidth * 3 - 8.5),
						weight: .bold,
						design: .rounded
					)
				)
                .rotationEffect(layoutDirection == .rightToLeft ? .degrees(270) : .degrees(90))
                .foregroundColor(Color.primary)
        }
		.rotationEffect(layoutDirection == .rightToLeft ? .degrees(90) : .degrees(270))
        .padding(round(ringWidth * 0.8))
        .frame(
			width: round(ringWidth * 6.5),
			height: round(ringWidth * 6.5)
		)
		.gesture(DragGesture()
			.onChanged { value in
				let newValue = self.newRating - Double(value.translation.height / 20.0)
				self.rating = max(0, min(20, newValue))
			}
			.onEnded { value in
				let newValue = self.newRating - Double(value.translation.height / 20.0)
				self.rating = max(0, min(20, newValue))
				self.newRating = self.rating
			})
		.onAppear {
			self.newRating = self.rating
		}
    }
}

#if DEBUG
struct RingView_Previews: PreviewProvider {
	static var previews: some View {
		RingView(rating: Binding.constant(5))
			.environment(\.layoutDirection, .leftToRight)
	}
}
#endif
