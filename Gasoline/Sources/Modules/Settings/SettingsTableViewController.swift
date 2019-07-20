//
//  SettingsTableViewController.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 6/6/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import SCLAlertView
import RealmSwift

class SettingsTableViewController: UITableViewController {

	// MARK: - Properties

	@IBOutlet weak var versionLabel: UILabel!

	// MARK: - Override Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setups()
	}
	
	// MARK: - Private Methods
	
	private func setups() {
		self.setupUI()
		self.setupNavigation()
		self.setupVersions()
	}

	private func setupUI() {
		self.view.backgroundColor = LK.backgroundColor
	}
	
	private func setupNavigation() {
		guard let nav = self.navigationController else {
			return
		}
		
		nav.navigationBar.titleTextAttributes = UIFont.attributedString(size: 17)
		nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		nav.navigationBar.shadowImage = UIImage()
		nav.navigationBar.isTranslucent = false
		nav.navigationBar.barTintColor = LK.redColor
	}
	
	private func setupVersions() {
		
		guard
			let info = Bundle.main.infoDictionary,
			let appVersion = info["CFBundleShortVersionString"] as? String,
			let buildVersion = info["CFBundleVersion"] as? String else {
			return
		}
		
		self.versionLabel.text = String(format: "%@ (%@)", appVersion, buildVersion)
	}
	
	// MARK: - Self Public Methods
	
	func showAlert() {
		let alert = SCLAlertView()
		alert.showTitle("Alert", subTitle: "Cleaned", style: .success)
	}

	// MARK: - Private Methods
	
	private func goToCollection(row: Int) {
		
		guard let navigationController = self.navigationController else {
			return
		}
		
		var viewController: UIViewController!
		
		switch row {
			case 0: viewController = CollectionConfig.all.createViewController()
			case 1: viewController = CollectionConfig.superLiked.createViewController()
			case 2: viewController = CollectionConfig.disliked.createViewController()
			case 3: viewController = CollectionConfig.blocks.createViewController()
			case 4: viewController = CollectionConfig.removed.createViewController()
			case 5: viewController = CollectionConfig.instagram.createViewController()
			case 6: viewController = CollectionConfig.snapchat.createViewController()
			case 7: viewController = CollectionConfig.hot.createViewController()
			default: viewController = CollectionConfig.browser.createViewController()
		}

		navigationController.pushViewController(viewController, animated: true)
	}
	
	private func deleteCollection(row: Int) {
		
		var listToDelete: Results<GASTinder>?
		
		switch row {
			case 0:
                GASPhotosManager.shared.nsfwAll()
                return
                // listToDelete = GASTinderManager.listLikedMe()
			case 1: listToDelete = GASTinderManager.listBrowser()
			case 2: listToDelete = GASTinderManager.listILiked()
			case 3: listToDelete = GASTinderManager.listIDisLiked()
			case 4:
				PersistenceManager.clear()
				self.showAlert()
			default: break
		}
		
		if let objects = listToDelete {
			PersistenceManager.delete(objects: objects)
			self.showAlert()
		}
	}
	
	private func logout() {
		AuthManager.logout()
        UIViewController.goToLogin()
	}
}

// MARK: - UITableViewDelegate

extension SettingsTableViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case 0: self.goToCollection(row: indexPath.row)
		case 1: self.deleteCollection(row: indexPath.row)
		case 2: self.logout()
		default: break
		}
	}
}
