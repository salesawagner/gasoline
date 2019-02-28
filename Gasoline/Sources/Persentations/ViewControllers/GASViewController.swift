//
//  GASViewController.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 5/25/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit

class GASViewController: UIViewController {
	
	// MARK: - Public Methods
	
	func setupUI() {
		self.view.backgroundColor = LK.backgroundColor
	}

	func setupNavigation() {
		guard let nav = self.navigationController else {
			return
		}

		// Navigation
		nav.navigationBar.titleTextAttributes = UIFont.attributedString(size: 17)
		nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		nav.navigationBar.shadowImage = UIImage()
		nav.navigationBar.isTranslucent = false
		nav.navigationBar.barTintColor = LK.redColor

		// Check if is actul is first view controller
		if nav.viewControllers.count > 0 &&  nav.viewControllers.first != self {
			// Gesture
			nav.interactivePopGestureRecognizer?.isEnabled = true
			nav.interactivePopGestureRecognizer?.delegate = self
			// Frame
			let width = #imageLiteral(resourceName: "btn_back").size.width
			let height = #imageLiteral(resourceName: "btn_back").size.height
			let frame = CGRect(x: 0, y: 0, width: width, height: height)
			// Button
			let backButton = UIButton(frame: frame)
			backButton.setImage(#imageLiteral(resourceName: "btn_back"), for: UIControl.State())
			backButton.addTarget(self, action: #selector(self.pop), for: .touchUpInside)
			// Button Item
			let backButtonItem = UIBarButtonItem(customView: backButton)
			self.navigationItem.leftBarButtonItem = backButtonItem
		}
	}
	
	func setupTitle(title: String) {
		self.title = title
	}
	
	// MARK: - Override Public Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupNavigation()
		self.setupUI()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension GASViewController: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
