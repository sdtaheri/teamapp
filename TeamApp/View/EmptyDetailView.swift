//
//  EmptyDetailView.swift
//  TeamApp
//
//  Created by Saeed Taheri on 11/24/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import SwiftUI

struct EmptyDetailView: View {
    var body: some View {
		NavigationView {
			BigImageInfoView(systemImageName: "arrowshape.turn.up.left", localizedStringKey: "choose_from_left_column")
				.navigationBarTitle(Text(""), displayMode: .inline)
		}.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EmptyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyDetailView()
    }
}
