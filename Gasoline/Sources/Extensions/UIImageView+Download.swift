//
//  UIImageView+Download.swift
//  Gasoline
//
//  Created by Wagner Sales on 15/03/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {

    @discardableResult
	func setPhoto(photoID: String, completion: @escaping Completion) -> DataRequest? {

		guard let photo = GASPhoto.findById(id: photoID) else {
			Log.e("Photo not found")
			return nil
		}

		return AlamoFireJSONClient.requestImage(url: photo.url) { image in
			guard let image = image else {
				Log.e("Load photo")
				completion()
				return
			}

            Log.i(photo.url)
			GASPhoto.nsfw(photoID: photoID, image: image)

			DispatchQueue.main.async { [weak self] in
				self?.image = image
				completion()
			}
		}
	}
}
