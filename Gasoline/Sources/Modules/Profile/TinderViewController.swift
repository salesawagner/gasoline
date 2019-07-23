//
//  TinderViewController.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 5/25/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift
import CHIPageControl
import PullToDismissTransition
import SCLAlertView
import WASKit

class TinderViewController: GASViewController {

	// MARK: - Properties

	var viewModel: DetailTinderViewModel!

	// MARK: - IBOutlets

    @IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: CHIPageControlJaloro!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var superLikeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!

    @IBOutlet weak var tagEffectView: UIVisualEffectView!
    @IBOutlet weak var hotButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var snapButton: UIButton!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    // MARK: - Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setups()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupPullToDismiss()
        self.pullToDismissTransition.monitorActiveScrollView(scrollView: self.scrollView)
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        self.setupPullToDismiss()
    }

    override func setupNavigation() {
        super.setupNavigation()

        guard let nav = self.navigationController else {
            return
        }

        // Navigation
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.barTintColor = .clear

        // Frame
        let width = 30
        let height = 30
        let frame = CGRect(x: 0, y: 0, width: width, height: height)

        // More button
        let moreImage = UIImage(named: "btn_more")
        let moreButton = UIButton(frame: frame)
        moreButton.setImage(moreImage, for: UIControl.State())
        moreButton.addTarget(self, action: #selector(self.didTapMoreButton), for: .touchUpInside)
        moreButton.setShadow()

        // Close button
        let closeImage = UIImage(named: "btn_back")
        let closeButton = UIButton(frame: frame)
        closeButton.setImage(closeImage, for: UIControl.State())
        closeButton.addTarget(self, action: #selector(self.didTapCloseButton), for: .touchUpInside)
        closeButton.setShadow()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }

    override func setupUI() {
        super.setupUI()

        self.tagEffectView.layer.cornerRadius = 10
        self.tagEffectView.layer.masksToBounds = true

        self.pageControl.backgroundColor = .clear
        self.pageControl.tintColor = .lightGray
        self.pageControl.currentPageTintColor = .lightGray
        self.pageControl.padding = 3
        self.pageControl.elementHeight = 10
        self.pageControl.elementHeight = 3
        self.pageControl.radius = self.pageControl.elementHeight / 2
        self.pageControl.clipsToBounds = true

        self.likeButton.setCircle()
        self.dislikeButton.setCircle()
        self.superLikeButton.setCircle()
    }

    // MARK: Private Methods

    private func setups() {
        self.setupScrollView()
        self.setupViewModel()
        self.setupTinder()
        self.setupTapGesture()

        self.becomeFirstResponder()
    }

	private func setupViewModel() {
		self.viewModel.completion = {
			self.setupTinder()
		}
		self.viewModel.load()
	}

    private func setupScrollView() {
        self.scrollView.contentInsetAdjustmentBehavior = .never
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 0)
    }

    private func setupTinder() {
        self.nameLabel.text = self.viewModel.name
        self.descriptionLabel.text = self.viewModel.bio

        self.instagramButton.isHidden = self.viewModel.instagram.isEmpty
        self.snapButton.isHidden = self.viewModel.snapchat.isEmpty
        self.hotButton.isHidden = !self.viewModel.isHot

        self.setIsFavorite(!self.viewModel.isFavorite)
        self.setIsLiked(self.viewModel.isLiked)
        self.setIsSuperLiked(self.viewModel.isSuperLiked)
        self.setIsMatch(self.viewModel.isMatch)
        self.setIsHot(self.viewModel.isHot)

        self.pageControl.numberOfPages = self.viewModel.photos.count
        self.collectionView.reloadData()
	}

    private func setupPanGesture() {
        self.setupPullToDismiss()
        self.pullToDismissTransition.monitorActiveScrollView(scrollView: scrollView)
    }

    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapCollectionView(_:)))
        self.collectionView.addGestureRecognizer(tap)
    }

    private func scrollNext() {
        let cellSize = CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        let contentOffset = self.collectionView.contentOffset
        let rect = CGRect(x: contentOffset.x + cellSize.width,
                          y: contentOffset.y,
                          width: cellSize.width,
                          height: cellSize.height)

        self.collectionView.scrollRectToVisible(rect, animated: true)
    }

    private func close() {
        self.isPullToDismissEnabled = false
        self.dismiss()
    }

    // MARK: Internal Methods

    @objc
    func didTapCollectionView(_ sender: UITapGestureRecognizer? = nil) {
        guard let tap = sender?.location(in: self.view) else { return }

        let cellSize = CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        let contentOffset = self.collectionView.contentOffset

        var contentOffsetX:CGFloat = 0
        if tap.x < (self.view.frame.width / 2) {
            contentOffsetX = contentOffset.x - cellSize.width
        } else {
            contentOffsetX = contentOffset.x + cellSize.width
        }

        let rect = CGRect(x: contentOffsetX,
                          y: contentOffset.y,
                          width: cellSize.width,
                          height: cellSize.height)

        self.collectionView.scrollRectToVisible(rect, animated: true)
    }

    @objc
    func didTapCloseButton() {
        self.close()
    }

    @objc
    func didTapMoreButton() {

        let alert = SCLAlertView()
        alert.addButton("Sim") { [weak self] in
            PersistenceManager.delete(tinderID: self?.viewModel.tinderID ?? "")
            self?.close()
        }

        alert.showTitle("Cuidado",
                        subTitle: "Você deseja remover esse usuário?",
                        timeout: nil,
                        completeText: "Cancelar",
                        style: .warning,
                        colorStyle: UInt(LK.redColor.WAStoUInt),
                        animationStyle: .bottomToTop)
    }

    // MARK: - Actions

    @IBAction func didTapFavoriteButton(_ sender: Any) {
        self.viewModel.favorite()
    }

    @IBAction func didTapInstagramButton(_ sender: Any) {
        URL.openInstagram(self.viewModel.instagram)
    }

    @IBAction func didTapSnapButton(_ sender: Any) {
        URL.openSnap(self.viewModel.snapchat)
    }

    @IBAction func didTapLikeButton(_ sender: Any) {
        self.viewModel.likeButtonTapped()
        self.close()
    }

    @IBAction func didTapDislikeButton(_ sender: Any) {
        self.viewModel.disLikeButtonTapped()
        self.close()
    }

    @IBAction func didTapSuperlikeButton(_ sender: Any) {
        self.viewModel.superLikeButtonTapped()
        self.close()
    }

    // MARK: - PullToDismissable Prorpeties

    private(set) lazy var pullToDismissTransition = PullToDismissTransition(viewController: self)
}

// MARK: - Shake

extension TinderViewController {
    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.viewModel.favorite()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TinderViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.viewModel.photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let id: String = PhotoCollectionViewCell.identifier
		let collection: UICollectionView = collectionView
		let cell: UICollectionViewCell = collection.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)

		guard let photoCell = cell as? PhotoCollectionViewCell else {
			return UICollectionViewCell()
		}

		let photo = self.viewModel.photos[indexPath.row]
		let viewModel = PhotoViewModel(photoID: photo.id)
		photoCell.setup(viewModel: viewModel)

		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TinderViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
	}

	func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin: CGFloat = 0
		return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
	}

	func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}

	func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}

// MARK: - UICollectionViewDelegate

extension TinderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        self.pageControl.set(progress: indexPath.row, animated: true)
    }
}

// MARK: - PullToDismissable

extension TinderViewController: PullToDismissable { }

// MARK: - UIViewControllerTransitioningDelegate

extension TinderViewController: UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard isPullToDismissEnabled else { return nil }
        return pullToDismissTransition
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard isPullToDismissEnabled else { return nil }
        return pullToDismissTransition
    }
}

extension TinderViewController {

    func setIsFavorite(_ isFavorite: Bool) {
        self.favoriteButton.isHidden = !isFavorite
    }

    func setIsHot(_ isHot: Bool) {
        self.hotButton.isHidden = !isHot
    }

    func setIsLiked(_ isLiked: Bool) {
        let imageName = isLiked ? "btn_liked_big" : "btn_like_big"
        let image = UIImage(named: imageName)
        self.likeButton.setImage(image, for: .normal)
    }

    func setIsSuperLiked(_ isLiked: Bool) {
        let imageName = isLiked ? "btn_superliked_big" : "btn_superlike_big"
        let image = UIImage(named: imageName)
        self.superLikeButton.setImage(image, for: .normal)
    }

    func setIsMatch(_ isMatch: Bool) {
        self.likeButton.isEnabled = !isMatch
        self.superLikeButton.isEnabled = !isMatch
    }
}
