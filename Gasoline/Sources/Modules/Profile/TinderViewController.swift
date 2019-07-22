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

class TinderViewController: GASViewController {

	// MARK: - Properties

	var viewModel: DetailTinderViewModel!

	// MARK: - IBOutlets

//    @IBOutlet weak var scrollView: UIScrollView!
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

    func setupButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.size.width/2
        button.layer.masksToBounds = true
    }

	// MARK: Private Methods

    private func setups() {
        self.setupViewModel()
        self.setupTinder()
        self.becomeFirstResponder()

        self.collectionView.contentInsetAdjustmentBehavior = .never
    }

	private func setupViewModel() {
		self.viewModel.completion = {
			self.setupTinder()
		}
		self.viewModel.load()
	}

    private func setupTinder() {
		self.title = self.viewModel.name
        self.nameLabel.text = self.viewModel.name
        self.descriptionLabel.text = self.viewModel.bio

        self.instagramButton.isHidden = self.viewModel.instagram.isEmpty
        self.favoriteButton.isHidden = !self.viewModel.isFavorite
        self.hotButton.isHidden = !self.viewModel.isHot

        self.pageControl.numberOfPages = self.viewModel.photos.count
        self.collectionView.reloadData()
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

    // MARK: Internal Methods

    @objc
    func didTapCloseButton() {
        self.dismiss()
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
        sheet.addAction(UIAlertAction(title: title, style: .default, handler: { (alert: UIAlertAction!) -> Void in
            guard let viewModel = self.viewModel else { return }
            PersistenceManager.delete(tinderID: viewModel.tinderID)
            self.pop()
        }))

        sheet.addAction(UIAlertAction(title: "Close", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.dismiss()
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
        self.dismiss()
    }

    @IBAction func didTapDislikeButton(_ sender: Any) {
        self.viewModel.disLikeButtonTapped()
        self.dismiss()
    }

    @IBAction func didTapSuperlikeButton(_ sender: Any) {
        self.viewModel.superLikeButtonTapped()
        self.dismiss()
    }
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

extension TinderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.set(progress: indexPath.row, animated: true)
    }
}
