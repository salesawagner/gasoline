//
//  PhotoCollectionViewCell.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 5/25/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator

class PhotoCollectionViewCell: UICollectionViewCell {

	// MARK: - Properties

	static let identifier: String = "MTPPhotoCollectionViewCellIdentifier"
	private var viewModel: PhotoViewModel!
	private var photoID: String = ""

	// MARK: - IBOutlets

    @IBOutlet weak var indicatorView: MDCActivityIndicator!
	@IBOutlet weak var photoImageView: UIImageView!
	@IBOutlet weak var nsfwLabel: UILabel!

	// MARK: - Override Methods

	override func prepareForReuse() {
		self.photoImageView.image = nil
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        self.indicatorView.backgroundColor = .clear
        self.indicatorView.cycleColors = [.red]
    }

	// MARK: - Private Methods

	private func start() {
        self.indicatorView.startAnimating()
	}

	private func stop() {
        self.indicatorView.stopAnimating()
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
