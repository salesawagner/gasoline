//
//  TinderCollectionCell.swift
//  Gasoline
//
//  Created by Wagner Sales on 24/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import Alamofire
import MaterialComponents

class TinderCollectionCell: PhotoCell {

    // MARK: - Internal Static Properties

    static let ID: String = "TinderCollectionCell"

    // MARK: - IBOutlets Properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var disLikeButton: UIButton!

    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var hotLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!

    // MARK: - Internal Properties

    var viewModel: SimpleTinderViewModel!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        self.resetValues()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetValues()
    }

    override func resetValues() {
        super.resetValues()
        self.nameLabel.text = nil
    }

    // MARK: - Private Methods

    private func setupUI() {
        self.setupCell()
        self.setupCard()
    }

    private func setupCell() {
        self.backgroundColor = .white
        self.layer.masksToBounds = false
    }

    private func setupCard() {
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 10
        self.cornerRadius = self.contentView.layer.cornerRadius
        self.setShadowElevation(.cardResting, for: .normal)
    }

    // MARK: - Internal Methods

    func setup(viewModel: SimpleTinderViewModel) {
        self.resetValues()
        self.viewModel = viewModel
        self.setupTinder()
    }

    func setupTinder(updatePhoto: Bool = true) {

        if updatePhoto {
            self.setImage(self.viewModel.photoID)
        }

        self.viewModel.setupTinder()
        self.nameLabel.text = self.viewModel.name
        self.setIsFavorite()
        self.setIsHot()
        self.setIsInstagram()
        self.setIsLiked()
        self.setIsSuperLiked()
        self.setIsMatch()
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

// Mark: - TinderDelegate

extension TinderCollectionCell {

    private func setIsFavorite() {
        self.favoriteLabel.isHidden = !self.viewModel.isFavorited
    }

    private func setIsHot() {
        self.hotLabel.isHidden = !self.viewModel.isHot
    }

    private func setIsInstagram() {
        self.instagramLabel.isHidden = self.viewModel.instagram.isEmpty
    }

    private func setIsLiked() {
        let imageName = self.viewModel.isLiked ? "btn_liked_big" : "btn_like_big"
        let image = UIImage(named: imageName)
        self.likeButton.setImage(image, for: .normal)
    }

    private func setIsSuperLiked() {
        guard self.viewModel.isSuperLiked else { return }
        let imageName = "btn_superliked_big"
        let image = UIImage(named: imageName)
        self.likeButton.setImage(image, for: .normal)
    }

    private func setIsMatch() {
        self.likeButton.isEnabled = !self.viewModel.isMatch
    }
}
