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

	func setPhoto(photoID: String, completion: @escaping Completion) {

        guard let photo = GASPhoto.findById(id: photoID), let url = URL(string: photo.url) else {
            completion()
            return
		}

        self.af_setImage(withURL: url,
                         placeholderImage: UIImage(named: "Artboard"),
                         progressQueue: DispatchQueue.main,
                         imageTransition: UIImageView.ImageTransition.crossDissolve(0.25),
                         runImageTransitionIfCached: false) { response in

                            defer {
                                completion()
                            }

                            guard let image = response.value else {
                                return
                            }

                            GASPhoto.nsfw(photoID: photoID, image: image)
        }

        return
	}
}
