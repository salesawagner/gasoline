//
//  PhotoViewModel.swift
//  Gasoline
//
//  Created by Wagner Sales on 12/02/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation

class PhotoViewModel: NSObject {

	// MARK: - Properties

	var photoID: String = ""
	var nsfw: String = ""

	// MARK: - Constructors

	init(photoID: String) {
		super.init()
		
		guard let photo = GASPhoto.findById(id: photoID) else {
			return
		}
		
		self.setupPhoto(photo: photo)
	}

	// MARK: - Private Methods

	private func setupPhoto(photo: GASPhoto) {
		self.photoID = photo.id
		self.nsfw = "\(photo.nsfw)"
	}
}
