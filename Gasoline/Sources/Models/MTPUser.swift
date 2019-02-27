//
//  MTPUser.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 5/23/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import SwiftyJSON

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************
private let kUserDefaults = "br.com.gasoline.UserDefaults"
private let kTinderToken = "br.com.gasoline.tinderToken"
private let kTinderId = "br.com.gasoline.tinderId"
private let kTinderName = "br.com.gasoline.tinderName"
//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************
class MTPUser: NSObject, NSCoding {
	//**************************************************
	// MARK: - Properties
	//**************************************************
	var tinderToken: String?
	var id: String!
	var name: String!
	class var userLogged: MTPUser? {
		var userLogged: MTPUser?
		if let unarchivedObject = UserDefaults.standard.object(forKey: kUserDefaults) as? Data {
			if let user = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject) as? MTPUser {
				userLogged = user
			}
		}
		return userLogged
	}
	//**************************************************
	// MARK: - Constructors
	//**************************************************
	init?(json: JSON) {
		MTPUser.delete()
		guard
			let token = json["token"].string,
			let user = json["user"].dictionary,
			let id = user["_id"],
			let name = user["name"] else {
				return nil
		}
		self.tinderToken = token
		self.id = id.stringValue
		self.name = name.stringValue
		super.init()
		self.save()
	}
	required init?(coder aDecoder: NSCoder) {
		guard
			let token = aDecoder.decodeObject(forKey: kTinderToken) as? String,
			let id = aDecoder.decodeObject(forKey: kTinderId) as? String,
			let name = aDecoder.decodeObject(forKey: kTinderName) as? String else {
				return nil
		}
		self.tinderToken = token
		self.id = id
		self.name = name
	}
	//**************************************************
	// MARK: - Private Methods
	//**************************************************

	//**************************************************
	// MARK: - Internal Methods
	//**************************************************

	//**************************************************
	// MARK: - Public Methods
	//**************************************************
	func encode(with aCoder: NSCoder) {
		aCoder.encode(self.tinderToken, forKey: kTinderToken)
		aCoder.encode(self.id, forKey: kTinderId)
		aCoder.encode(self.name, forKey: kTinderName)
	}
	func save() {
		let archivedObject = NSKeyedArchiver.archivedData(withRootObject: self)
		let defaults = UserDefaults.standard
		defaults.set(archivedObject, forKey: kUserDefaults)
	}
	class func delete() {
		let defaults = UserDefaults.standard
		defaults.removeObject(forKey: kUserDefaults)
	}
	//**************************************************
	// MARK: - Override Public Methods
	//**************************************************
}
