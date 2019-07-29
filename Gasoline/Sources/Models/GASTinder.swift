//
//  Teste.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 20/10/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import WASKit
import Alamofire

class GASTinder: Object {

	// MARK: - Properties

	@objc dynamic var id: String = ""

	// User Strings
	@objc dynamic var bio: String = ""
	@objc dynamic var name: String = ""
	@objc dynamic var instagram: String = ""

	// User Others
	@objc dynamic var distance: Int = 0
	@objc dynamic var nsfw: Float = 0

	// User Dates
	@objc dynamic var created = Date()
	@objc dynamic var birthDay = Date(timeIntervalSince1970: 1)
	@objc dynamic var lastUpdate = Date()

	// Match
	@objc dynamic var matchId: String = ""
	@objc dynamic var matchDate = Date(timeIntervalSince1970: 1)
	@objc dynamic var matchLastActivity = Date(timeIntervalSince1970: 1)

	//  Booleans
	@objc dynamic var isBlocked: Bool = false
	@objc dynamic var isDisLiked: Bool = false
	@objc dynamic var isLiked: Bool = false
	@objc dynamic var isMatch: Bool = false
	@objc dynamic var isSuperLiked: Bool = false
    @objc dynamic var isFavorited: Bool = false
	@objc dynamic var wasLiked: Bool = false
	@objc dynamic var wasSuperLiked: Bool = false

	// Server
	@objc dynamic var statusCode: Int = 0

	// Photos
	let photos = List<GASPhoto>()

	// MARK: - Constructors

	convenience init?(json: JSON) {

		guard let id = json["_id"].string else {
			return nil
		}

		if let tinder = GASTinder.findById(id: id) {
			self.init(value: tinder)
		} else {
			self.init()
			self.id = id
		}

		// Strings
		self.name = json["name"].stringValue
		self.bio = json["bio"].stringValue

		// Numbers
		if json["distance_mi"].intValue > 0 {
			self.distance = json["distance_mi"].intValue
		}

		// Dates
		if let date = json["birth_date"].stringValue.WAStoDate() {
			self.birthDay = date
		}

		// Instagram Photos
		self.photos.append(objectsIn: GASPhoto.arrayFromJson(json))

		// Social
		self.instagram = self.bio.instagram
	}

	convenience init?(match: JSON) {

		self.init(json: match["person"])

		self.matchId = match["_id"].stringValue
		self.isMatch = true

		if let date = match["created_date"].stringValue.WAStoDate() {
			self.matchDate = date
		}

		if let date = match["last_activity_date"].stringValue.WAStoDate() {
			self.matchLastActivity = date
		}
	}

	convenience init?(update json: JSON) {
		self.init(json: json)
		self.lastUpdate = Date()
	}

	convenience init?(blocks: JSON) {
		self.init(json: blocks)
		self.matchId = id
		self.isBlocked = true
		self.isMatch = true
	}

	// MARK: - Override Public Methods

	override static func primaryKey() -> String? {
		return "id"
	}

	override static func ignoredProperties() -> [String] {
		return ["photo"]
	}

}

// MARK: - Setters

extension GASTinder {

    func setFavorite(_ value: Bool) {
        PersistenceManager.write {
            self.isFavorited = value
        }
    }

	func setLike(_ value: Bool) {
		PersistenceManager.write {
			self.isLiked = value
		}
	}

	func setSuperLike(_ value: Bool) {
		PersistenceManager.write {
			self.isLiked = value
			self.isSuperLiked = value
		}
	}

	func setDisLike(_ value: Bool) {
		PersistenceManager.write {
			self.isDisLiked = value
		}
	}

	func setMacth(_ value: Bool) {
		PersistenceManager.write {
			self.isMatch = value
		}
	}

	func setError() {
		PersistenceManager.write {
			self.statusCode = 500
		}
	}
}

// MARK: - Helpers

extension GASTinder {

	var isNsfw: Bool {
		return self.nsfw > 0.8 && self.nsfw <= 1
	}

	var canAction: Bool {
		return !self.isMatch && !self.isBlocked && self.statusCode != 500
	}

	var canDislike: Bool {
		return self.canAction && !self.isDisLiked
	}

	var canLike: Bool {
		return self.canAction && !self.isMatch
	}

	var canUpdate: Bool {
		return self.statusCode != 500 && self.lastUpdate + 30.WASminute < Date()
	}
}

// Static Methods

extension GASTinder {

	class func findById(id: String) -> GASTinder? {
		guard let realm = PersistenceManager.realm else { return nil }
		let tinder = realm.object(ofType: GASTinder.self, forPrimaryKey: id)
		return tinder
	}

	class func arrayFromResult(_ json: [String: Any]) -> [GASTinder] {

		var tinders: [GASTinder] = []
		guard let array = JSON(json)["results"].array else { return [] }

		for json in array {
			guard let tinder = GASTinder(json: json["user"]) else { continue }
			tinders.append(tinder)
		}

		return tinders
	}

	class func arrayFromBlocks(_ json: [String: Any]) -> [GASTinder] {

		var tinders: [GASTinder] = []
		guard let array = JSON(json)["blocks"].array else { return tinders }

		for id in array {
			guard let tinder = GASTinder(blocks: JSON(["_id": id])) else { continue }
			tinders.append(tinder)
		}

		return tinders
	}

	class func arrayFromMatches(_ json: [String: Any]) -> [GASTinder] {

		var tinders: [GASTinder] = []
		guard let array = JSON(json)["matches"].array else { return tinders }

		for json in array {
			guard let tinder = GASTinder(match: json) else { continue }
			tinders.append(tinder)
		}

		return tinders
	}
}
