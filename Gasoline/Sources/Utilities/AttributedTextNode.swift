//
//  AttributedTextNode.swift
//  MyTinderPro
//
//  Created by Wagner Sales on 24/04/17.
//  Copyright © 2017 Wagner Sales. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AttributedTextNode: ASTextNode {

    func configure(_ text: String,
                   size: CGFloat,
                   color: UIColor = UIColor.white,
                   textAlignment: NSTextAlignment = .left) {
		
		let range = NSMakeRange(0, text.count)
		
        let mutableString = NSMutableAttributedString(string: text)
        mutableString.addAttribute(NSAttributedStringKey.font, value: UIFont.fontBook(size: size), range: range)
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)

		let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        mutableString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: range)

		let shadow = NSShadow()
		shadow.shadowColor = UIColor.black
		shadow.shadowOffset = CGSize(width: 1, height: 1)
		shadow.shadowBlurRadius = 1
		mutableString.addAttribute(NSAttributedStringKey.shadow, value: shadow, range: range)

		self.attributedText = mutableString
    }
}
