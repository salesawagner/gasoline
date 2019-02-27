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
		viewControllers.append(Collection.browser.createViewController(inNavigationControler: true))
		viewControllers.append(Collection.iLiked.createViewController(inNavigationControler: true))
		viewControllers.append(Collection.matched.createViewController(inNavigationControler: true))
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
		appearance.setTitleTextAttributes(attributedString, for: UIControlState())
    }

	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		
		guard tabBar.subviews.count <= item.tag else {
			return
		}

		let itemSelected = tabBar.subviews[item.tag]
		if let view = itemSelected.subviews.compactMap({ $0 as? UIImageView }).first {
			let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
			pulseAnimation.duration = 0.25
			pulseAnimation.fromValue = 1
			pulseAnimation.toValue = 1.30
			pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			pulseAnimation.autoreverses = true
			pulseAnimation.repeatCount = 0
			view.layer.add(pulseAnimation, forKey: "animate.transform.scale.\(item.tag)")
		}
	}
}
