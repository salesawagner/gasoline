//
//  CardView.swift
//  Gasoline
//
//  Created by Wagner Sales on 20/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit

@IBDesignable
class Test: UIButton {
    @IBInspectable
    var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.clipsToBounds = self.cornerRadius > 0
        }
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        self.layer.cornerRadius = self.cornerRadius
        self.clipsToBounds = self.cornerRadius > 0
    }
}

@IBDesignable
class CardView: UIView {

    // MARK: - Internal Properties

    @IBInspectable
    var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    @IBInspectable
    var shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0) {
        didSet {
            self.layer.shadowOffset = self.shadowOffset
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 3.0 {
        didSet {
            self.layer.shadowRadius = self.shadowRadius
            self.layer.shadowPath = self.bezierPath.cgPath
        }
    }

    @IBInspectable
    var shadowOpacity: Float = 0.3 {
        didSet {
            self.layer.shadowOpacity = self.shadowOpacity
        }
    }

    @IBInspectable
    var shadowColored: UIColor? = .black {
        didSet {
            self.layer.shadowColor = self.shadowColored?.cgColor
        }
    }

    @IBInspectable
    var borderedWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderedWidth
        }
    }

    @IBInspectable
    var borderedColor: UIColor = .lightGray {
        didSet {
            self.layer.borderColor = self.borderedColor.cgColor
        }
    }

    @IBInspectable
    var clips: Bool = false {
        didSet {
            self.clipsToBounds = self.clips
        }
    }

    // MARK: - Private Properties

    private var bezierPath: UIBezierPath {
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius)
        return path
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        self.clipsToBounds = self.clips
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowPath = self.bezierPath.cgPath
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.borderWidth = self.borderedWidth
        self.layer.borderColor = self.borderedColor.cgColor
        self.layer.shadowColor = self.shadowColored?.cgColor
    }
}
