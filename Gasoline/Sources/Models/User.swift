//
//  User.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 5/23/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: - Constants
// FIXME: Create a struct of keys
private let kUserDefaults = "br.com.gasoline.User"
private let kTinderToken = "br.com.gasoline.tinderToken"
private let kTinderId = "br.com.gasoline.tinderId"
private let kTinderName = "br.com.gasoline.tinderName"
private let kTinderRefreshToken = "br.com.gasoline.tinderRefreshToken"

// MARK: - Class

class User: NSObject, NSCoding {

	// MARK: - Properties

	var ID: String?
	var token: String?
	var name: String?
	var refreshToken: String?

	// MARK: - Constructors

	init?(json: JSON) {

		guard
			let data = json["data"].dictionary,
			let token = data["api_token"],
			let id = data["_id"],
			let refreshToken = data["refresh_token"] else {
				return nil
		}

		self.token = token.stringValue
		self.ID = id.stringValue
		self.name = "" // FIXME: remove
		self.refreshToken = refreshToken.stringValue
	}

	required init?(coder aDecoder: NSCoder) {

		guard
			let ID = aDecoder.decodeObject(forKey: kTinderId) as? String,
			let token = aDecoder.decodeObject(forKey: kTinderToken) as? String,
			let name = aDecoder.decodeObject(forKey: kTinderName) as? String,
			let refreshToken = aDecoder.decodeObject(forKey: kTinderRefreshToken) as? String else {
				return nil
		}

		self.ID = ID
		self.token = token
		self.name = name
		self.refreshToken = refreshToken
	}

	// MARK: - Internal Methods

	func encode(with aCoder: NSCoder) {
		aCoder.encode(self.ID, forKey: kTinderId)
		aCoder.encode(self.token, forKey: kTinderToken)
		aCoder.encode(self.name, forKey: kTinderName)
		aCoder.encode(self.refreshToken, forKey: kTinderRefreshToken)
	}

}

extension User {

	class func save(user: User) {

		do {
			let archived = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
			UserDefaults.standard.set(archived, forKey: kUserDefaults)
		} catch {
			Log.e(error.localizedDescription)
		}

	}

	class func logged() -> User? { // FIXME: function to computed

		guard let unarchived = UserDefaults.standard.object(forKey: kUserDefaults) as? Data else {
			return nil
		}

		do {
			guard let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchived) as? User else {
				Log.e("Can't unarchiveTopLevelObjectWithData")
				return nil
			}
			return user
		} catch {
			Log.e(error.localizedDescription)
			return nil
		}

	}

	class func delete() {
		UserDefaults.standard.removeObject(forKey: kUserDefaults)
	}

}
