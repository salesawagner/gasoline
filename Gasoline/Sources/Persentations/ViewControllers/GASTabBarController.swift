//
//  GASTabBarController.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 05/10/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift

class GASTabBarController: UITabBarController {

	// MARK: - Private Methods

	private func setupCollectionViews() {

		var viewControllers = [UIViewController]()
//		viewControllers.append(Collection.likedMe.createViewController(inNavigationControler: true))
		viewControllers.append(CollectionConfig.browser.createViewController(inNavigationControler: true))
//		viewControllers.append(CollectionConfig.iLiked.createViewController(inNavigationControler: true))
		viewControllers.append(CollectionConfig.matched.createViewController(inNavigationControler: true))
		viewControllers.append(self.getSettings())

		self.setViewControllers(viewControllers, animated: false)
	}
	
	private func getSettings() -> UINavigationController {
		
		let storyboard = UIStoryboard(name: "Settings", bundle: nil)
		guard let nav = storyboard.instantiateInitialViewController() as? UINavigationController else {
			return UINavigationController()
		}
		
		nav.title = "Settings"
		return nav
	}

	// MARK: - Override Public Methods

	override func viewDidLoad() {
        super.viewDidLoad()
		self.tabBar.isTranslucent = false
		self.setupCollectionViews()
		let attributedString = UIFont.attributedString(size: 11, color: .black)
		let appearance = UITabBarItem.appearance()
		appearance.setTitleTextAttributes(attributedString, for: UIControl.State())
    }
}
