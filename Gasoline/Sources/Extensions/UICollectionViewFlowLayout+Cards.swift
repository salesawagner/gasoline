//
//  UICollectionViewFlowLayoutExtensions.swift
//  Gasoline
//
//  Created by Wagner Sales on 24/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    static var cards: UICollectionViewFlowLayout {

        let perLine = 2

        let margin: CGFloat = 12
        let screenWhidth: CGFloat = UIScreen.main.bounds.width - 1
        let cardSpaces: CGFloat = margin * (CGFloat(perLine) + 1)
        let cardWidth = (screenWhidth - cardSpaces) / CGFloat(perLine)
        let cardHeight = cardWidth * 1.50

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        layout.itemSize = CGSize(width: cardWidth, height: cardHeight)
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)

        return layout
    }
}
