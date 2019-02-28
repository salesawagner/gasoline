//
//  UIFontExtensions.swift
//  Gasoline
//
//  Created by Wagner Sales on 05/06/18.
//  Copyright © 2018 Wagner Sales. All rights reserved.
//

import UIKit

extension UIFont {
	
	class func font(name: String, size: CGFloat) -> UIFont {
		return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
	}
	
	class func fontMedium(size: CGFloat) -> UIFont {
		return UIFont.font(name: "Avenir-Medium", size: size)
	}
	
	class func fontBook(size: CGFloat) -> UIFont {
		return UIFont.font(name: "Avenir-Book", size: size)
	}
	
	class func attributedString(size: CGFloat, color: UIColor = .white) -> [NSAttributedString.Key: Any]  {
		let font = UIFont.fontMedium(size: size)
		return [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
	}
}
