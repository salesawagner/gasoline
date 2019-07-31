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

    var photos: Results<GASPhoto>!
    var bio: String = "" {
        didSet {
            self.delegate?.setBio?(self.bio)
        }
    }

	// MARK: - Override Methods

	override func setupTinder() {
		super.setupTinder()

        // Bio
		self.bio = self.tinder.bio.WAStrimmed

        // Photos
		self.photos = tinder.photos.sorted(byKeyPath: "nsfw", ascending: false)
	}

	// MARK: - Internal Methods

	func load() {
        self.setupTinder()
		GASTinderManager.update(tinderID: self.tinderID)
	}

    func favorite() {
        GASTinderManager.favorite(tinderID: self.tinderID)
    }
}
