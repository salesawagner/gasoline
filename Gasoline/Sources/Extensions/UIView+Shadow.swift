//
//  UIView+Shadow.swift
//  Gasoline
//
//  Created by Wagner Sales on 24/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit

struct Shadow {
    static var style: Shadow { return Shadow() }

    var shadowOffset = CGSize(width: 1.5, height: 1.5)
    var shadowRadius: CGFloat = 0.5
    var shadowOpacity: Float = 1.0
    var shadowColor = UIColor.black.cgColor
}

extension UIView {
    func setShadow(_ shadow: Shadow = Shadow.style) {
        self.clipsToBounds = false
        self.layer.shadowOffset = shadow.shadowOffset
        self.layer.shadowRadius = shadow.shadowRadius
        self.layer.shadowOpacity = shadow.shadowOpacity
        self.layer.shadowColor = shadow.shadowColor
    }
}
