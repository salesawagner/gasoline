//
//  GASTinderManager+Lists.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import RealmSwift

extension GASTinderManager {

	private class var baseFilter: String {
		var filter = "statusCode != 500"
		filter += " AND isBlocked = false"
		return filter
	}

	class func listAll() -> Results<GASTinder> {
		let result = PersistenceManager.objects(objectType: GASTinder.self)
		return result
	}

	class func listLikedMe() -> Results<GASTinder> {
		var filter = self.baseFilter
		filter += " AND isDisLiked = false"
		filter += " AND isLiked = false"
		filter += " AND isMatch = false"
		filter += " AND isSuperLiked = false"
		filter += " AND wasLiked = true"
		let result = GASTinderManager.listAll()
		return self.order(result: result.filter(filter))
	}

	class func listBrowser() -> Results<GASTinder> {
		var filter = self.baseFilter
		filter += " AND isDisLiked = false"
		filter += " AND isLiked = false"
		filter += " AND isMatch = false"
		filter += " AND isSuperLiked = false"
		filter += " AND wasLiked = false"
		filter += " AND wasSuperLiked = false"
		let result = GASTinderManager.listAll()
		return self.order(result: result.filter(filter))
	}

	class func listILiked() -> Results<GASTinder> {
		var filter = self.baseFilter
		filter += " AND isDisLiked = false"
		filter += " AND (isLiked = true OR isSuperLiked = true)"
		filter += " AND isMatch = false"
		filter += " AND wasLiked = false"
		filter += " AND wasSuperLiked = false"
		let result = GASTinderManager.listAll()
		return self.order(result: result.filter(filter))
	}

	class func listISuperLiked() -> Results<GASTinder> {
		var filter = self.baseFilter
		filter += " AND isDisLiked = false"
		filter += " AND isSuperLiked = true"
		filter += " AND isMatch = false"
		filter += " AND wasLiked = false"
		filter += " AND wasSuperLiked = false"
		let result = GASTinderManager.listAll()
		return self.order(result: result.filter(filter))
	}

	class func listIDisLiked() -> Results<GASTinder> {
		var filter = self.baseFilter
		filter += " AND isDisLiked = true"
		let result = GASTinderManager.listAll()
		return self.order(result: result.filter(filter))
	}

	class func listMatched() -> Results<GASTinder> {
		var filter = self.baseFilter
		filter += " AND isMatch = true"
		let result = GASTinderManager.listAll()
		return self.order(result: result.filter(filter))
	}

	class func listBlocked() -> Results<GASTinder> {
		var filter = "statusCode != 500"
		filter += " AND isBlocked = true"
		let result = GASTinderManager.listAll()
		return self.order(result: result.filter(filter))
	}

	class func listRemoved() -> Results<GASTinder> {
		let filter = "statusCode == 500"
		let result = GASTinderManager.listAll()
		return self.order(result: result.filter(filter))
	}

	class func listInstagram() -> Results<GASTinder> {
		var filter = self.baseFilter
		filter += " AND instagram != ''"
		let result = GASTinderManager.listAll()
		return self.order(result: result.filter(filter))
	}

	class func listHot() -> Results<GASTinder> {
		var filter = self.baseFilter
		filter += " AND nsfw > 0.8 AND nsfw <= 1"
		let result = GASTinderManager.listAll()
		return self.order(result: result.filter(filter))
	}

	class func order(result: Results<GASTinder>) -> Results<GASTinder> {
		return result.sorted(byKeyPath: "created", ascending: false)
	}
}
