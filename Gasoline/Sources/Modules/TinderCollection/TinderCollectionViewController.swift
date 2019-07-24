//
//  TinderCollectionViewController.swift
//  Gasoline
//
//  Created by Wagner Sales on 22/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift

class TinderCollectionViewController: GASViewController {

    // MARK: - IBOutlet Properties

    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private var notificationToken: NotificationToken?
    private var dataSource: Results<GASTinder> {
        return self.viewModel.dataSource
    }

    // MARK: - Internal Properties

    var viewModel: CollectionViewModel!

    // MARK: - Life Cicle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setups()
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

    override func setupUI() {
        super.setupUI()
        self.setupTitle(title: self.viewModel.collection.title)
    }

    override func setupNavigation() {
        super.setupNavigation()

        let refreshButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                target: self,
                                                action: #selector(self.didTapRefresh))
        let searchButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                               target: self,
                                               action: #selector(self.didTapFilter))

        self.navigationItem.leftBarButtonItem = refreshButtonItem
        self.navigationItem.rightBarButtonItem = searchButtonItem
    }

    @objc
    private func didTapRefresh() {
        self.startLoading()
        self.viewModel.load { [weak self] success in
            self?.stopLoading(hasError: !success)
        }
    }

    @objc
    private func didTapFilter() {
        let viewController = UIViewController.filter(colletionViewModel: self.viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }

    private func setupCollectionView() {
        guard let collection = self.collectionView else {
            return
        }

        // Cell
        let cellNib = UINib(nibName: TinderCollectionCell.ID, bundle: nil)

        // Setup
        collection.register(cellNib, forCellWithReuseIdentifier: TinderCollectionCell.ID)
        collection.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        collection.collectionViewLayout = UICollectionViewFlowLayout.cards
    }

    private func showCollectionView() {
        // TODO: -
    }
}

// MARK: - UICollectionViewDataSource

extension TinderCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TinderCollectionCell.ID, for: indexPath) as! TinderCollectionCell
        let tinder = self.dataSource[indexPath.row]
        let viewModel = SimpleTinderViewModel(tinderID: tinder.id)
        cell.setup(viewModel: viewModel)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TinderCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellHeightAt indexPath: IndexPath) -> CGFloat {
        return self.collectionView.frame.width / 2 * 1.5
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tinder = self.viewModel.dataSource[indexPath.row]

        let viewController = UIViewController.tinder(tinder: tinder)

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationCapturesStatusBarAppearance = true
        navigationController.modalPresentationStyle = .overFullScreen

        self.present(navigationController, animated: true, completion: nil)
    }
}
