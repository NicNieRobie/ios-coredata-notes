//
//  AutoInvalidatingLayout.swift
//  vmpendischukPW4
//
//  Created by Vladislav on 21.10.2021.
//

import UIKit

class AutoInvalidatingLayout: UICollectionViewFlowLayout {
    // Computes the width of a full width cell for given bounds.
    func widestCellWidth(bounds: CGRect) -> CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }

        let insets = collectionView.contentInset
        let width = bounds.width - insets.left - insets.right
        
        if width < 0 { return 0 }
        else { return width }
    }
    
    // Updates the estimatedItemSize for a given bounds.
    func updateEstimatedItemSize(bounds: CGRect) {
        estimatedItemSize = CGSize(
            width: widestCellWidth(bounds: bounds),
            height: 200
        )
    }

    // Updates the layout.
    override func prepare() {
        super.prepare()

        // Updating the estimation for cell size.
        let bounds = collectionView?.bounds ?? .zero
        updateEstimatedItemSize(bounds: bounds)
    }
    
    // Checks if layout should be invalidated.
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }
        
        // Returns true with new estimation for size
        //   if collection view bounds have changed.
        let oldSize = collectionView.bounds.size
        guard oldSize != newBounds.size else { return false }
        updateEstimatedItemSize(bounds: newBounds)
        return true
    }
}
