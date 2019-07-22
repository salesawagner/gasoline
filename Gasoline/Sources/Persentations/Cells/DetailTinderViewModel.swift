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

    var isHot: Bool = false
    var isFavorite: Bool = false

	var photos: Results<GASPhoto>!
	
	var completion: Completion?

	// MARK: - Constructors

	override init(tinderID: String) {
		super.init(tinderID: tinderID)
	}

	override func setupTinder(tinder: GASTinder) {
		super.setupTinder(tinder: tinder)

        // Bio
		self.bio = tinder.bio.WAStrimmed

		// Others
		self.instagram = tinder.bio.instagram.WAStrimmed
		self.snapchat = tinder.bio.snapchat.WAStrimmed
        self.isHot = tinder.isNsfw
        self.isFavorite = tinder.isFavorited

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
	}

    func favorite() {
        GASTinderManager.favorite(tinderID: self.tinderID)
    }
}
