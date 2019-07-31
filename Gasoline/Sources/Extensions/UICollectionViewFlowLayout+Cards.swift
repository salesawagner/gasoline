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

        let layout = InvertedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        layout.itemSize = CGSize(width: cardWidth, height: cardHeight)
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)

        return layout
    }
}

class InvertedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // inverting the transform in the layout, rather than directly on the cell,
    // is the only way I've found to prevent cells from flipping during animated
    // cell updates

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.layoutAttributesForItem(at: indexPath)
        attrs?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        return attrs
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrsList = super.layoutAttributesForElements(in: rect)
        if let list = attrsList {
            for i in 0..<list.count {
                list[i].transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        }
        return attrsList
    }
}
