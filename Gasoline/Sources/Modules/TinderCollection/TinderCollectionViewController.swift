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

    private var token: NotificationToken?

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
        self.token = self.viewModel.dataSource.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
                case .initial: self?.collectionView.reloadData()
                case .update(_, let deletions, let insertions, let updates):

                    self?.collectionView.performBatchUpdates({
                        self?.collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                        self?.collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                        updates.forEach {
                            let indePath = IndexPath(row: $0, section: 0)
                            self?.updates(indexPath: indePath)
                        }
                    }, completion: { completed in
                        guard completed, self?.viewModel.dataSource.count == 0 else { return }
                        self?.startLoading()
                        self?.viewModel.load { [weak self] success in
                            self?.stopLoading(hasError: !success)
                        }
                    })

                case .error(let error): Log.i(error)
            }
        }
    }

    func updates(indexPath: IndexPath) {
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? TinderCollectionCell else { return }
        cell.viewModel.setupTinder()
        cell.setupTinder(updatePhoto: false)
    }

    override func setupUI() {
        super.setupUI()
        self.setupTitle(title: self.viewModel.title)
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

        collection.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }

    private func showCollectionView() {
        // TODO: - Implementar
    }
}

// MARK: - UICollectionViewDataSource

extension TinderCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TinderCollectionCell.ID, for: indexPath) as! TinderCollectionCell
        let tinder = self.viewModel.dataSource[indexPath.row]
        let viewModel = SimpleTinderViewModel(tinderID: tinder.id)
        cell.setup(viewModel: viewModel)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TinderCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let tinder = self.viewModel.dataSource[indexPath.row]
        let viewController = UIViewController.tinder(tinder: tinder)

        let cell = collectionView.cellForItem(at: indexPath)
        cell?.hero.id = tinder.id

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.hero.isEnabled = true

        self.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - Shake

extension TinderCollectionViewController {
    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.startLoading()
            self.viewModel.load { [weak self] success in
                self?.stopLoading(hasError: !success)
            }
        }
    }
}
