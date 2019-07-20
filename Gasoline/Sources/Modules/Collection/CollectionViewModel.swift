//
//  CollectionViewModel.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 10/02/17.
//  Copyright © 2017 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift

class CollectionViewModel: NSObject {

	// MARK: - Properties

	let collection: CollectionConfig!
	var dataSource: Results<GASTinder> {

		var filter = "statusCode != 500"
		for item in self.filters.filter({ $0.isOn }) {
			filter += " AND \(item.filter)"
		}

		return GASTinderManager.order(result: GASTinderManager.listAll().filter(filter))
	}

	var filters: [FilterItem]
	var filtered: Completion?

	var title: String {
		return self.collection.title
	}

	// MARK: - Constructors

	init(collection: CollectionConfig = CollectionConfig.browser) {

		self.collection = collection

		self.filters = [
			FilterItem(title: "No Action", filter: "isLiked = false AND isDisLiked = false AND isSuperLiked = false AND isMatch = false AND wasLiked = false AND wasSuperLiked = false", isOn: true),
			FilterItem(title: "I Liked", filter: "(isLiked = true OR isSuperLiked = true)"),
			FilterItem(title: "I Super Liked", filter: "isSuperLiked = true"),
			FilterItem(title: "Matches", filter: "isMatch = true"),
			FilterItem(title: "I Disliked", filter: "isDisLiked = true"),
			FilterItem(title: "With Instagram", filter: "instagram != ''"),
			FilterItem(title: "🔥 Hot", filter: "nsfw > 0.8"),
            FilterItem(title: "😍 Favorited", filter: "isFavorited = true"),
		]

		self.collection.didLoadBlock?()
	}


	// MARK: - Internal Methods

	func load(_ completion: @escaping CompletionSuccess) {
		guard self.collection.canReload else { return }
		GASTinderManager.recs { (_, success) in
			completion(success)
            GASPhotosManager.shared.nsfwAll()
		}
	}

	func setFilter() {
		self.filtered?()
	}
}
