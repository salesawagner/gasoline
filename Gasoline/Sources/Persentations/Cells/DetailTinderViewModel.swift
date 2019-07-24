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

    weak var parent: TinderViewController!

	var bio: String = ""
	var snapchat: String = ""

	var photos: Results<GASPhoto>!
	
	var completion: Completion?

	// MARK: - Constructors

    private override init(tinderID: String) {
		super.init(tinderID: tinderID)
        self.setupToken()
	}

    convenience init(parent: TinderViewController, tinderID: String) {
        self.init(tinderID: tinderID)
        self.parent = parent
    }

	override func setupTinder() {
		super.setupTinder()

        // Bio
		self.bio = tinder.bio.WAStrimmed

		// Others
		self.snapchat = tinder.bio.snapchat.WAStrimmed
        self.isHot = tinder.isNsfw
        self.isFavorite = tinder.isFavorited

		// Photos
		self.photos = tinder.photos.sorted(byKeyPath: "nsfw", ascending: false)

		// Completion
		self.callCompletion()
	}

    private func setupToken() {
        self.token = self.tinder.observe { change in
            switch change {
            case .change(let properties): properties.forEach{ self.propertyChange($0) }
            case .error(let error): Log.e("An error occurred: \(error)")
            case .deleted: Log.i("The object was deleted.")
            }
        }
    }

    func propertyChange(_ property: PropertyChange) {
        switch property.name {
            case "isFavorited": self.parent.setIsFavorite(self.tinder.isFavorited)
            case "isMatch": self.parent.setIsFavorite(self.tinder.isMatch)
            case "isLiked": self.parent.setIsLiked(self.tinder.isLiked)
            case "isNsfw": self.parent.setIsHot(self.tinder.isNsfw)
            case "isSuperLiked": self.parent.setIsSuperLiked(self.tinder.isSuperLiked)
        default: break
        }
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
