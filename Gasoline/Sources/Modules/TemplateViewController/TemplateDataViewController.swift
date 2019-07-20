//
//  TemplateDataViewController.swift
//  Youse
//
//  Created by Wagner Sales on 18/05/18.
//  Copyright © 2018 Youse. All rights reserved.
//

import UIKit

class TemplateDataViewController: TemplateViewController {
	
	// MARK: - Properties
	
	var data: TemplateData! {
		didSet {
			self.didSetData()
		}
	}
	
	// MARK: - Constructors
	
	convenience init(withData data: TemplateData) {
		self.init(template: .simple)
		self.data = data
		self.didSetData()
	}
	
	// MARK: - Private Methods
	
	private func didSetData() {
		self.titleText = self.data.titleText
		self.descriptionText = self.data.descriptionText
		self.image = self.data.image
	}
}
