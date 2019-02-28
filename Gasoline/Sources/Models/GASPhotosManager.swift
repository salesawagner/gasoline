//
//  PhotosDataManager.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 1/30/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AsyncDisplayKit

class GASPhotosManager: NSObject {

	static let instance = GASPhotosManager()
	let photoCache = AutoPurgingImageCache(
		memoryCapacity: 100 * 1024 * 1024,
		preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
	)
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
		let photoManager = GASPhotosManager.instance
		photoManager.photoCache.add(image, withIdentifier: url)
	}
	class func loadImageFromCache(_ url: String) -> Image? {
		let photoManager = GASPhotosManager.instance
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
}
