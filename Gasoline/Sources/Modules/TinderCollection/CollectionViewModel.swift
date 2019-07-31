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

	var dataSource: Results<GASTinder> {

		var filter = "statusCode != 500"
		for item in self.filters.filter({ $0.isOn }) {
			filter += " AND \(item.filter)"
		}

		return GASTinderManager.order(result: GASTinderManager.listAll().filter(filter))
	}

    lazy var filters: [FilterItem] = {
        [
            FilterItem(title: "No Action", filter: "isLiked = false AND isDisLiked = false AND isMatch = false", isOn: true),
            FilterItem(title: "I Liked", filter: "isLiked = true OR isSuperLiked = true"),
            FilterItem(title: "I Super Liked", filter: "isSuperLiked = true"),
            FilterItem(title: "Matches", filter: "isMatch = true"),
            FilterItem(title: "I Disliked", filter: "isDisLiked = true"),
            FilterItem(title: "With Instagram", filter: "instagram != ''"),
            FilterItem(title: "🔥 Hot", filter: "nsfw > 0.8"),
            FilterItem(title: "😍 Favorited", filter: "isFavorited = true")
        ]
    }()
	var filtered: Completion?

	let title: String  = "Browser"

	// MARK: - Constructors

	override init() {
        super.init()
	}

	// MARK: - Internal Methods

	func load(_ completion: @escaping CompletionSuccess) {
		GASTinderManager.recs { (_, success) in
			completion(success)
            GASPhotosManager.shared.nsfwAll()
		}
	}

	func setFilter() {
		self.filtered?()
	}
}
