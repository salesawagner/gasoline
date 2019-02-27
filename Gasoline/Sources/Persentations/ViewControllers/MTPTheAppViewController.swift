//
//  MTPTheAppViewController.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 6/9/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit

class MTPTheAppViewController: GASViewController {

//**************************************************
// MARK: - Properties
//**************************************************

	@IBOutlet weak var versionLabel: UILabel!

//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Internal Methods
//**************************************************

//**************************************************
// MARK: - Private Methods
//**************************************************

	fileprivate func setupVersions() {

		if let info = Bundle.main.infoDictionary {
			if let appVersion = info["CFBundleShortVersionString"] as? String {
				if let buildVersion = info["CFBundleVersion"] as? String {
					self.versionLabel.text = String(format: "v. %@ (%@)", appVersion, buildVersion)
				}
			}
		}
	}

//**************************************************
// MARK: - Self Public Methods
//**************************************************

//**************************************************
// MARK: - Override Public Methods
//**************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupVersions()
		self.title = "App version"
    }
}
