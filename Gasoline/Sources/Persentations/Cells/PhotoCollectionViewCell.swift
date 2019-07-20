//
//  PhotoCollectionViewCell.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 5/25/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

	// MARK: - Properties

	static let identifier: String = "MTPPhotoCollectionViewCellIdentifier"
	private var viewModel: PhotoViewModel!
	private var photoID: String = ""

	// MARK: - IBOutlets

	@IBOutlet weak var indicator: UIActivityIndicatorView!
	@IBOutlet weak var photoImageView: UIImageView!
	@IBOutlet weak var nsfwLabel: UILabel!

	// MARK: - Override Methods

	override func prepareForReuse() {
		self.photoImageView.image = nil
	}

	// MARK: - Private Methods

	private func start() {
		self.indicator.startAnimating()
	}

	private func stop() {
		self.indicator.stopAnimating()
	}

	// MARK: - Public Methods

	func setup(viewModel: PhotoViewModel) {

		self.viewModel = viewModel
		self.photoID = viewModel.photoID
//        self.nsfwLabel.text = viewModel.nsfw

		self.start()
		self.photoImageView.setPhoto(photoID: self.photoID, completion: {
			self.stop()
		})
	}
}
