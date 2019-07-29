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
import MaterialComponents.MDCCardCollectionCell

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
        self.setupUI()
        self.resetValues()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetValues()
    }

    // MARK: - Private Methods

    private func resetValues() {
        self.imageView.image = UIImage(named: "Artboard")
        self.nameLabel.text = nil

        self.setIsHot(false)
        self.setIsFavorite(false)
        self.setIsInstagram(false)
        self.request?.cancel()
        self.stopAnimating()
    }

    private func setupUI() {
        self.setupCell()
        self.setupCard()
        self.setupIndicator()
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

    private func setImage(_ photoID: String) {
        self.startAnimating()
        self.request = self.imageView.setPhoto(photoID: photoID, completion: {
            self.stopAnimating()
        })
    }

    // MARK: - Internal Methods

    func setup(viewModel: SimpleTinderViewModel) {
        self.resetValues()
        self.viewModel = viewModel
        self.nameLabel.text = self.viewModel.name
        self.setImage(self.viewModel.photoID)
        self.viewModel.setupTinder()
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

extension TinderCollectionCell: TinderDelegate {

    func setIsFavorite(_ isFavorite: Bool) {
        self.favoriteLabel.isHidden = !isFavorite
    }

    func setIsHot(_ isHot: Bool) {
        self.hotLabel.isHidden = !isHot
    }

    func setIsInstagram(_ isInstagram: Bool) {
        self.instagramLabel.isHidden = !isInstagram
    }

    func setIsLiked(_ isLiked: Bool) {
        let imageName = isLiked ? "btn_liked_big" : "btn_like_big"
        let image = UIImage(named: imageName)
        self.likeButton.setImage(image, for: .normal)
    }

    func setIsSuperLiked(_ isLiked: Bool) {
        guard isLiked else { return }
        let imageName = "btn_superliked_big"
        let image = UIImage(named: imageName)
        self.likeButton.setImage(image, for: .normal)
    }

    func setIsMatch(_ isMatch: Bool) {
        self.likeButton.isEnabled = !isMatch
    }
}
