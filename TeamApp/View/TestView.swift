//
//  TestView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/23/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct TestView: View {
    var body: some View {
		Button(action: {

		}) {
			Text("Hello World")
		}.buttonStyle(ActionButtonBackgroundStyle())
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
