//
//  UICollection+Reactive.swift
//  Gasoline
//
//  Created by Wagner Sales on 25/07/19.
//  Copyright © 2019 Wagner Sales. All rights reserved.
//

import Foundation
import RealmSwift

extension UICollectionView {
    func applyChanges<T>(changes: RealmCollectionChange<T>) {
        switch changes {
        case .initial: reloadData()
        case .update(_, let deletions, let insertions, let updates):

            self.performBatchUpdates({
                self.reloadItems(at: updates.map { IndexPath(row: $0, section: 0) })
                self.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                self.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
            }, completion: { (completed: Bool) in
                self.reloadData()
            })

        case .error(let error): fatalError("\(error)")
        }
    }
}
