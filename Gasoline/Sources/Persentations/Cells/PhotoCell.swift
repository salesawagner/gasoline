//
//  PhotoCell.swift
//  Gasoline
//
//  Created by Wagner Sales on 30/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import Alamofire
import MaterialComponents

class PhotoCell: MDCCardCollectionCell {

    // MARK: - IBOutlets Properties

    @IBOutlet private weak var indicatorView: MDCActivityIndicator!
    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Internal Properties

    private var photoID: String?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupIndicator()
        self.resetValues()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetValues()
    }

    // MARK: - Private Methods

    private func setupIndicator() {
        self.indicatorView.backgroundColor = .clear
        self.indicatorView.cycleColors = [.red]
    }

    private func startAnimating() {
        self.indicatorView.startAnimating()
    }

    private func stopAnimating() {
        self.indicatorView.stopAnimating()
    }

    // MARK: - Internal Methods

    func resetValues() {
        self.imageView.af_cancelImageRequest()
        self.stopAnimating()
    }

    func setImage(_ photoID: String) {
        self.photoID = photoID
        self.startAnimating()
        self.imageView.setPhoto(photoID: photoID, completion: {
            self.stopAnimating()
        })
    }
}
