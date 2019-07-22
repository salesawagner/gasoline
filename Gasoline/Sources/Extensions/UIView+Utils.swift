//
//  UIView+Utils.swift
//  Gasoline
//
//  Created by Wagner Sales on 22/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit

extension UIView { // FIXME

    func setShadow() {
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 0.5
        self.layer.shadowOpacity = 1.0
        self.layer.shadowColor = UIColor.black.cgColor
    }

    func setCircle() {
        guard self.frame.size.width == self.frame.size.height else { return }

        let radius = self.frame.size.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
