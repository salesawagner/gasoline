//
//  TinderViewController.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 5/25/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit
import RealmSwift

struct Cell {
	
	private static let perLine: CGFloat = 1
	private static let screenWidth: CGFloat = UIScreen.main.bounds.width - 1
	
	static let margin: CGFloat = 0
	
	static var width: CGFloat {
		let perLine = Cell.perLine
		let size = (Cell.screenWidth-(Cell.margin*(perLine+1)))
		return size / perLine
	}
	
	static var height: CGFloat {
		return Cell.width * 1.60
	}
}

class TinderViewController: GASViewController {

	// MARK: - Properties

	var viewModel: DetailTinderViewModel!

	// MARK: - IBOutlets

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var onlineLabel: UILabel!
	@IBOutlet weak var distanceLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var matchDateLabel: UILabel!
	@IBOutlet weak var matchLastDateLabel: UILabel!
	
	// Buttons
	@IBOutlet weak var disLikeView: UIView!
	@IBOutlet weak var disLikeButton: UIButton!

	@IBOutlet weak var superLikeView: UIView!
	@IBOutlet weak var superLikeButton: UIButton!

	@IBOutlet weak var likeView: UIView!
	@IBOutlet weak var likeButton: UIButton!

	// MARK: - Self Public Methods
	
	func openUrl(_ urlString: String) {
		guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
			return
		}
		UIApplication.shared.open(url, options: [:], completionHandler: nil)
	}

	@objc func moreButtonTapped() {

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
				let snapHooks = String(format: "snapchat://add/%@", self.viewModel.snapchat.isEmpty)
				self.openUrl(snapHooks)
			}))
		}

		let title = String(format: "Delete")
		sheet.addAction(UIAlertAction(title: title, style: .default, handler: { (alert: UIAlertAction!) -> Void in
			guard let viewModel = self.viewModel else { return }
			PersistenceManager.delete(tinderID: viewModel.tinderID)
			self.pop()
		}))

		sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
			(alert: UIAlertAction!) -> Void in
		}))
		
		self.present(sheet, animated: true, completion: nil)
	}

	// MARK: IBActions

	@IBAction func superLikeButtonTapped(_ sender: AnyObject) {
		self.viewModel.likeButtonTapped()
		self.pop()
	}

	@IBAction func disLikeButtonTapped(_ sender: AnyObject) {
		self.viewModel.disLikeButtonTapped()
		self.pop()
	}

	@IBAction func likeButtonTapped(_ sender: AnyObject) {
		self.viewModel.likeButtonTapped()
		self.pop()
	}

	// MARK: Setups

	private func setupViewModel() {
		self.viewModel.completion = {
			self.setupTinder()
		}
		self.viewModel.load()
	}

	private func prepareButton(_ view: UIView, button: UIButton, color: UIColor) {
		button.layer.cornerRadius = button.frame.width/2
		button.layer.borderWidth = 1
		button.layer.borderColor = LK.cardBorderColor.cgColor
		button.clipsToBounds = true

		let shadowLayer = CAShapeLayer()
		shadowLayer.path = UIBezierPath(roundedRect: button.frame, cornerRadius: button.frame.width/2).cgPath
		shadowLayer.fillColor = LK.cardBorderColor.cgColor

		shadowLayer.shadowColor = UIColor.black.cgColor
		shadowLayer.shadowOpacity = 0.25
		shadowLayer.shadowRadius = 2
		shadowLayer.shadowPath	= shadowLayer.path
		shadowLayer.shadowOffset = CGSize(width: 0, height: 0)

		view.layer.insertSublayer(shadowLayer, at: 0)
		view.clipsToBounds = true
		view.backgroundColor = UIColor.clear
	}

	private func setupButtons() {
		self.prepareButton(self.disLikeView, button: self.disLikeButton, color: LK.redColor)
		self.prepareButton(self.superLikeView, button: self.superLikeButton, color: LK.blueColor)
		self.prepareButton(self.likeView, button: self.likeButton, color: LK.greenColor)
	}

	private func setupTinder() {

		// name
		self.title = self.viewModel.name

		// ping time
		self.onlineLabel.textColor = UIColor.white
		self.onlineLabel.text = self.viewModel.online

		// distance
		self.distanceLabel.text = self.viewModel.distance

		// bio
		self.descriptionLabel.text = self.viewModel.bio

		// match date
		self.matchDateLabel.text = ""

		// match last activity
		self.matchLastDateLabel.text = ""

		// liked
		if self.viewModel.isLiked {
			self.likeButton.setImage(UIImage(named: "btn_liked_big"), for: UIControlState())
		} else {
			self.likeButton.setImage(UIImage(named: "btn_like_big"), for: UIControlState())
		}

		if !self.viewModel.canAction {
			self.disLikeView.isHidden = true
			self.superLikeView.isHidden = true
			self.likeView.isHidden = true
		}
		self.superLikeView.isHidden = true
	}

	// MARK: - Override Public Methods

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupViewModel()

		self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.disLikeView.frame.height, 0)

		self.setupButtons()
		self.setupTinder()
	}

	override func setupNavigation() {
		super.setupNavigation()

		// Image
		let image = #imageLiteral(resourceName: "btn_more")

		// Frame
		let width = image.size.width
		let height = image.size.height
		let frame = CGRect(x: 0, y: 0, width: width, height: height)

		// Button
		let button = UIButton(frame: frame)
		button.setImage(image, for: UIControlState())
		button.addTarget(self, action: #selector(self.moreButtonTapped), for: .touchUpInside)

		// Button Item
		let buttonItem = UIBarButtonItem(customView: button)
		self.navigationItem.rightBarButtonItem = buttonItem
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

extension TinderViewController {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: Cell.width, height: self.collectionView.frame.height)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		let margin = Cell.margin
		return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return Cell.margin
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return Cell.margin
	}
}
