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
	private var photo: GASPhoto!

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

	func setup(_ photo: GASPhoto) {

		self.photo = photo
		self.nsfwLabel.text = "\(photo.nsfw)"

		self.start()
		GASPhoto.download(photoID: photo.id) { [weak self] image in

			defer {
				self?.stop()
			}

			guard let image = image else {
				return
			}

			DispatchQueue.main.async {
				self?.photoImageView.image = image
			}

		}

	}

}
