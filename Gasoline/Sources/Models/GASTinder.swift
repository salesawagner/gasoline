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

	//**************************************************
	// MARK: - Properties
	//**************************************************

	@objc dynamic var id: String = ""

	// Strings User
	@objc dynamic var bio: String	= ""
	@objc dynamic var name: String = ""
	@objc dynamic var instagram: String = ""
	@objc dynamic var snapchat: String = ""

	// Others User
	@objc dynamic var distance: Int = 0
	@objc dynamic var nsfw: Float = 0
	var isNsfw: Bool {
		return self.nsfw > 0.8 && self.nsfw <= 1
	}

	// Dates User
	@objc dynamic var created = Date()
	@objc dynamic var birthDay = Date(timeIntervalSince1970: 1)
	@objc dynamic var lastActivity = Date(timeIntervalSince1970: 1)
	@objc dynamic var lastUpdate = Date()

	// Match
	@objc dynamic var matchId: String	= ""
	@objc dynamic var matchDate = Date(timeIntervalSince1970: 1)
	@objc dynamic var matchLastActivity = Date(timeIntervalSince1970: 1)

	// Actions
	////  Dates
	@objc dynamic var likeDate = Date(timeIntervalSince1970: 1)
	@objc dynamic var dislikeDate	= Date(timeIntervalSince1970: 1)

	////  Booleans
	@objc dynamic var isBlocked: Bool = false
	@objc dynamic var isDisLiked: Bool = false
	@objc dynamic var isLiked: Bool = false
	@objc dynamic var isMatch: Bool = false
	@objc dynamic var isStared: Bool = false
	@objc dynamic var isSuperLiked: Bool = false
	@objc dynamic var wasLiked: Bool = false
	@objc dynamic var wasSuperLiked: Bool = false

	// Server
	@objc dynamic var statusCode: Int = 0

	// Photos
	let photos = List<GASPhoto>()

	// Computed

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
		return self.statusCode != 500 // FIXME: && self.lastUpdate + 30.WASminute < Date()
	}

	//**************************************************
	// MARK: - Constructors
	//**************************************************

	convenience init?(user: JSON) {
		guard
			let id = user["_id"].string,
			let logged = MTPUser.userLogged else {
				return nil
		}
		let replaced = id.replacingOccurrences(of: logged.id, with: "")
		if let tinder = GASTinder.findById(id: replaced) {
			self.init(value: tinder)
		} else {
			self.init()
			self.id = replaced
		}

		// Strings
		self.name = user["name"].stringValue
		self.bio = user["bio"].stringValue

		// Numbers
		if user["distance_mi"].intValue > 0 {
			self.distance	= user["distance_mi"].intValue
		}

		// Dates
		self.lastActivity = Date()
		if let date = user["birth_date"].stringValue.WAStoDate() {
			self.birthDay = date
		}

		// Fotos
		for photo in user["photos"].arrayValue {
			if let image = GASPhoto(photo: photo, tinder: self) {
				self.photos.append(image)
			}
		}

		// Social
		self.instagram = self.bio.instagram
		self.snapchat = self.bio.snapchat

	}

	convenience init?(match: JSON) {
		self.init(user: match["person"])

		self.matchId = match["_id"].stringValue
		self.isMatch = true

		if let date = match["created_date"].stringValue.WAStoDate() {
			self.matchDate = date as Date
		}

		if let date = match["last_activity_date"].stringValue.WAStoDate() {
			self.matchLastActivity = date as Date
		}
	}

	convenience init?(update: JSON) {
		let results = JSON(update["results"].dictionaryValue)
		let idString = results["id"].string != nil ? results["id"].string : results["_id"].string
		guard
			let id = idString,
			let tinder = GASTinder.findById(id: id) else {
			return nil
		}
		self.init(value: tinder)
		if let name = results["name"].string {
			self.name = name
		}
		if let bio = results["bio"].string {
			self.bio = bio
		}
		if results["distance_mi"].intValue > 0 {
			self.distance = results["distance_mi"].intValue
		}
		if let date = results["birth_date"].stringValue.WAStoDate() {
			self.birthDay = date
		}
		for photo in results["photos"].arrayValue {
			if let image = GASPhoto(photo: photo, tinder: self), !self.photos.contains(image) {
				self.photos.append(image)
			}
		}
	}

	convenience init?(id: String) {
		self.init(user: JSON(["_id": id]))
		self.matchId = id
		self.isBlocked = true
		self.isMatch = true
	}

	// MARK: - Public Methods

	func updateRealm() {
		PersistenceManager.add(self)
	}

	class func findById(id: String) -> GASTinder? {
		guard let realm = PersistenceManager.realm else { return nil }
		let tinder = realm.object(ofType: GASTinder.self, forPrimaryKey: id)
		return tinder
	}

	// MARK: - Override Public Methods

	override static func primaryKey() -> String? {
		return "id"
	}

	override static func ignoredProperties() -> [String] {
		return ["photo"]
	}

}

//**************************************************************************************************
//
// MARK: - Class - Create from array
//
//**************************************************************************************************
extension GASTinder {
	class func arrayFromResult(_ json: [String: Any]) -> [GASTinder] {
		var tinders: [GASTinder] = []
		for user in JSON(json)["results"].arrayValue {
			if let tinder = GASTinder(user: user) {
				
				if let instagram = user["instagram"].dictionary {
					if let photos = instagram["photos"] {
						for photo in photos.arrayValue {
							if let image = GASPhoto(instagramPhoto: photo, tinder: tinder) {
								tinder.photos.append(image)
							}
						}
					}
				}
				
				tinders.append(tinder)
			}
		}
		return tinders
	}
	class func arrayFromtopPicks(_ json: [String: Any]) -> [GASTinder] {
		guard let data = json["data"] else { return [] }
		var tinders: [GASTinder] = []
		tinders.append(contentsOf: self.arrayFromJson(JSON(data)))
		// TODO: - teasers
		return tinders
	}
	class func arrayFromJson(_ json: JSON) -> [GASTinder] {
		var tinders: [GASTinder] = []
		for user in json["results"].arrayValue {
			if let tinder = GASTinder(user: user["user"]) {
				if let instagram = user["instagram"].dictionary {
					if let photos = instagram["photos"] {
						for photo in photos.arrayValue {
							if let image = GASPhoto(instagramPhoto: photo, tinder: tinder) {
								tinder.photos.append(image)
							}
						}
					}
				}

				tinders.append(tinder)
			}
		}
		return tinders
	}
	class func arrayFromJsonBlocks(_ json: JSON) -> [GASTinder] {
		var tinders: [GASTinder] = []
		for id in json["blocks"].arrayValue {
			if let tinder = GASTinder(id: String(describing: id)) {
				tinders.append(tinder)
			}
		}
		return tinders
	}
	class func arrayFromJsonMatches(_ json: JSON) -> [GASTinder] {
		var tinders: [GASTinder] = []
		for json in json["matches"].arrayValue {
			if let tinder = GASTinder(match: json) {
				tinders.append(tinder)
			}
		}
		return tinders
	}
}
