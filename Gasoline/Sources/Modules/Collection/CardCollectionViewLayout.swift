//
//  CardCollectionViewLayout.swift
//  Gasoline
//
//  Created by Wagner Sales on 23/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit

class CardCollectionViewFlowLayout: UICollectionViewFlowLayout {

    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 6
    private var cache: [UICollectionViewLayoutAttributes] = [] // Array to keep a cache of attributes.

    private var contentWidth: CGFloat {
        guard let collectionView = self.collectionView else {
            return 0
        }

        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    private var contentHeight: CGFloat {
        return self.contentWidth * 1.6
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.contentWidth, height: self.contentHeight)
    }

    override func prepare() {

        guard self.cache.isEmpty, let collectionView = collectionView else {
            return
        }

        // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
        let columnWidth = self.contentWidth / CGFloat(self.numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< self.numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: self.numberOfColumns)

        // 3. Iterates through the list of items in the first section
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {

            let indexPath = IndexPath(item: item, section: 0)

            // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
//            let photoHeight = self.contentHeight
            let height = self.contentHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            self.cache.append(attributes)

            // 6. Updates the collection view content height
            yOffset[column] = yOffset[column] + height

            column = column < (self.numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        // Loop through the cache and look for items in the rect
        for attributes in self.cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cache[indexPath.item]
    }
}
