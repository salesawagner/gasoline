//
//  UIViewController+Utils.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 3/10/17.
//  Copyright © 2017 Wagner Sales. All rights reserved.
//

import UIKit
import SCLAlertView
import MaterialComponents.MaterialCollections

private var kLoadingAssociationKey: UInt8 = 0

extension UIViewController {

	var loading: SCLAlertViewResponder? {
		get {
			return objc_getAssociatedObject(self, &kLoadingAssociationKey) as? SCLAlertViewResponder
		}
		set(newValue) {
			let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
			objc_setAssociatedObject(self, &kLoadingAssociationKey, newValue, policy)
		}
	}

	func startLoading(_ title: String = L.wait, subtitle: String = L.loading) {
		if self.loading == nil {
			let app = SCLAlertView.SCLAppearance(showCloseButton: false)
			let loading = SCLAlertView(appearance: app)
			let colorStyle = UInt(LK.redColor.WAStoUInt)
			self.loading = loading.showWait(title, subTitle: subtitle, colorStyle: colorStyle)
		}
	}

	func stopLoading(hasError error: Bool = false) {
		if let loading = self.loading {
			loading.setDismissBlock({
				self.loading = nil
				if error {
					self.showError()
					return
				}
			})
			loading.close()
		}
	}

	func showError() {
		let colorStyle = UInt(LK.redColor.WAStoUInt)
		self.showAlert(title: L.sorry, subtitle: L.somethingWentWrong, style: .warning, colorStyle: colorStyle)
	}

	func showMatch() {
		let colorStyle = UInt(LK.greenColor.WAStoUInt)
		self.showAlert(title: L.congratulations, subtitle: L.newMatch, style: .success, colorStyle: colorStyle)
	}

	func showAlert(title: String, subtitle: String, style: SCLAlertViewStyle = .warning, colorStyle: UInt = UInt(LK.redColor.WAStoUInt)) {
		guard self.loading == nil else {
			return
		}
		SCLAlertView().showTitle(title, subTitle: subtitle, style: style, colorStyle: colorStyle)
	}

    @objc func pop() {
        guard let nav = self.navigationController else {
            return
        }
        if let loading = self.loading {
            loading.setDismissBlock {
                nav.popViewController(animated: true)
            }
        } else {
            nav.popViewController(animated: true)
        }
    }

    @objc func dismiss() {

        var viewController: UIViewController = self
        if let nav = self.navigationController {
            viewController = nav
        }

        if let loading = self.loading {
            loading.setDismissBlock {
                viewController.dismiss(animated: true, completion: nil)
            }
        } else {
            viewController.dismiss(animated: true, completion: nil)
        }
    }

	func preloadView() {
		let _ = view
	}
}

// MARK: - UI

import MaterialComponents.MaterialNavigationBar

extension MDCCollectionViewController {
    func setupNavigationBar() {
        guard let navigationController = self.navigationController else {
            return
        }

        let navigationBar = navigationController.navigationBar
        navigationBar.titleTextAttributes = UIFont.attributedString(size: 17)
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = LK.redColor
    }
}
