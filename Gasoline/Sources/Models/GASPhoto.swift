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
	@objc dynamic var tinder: GASTinder?
	@objc dynamic var nsfw: Float = 0
	var isNsfw: Bool {
		return self.nsfw > 0.8 && self.nsfw <= 1
	}

	// MARK: - Constructors

	convenience init?(photo: JSON, tinder: GASTinder) {
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
		self.tinder = tinder
	}

	convenience init?(instagramPhoto: JSON, tinder: GASTinder) {

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

		self.tinder = tinder
	}

	// MARK: - Override Methods

	override static func primaryKey() -> String? {
		return "id"
	}

}

extension GASPhoto {
	
	class func download(photoID: String, completion: @escaping AlamofireImageCompletionHandler) {

		guard let photo = GASPhoto.findById(id: photoID) else {
			Log.e("Photo not found")
			completion(nil)
			return
		}

		AlamoFireJSONClient.requestImage(url: photo.url) { image in
			guard let image = image else {
				Log.e("Load photo")
				PersistenceManager.delete(photoID: photoID)
				return
			}

			GASPhoto.nsfw(photoID: photoID, image: image)
			completion(image)

		}

	}

	class func findById(id: String?) -> GASPhoto? {
		guard let realm = PersistenceManager.realm, let id = id else { return nil }
		let photo = realm.object(ofType: GASPhoto.self, forPrimaryKey: id)
		return photo
	}

//	class func nsfwAllPhotos() {
//		guard let realm = PersistenceManager.realm else { return }
//
//		let photos = realm.objects(GASPhoto.self).filter { photo -> Bool in
//			guard let tinder = photo.tinder else { return false }
//			return photo.nsfw == 0 && tinder.isBlocked == false
//		}
//
//		let photoIDs: [String] = photos.map({ photo -> String in
//			return photo.id
//		})
//
//		let count = photoIDs.count <= 100 ? photoIDs.count : 100
//		for i in 0..<count {
//			let photoID = photoIDs[i]
//			GASPhoto.download(photoID: photoID) { (image) in
//				// TODO:
//			}
//		}
//	}

	class func nsfw(photoID: String?, image: UIImage, completion: Completion? = nil) {

		guard let photoID = photoID, #available(iOS 12.0, *) else {
			Log.e("Machine Learning iOS version")
			return
		}

		DispatchQueue(label: "background_nsfw").async {
			autoreleasepool {

				guard let photo = GASPhoto.findById(id: photoID) else {
					Log.e("Photo not found")
					return
				}

				guard photo.nsfw == 0 else {
					return
				}

				let detector = Detector.shared
				detector.check(image: image, completion: { result in

					switch result {
					case let .success(nsfwConfidence: confidence):

						guard confidence > photo.nsfw  else { return }

						PersistenceManager.write {
							photo.nsfw = confidence <= 1 ? confidence : 0.1

							if photo.nsfw > photo.tinder?.nsfw ?? 0 {
								photo.tinder?.nsfw = photo.nsfw
							}

						}

					case let .error(error):
						Log.e(error.localizedDescription)
					}

				})

			}

		}
	}
	
	class func createFile(photo: GASPhoto, image: UIImage, confidence: Float) {
		do {
			let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
			var fileURL = documentsURL.appendingPathComponent("photos/")
			
			if photo.isNsfw {
				fileURL = fileURL.appendingPathComponent("bikini/\(photo.id).jpg")
				if let pngImageData = UIImageJPEGRepresentation(image, 1.0) {
					try pngImageData.write(to: fileURL, options: .atomic)
					Log.e("------->>>>\(confidence)")
				} else {
					Log.e("------->>>>nao salvou o arquivo")
				}
				
			} else if photo.nsfw < 0.5 {
				fileURL = fileURL.appendingPathComponent("nobikini/\(photo.id).jpg")
				if let pngImageData = UIImageJPEGRepresentation(image, 1.0) {
					try pngImageData.write(to: fileURL, options: .atomic)
					Log.e("------->>>>\(confidence)")
				} else {
					Log.e("------->>>>nao salvou o arquivo")
				}
			}
			
		} catch {
			Log.e(error.localizedDescription)
		}
	}
}
