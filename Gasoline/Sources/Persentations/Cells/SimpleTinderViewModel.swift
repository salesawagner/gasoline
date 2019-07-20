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
	var photoUrl: String = ""
	var canAction: Bool = false

	var isLiked: Bool = false
	var isMatch: Bool = false

	var photosURL: [[String: String]] = []

	// MARK: - Constructors

	init(tinderID: String) {
		super.init()

		guard let tinder = GASTinder.findById(id: tinderID) else {
			return
		}

		self.setupTinder(tinder: tinder)
	}

	// MARK: - Internal Methods

	func setupTinder(tinder: GASTinder) {
		self.tinderID = tinder.id
		self.isLiked = tinder.isLiked
		self.isMatch = tinder.isMatch

		// Distance
		let kms: Float = Float(tinder.distance) * 1.609344
		self.distance = String(format: "%.0f km", kms)

		// Name
		let nsfw = tinder.isNsfw == true ? "🔥 " : ""
		let years = " \(Date().WASyears(from: tinder.birthDay))"
		self.name = nsfw + tinder.name + years

		// Photo
		let photos = tinder.photos.sorted(byKeyPath: "nsfw", ascending: false)
		if let photo = photos.first {
			self.photoID = photo.id
			self.photoUrl = photo.url
		}

		for photo in tinder.photos {
			var photoURL: [String: String] = [:]
			photoURL["id"] = photo.id
			photoURL["url"] = photo.url

			self.photosURL.append(photoURL)
		}

		// Actions
		self.canAction = !tinder.isMatch // tinder.canAction && !tinder.isLiked
	}

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
