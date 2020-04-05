//
//  SceneDelegate.swift
//  TeamApp
//
//  Created by Saeed Taheri on 10/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	private lazy var database: Database = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

		let contentView = ContentView()
			.environment(\.database, database)

		if let windowScene = scene as? UIWindowScene {
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

