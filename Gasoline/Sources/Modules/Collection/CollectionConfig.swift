//
//  CollectionConfig.swift
//  Gasoline
//
//  Created by Wagner Sales on 19/03/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift

struct CollectionConfig {

	// MARK: - Properties

	let title: String!
	let icon: String?
	let dataSource: Results<GASTinder>!
	let canReload: Bool!
	let multipleRequests: Bool!
	let didLoadBlock: Completion?
	var tabBarItem: UITabBarItem? {
		guard let icon = self.icon else { return nil }

		let image = UIImage(named: icon)
		let selectedImage = UIImage(named: icon + "_selected")
		let tabBarItem = UITabBarItem(title: self.title, image: image, selectedImage: selectedImage)

		return tabBarItem
	}

	// MARK: - Constructors

	init(title: String, icon: String? = nil, dataSource: Results<GASTinder>, canReload: Bool = false, multipleRequests: Bool = false, didLoadBlock: Completion? = nil) {
		self.title = title
		self.icon = icon
		self.dataSource = dataSource
		self.canReload = canReload
		self.multipleRequests = multipleRequests
		self.didLoadBlock = didLoadBlock
	}

	// MARK: - Properties

	static var likedMe: CollectionConfig {
		return CollectionConfig(title: "Liked Me", icon: "icn_drop", dataSource: GASTinderManager.listLikedMe(), canReload: true, multipleRequests: true)
	}

	static var browser: CollectionConfig {
		return CollectionConfig(title: "Browser", icon: "icn_all", dataSource: GASTinderManager.listBrowser(), canReload: true)
	}

	static var iLiked: CollectionConfig {
		return CollectionConfig(title: "I Liked", icon: "icn_like", dataSource: GASTinderManager.listILiked())
	}

	static var matched: CollectionConfig {
		let block: Completion = {
			GASTinderManager.updates()
		}
		return CollectionConfig(title: "Matches", icon: "icn_star", dataSource: GASTinderManager.listMatched(), didLoadBlock: block)
	}

	static var blocks: CollectionConfig { // FIXME: - remover
		return CollectionConfig(title: "All", icon: "icn_star", dataSource: GASTinderManager.listAll())
	}

	static var all: CollectionConfig {
		return CollectionConfig(title: "All", icon: "icn_star", dataSource: GASTinderManager.listAll())
	}

	static var disliked: CollectionConfig {
		return CollectionConfig(title: "Disliked", icon: "icn_star", dataSource: GASTinderManager.listIDisLiked())
	}

	static var superLiked: CollectionConfig {
		return CollectionConfig(title: "Super Liked", icon: "icn_star", dataSource: GASTinderManager.listISuperLiked())
	}

	static var removed: CollectionConfig {
		return CollectionConfig(title: "Desativacted", icon: "icn_star", dataSource: GASTinderManager.listRemoved())
	}

	static var instagram: CollectionConfig {
		return CollectionConfig(title: "With Instagram", icon: "icn_star", dataSource: GASTinderManager.listInstagram())
	}

	static var hot: CollectionConfig {
		return CollectionConfig(title: "Hot", icon: "icn_star", dataSource: GASTinderManager.listHot())
	}

	// MARK: - Public Methods

	func createViewController(inNavigationControler: Bool = false) -> UIViewController {

		let viewModel = CollectionViewModel(collection: self)
		let viewController = UIViewController() //CollectionViewController(viewModel: viewModel)
		viewController.tabBarItem = self.tabBarItem

		if inNavigationControler {
			return UINavigationController(rootViewController: viewController)
		}

		return viewController
	}
}
