//
//  AppDelegate.swift
//  TeamApp
//
//  Created by Saeed Taheri on 10/21/19.
//  Copyright © 2019 Saeed Taheri. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		setNavigationBarsFont()
		UIApplication.shared.registerForRemoteNotifications()

		if let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
			self.application(
				application,
				didReceiveRemoteNotification: remoteNotification
			) { _ in }
		}

		return true
	}

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		if CKNotification(fromRemoteNotificationDictionary: userInfo) != nil {
			NotificationCenter.default.post(name: .databaseUpdated, object: nil)
		}
	}

	// MARK: - UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentCloudKitContainer = {
		let container = NSPersistentCloudKitContainer(name: "TeamApp")
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()
}

extension AppDelegate {
	private func setNavigationBarsFont() {
		let appearance = UINavigationBarAppearance()

		#if targetEnvironment(macCatalyst)
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = .secondarySystemBackground
		#else
		appearance.configureWithDefaultBackground()
		#endif

		let largeTitleFontSize = CGFloat(38)
		let largeTitleFont = UIFont.systemFont(ofSize: largeTitleFontSize, weight: .bold)
		if let descriptor = largeTitleFont.fontDescriptor.withDesign(.rounded) {
			let largeTitleFont = UIFont(descriptor: descriptor, size: largeTitleFontSize)
			appearance.largeTitleTextAttributes = [.font: largeTitleFont]
		}

		let titleFontSize = CGFloat(18)
		let titleFont = UIFont.systemFont(ofSize: titleFontSize, weight: .semibold)
		if let descriptor = titleFont.fontDescriptor.withDesign(.rounded) {
			let titleFont = UIFont(descriptor: descriptor, size: titleFontSize)
			appearance.titleTextAttributes = [.font: titleFont]
		}

		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance
	}
}

extension AppDelegate {
	override func buildMenu(with builder: UIMenuBuilder) {
		super.buildMenu(with: builder)

		guard builder.system == .main else { return }

		builder.remove(menu: .format)

		builder.replaceChildren(ofMenu: .help) {
			var newChildren = $0
			newChildren.removeFirst() //Removes TeamApp Help since it spawns an error message stating it's not available.
			return newChildren
		}
	}
}
