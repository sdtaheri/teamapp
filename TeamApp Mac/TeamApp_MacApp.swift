//
//  TeamApp_MacApp.swift
//  TeamApp Mac
//
//  Created by Saeed Taheri on 11/29/20.
//  Copyright © 2020 Saeed Taheri. All rights reserved.
//

import SwiftUI

@main
struct TeamApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
