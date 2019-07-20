//
//  FilterTableViewController.swift
//  Gasoline
//
//  Created by Wagner Sales on 07/06/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit

class FilterItem {

	let title: String
	let filter: String
	var isOn: Bool = false

	init(title: String, filter: String, isOn: Bool = false) {
		self.title = title
		self.filter = filter
		self.isOn = isOn
	}

}

class FilterTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var filterSwitch: UISwitch!

	var filter: FilterItem?

	func setup(filter: FilterItem) {
		self.filter = filter
		self.titleLabel.text = filter.title
		self.filterSwitch.isOn = filter.isOn
	}

	@IBAction func didChangeSwitch(_ sender: Any) {
		self.filter?.isOn = self.filterSwitch.isOn
	}
}

class FilterTableViewController: UITableViewController {

	var collectionViewModel: CollectionViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setups()
    }

	// MARK: - Private Methods

	private func setups() {
		self.setupUI()
		self.setupNavigation()
	}

	private func setupUI() {
		self.view.backgroundColor = LK.backgroundColor
	}

	private func setupNavigation() {
		guard let nav = self.navigationController else {
			return
		}

		nav.navigationBar.titleTextAttributes = UIFont.attributedString(size: 17)
		nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		nav.navigationBar.shadowImage = UIImage()
		nav.navigationBar.isTranslucent = false
		nav.navigationBar.barTintColor = LK.redColor
	}

	// MARK: - Action

	private func closeViewController() {
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func didTapDoneButton(_ sender: Any) {
		self.collectionViewModel?.setFilter()
		self.closeViewController()
	}

	@IBAction func didTapCancelButton(_ sender: Any) {
		self.closeViewController()
	}

}

// MARK: - Table view data source

extension FilterTableViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.collectionViewModel?.filters.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

		if let filterCell = cell as? FilterTableViewCell, let viewModel = self.collectionViewModel {
			filterCell.setup(filter: viewModel.filters[indexPath.row])
		}

		return cell
	}
}
