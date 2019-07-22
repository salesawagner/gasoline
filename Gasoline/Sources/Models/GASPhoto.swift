//
//  MTPPhoto.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 5/27/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class GASPhoto: Object {

	// MARK: - Properties

	@objc dynamic var id = ""
	@objc dynamic var created = Date()
	@objc dynamic var url = ""
	@objc dynamic var instagram: Bool = false

	@objc dynamic var nsfw: Float = 0

	var tinder: GASTinder? { return self.tinders.first }
	private let tinders = LinkingObjects(fromType: GASTinder.self, property: "photos")

	// MARK: - Constructors

	convenience init?(photo: JSON) {
		let id = photo["id"].stringValue

		guard
			let realm = PersistenceManager.realm,
			!id.isEmpty,
			realm.object(ofType: GASPhoto.self, forPrimaryKey: id) == nil else {
				return nil
		}

		self.init()
		self.id = id
		self.created = Date()
		self.url = photo["url"].stringValue
	}

	convenience init?(instagramPhoto: JSON) {

		var id = instagramPhoto["ts"].stringValue
		if !id.isEmpty { id = "instagram_" + id }

		guard
			let realm = PersistenceManager.realm,
			!id.isEmpty,
			realm.object(ofType: GASPhoto.self, forPrimaryKey: id) == nil else {
				return nil
		}

		self.init()
		self.id = id
		self.created = Date()
		self.url = instagramPhoto["image"].stringValue
		self.instagram = true
	}

	// MARK: - Override Methods

	override static func primaryKey() -> String? {
		return "id"
	}
}

// MARK: - Computed properties

extension GASPhoto {
	var isNsfw: Bool {
		return self.nsfw > 0.8 && self.nsfw <= 1
	}
}

// MARK: - Static Methods

extension GASPhoto {

	// MARK: - Internal Methods

	class func findById(id: String?) -> GASPhoto? {
		guard let realm = PersistenceManager.realm, let id = id else { return nil }
		let photo = realm.object(ofType: GASPhoto.self, forPrimaryKey: id)
		return photo
	}

	class func arrayFromJson(_ json: JSON)  -> [GASPhoto] {

		var photos: [GASPhoto] = []
		photos.append(contentsOf: self.arrayFromResult(json))
		photos.append(contentsOf: self.arrayFromInstagram(json))

		return photos
	}

	class func nsfw(photoID: String?, image: UIImage, completion: Completion? = nil) {

        guard let photoID = photoID, #available(iOS 12.0, *) else {
            Log.e("Machine Learning iOS version")
            return
        }

        DispatchQueue(label: "background_nsfw").async {
            autoreleasepool {

                Detector.shared.check(image: image, completion: { result in

                    switch result {
                    case let .success(confidence: nsfw): self.setNsfw(photoID: photoID, confidence: nsfw)
                    case let .error(error): Log.e(error.localizedDescription)
                    }
                })
            }
        }
	}

	// MARK: - Private Methods

	private class func arrayFromResult(_ json: JSON)  -> [GASPhoto] {

		var photos: [GASPhoto] = []

		for photo in json["photos"].arrayValue {
			if let image = GASPhoto(photo: photo) {
				photos.append(image)
			}
		}

		return photos
	}

	private class func arrayFromInstagram(_ json: JSON) -> [GASPhoto] {

		guard
			let instagram = JSON(json)["instagram"].dictionary,
			let instagramPhotos = instagram["photos"] else {
				return []
		}

		var photos: [GASPhoto] = []
		for photo in instagramPhotos.arrayValue {
			guard let image = GASPhoto(instagramPhoto: photo) else { continue }
			photos.append(image)
		}

		return photos
	}

	static func setNsfw(photoID: String, confidence: Float) {
		guard let photo = GASPhoto.findById(id: photoID), photo.nsfw == 0 else {
			return
		}

		PersistenceManager.write {
			let nsfw = confidence <= 1 ? confidence : 0.1
			photo.nsfw = nsfw


            if nsfw > 0.8 {
                Log.i("BINGO \(nsfw)")
            } else {
                Log.i(nsfw)
            }

			if photo.nsfw > photo.tinder?.nsfw ?? 0 {
				photo.tinder?.nsfw = photo.nsfw
			}
		}
	}
}
