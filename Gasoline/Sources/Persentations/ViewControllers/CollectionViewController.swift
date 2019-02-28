//
//  ViewController.swift
//  ASCollectionTeste
//
//  Created by Wagner Sales on 8/28/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

class CollectionViewController: GASViewController {
	
	// MARK: - Properties
	
	let viewModel: CollectionViewModel!
	var collectionView: ASCollectionNode!
	let notFound = MTPNotFound.create()
	private var notificationToken: NotificationToken?

	// MARK: - Constructors

	init(viewModel: CollectionViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		self.viewModel = CollectionViewModel()
		super.init(coder: aDecoder)
	}
	
	// MARK: - Override Public Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = self.viewModel.collection.title
	}
	
	override func setupUI() {
		self.setupCollectionView()
		self.setupNotification()
		self.setupNotFound()
	}
	
	override func setupNavigation() {
		super.setupNavigation()

		guard self.viewModel.collection.canReload else {
			return
		}

		let width = #imageLiteral(resourceName: "icn_load").size.width
		let height = #imageLiteral(resourceName: "icn_load").size.height
		let frame = CGRect(x: 0, y: 0, width: width, height: height)

		let reloadButton = UIButton(frame: frame)
		reloadButton.setImage(#imageLiteral(resourceName: "icn_load"), for: UIControl.State())
		reloadButton.addTarget(self, action: #selector(self.didTapReload), for: .touchUpInside)

		let reloadButtonItem = UIBarButtonItem(customView: reloadButton)
		self.navigationItem.rightBarButtonItem = reloadButtonItem

		self.title = self.viewModel.title
	}
	
	deinit {
		self.notificationToken?.invalidate()
	}

	// MARK: - Private Methods

	private func setupCollectionView() {

		// FlowLayout
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = kMargin
		layout.minimumLineSpacing = kMargin
		layout.itemSize	= CGSize(width: kNodeWidth, height: kNodeHeight)
		layout.sectionInset = UIEdgeInsets(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)

		// Collection view
		let collectionView = ASCollectionNode(collectionViewLayout: layout)
		collectionView.backgroundColor = LK.backgroundColor
		self.collectionView = collectionView

		// Self Collection
		let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
		let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
		let statusBarHeight = UIApplication.shared.statusBarFrame.height
		let width = self.view.frame.size.width
		let height = self.view.frame.height - tabBarHeight - navigationBarHeight - statusBarHeight
		self.collectionView.frame = CGRect(x: 0, y: 0, width: width, height: height)
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		self.view.addSubnode(self.collectionView)
	}

	private func setupNotification() {
		let tinders = self.viewModel.tinders
		self.notificationToken = tinders.observe { [weak self] (changes: RealmCollectionChange) in
			guard let collection = self?.collectionView else { return }
			switch changes {
				case .initial:
					collection.reloadData(completion: {
						self?.showCollectionView()
					})
					break
				case .update(_, let deletions, let insertions, let modifications):
					collection.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
					collection.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
					collection.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
					self?.showCollectionView()
					break
				case .error(let error):
					Log.e(error.localizedDescription)
					break
			}
		}
	}
	
	private func setupNotFound() {
		self.notFound.frame = self.view.frame
		self.notFound.information = "Sorry... I can not found anyone."
		self.notFound.alpha = 0
		self.view.addSubview(self.notFound)
	}
	
	private func showCollectionView() {
		UIView.animate(withDuration: 0.25, animations: {
			self.collectionView.alpha = (self.viewModel.tinders.count > 0 ? 1 : 0)
			self.notFound.alpha = (self.viewModel.tinders.count <= 0 ? 1 : 0)
		})
	}
	
	private func goToTinder(tinder: GASTinder) {
		let viewController = UIViewController.tinder(tinder: tinder)
		self.navigationController?.pushViewController(viewController, animated: true)
	}

	@objc private func didTapReload() {
		self.startLoading()
		self.viewModel.forceLoad { [weak self] success in
			self?.stopLoading(hasError: !success)
		}
	}
}

// MARK: - ASCollectionDataSource

extension CollectionViewController: ASCollectionDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModel.tinders.count
	}

	func collectionNode(_ collectionNode: ASCollectionNode, 
	                    nodeBlockForItemAt indexPath: IndexPath) -> AsyncDisplayKit.ASCellNodeBlock {

		let tinder = self.viewModel.tinders[indexPath.row]
		let tinderID = tinder.id

		return {
			let viewModel = SimpleTinderViewModel(tinderID: tinderID)
			let cell = CellNode(viewModel: viewModel)
			return cell
		}
	}
}

// MARK: - ASCollectionDelegate

extension CollectionViewController: ASCollectionDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let tinder = self.viewModel.tinders[indexPath.row]
		self.goToTinder(tinder: tinder)
	}
}
