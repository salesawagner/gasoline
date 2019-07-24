//
//  TinderCollectionViewController.swift
//  Gasoline
//
//  Created by Wagner Sales on 22/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift
import MaterialComponents.MaterialCollections

class TinderCollectionViewController: MDCCollectionViewController {

    // MARK: - Instance Properties

    var viewModel: CollectionViewModel! {
        didSet {
            self.setups()
        }
    }
    private var notificationToken: NotificationToken?
    private var dataSource: Results<GASTinder> {
        return self.viewModel.dataSource
    }

    // MARK: - Life Cicle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Private Cicle

    private func setups() {
        self.setupViewModel()
        self.setupNotification()
        self.setupCollectionView()
    }

    private func setupViewModel() {
        self.viewModel.filtered = {
            self.collectionView.reloadData()
            self.setupNotification()
        }
    }

    private func setupNavigation() {
        self.title = self.viewModel.collection.title
    }

    private func setupNotification() {
        //        self.notificationToken = self.viewModel.dataSource.observe { [weak self] (changes: RealmCollectionChange) in
        //            guard let collection = self?.collectionView else { return }
        //            switch changes {
        //                case .initial: self?.showCollectionView()
        //                case .update(_, let deletions, let insertions, _):
        //                    collection.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
        //                    collection.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
        //                    self?.showCollectionView()
        //                    break
        //                case .error(let error): Log.e(error.localizedDescription)
        //            }
        //        }
    }

    private func setupCollectionView() {
        guard let collection = self.collectionView else {
            return
        }

        let cellNib = UINib(nibName: "PhotoCell", bundle: nil)
        collection.register(cellNib, forCellWithReuseIdentifier: TinderCollectionCell.ID)
        collection.backgroundColor = UIColor(white: 0.9, alpha: 1.0)

        self.styler.cellStyle = .card
        self.styler.cellLayoutType = .grid
        self.styler.gridPadding = 8
        self.styler.gridColumnCount = 2
        self.styler.cardBorderRadius = 10
    }

    private func showCollectionView() {
        // TODO: -
    }
}

// MARK: - UICollectionViewDataSource

extension TinderCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: TinderCollectionCell.ID, for: indexPath) as! TinderCollectionCell
        let tinder = self.dataSource[indexPath.row]
        let viewModel = SimpleTinderViewModel(tinderID: tinder.id)
        cell.setup(viewModel: viewModel)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TinderCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, cellHeightAt indexPath: IndexPath) -> CGFloat {
        return self.collectionView.frame.width / 2 * 1.5
    }
}

extension TinderCollectionViewController {
    //    static func instantiate() -> TinderCollectionViewController {
    //
    //        let storyboard = UIStoryboard(name: "TinderCollectionViewController", bundle: nil)
    //        let viewController = storyboard.instantiateInitialViewController() as! TinderCollectionViewController
    //        viewController.viewModel = CollectionViewModel()
    //
    //        return viewController
    //    }
}


class TinderCollectionCell: MDCCardCollectionCell {

    @IBOutlet weak var indicatorView: MDCActivityIndicator!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var disLikeButton: UIButton!

    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var hotLabel: UILabel!
    @IBOutlet weak var instagramLabel: UILabel!

    static let ID = "Cell"
    var viewModel: SimpleTinderViewModel!

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

import MaterialComponents.MaterialActivityIndicator

extension TinderCollectionCell {

    func setImage(_ photoID: String) {
        self.startAnimating()
        self.imageView.setPhoto(photoID: photoID, completion: {
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
