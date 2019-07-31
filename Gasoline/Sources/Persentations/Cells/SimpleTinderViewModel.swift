//
//  SimpleTinderViewModel.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import RealmSwift

@objc protocol TinderDelegate: class {

    func setIsInstagram(_ isInstagram: Bool)
    func setIsFavorite(_ isFavorite: Bool)
    func setIsHot(_ isHot: Bool)

    @objc optional func setImage(_ photoID: String)
    @objc optional func setIsLiked(_ isLiked: Bool)
    @objc optional func setIsSuperLiked(_ isLiked: Bool)
    @objc optional func setIsMatch(_ isMatch: Bool)
    @objc optional func setBio(_ text: String)
}

class SimpleTinderViewModel: NSObject {

	// MARK: - Properties

    // FIXME: Achar solucao para herança e inacessível na view
    weak var delegate: TinderDelegate? = nil
    var tinder: GASTinder!

    private(set) var tinderID: String = ""
    private(set) var photoID: String = ""

	private(set) var name: String = ""
	private(set) var photoUrl: String = ""

    private(set) var instagram: String = "" {
        didSet {
            self.delegate?.setIsInstagram(!self.instagram.isEmpty)
        }
    }

    private(set) var isLiked: Bool = false {
        didSet {
            self.delegate?.setIsLiked?(self.tinder.isLiked)
        }
    }

    private(set) var isSuperLiked: Bool = false {
        didSet {
            self.delegate?.setIsSuperLiked?(self.isSuperLiked)
        }
    }

    private(set) var isMatch: Bool = false {
        didSet {
            self.delegate?.setIsMatch?(self.tinder.isMatch)
        }
    }

    private(set) var isHot: Bool = false {
        didSet {
            self.delegate?.setIsHot(self.tinder.isNsfw)
        }
    }

    private(set) var isFavorited: Bool = false {
        didSet {
            self.delegate?.setIsFavorite(self.tinder.isFavorited)
        }
    }

    private var token: NotificationToken?

	// MARK: - Constructors

	init(delegate: TinderDelegate? = nil, tinderID: String) {
		super.init()

		guard let tinder = GASTinder.findById(id: tinderID) else {
			return
		}

        self.tinder = tinder
        self.delegate = delegate
		self.setupTinder()
        self.setupToken()
	}

	// MARK: - Internal Methods

    private func setupToken() {
        self.token = self.tinder.observe { change in
            switch change {
            case .change(let properties): properties.forEach{ self.propertyChange($0) }
            case .error(let error): Log.e("An error occurred: \(error)")
            case .deleted: Log.i("The object was deleted.")
            }
        }
    }

   private func propertyChange(_ property: PropertyChange) {
        switch property.name {
            case "isFavorited": self.isFavorited = self.tinder.isFavorited
            case "isMatch": self.isMatch = self.tinder.isMatch
            case "isLiked": self.isLiked = self.tinder.isLiked
            case "isNsfw": self.isHot = self.tinder.isNsfw
            case "isSuperLiked": self.isSuperLiked = self.tinder.isSuperLiked
            default: break
        }
    }

	func setupTinder() {

        self.tinderID = self.tinder.id
		self.isLiked = self.tinder.isLiked
		self.isMatch = self.tinder.isMatch
        self.isSuperLiked = self.tinder.isSuperLiked
        self.isFavorited = self.tinder.isFavorited
        self.instagram = self.tinder.bio.instagram.WAStrimmed

        // Name
		let years = " \(Date().WASyears(from: self.tinder.birthDay))"
		self.name = (self.tinder.name + ", " + years).WAStrimmed

		// Photo
		let photos = self.tinder.photos.sorted(byKeyPath: "nsfw", ascending: false)
		if let photo = photos.first {
			self.photoID = photo.id
			self.photoUrl = photo.url
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
