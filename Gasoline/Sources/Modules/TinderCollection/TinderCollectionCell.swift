//
//  TinderCollectionCell.swift
//  Gasoline
//
//  Created by Wagner Sales on 24/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import Alamofire
import MaterialComponents.MaterialActivityIndicator

class TinderCollectionCell: MDCCardCollectionCell {

    static let ID: String = "TinderCollectionCell"

    // MARK: - IBOutlets

    @IBOutlet weak var indicatorView: MDCActivityIndicator!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var disLikeButton: UIButton!

    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var hotLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!

    // MARK: - Instance Properties

    var viewModel: SimpleTinderViewModel!
    var request: DataRequest?

    // MARK: - Life cicle

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .white

        self.contentView.layer.masksToBounds = true
        self.layer.masksToBounds = false

        self.contentView.layer.cornerRadius = 10
        self.cornerRadius = self.contentView.layer.cornerRadius

        self.setShadowElevation(.cardResting, for: .normal)

        self.indicatorView.backgroundColor = .clear
        self.indicatorView.cycleColors = [.red]
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = UIImage(named: "Artboard")
        self.nameLabel.text = nil

        self.favoriteLabel.text = nil
        self.hotLabel.text = nil
        self.instagramLabel.text = nil
        self.request?.cancel()
    }

    // MARK: - Private Methods

    private func startAnimating() {
        self.indicatorView.startAnimating()
    }

    private func stopAnimating() {
        self.indicatorView.stopAnimating()
    }

    // MARK: - Internal Methods

    func setup(viewModel: SimpleTinderViewModel) {
        self.viewModel = viewModel

        self.nameLabel.text = self.viewModel.name

        self.setImage(self.viewModel.photoID)
        self.setIsLiked(self.viewModel.isLiked)
        self.setIsMatch(self.viewModel.isMatch)

        self.setIsFavorite(self.viewModel.isFavorite)
        self.setIsHot(self.viewModel.isHot)
        self.setIsInstagram(self.viewModel.instagram.isEmpty)
    }

    // MARK: - Actions

    @IBAction func didTapLikeButton() {
        self.viewModel.likeButtonTapped()
    }

    @IBAction func didTapDisLikeButton() {
        self.viewModel.disLikeButtonTapped()
    }

    @IBAction func didLongPress() {
        self.viewModel.superLikeButtonTapped()
    }
}

extension TinderCollectionCell {

    func setImage(_ photoID: String) {
        self.startAnimating()
        self.request = self.imageView.setPhoto(photoID: photoID, completion: {
            self.stopAnimating()
        })
    }

    func setIsFavorite(_ isFavorite: Bool) {
        self.favoriteLabel.isHidden = !isFavorite
    }

    func setIsHot(_ isHot: Bool) {
        self.hotLabel.isHidden = !isHot
    }

    func setIsInstagram(_ isInstagram: Bool) {
        self.instagramLabel.isHidden = isInstagram
    }

    func setIsLiked(_ isLiked: Bool) {
        let imageName = isLiked ? "btn_liked_big" : "btn_like_big"
        let image = UIImage(named: imageName)
        self.likeButton.setImage(image, for: .normal)
    }

    func setIsMatch(_ isMatch: Bool) {
        self.likeButton.isEnabled = !isMatch
    }
}
