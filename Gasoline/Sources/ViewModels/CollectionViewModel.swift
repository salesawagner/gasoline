//
//  CollectionViewModel.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 10/02/17.
//  Copyright © 2017 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift

struct Collection {

	// MARK: - Properties
	
	let title: String!
	let icon: String?
	let list: Results<GASTinder>!
	let canReload: Bool!
	let multipleRequests: Bool!
	let didLoadBlock: Completion?
	var tabBarItem: UITabBarItem? {
		guard let icon = self.icon else { return nil }

		let image = UIImage(named: icon)
		let selectedImage = UIImage(named: icon + "_selected")
		let tabBarItem = UITabBarItem(title: self.title, image: image, selectedImage: selectedImage)
		//		barItem.tag = self.rawValue // FIXME:

		return tabBarItem
	}
	
	// MARK: - Constructors
	
	init(title: String, icon: String? = nil, list: Results<GASTinder>, canReload: Bool = false, multipleRequests: Bool = false, didLoadBlock: Completion? = nil) {
		self.title = title
		self.icon = icon
		self.list = list
		self.canReload = canReload
		self.multipleRequests = multipleRequests
		self.didLoadBlock = didLoadBlock
	}
	
	// MARK: - Properties
	
	static var likedMe: Collection {
		return Collection(title: "Liked Me", icon: "icn_drop", list: GASTinderManager.listLikedMe(), canReload: true, multipleRequests: true)
	}
	
	static var browser: Collection {
		return Collection(title: "Browser", icon: "icn_all", list: GASTinderManager.listBrowser(), canReload: true)
	}
	
	static var iLiked: Collection {
		return Collection(title: "I Liked", icon: "icn_like", list: GASTinderManager.listILiked())
	}
	
	static var matched: Collection {
		let block: Completion = {
			GASTinderManager.updates()
		}
		return Collection(title: "Matches", icon: "icn_star", list: GASTinderManager.listMatched(), didLoadBlock: block)
	}
	
	static var blocks: Collection { // FIXME: - remover
		return Collection(title: "All", icon: "icn_star", list: GASTinderManager.listAll())
	}
	
	static var all: Collection {
		return Collection(title: "All", icon: "icn_star", list: GASTinderManager.listAll())
	}
	
	static var disliked: Collection {
		return Collection(title: "Disliked", icon: "icn_star", list: GASTinderManager.listIDisLiked())
	}
	
	static var superLiked: Collection {
		return Collection(title: "Super Liked", icon: "icn_star", list: GASTinderManager.listISuperLiked())
	}
	
	static var removed: Collection {
		return Collection(title: "Desativacted", icon: "icn_star", list: GASTinderManager.listRemoved())
	}
	
	static var instagram: Collection {
		return Collection(title: "With Instagram", icon: "icn_star", list: GASTinderManager.listInstagram())
	}
	
	static var snapchat: Collection {
		return Collection(title: "With Instagram", icon: "icn_star", list: GASTinderManager.listSnapChat())
	}
	
	static var hot: Collection {
		return Collection(title: "Hot", icon: "icn_star", list: GASTinderManager.listHot())
	}
	
	// MARK: - Public Methods

	func createViewController(inNavigationControler: Bool = false) -> UIViewController {
		
		let viewModel = CollectionViewModel(collection: self)
		let viewController = CollectionViewController(viewModel: viewModel)
		viewController.tabBarItem = self.tabBarItem
		
		if inNavigationControler {
			return UINavigationController(rootViewController: viewController)
		}
		
		return viewController
	}
}

class CollectionViewModel: NSObject {

	// MARK: - Properties

	let collection: Collection!
	var tinders: Results<GASTinder>
	var title: String {
		return self.collection.title
	}

	// MARK: - Constructors

	init(collection: Collection = Collection.browser) {
		self.collection = collection
		self.tinders = self.collection.list
		
		guard let block = self.collection.didLoadBlock else { return }
		block()
	}

	// MARK: - Public Methods

	func forceLoad(_ completion: @escaping CompletionSuccess) {
		if self.collection.multipleRequests {

			GASTinderManager.resetLikedMe()

			GASTinderManager.profile { success in
				GASTinderManager.likedMe { success in
					completion(success)
				}
			}

		} else {
			GASTinderManager.recs { (_, success) in
				completion(success)
			}
		}
	}

	func load(_ completion: @escaping CompletionSuccess) {
		guard self.tinders.count == 0 && self.collection.canReload else { return }
		self.forceLoad(completion)
	}
}
