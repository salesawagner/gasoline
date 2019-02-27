//
//  MTPNotFound.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 6/6/16.
//  Copyright © 2016 Wagner Sales. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class MTPNotFound: UIView {

//**************************************************
// MARK: - Properties
//**************************************************

	var title: String = "" {
		didSet {
			self.titleLabel.text = self.title
		}
	}
	var information: String = "" {
		didSet {
			self.descriptionLabel.text = self.information
		}
	}
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

//**************************************************
// MARK: - Constructors
//**************************************************

	class func create(title: String = "",
	                  description: String = "",
	                  frame: CGRect? = nil) -> MTPNotFound {
		let bundle = Bundle.main
		guard
			let nib = bundle.loadNibNamed("MTPNotFound", owner: self, options: nil),
			let view = nib.first as? MTPNotFound else {
				return MTPNotFound()
		}
		view.titleLabel.text = title
		view.descriptionLabel.text = description
		if let frame = frame {
			view.frame = frame
		}
		return view
	}

//**************************************************
// MARK: - Internal Methods
//**************************************************

//**************************************************
// MARK: - Private Methods
//**************************************************

//**************************************************
// MARK: - Self Public Methods
//**************************************************

//**************************************************
// MARK: - Override Public Methods
//**************************************************

}
