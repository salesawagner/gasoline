//
//  FlowLayout.swift
//  Gasoline
//
//  Created by Wagner Sales on 28/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import UIKit

class ChatCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard super.layoutAttributesForElements(in: rect) != nil else { return nil }
        var attributesArrayNew = [UICollectionViewLayoutAttributes]()

        if let collectionView = self.collectionView {
            for section in 0 ..< collectionView.numberOfSections {
                for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                    let indexPathCurrent = IndexPath(item: item, section: section)
                    if let attributeCell = layoutAttributesForItem(at: indexPathCurrent) {
                        if attributeCell.frame.intersects(rect) {
                            attributesArrayNew.append(attributeCell)
                        }
                    }
                }
            }

            for section in 0 ..< collectionView.numberOfSections {
                let indexPathCurrent = IndexPath(item: 0, section: section)
                if let attributeKind = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPathCurrent) {
                    attributesArrayNew.append(attributeKind)
                }
            }
        }

        return attributesArrayNew
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributeKind = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)

        if let collectionView = self.collectionView {
            var fullHeight: CGFloat = 0.0

            for section in 0 ..< indexPath.section + 1 {
                for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                    let indexPathCurrent = IndexPath(item: item, section: section)
                    fullHeight += cellHeight(indexPathCurrent) + minimumLineSpacing
                }
            }

            attributeKind.frame = CGRect(x: 0, y: collectionViewContentSize.height - fullHeight - CGFloat(indexPath.section + 1) * headerHeight(indexPath.section) - sectionInset.bottom + minimumLineSpacing/2, width: collectionViewContentSize.width, height: headerHeight(indexPath.section))
        }

        return attributeKind
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributeCell = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        if let collectionView = self.collectionView {
            var fullHeight: CGFloat = 0.0

            for section in 0 ..< indexPath.section + 1 {
                for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                    let indexPathCurrent = IndexPath(item: item, section: section)
                    fullHeight += cellHeight(indexPathCurrent) + minimumLineSpacing

                    if section == indexPath.section && item == indexPath.item {
                        break
                    }
                }
            }

            attributeCell.frame = CGRect(x: 0, y: collectionViewContentSize.height - fullHeight + minimumLineSpacing - CGFloat(indexPath.section) * headerHeight(indexPath.section) - sectionInset.bottom, width: collectionViewContentSize.width, height: cellHeight(indexPath) )
        }

        return attributeCell
    }

    override var collectionViewContentSize: CGSize {
        get {
            var height: CGFloat = 0.0
            var bounds = CGRect.zero

            if let collectionView = self.collectionView {
                for section in 0 ..< collectionView.numberOfSections {
                    for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                        let indexPathCurrent = IndexPath(item: item, section: section)
                        height += cellHeight(indexPathCurrent) + minimumLineSpacing
                    }
                }

                height += sectionInset.bottom + CGFloat(collectionView.numberOfSections) * headerHeight(0)
                bounds = collectionView.bounds
            }

            return CGSize(width: bounds.width, height: max(height, bounds.height))
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let oldBounds = self.collectionView?.bounds,
            oldBounds.width != newBounds.width || oldBounds.height != newBounds.height {
            return true
        }

        return false
    }

    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if let collectionView = self.collectionView, let delegateFlowLayout = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
            let size = delegateFlowLayout.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)
            return size.height
        }

        return 0
    }

    func headerHeight(_ section: Int) -> CGFloat {
        if let collectionView = self.collectionView, let delegateFlowLayout = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
            let size = delegateFlowLayout.collectionView!(collectionView, layout: self, referenceSizeForHeaderInSection: section)
            return size.height
        }

        return 0
    }
}
