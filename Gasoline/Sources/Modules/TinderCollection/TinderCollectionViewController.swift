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
        self.setupNavigation()
        self.setupCollectionView()
    }

    private func setupViewModel() {
        self.viewModel.filtered = {
            self.collectionView.reloadData()
            self.setupNotification()
        }
    }

    private func setupNotification() {
        self.notificationToken = self.viewModel.dataSource.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collection = self?.collectionView else { return }
            switch changes {
            case .initial: self?.showCollectionView()
            case .update(_, let deletions, let insertions, _):
                collection.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                collection.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                self?.showCollectionView()
                break
            case .error(let error): Log.e(error.localizedDescription)
            }
        }
    }

    private func setupNavigation() {
        self.setupNavigationBar()
        self.title = self.viewModel.collection.title
    }

    private func setupCollectionView() {
        guard let collection = self.collectionView else {
            return
        }

        let cellNib = UINib(nibName: TinderCollectionCell.ID, bundle: nil)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TinderCollectionCell.ID, for: indexPath) as! TinderCollectionCell
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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tinder = self.viewModel.dataSource[indexPath.row]

        let viewController = UIViewController.tinder(tinder: tinder)
        viewController.isPullToDismissEnabled = true

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationCapturesStatusBarAppearance = true
        navigationController.modalPresentationStyle = .overFullScreen

        self.present(navigationController, animated: true, completion: nil)
    }
}
