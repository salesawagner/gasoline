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

// MARK: - Requests

class GASTinderManager: NSObject {

	class func recs(completion: @escaping (_ tinders: [GASTinder], _ success: Bool) -> Void) { // FIXME: - typealiase
		TinderJSONClient.recs { result in
			switch result {
				case .success(let json): do {
                    let data = JSON(json)["data"].dictionary ?? [:]
					let tinders = GASTinder.arrayFromResult(data)
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
//        TinderJSONClient.updates { result in
//            switch result {
//                case .success(let json): do {
//                    let matches = GASTinder.arrayFromMatches(json)
//                    PersistenceManager.add(matches)
//                }
//                case .failure(let error): do {
//                    Log.e(error.localizedDescription)
//                }
//            }
//        }
	}

	class func topPicks() { // FIXME: remove
//		TinderJSONClient.topPicks { result in
//			switch result {
//				case .success(let json): do {
//					let tinders = GASTinder.arrayFromtopPicks(json)
//					PersistenceManager.add(tinders)
//				}
//				case .failure(let error): do {
//					Log.e(error.localizedDescription)
//				}
//			}
//		}
	}

}

// MARK: - Actions

extension GASTinderManager {

	// MARK: - Private Methods

	private class func checkLikeLimitExceeded(_ json: [String: Any]) -> Bool {

		if JSON(json)["likes_remaining"].intValue <= 0 {
			let visible = UIViewController.visible
			visible.showError()
			return true
		}

		return false
	}

	private class func checkSuperLikeLimitExceeded(_ json: [String: Any]) -> Bool {

		if JSON(json)["limit_exceeded"].boolValue {
			let visible = UIViewController.visible
			visible.showError()
			return true
		}

		return false
	}

	private class func checkMatch(_ json: [String: Any]) -> Bool {

		guard let _ = JSON(json)["match"].dictionary else { return false }

		let visible = UIViewController.visible
		visible.showMatch()
		return true

	}

	// MARK: - Internal Methods

	class func update(tinderID: String) {

		guard let tinder = GASTinder.findById(id: tinderID), tinder.canUpdate else { return }

		TinderJSONClient.user(tinderID: tinderID) { result in
			switch result {
				case .success(let json): do {
					guard let tinder = GASTinder(update: JSON(json)["results"]) else { return }
					PersistenceManager.add([tinder])
				}
				case .failure(let error): do {
					Log.e(error.localizedDescription)
					tinder.setError()
				}
			}
		}

	}

    class func favorite(tinderID: String) {
        guard let tinder = GASTinder.findById(id: tinderID) else { return }
        tinder.setFavorite(!tinder.isFavorited)
    }

	class func like(tinderID: String) {

		guard let tinder = GASTinder.findById(id: tinderID) else { return }

		tinder.setLike(true)
		TinderJSONClient.like(tinderID: tinderID) { result in
			switch result {
				case .success(let json): do {
					if self.checkLikeLimitExceeded(json) {
						tinder.setLike(false)
					} else if self.checkMatch(json) {
						tinder.setMacth(true)
					}
				}
				case .failure(let error): do {
					Log.e(error.localizedDescription)
					tinder.setLike(false)
				}
			}
		}

	}

	class func superLike(tinderID: String) {

		guard let tinder = GASTinder.findById(id: tinderID) else { return }

		tinder.setSuperLike(true)
		TinderJSONClient.superLike(tinderID: tinderID) { result in
			switch result {
				case .success(let json): do {
					if self.checkSuperLikeLimitExceeded(json) {
						tinder.setSuperLike(false)
					} else if self.checkMatch(json) {
						tinder.setMacth(true)
					}
				}
				case .failure(let error): do {
					Log.e(error.localizedDescription)
					tinder.setSuperLike(false)
				}
			}
		}

	}

	class func disLike(tinderID: String) {

		guard let tinder = GASTinder.findById(id: tinderID) else { return }

		if tinder.isMatch {
			self.unMatch(tinderID: tinder.id)
			return
		}

		tinder.setDisLike(true)
		TinderJSONClient.disLike(tinderID: tinderID) { result in
			switch result {
				case .success( _): return
				case .failure(let error): do {
					Log.e(error.localizedDescription)
					tinder.setDisLike(false)
				}
			}
		}

	}

	class func unMatch(tinderID: String) {

		guard let tinder = GASTinder.findById(id: tinderID), !tinder.matchId.isEmpty else {
			return
		}

		defer {
			PersistenceManager.delete(tinderID: tinder.id)
		}

		TinderJSONClient.unMatch(matchID: tinder.matchId) { result in
			switch result {
				case .success( _): return
				case .failure(let error): Log.e(error.localizedDescription)
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
