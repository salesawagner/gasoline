//
//  NetbeeAddressOnboardingData.swift
//  Youse
//
//  Created by Wagner Sales on 11/10/17.
//  Copyright © 2017 Youse. All rights reserved.
//

import UIKit

class TemplateData: NSObject {
	
	let titleText: String
	let descriptionText: String
    
	let image: UIImage
	
	init(title: String, information: String, image: UIImage) {
		self.titleText = title
		self.descriptionText = information
		self.image = image
	}
}
