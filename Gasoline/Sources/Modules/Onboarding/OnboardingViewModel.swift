//
//  OnboardingViewModel.swift
//  Gasoline
//
//  Created Wagner Sales on 11/10/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol OnboardingDelegate {
	func pageControllerDidLoad(numberOfPages: Int)
	func pageDidChange(index: Int, isLast: Bool)
}

class OnboardingViewModel: NSObject {

	// MARK: - Properties
	
	var delegate: OnboardingDelegate!
	var pageViewController: UIPageViewController!
	lazy var dataSource: [TemplateData] = {
		return [
			TemplateData(title: "Hello,", information: "I'm the App Gasoline... With me, you can discover who liked you on tinder!!! Amazing, right?", image: #imageLiteral(resourceName: "AppName")),
			TemplateData(title: "Liked Me", information: "See the people who likes you, and like them back for an instant match.", image: #imageLiteral(resourceName: "LikeMe")),
			TemplateData(title: "", information: "By the way... You can see everyone, who you liked and your matches.", image: #imageLiteral(resourceName: "Tabbar"))
		]
	}()
	var currentPage: TemplateDataViewController? {
		get {
			guard let viewControllers = self.pageViewController.viewControllers, let currentPage = viewControllers.first else {
				return nil
			}
			return currentPage as? TemplateDataViewController
		}
	}
	var nextPage: TemplateDataViewController? {
		get {
			guard let currentPage = self.currentPage, let index = self.getIndex(withViewController: currentPage) else {
				return nil
			}
			return self.getViewController(withIndex: index + 1) as? TemplateDataViewController
		}
	}
	
	init(delegate: OnboardingDelegate) {
		super.init()
		self.delegate = delegate
	}
	
	// MARK: - Public Methods
	
	func viewDidLoad() {
		self.setupPagecontroller()
	}
	
	func goToNextPage() {
		guard let nextPage = self.nextPage else {
			return
		}
		self.moveToPage(withDataViewController: nextPage)
	}
	
	func login(viewController: UIViewController) {
		AuthManager.login(viewController) { success in
			guard success else {
				viewController.showError()
				return
			}
			UIViewController.goToMain()
		}
	}
	
	// MARK: - Private Methods

	private func setupPagecontroller() {

		guard let dataViewController = self.getViewController(withIndex: 0) as? TemplateDataViewController else {
			return
		}
		
		self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
		self.pageViewController.delegate = self
		self.pageViewController.dataSource = self

		self.pageViewController.setViewControllers([dataViewController], direction: .forward, animated: false)
		self.delegate.pageControllerDidLoad(numberOfPages: self.dataSource.count)
	}
	
	private func moveToPage(withDataViewController dataViewController: TemplateDataViewController) {
		self.pageViewController.setViewControllers([dataViewController], direction: .forward, animated: true) { [weak self]  _ in
			self?.pageDidChange()
		}
	}
	
	fileprivate func pageDidChange() {
		
		guard let currentPage = self.currentPage, let index = self.getIndex(withViewController: currentPage) else {
			return
		}

		let isLast = index == self.dataSource.count - 1
		self.delegate.pageDidChange(index: index, isLast: isLast)
	}
	
	// MARK: - File private Methods
	
	fileprivate func getIndex(withViewController viewController: UIViewController) -> Int? {
		
		guard
			let dataViewController = viewController as? TemplateDataViewController,
			let data = dataViewController.data,
			let index = self.dataSource.index(of: data) else {
				return nil
		}
		
		return index
	}
	
	fileprivate func getViewController(withData data: TemplateData) -> UIViewController {
		return self.getDataViewController(withData: data)
	}
	
	fileprivate func getViewController(withIndex index: Int) -> UIViewController? {
		guard (0...self.dataSource.count-1).contains(index) else {
			return nil
		}
		return self.getViewController(withData: self.dataSource[index])
	}
	
	func getDataViewController(withData data: TemplateData) -> UIViewController {
		let viewController = TemplateDataViewController(withData: data)
		return viewController
	}
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewModel: UIPageViewControllerDelegate {
	
	func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
		self.pageDidChange()
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		self.pageDidChange()
	}
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewModel: UIPageViewControllerDataSource {
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		guard var index = self.getIndex(withViewController: viewController) else {
			return nil
		}
		
		index -= 1
		let viewController = self.getViewController(withIndex: index)
		return viewController
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		guard var index = self.getIndex(withViewController: viewController) else {
			return nil
		}
		
		index += 1
		let viewController = self.getViewController(withIndex: index)
		return viewController
	}
}
