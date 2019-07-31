//
//  AppDelegate.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 5/23/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import RealmSwift
import Fabric
import Crashlytics
import Firebase

typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication,
	                 didFinishLaunchingWithOptions launchOptions: LaunchOptions) -> Bool {

		FirebaseApp.configure()
		Fabric.with([Crashlytics.self])

		// Realm migration
		self.realmMigration()

        // Set root view controller
        var rootViewController: UIViewController
        if User.logged() == nil {
            rootViewController = UIViewController.login
        } else {
            rootViewController = GASTabBarController()
        }

		// Setup window
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = rootViewController
		window.makeKeyAndVisible()
		self.window = window

		// Facebook
		if let facebook = FBSDKApplicationDelegate.sharedInstance() {
			return facebook.application(application, didFinishLaunchingWithOptions: launchOptions)
		}

		return true
	}

	func application(_ application: UIApplication,
	                 open url: URL,
	                 sourceApplication: String?,
	                 annotation: Any) -> Bool {
		if let facebook = FBSDKApplicationDelegate.sharedInstance() {
			return facebook.application(application, open: url,
			                            sourceApplication: sourceApplication,
			                            annotation: annotation)
		}
		return false
	}

	func realmMigration() {
		let config = Realm.Configuration(
			// Set the new schema version. This must be greater than the previously used
			// version (if you've never set a schema version before, the version is 0).
			schemaVersion: 217,
			// Set the block which will be called automatically when opening a Realm with
			// a schema version lower than the one set above
			migrationBlock: { migration, oldSchemaVersion in
			// We haven’t migrated anything yet, so oldSchemaVersion == 0
			if (oldSchemaVersion < 202) { }
		})

		Realm.Configuration.defaultConfiguration = config
		Log.i(config.fileURL ?? "")
	}
}
