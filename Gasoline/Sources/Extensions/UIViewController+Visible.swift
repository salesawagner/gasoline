//
//  UIViewController+Visible.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 13/03/17.
//  Copyright © 2017 Wagner Sales. All rights reserved.
//

import UIKit
//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************
private let kLoginStoryboard = "Onboarding"
private let kTinderStoryboard = "Tinder"
private let kFilterStoryboard = "Filter"

//**************************************************************************************************
//
// MARK: - Definitions -
//
//**************************************************************************************************

extension UIViewController {
	//**************************************************
	// MARK: - Properties
	//**************************************************
	class var visible: UIViewController {
		guard
			let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			let window = appDelegate.window,
			let visible = window.visibleViewController else {
			return UIViewController()
		}
		return visible
	}
	class var login: UIViewController {
		let storyboard = self.storyboardWith(identifier: kLoginStoryboard)
		return storyboard.instantiateInitialViewController() ?? UIViewController()
	}
	private class var mainWindow: UIWindow? {
		guard
			let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			let window = appDelegate.window else {
				return nil
		}
		return window
	}
	//**************************************************
	// MARK: - Private Methods
	//**************************************************
	private class func storyboardWith(identifier: String) -> UIStoryboard {
		return UIStoryboard(name: identifier, bundle: nil)
	}
	//**************************************************
	// MARK: - Public Methods
	//**************************************************
	class func goTo(viewController: UIViewController) {
		guard
			let window = self.mainWindow else {
				return
		}
		window.rootViewController = viewController
	}

	class func goToMain() {
		self.goTo(viewController: GASTabBarController())
	}

	class func goToLogin() {
		if !(self.visible is OnboardingViewController) {
			self.goTo(viewController: self.login)
		}
	}

    class func collection() -> TinderCollectionViewController {

        let storyboard = UIStoryboard(name: "TinderCollectionViewController", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! TinderCollectionViewController
        viewController.viewModel = CollectionViewModel()

        return viewController
    }

	class func tinder(tinder: GASTinder) -> TinderViewController {

		let storyboard = self.storyboardWith(identifier: kTinderStoryboard)
		let viewController = storyboard.instantiateInitialViewController()

        if let tinderViewController = viewController as? TinderViewController {
            tinderViewController.viewModel = DetailTinderViewModel(delegate: tinderViewController, tinderID: tinder.id)
			return tinderViewController
		}

		return TinderViewController()
	}

	class func filter(colletionViewModel viewModel: CollectionViewModel) -> FilterTableViewController {

		let storyboard = self.storyboardWith(identifier: kFilterStoryboard)
		let viewController = storyboard.instantiateInitialViewController()

		if let tinderViewController = viewController as? FilterTableViewController {
			tinderViewController.collectionViewModel = viewModel
			return tinderViewController
		}

		return FilterTableViewController()
	}
}
extension UIWindow {

	// MARK: - Properties

	var visibleViewController: UIViewController? {
		return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
	}

	// MARK: - Public Methods

	class func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
		if let nc = vc as? UINavigationController {
			return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
		} else if let tc = vc as? UITabBarController {
			return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
		} else {
			if let pvc = vc?.presentedViewController {
				return UIWindow.getVisibleViewControllerFrom(pvc)
			} else {
				return vc
			}
		}
	}
}
