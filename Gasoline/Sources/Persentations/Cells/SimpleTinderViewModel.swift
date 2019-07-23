//
//  SimpleTinderViewModel.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import RealmSwift

class SimpleTinderViewModel: NSObject {

	// MARK: - Properties

    var tinder: GASTinder!
	var tinderID: String {
        return self.tinder.id
    }
	var photoID: String = ""

	var name: String = ""
	var photoUrl: String = ""

	var isLiked: Bool = false
    var isSuperLiked: Bool = false
	var isMatch: Bool = false

	var photosURL: [[String: String]] = []

    var token: NotificationToken?

	// MARK: - Constructors

	init(tinderID: String) {
		super.init()

		guard let tinder = GASTinder.findById(id: tinderID) else {
			return
		}

        self.tinder = tinder
		self.setupTinder()
	}

	// MARK: - Internal Methods

	func setupTinder() {

		self.isLiked = self.tinder.isLiked
		self.isMatch = self.tinder.isMatch
        self.isSuperLiked = self.tinder.isSuperLiked

        // Name
		let years = " \(Date().WASyears(from: self.tinder.birthDay))"
		self.name = (self.tinder.name + ", " + years).WAStrimmed

		// Photo
		let photos = self.tinder.photos.sorted(byKeyPath: "nsfw", ascending: false)
		if let photo = photos.first {
			self.photoID = photo.id
			self.photoUrl = photo.url
		}

		for photo in self.tinder.photos {
			var photoURL: [String: String] = [:]
			photoURL["id"] = photo.id
			photoURL["url"] = photo.url

			self.photosURL.append(photoURL)
		}
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
