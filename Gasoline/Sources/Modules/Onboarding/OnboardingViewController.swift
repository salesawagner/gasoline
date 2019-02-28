//
//  OnboardingViewController.swift
//  Gasoline
//
//  Created Wagner Sales on 11/10/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class OnboardingViewController: GASViewController {

	// MARK: - IBOutlets
	
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var actionButton: UIButton!
	
	// MARK: - Prorpeties

	lazy var viewModel: OnboardingViewModel = {
		return OnboardingViewModel(delegate: self)
	}()
	
	var pageViewController: UIPageViewController! {
		return self.viewModel.pageViewController
	}

	// MARK: - Override methods

	override func viewDidLoad() {
        super.viewDidLoad()
		self.viewModel.viewDidLoad()
		self.setups()
	}
	
	// MARK: - Private Methods

	private func setups() {
		self.setupUI()
	}
	
	override func setupUI() {
		self.view.backgroundColor = LK.redColor
		self.actionButton.backgroundColor = LK.facebook
	}
	
	// MARK: - IBAction
	
	@IBAction func actionButtonDidTouch(_ sender: Any) {
		self.viewModel.login(viewController: self)
	}
}

// MARK: - OnboardingDelegate

extension OnboardingViewController: OnboardingDelegate {

	func pageControllerDidLoad(numberOfPages: Int) {
		self.addChild(self.pageViewController)
		self.containerView.addSubview(self.pageViewController.view)
		self.pageViewController.view.frame = self.containerView.frame
		self.pageControl.numberOfPages = numberOfPages
		self.pageViewController.didMove(toParent: self)
	}

	func pageDidChange(index: Int, isLast: Bool) {
		self.pageControl.currentPage = index
	}
}
