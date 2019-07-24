//
//  UIView+Utils.swift
//  Gasoline
//
//  Created by Wagner Sales on 22/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit

extension UIView {
    func setCircle() {
        guard self.frame.size.width == self.frame.size.height else { return }

        let radius = self.frame.size.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
