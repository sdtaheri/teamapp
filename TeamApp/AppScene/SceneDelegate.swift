//
//  SceneDelegate.swift
//  TeamApp
//
//  Created by Saeed Taheri on 10/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import UIKit
import SwiftUI

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	// swiftlint:disable force_cast
	private lazy var database: Database = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	// swiftlint:enable force_cast

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		let contentView = ContentView()
			.environment(\.database, database)
			.environmentObject(TeamAppCore())

		if let windowScene = scene as? UIWindowScene {
			#if targetEnvironment(macCatalyst)
			windowScene.titlebar?.titleVisibility = .hidden
			windowScene.titlebar?.toolbar = nil
			#endif

			let window = UIWindow(windowScene: windowScene)
			window.rootViewController = UIHostingController(rootView: contentView)
			self.window = window
			self.window?.tintColor = UIColor.systemGreen
			window.makeKeyAndVisible()
		}
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		database.cleanup()
	}
}
