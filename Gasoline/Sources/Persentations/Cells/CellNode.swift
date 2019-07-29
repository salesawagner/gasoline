//
//  CellNode.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 24/04/17.
//  Copyright © 2017 Wagner Sales. All rights reserved.
//

import UIKit
import AsyncDisplayKit

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

let kMargin: CGFloat = 5
let kButtonsHeight: CGFloat = 40
let kColor: UIColor = UIColor.clear
let kNodePerLine: CGFloat = 2

let kScreenWhidth: CGFloat = UIScreen.main.bounds.width-1
let kNodeWidth: CGFloat	= (kScreenWhidth-(kMargin*(kNodePerLine+1)))/kNodePerLine
let kNodeHeight: CGFloat = kNodeWidth * 1.60

// FIXME:
class CellNode: ASCellNode {

	let viewModel: SimpleTinderViewModel
	let backgroundImage: ASImageNode
	let imageNode: ASNetworkImageNode
	let distanceNode: AttributedTextNode
	let disLikeButtonNode: ASButtonNode
	let nameNode: AttributedTextNode
	var buttonsNode: ASDisplayNode?
	var likeButtonNode: ASButtonNode?
	var superLikeButtonNode: ASButtonNode?
	var photoIndex: Int = 0

	required init(viewModel: SimpleTinderViewModel) {

		self.viewModel = viewModel
		self.backgroundImage = ASImageNode()
		self.imageNode = ASNetworkImageNode()
		self.distanceNode = AttributedTextNode()
		self.nameNode = AttributedTextNode()
		self.disLikeButtonNode = ASButtonNode()

		super.init()
		self.setups()
	}
	
	override func didLoad() {
		super.didLoad()
		self.setupTap()
	}

	private func setups() {
		self.setupView()
		self.setupBackground()
		self.setupView()
		self.setupImage()
		self.setupDisLikeButton()
		self.setupButtons()
		self.setupName()
	}

	private func setupBackground() {
		let image = #imageLiteral(resourceName: "Card")
		self.backgroundImage.image = image
		self.backgroundImage.contentMode = .scaleToFill
		self.addSubnode(self.backgroundImage)
	}

	private func setupView() {
		self.cornerRadius = 5.0
		self.clipsToBounds = true
		self.backgroundColor = kColor
	}

	func setupTap() {
		let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeGesture))
		rightSwipe.direction = .right
		self.view.addGestureRecognizer(rightSwipe)
		
		let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeGesture))
		leftSwipe.direction = .left
		self.view.addGestureRecognizer(leftSwipe)

//		self.imageNode.addTarget(self, action: #selector(tapGesture), forControlEvents: .touchUpInside)
	}
	
	@objc func rightSwipeGesture(sender: UISwipeGestureRecognizer) {
		self.viewModel.likeButtonTapped()
	}
	
	@objc func leftSwipeGesture(sender: UISwipeGestureRecognizer) {
		self.viewModel.disLikeButtonTapped()
	}

	@objc func tapGesture(sender: UISwipeGestureRecognizer) {
//        let newIndex = self.photoIndex + 1
//        self.photoIndex = newIndex < self.viewModel.photosURL.count ? newIndex : 0
//        let photoURL = self.viewModel.photosURL[self.photoIndex]
//
//        if let id = photoURL["id"], let urlString = photoURL["url"] {
//            self.setPhoto(id: id, urlString: urlString)
//        }
	}

	// FIXME: photo id location
	var photoID: String?

	private func setupImage() {

		self.addSubnode(self.imageNode)
		self.imageNode.backgroundColor = LK.cardBorderColor
		self.imageNode.contentMode = .scaleAspectFill
		self.imageNode.placeholderFadeDuration = 0.15
		self.imageNode.shouldRenderProgressImages = true
		self.imageNode.shouldCacheImage = true
		self.imageNode.defaultImage = #imageLiteral(resourceName: "card_smille")
		self.imageNode.delegate = self

		if let url = URL(string: self.viewModel.photoUrl) {
			self.photoID = self.viewModel.photoID
			self.imageNode.url = url
		}
	}

	private func setPhoto(id: String, urlString: String) {
		if let url = URL(string: urlString) {
			self.photoID = id
			self.imageNode.url = url
		}
	}

    private func setupDisLikeButton() {
		let image = #imageLiteral(resourceName: "btn_close")
		self.disLikeButtonNode.setImage(image, for: .normal)
		let selector = #selector(viewModel.disLikeButtonTapped)
		self.disLikeButtonNode.addTarget(self.viewModel, action: selector, forControlEvents: .touchUpInside)
		self.addSubnode(self.disLikeButtonNode)
	}

	private func setupButtons() {
		let buttonsNode = ASDisplayNode()
		self.buttonsNode = buttonsNode
		self.addSubnode(buttonsNode)
		self.setupLikeButton()
		self.setupSuperLikeButton()
	}

	private func setupName() {
		let text = viewModel.name
		self.nameNode.configure(text, size: 18)
		self.nameNode.backgroundColor = kColor
		self.addSubnode(self.nameNode)
	}

	private func setupLikeButton() {

		let imageName = (self.viewModel.isLiked || self.viewModel.isMatch) ? "btn_liked" : "btn_like"
		let image = UIImage(named: imageName)

		let likeButtonNode = ASButtonNode()
		likeButtonNode.setImage(image, for: .normal)

		let selector = #selector(viewModel.likeButtonTapped)
		likeButtonNode.addTarget(viewModel, action: selector, forControlEvents: .touchUpInside)

		self.likeButtonNode = likeButtonNode
		self.addSubnode(likeButtonNode)
	}

	private func setupSuperLikeButton() {

		let image = #imageLiteral(resourceName: "btn_superlike")
		let superLikeButtonNode = ASButtonNode()
		superLikeButtonNode.setImage(image, for: .normal)
		let selector = #selector(viewModel.superLikeButtonTapped)
		superLikeButtonNode.addTarget(self.viewModel, action: selector, forControlEvents: .touchUpInside)
		self.superLikeButtonNode = superLikeButtonNode
		self.addSubnode(superLikeButtonNode)
	}

	private func likeButtonSpec(_ constrainedSize: ASSizeRange) {
		guard
			let buttonNode = self.likeButtonNode else {
			return
		}

		// Content
		let contentWidthSize = constrainedSize.max
		let likeContentWidth = contentWidthSize.width / 2

		// Image
		let imageY = contentWidthSize.height - kButtonsHeight
		let likeButtonCenterX = likeContentWidth

		buttonNode.style.preferredSize = CGSize(width: likeContentWidth, height: kButtonsHeight)
		buttonNode.style.layoutPosition = CGPoint(x: likeButtonCenterX, y: imageY)
	}

	private func superLikeButtonSpec(_ constrainedSize: ASSizeRange) {
		guard
			let buttonNode = self.superLikeButtonNode else {
				return
		}

		// Content
		let contentWidthSize = constrainedSize.max
		let likeContentWidth = contentWidthSize.width / 2

		// Image
		let imageY = contentWidthSize.height - kButtonsHeight

		buttonNode.style.preferredSize = CGSize(width: likeContentWidth, height: kButtonsHeight)
		buttonNode.style.layoutPosition = CGPoint(x: 0, y: imageY)
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

		var children = [ASLayoutElement]()
		let size = constrainedSize.max

		// Image
		self.imageNode.style.layoutPosition = CGPoint(x: 0, y: 0)
		children.append(self.imageNode)

		// Buttons
		var nameY: CGFloat = 0
		let nameHeight: CGFloat = 22
		if let buttonsNode = self.buttonsNode,
			let likeButtonNode = self.likeButtonNode,
			let superLikeButtonNode = self.superLikeButtonNode {

			// Photo image
			self.imageNode.style.preferredSize = CGSize(width: size.width, height: size.height-kButtonsHeight)

			// Buttons View
			let buttonsY = size.height - kButtonsHeight
			buttonsNode.style.preferredSize = CGSize(width: size.width, height: kButtonsHeight)
			buttonsNode.style.layoutPosition = CGPoint(x: 0, y: buttonsY)
			children.append(buttonsNode)

			// Like Button
			self.likeButtonSpec(constrainedSize)
			children.append(likeButtonNode)

			// SuperLike Button
			self.superLikeButtonSpec(constrainedSize)
			children.append(superLikeButtonNode)

			// Name
			nameY = buttonsY - nameHeight
		} else {
			nameY = size.height - nameHeight
			self.imageNode.style.preferredSize = CGSize(width: size.width, height: size.height)
		}

		// Name
		self.nameNode.style.preferredSize = CGSize(width: size.width-(2*kMargin), height: nameHeight)
		self.nameNode.style.layoutPosition = CGPoint(x: kMargin, y: nameY-kMargin)
		children.append(self.nameNode)

		// Distance
		self.distanceNode.style.preferredSize = CGSize(width: size.width-(2*kMargin), height: nameHeight)
		self.distanceNode.style.layoutPosition = CGPoint(x: kMargin, y: kMargin)
		children.append(self.distanceNode)

		// DislikeButton
		let btnSize = #imageLiteral(resourceName: "btn_close").size
		let disLikeButtonX = size.width - btnSize.width - kMargin
		self.disLikeButtonNode.style.preferredSize = CGSize(width: btnSize.width, height: btnSize.height)
		self.disLikeButtonNode.style.layoutPosition = CGPoint(x: disLikeButtonX, y: kMargin)
		children.append(self.disLikeButtonNode)

		// BackgroundImage
		self.backgroundImage.style.preferredSize = CGSize(width: size.width, height: size.height)
		self.backgroundImage.style.layoutPosition = CGPoint(x: 0, y: 0)
		children.append(self.backgroundImage)

		return ASAbsoluteLayoutSpec(children: children)
	}
}

extension CellNode: ASNetworkImageNodeDelegate {
	func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
		guard let photoID = self.photoID else { return }
		GASPhoto.nsfw(photoID: photoID, image: image)
	}
}
