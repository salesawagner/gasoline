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

        // Close button
        let closeImage = UIImage(named: "btn_back")
        let closeButton = UIButton(frame: frame)
        closeButton.setImage(closeImage, for: UIControl.State())
        closeButton.addTarget(self, action: #selector(self.didTapCloseButton), for: .touchUpInside)

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

        self.setupButton(self.likeButton)
        self.setupButton(self.dislikeButton)
        self.setupButton(self.superLikeButton)
    }

    // MARK: Private Methods

    private func setups() {
        self.setupScrollView()
        self.setupViewModel()
        self.setupTinder()
//        self.setupPanGesture()
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
        self.favoriteButton.isHidden = !self.viewModel.isFavorite
        self.hotButton.isHidden = !self.viewModel.isHot

        self.pageControl.numberOfPages = self.viewModel.photos.count
        self.collectionView.reloadData()
	}

    private func setupButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.size.width/2
        button.layer.masksToBounds = true
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

    private func openUrl(_ urlString: String) { // FIXME: Colocar em extension
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func openInstagram() { // FIXME: Colocar em extension
        let instagramHooks = String(format: "instagram://user?username=%@", self.viewModel.instagram)
        self.openUrl(instagramHooks)
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

        let sheet = UIAlertController(title: nil, message: "Escolha a opção", preferredStyle: .actionSheet)

        if !self.viewModel.instagram.isEmpty {
            let title = String(format: "Instagram")
            sheet.addAction(UIAlertAction(title: title, style: .default, handler: { (alert: UIAlertAction!) -> Void in
                let instagramHooks = String(format: "instagram://user?username=%@", self.viewModel.instagram)
                self.openUrl(instagramHooks)
            }))
        }

        if !self.viewModel.snapchat.isEmpty {
            let title = String(format: "snapchat")
            sheet.addAction(UIAlertAction(title: title, style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.openInstagram()
            }))
        }

        let title = String(format: "Delete")
        sheet.addAction(UIAlertAction(title: title, style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            guard let viewModel = self.viewModel else { return }
            PersistenceManager.delete(tinderID: viewModel.tinderID)
            self.pop()
        }))

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        }))

        self.present(sheet, animated: true, completion: nil)
    }

    // MARK: - Actions

    @IBAction func didTapFavoriteButton(_ sender: Any) {
        self.viewModel.favorite()
    }

    @IBAction func didTapInstagramButton(_ sender: Any) {
        self.openInstagram()
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
