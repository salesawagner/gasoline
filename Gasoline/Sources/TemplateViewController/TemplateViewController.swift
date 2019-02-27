//
//  TemplateViewController.swift
//  ViewTemplate
//
//  Created by Wagner Sales on 18/05/18.
//  Copyright © 2018 Youse. All rights reserved.
//

import UIKit

enum ViewControllerTemplate {
	case simple
	case simpleButton
	case twoButtons
}

protocol TemplateViewControllerDelegate {
	func didTapSecondaryButton()
	func didTapPrimaryButton()
}

class TemplateViewController: UIViewController {
	
	// MARK: - Static Properties
	
	static let nibName: String = "TemplateViewController"

	// MARK: - IBOutlet Properties
	
	@IBOutlet weak var headerView: UIView?
	@IBOutlet weak var contentView: UIView?
	
	@IBOutlet weak var imageView: UIImageView?
	
	@IBOutlet weak var titleLabel: UILabel?
	@IBOutlet weak var descriptionLabel: UILabel?

	@IBOutlet weak var buttonView: UIView?
	@IBOutlet weak var primaryButton: UIButton?
	@IBOutlet weak var secondaryButton: UIButton?
	
	// MARK: - Instance Properties
	
	private var template: ViewControllerTemplate!
	var delegate: TemplateViewControllerDelegate? = nil
	
	var image: UIImage? = nil {
		didSet {
			guard let imageView = self.imageView else {
				return
			}
			imageView.image = image
		}
	}

	var titleText: String? = nil {
		didSet {
			guard let titleLabel = self.titleLabel else {
				return
			}
			titleLabel.text = self.titleText
		}
	}

	var descriptionText: String? = nil {
		didSet {
			guard let descriptionLabel = self.descriptionLabel else {
				return
			}
			descriptionLabel.text = self.descriptionText
		}
	}

	var primaryButtonText: String = "" {
		didSet {
			guard let button = self.primaryButton else {
				return
			}
			self.setButtonTitle(withText: self.primaryButtonText, button: button)
		}
	}

	var secondaryButtonText: String = "" {
		didSet {
			guard let button = self.secondaryButton else {
				return
			}
			self.setButtonTitle(withText: self.secondaryButtonText, button: button)
		}
	}
	
	// MARK: - Constructors

	required init(template: ViewControllerTemplate = .simple) {
		super.init(nibName: TemplateViewController.nibName, bundle: nil)
		self.template = template
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Override Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setups()
	}
	
	// MARK: - Private Methods
	
	private func setups() {
		self.setupTemplate()
		self.setupColors()
		self.loadData()
	}
	
	private func setupTemplate() {
		switch self.template {
		case .simple?:
			self.setupTemplateSimple()
		case .simpleButton?:
			self.setupTemplateSimpleButton()
		case .twoButtons?:
			self.setupTemplateTwoButtons()
		default:
			self.setupTemplateSimple()
			break
		}
		
		self.setupColors()
	}

	private func setupTemplateSimple() {
		self.buttonView?.isHidden = true
	}
	
	private func setupTemplateSimpleButton() {
		self.buttonView?.isHidden = false
		self.secondaryButton?.isHidden = true
	}
	
	private func setupTemplateTwoButtons() {
		self.buttonView?.isHidden = false
		self.secondaryButton?.isHidden = false
		self.primaryButton?.isHidden = false
	}
	
	private func setButtonTitle(withText text: String, button: UIButton) {
		defer {
			button.setTitle(text, for: .normal)
		}
		
		guard let label = button.titleLabel else {
			return
		}
		
		label.text = text
	}
	
	private func loadData() {
		
		if let imageView = self.imageView {
			imageView.image = self.image
		}
		
		if let titleLabel = self.titleLabel {
			titleLabel.text = self.titleText
		}
		
		if let descriptionLabel = self.descriptionLabel {
			descriptionLabel.text = self.descriptionText
		}
		
		if let primaryButton = self.primaryButton {
			self.setButtonTitle(withText: self.primaryButtonText, button: primaryButton)
		}
		
		if let secondaryButton = self.secondaryButton {
			self.setButtonTitle(withText: self.secondaryButtonText, button: secondaryButton)
		}
	}

	// MARK: - IBAction private Methods
	
	@IBAction private func didTapSecondaryButton(_ sender: Any) {
		guard let delegate = self.delegate else {
			return
		}
		delegate.didTapSecondaryButton()
	}
	
	@IBAction private func didTapPrimaryButton(_ sender: Any) {
		guard let delegate = self.delegate else {
			return
		}
		delegate.didTapPrimaryButton()
	}
	
	// MARK: - Instance Public Methods

	func setupColors() {
		self.titleLabel?.textColor = UIColor.white
		self.descriptionLabel?.textColor = UIColor.white
	}
	
	func setImage(withImage image: UIImage) {
		self.image = image
	}

	func setTitle(withText text: String) {
		self.titleText = text
	}

	func setDescription(withText text: String) {
		self.descriptionText = text
	}

	func setSecondaryButtonTitle(withText text: String) {
		self.secondaryButtonText = text
	}

	func setPrimaryButtonTitle(withText text: String) {
		self.primaryButtonText = text
	}
}
