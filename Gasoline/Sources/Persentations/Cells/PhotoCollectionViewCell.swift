//
//  PhotoCollectionViewCell.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 5/25/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: PhotoCell {

	// MARK: - Properties

	static let identifier: String = "MTPPhotoCollectionViewCellIdentifier"
	private var viewModel: PhotoViewModel!

	// MARK: - Internal Methods

	func setup(viewModel: PhotoViewModel) {
		self.viewModel = viewModel
        self.setImage(self.viewModel.photoID)
	}
}
