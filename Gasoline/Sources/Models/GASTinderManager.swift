//
//  GASTinderManager.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 10/02/17.
//  Copyright © 2017 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class GASTinderManager: NSObject {

	// MARK: - Properties

	static var array = [[GASTinder]]()
	static let maxRequest: Int = 7
	static var requestCount: Int = 0

	// MARK: - Private Methods

	class private func clear() {
		self.requestCount = 0
		self.array = []
	}

	// MARK: - Internal Methods

	class func discoveryMatches() {
		
		if self.array.count == self.maxRequest {

			var likedMe = Set(GASTinderManager.listAll())
			for list in self.array {
				likedMe = likedMe.intersection(list)
			}

			PersistenceManager.write {
				let tinders = List<GASTinder>()
				tinders.append(objectsIn: likedMe)
				tinders.setValue(true, forKey: "wasLiked")
			}
		}

		self.clear()
	}

	class func resetLikedMe() {
		PersistenceManager.write {
			GASTinderManager.listLikedMe().setValue(false, forKey: "wasLiked")
		}
	}
}

// MARK: - Requests

extension GASTinderManager {

	class func recs(completion: @escaping (_ tinders: [GASTinder], _ success: Bool) -> Void) { // FIXME: - typealiase
		TinderJSONClient.recs { result in
			switch result {
				case .success(let json): do {
					let tinders = GASTinder.arrayFromResult(json)
					PersistenceManager.add(tinders, completion: { success in
						completion(tinders, true)
					})
				}
				case .failure(let error): do {
					Log.e(error.localizedDescription)
					completion([], false)
				}
			}
		}
	}
	
	class func updates() {
		TinderJSONClient.updates { result in
			switch result {
				case .success(let json): do {
					let matches = GASTinder.arrayFromJsonMatches(JSON(json))
					PersistenceManager.add(matches)
				}
				case .failure(let error): do {
					Log.e(error.localizedDescription)
				}
			}
		}
	}

	class func topPicks() {
		TinderJSONClient.topPicks { result in
			switch result {
				case .success(let json): do {
					let tinders = GASTinder.arrayFromtopPicks(json)
					PersistenceManager.add(tinders)
				}
				case .failure(let error): do {
					Log.e(error.localizedDescription)
				}
			}
		}
	}

	class func likedMe(completion: @escaping CompletionSuccess) {
		self.recs { (tinders, success) in
			guard success else {
				self.clear()
				completion(false)
				return
			}

			self.requestCount += 1
			self.array.append(tinders)

			if self.requestCount < self.maxRequest {
				self.likedMe(completion: completion)
			} else {
				self.discoveryMatches()
				completion(true)
			}

		}
	}
}

// MARK: - Actions

extension GASTinderManager {

	// MARK: - Private Methods

	private class func checkMatch(tinder: GASTinder, json: JSON) {

		print(json)
		var isMatch = false
		if json["match"].dictionary != nil {
			isMatch = true
			let visible = UIViewController.visible
			visible.showMatch()
		}

		PersistenceManager.write {
			tinder.isMatch = isMatch
		}

	}

	// MARK: - Internal Methods

	class func update(tinderID: String) {

		// FIXME: - Colocar regras do can update dentro do metodo
		guard let tinder = GASTinder.findById(id: tinderID), tinder.canUpdate else { return }

		TinderJSONClient.user(tinderID: tinderID) { result in
			switch result {
				case .success(let json): do {
					guard let tinder = GASTinder(update: JSON(json)) else { return }
					tinder.lastUpdate = Date()
					PersistenceManager.add([tinder])
				}
				case .failure(let error): do {
					Log.e(error)
					Log.e(error.localizedDescription)
					let newTinder = GASTinder(value: tinder)
					newTinder.statusCode = 500
					PersistenceManager.add([newTinder])
				}
			}
		}

	}

	class func like(tinderID: String) {

		guard let tinder = GASTinder.findById(id: tinderID) else { return }

		func _persist(value: Bool) {
			PersistenceManager.write {
				tinder.isLiked = value
			}
		}

		_persist(value: true)
		TinderJSONClient.like(tinderID: tinderID) { result in
			switch result {
				case .success(let json): self.checkMatch(tinder: tinder, json: JSON(json))
				case .failure(let error): do {
					Log.e(error.localizedDescription)
					_persist(value: false)
				}
			}
		}

	}

	class func superLike(tinderID: String) {

		guard let tinder = GASTinder.findById(id: tinderID) else { return }

		func _persist(value: Bool) {
			PersistenceManager.write {
				tinder.isLiked = value
				tinder.isSuperLiked = value
			}
		}

		_persist(value: true)
		TinderJSONClient.superLike(tinderID: tinderID) { result in
			switch result {
				case .success(let json): self.checkMatch(tinder: tinder, json: JSON(json))
				case .failure(let error): do {
					Log.e(error.localizedDescription)
					_persist(value: false)
				}
			}
		}

	}

	class func disLike(tinderID: String) {

		guard let tinder = GASTinder.findById(id: tinderID) else { return }
		guard !tinder.isMatch else {
			GASTinderManager.unMatch(tinderID: tinder.id, matchID: tinder.matchId)
			return
		}
		guard !tinder.isDisLiked else {
			PersistenceManager.delete(tinderID: tinderID)
			return
		}

		func _persist(value: Bool) {
			PersistenceManager.write {
				tinder.isDisLiked = value
			}
		}

		_persist(value: true)
		TinderJSONClient.disLike(tinderID: tinderID) { result in
			switch result {
				case .success( _): return
				case .failure(let error): do {
					Log.e(error.localizedDescription)
					_persist(value: false)
				}
			}
		}

	}

	class func unMatch(tinderID: String, matchID: String) {

		guard let tinder = GASTinder.findById(id: tinderID) else { return }

		func _persist(value: Bool) {
			PersistenceManager.write {
				tinder.isBlocked = true
			}
			PersistenceManager.delete(tinderID: tinder.id)
		}

		_persist(value: true)
		TinderJSONClient.unMatch(matchID: matchID) { result in
			switch result {
				case .success( _): return
				case .failure(let error): do {
					Log.e(error.localizedDescription)
				}
			}
		}

	}

	class func profile(completion: @escaping CompletionSuccess) {

		var parameters: [String: Any] = [:]
		parameters["age_filter_max"] = 1000
		parameters["distance_filter"] = 99.419637863969086
		parameters["age_filter_min"] = 18

		TinderJSONClient.profile(parameters: parameters) { result in
			switch result {
				case .success( _): completion(true)
				case .failure(let error): do {
					Log.e(error.localizedDescription)
					completion(false)
				}
			}
		}
	}

}
