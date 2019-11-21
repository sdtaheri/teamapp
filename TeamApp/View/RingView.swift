//
//  RingView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/22/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct RingView: View {
	
	private let colors = Gradient(colors: [Color.red, Color.orange, Color.yellow, Color.green, Color.red])
	@Binding var rating: Int
	
    var body: some View {
		ZStack {
			Circle()
				.stroke(style: StrokeStyle(
					lineWidth: 30,
					lineCap: .round))
				.fill(Color(UIColor.systemGray6))
			.padding(24)
			.frame(height: 200)
				
			Circle()
				.trim(from: 0, to: CGFloat(rating) / 10.0)
				.stroke(style: StrokeStyle(
					lineWidth: 30,
					lineCap: .round))
				.fill(AngularGradient(gradient: colors, center: .center, startAngle: .degrees(18), endAngle: .degrees(378)))
				.rotationEffect(.degrees(270))
				.shadow(radius: 4.0)
			.padding(24)
			.frame(height: 200)
		}
			
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
		RingView(rating: Binding.constant(4))
    }
}
