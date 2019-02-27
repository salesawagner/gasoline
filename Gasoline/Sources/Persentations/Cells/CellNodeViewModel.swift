//
//  SimpleTinderViewModel.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation

class SimpleTinderViewModel: NSObject {

	// MARK: - Properties

	var tinderID: String = ""
	var photoID: String = ""

	var name: String = ""
	var distance: String = ""
	var online: String = ""
	var photoUrl: String = ""
	var canAction: Bool = false
	
	// MARK: - Constructors
	
	init(tinderID: String) {
		guard let tinder = GASTinder.findById(id: tinderID) else {
			return
		}

		self.tinderID = tinder.id

		// Distance
		let kms: Float = Float(tinder.distance) * 1.609344
		self.distance = String(format: "%.0f km", kms)

		// Online
		var online = ""
		if tinder.statusCode == 500 {
			online = "🤕 Deactivated"
		} else {
			online = "Active \(Date().WAStoStringAgo(tinder.pingTime)) ago"
		}
		self.online = online

		// Name
		let nsfw = tinder.isNsfw == true ? "🔥 " : ""
		let years = " \(Date().WASyears(from: tinder.birthDay))"
		self.name = nsfw + tinder.name + years

		// Photo
		let photos = tinder.photos.sorted(byKeyPath: "nsfw", ascending: false)
		if let photo = photos.first {
			self.photoID = photo.id
			self.photoUrl = photo.urlMid
		}

		// Actions
		self.canAction = tinder.canAction

	}

	// MARK: - Internal Methods

	@objc func likeButtonTapped() {
		GASTinderManager.like(tinderID: self.tinderID)
	}

	@objc func superLikeButtonTapped() {
		GASTinderManager.superLike(tinderID: self.tinderID)
	}

	@objc func disLikeButtonTapped() {
		GASTinderManager.disLike(tinderID: self.tinderID)
	}

}
