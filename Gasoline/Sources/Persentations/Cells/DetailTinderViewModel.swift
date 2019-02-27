//
//  DetailTinderViewModel.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import RealmSwift

class DetailTinderViewModel: SimpleTinderViewModel {

	// MARK: - Properties

	var online: String = ""
	var bio: String = ""
	var instagram: String = ""
	var snapchat: String = ""
	var isLiked: Bool = false

	var photos: Results<GASPhoto>!
	
	var completion: Completion?

	// MARK: - Constructors

	override init(tinderID: String) {
		super.init(tinderID: tinderID)
	}

	override func setupTinder(tinder: GASTinder) {
		super.setupTinder(tinder: tinder)

		// Online
		self.online = tinder.statusCode == 500 ? "🤕 Deactivated" : ""

		// Bio
		self.bio = tinder.bio

		// Others
		self.isLiked = tinder.isLiked
		self.instagram = tinder.bio.instagram
		self.snapchat = tinder.bio.snapchat

		// Photos
		self.photos = tinder.photos.sorted(byKeyPath: "nsfw", ascending: false)

		// Completion
		self.callCompletion()
	}

	// MARK: - Private Methods

	private func callCompletion() {
		guard let completion = self.completion else { return }
		completion()
	}

	// MARK: - Internal Methods

	func load() {
		GASTinderManager.update(tinderID: self.tinderID)
		// TODO: - colocar realm reativo
	}

}
