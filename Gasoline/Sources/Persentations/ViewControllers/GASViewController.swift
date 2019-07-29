//
//  GASViewController.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 5/25/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit

class GASViewController: UIViewController {

    // MARK: - Life Cicle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupUI()
    }
	
	// MARK: - Internal Methods
	
	func setupNavigation() {
		guard let navigationController = self.navigationController else {
			return
		}

        let navigationBar = navigationController.navigationBar
		navigationBar.titleTextAttributes = UIFont.attributedString(size: 17)
		navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		navigationBar.shadowImage = UIImage()
		navigationBar.isTranslucent = false
		navigationBar.barTintColor = LK.redColor
        navigationBar.tintColor = .white
	}

    func setupUI() {
        self.view.backgroundColor = LK.backgroundColor
    }
	
	func setupTitle(title: String) {
		self.title = title
	}
}

// MARK: - UIGestureRecognizerDelegate

extension GASViewController: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
