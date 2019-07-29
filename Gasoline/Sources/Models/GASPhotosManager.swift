//
//  PhotosDataManager.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 1/30/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import AlamofireImage
import AsyncDisplayKit

import CoreML
import Vision


class GASPhotosManager: NSObject {

	static let shared = GASPhotosManager()
    let group = DispatchGroup()
	let photoCache = AutoPurgingImageCache(
		memoryCapacity: 100 * 1024 * 1024,
		preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
	)

    class func listAll() -> Results<GASPhoto> {
        let result = PersistenceManager.objects(objectType: GASPhoto.self)
        return result.filter("nsfw = 0")
    }
}

class PhotoImage: NSObject, ASImageContainerProtocol {
	let image: UIImage!
	required init(url: String, image: UIImage) {
		self.image = image
		super.init()
		self.addImageToCache(url, image: image)
	}
	public func asdk_image() -> UIImage? {
		return self.image
	}
	public func asdk_animatedImageData() -> Data? {
		return self.image.pngData()
	}
	private func addImageToCache(_ url: String, image: Image) {
		let photoManager = GASPhotosManager.shared
		photoManager.photoCache.add(image, withIdentifier: url)
	}
	class func loadImageFromCache(_ url: String) -> Image? {
		let photoManager = GASPhotosManager.shared
		return photoManager.photoCache.image(withIdentifier: url)
	}
}

extension GASPhotosManager: ASImageCacheProtocol {

	func cachedImage(with URL: URL,
	                 callbackQueue: DispatchQueue,
	                 completion: @escaping AsyncDisplayKit.ASImageCacherCompletion) {
		guard let image = PhotoImage.loadImageFromCache(URL.absoluteString) else {
			return completion(nil)
		}
		completion(image)
	}

    func nsfwAll() {

        Log.i("NSFW rest: \(GASPhotosManager.listAll().count)")

        DispatchQueue.global(qos: .utility).async { [weak self] in

            GASPhotosManager.listAll().forEach {

                self?.group.enter()
                let photo = $0
                guard let url = URL(string: photo.url) else {
                    self?.group.leave()
                    return
                }

                let resquets = VNImageRequestHandler(url: url, options: [:])
                Detector.shared.check(resquets) { result in

//                    defer { self?.group.leave() }

                    switch result {
                        case let .success(confidence: nsfw): GASPhoto.setNsfw(photoID: photo.id, confidence: nsfw)
                        case let .error(_): GASPhoto.setNsfw(photoID: photo.id, confidence: -1)
                    }

//                    group.leave()
                }
            }

            self?.group.wait()
        }
    }
}
