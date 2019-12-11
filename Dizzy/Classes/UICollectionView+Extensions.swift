//
//  UICollectionView+Extensions.swift
//  Dizzy
//
//  Created by ジャティン on 2019/11/15.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit



public extension UICollectionView {
    func prepareFadeReload() {
        self.reloadData()
        self.performBatchUpdates({
            UIView.animate(views: self.orderedVisibleCells, animations: [AnimationType.from(direction: .bottom, offset: 100)], completion: nil)
        }, completion: nil)
    }
    
    /// VisibleCells in the order they are displayed on screen.
    var orderedVisibleCells: [UICollectionViewCell] {
        return indexPathsForVisibleItems.sorted().compactMap { cellForItem(at: $0) }
    }

    /// Gets the currently visibleCells of a section.
    ///
    /// - Parameter section: The section to filter the cells.
    /// - Returns: Array of visible UICollectionViewCells in the argument section.
    func visibleCells(in section: Int) -> [UICollectionViewCell] {
        return visibleCells.filter { indexPath(for: $0)?.section == section }
    }
    
}

