//
//  CryptoDexVerticalFlowLayout.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/21/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation

final class CryptoDexVerticalFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Instance Attributes
    var numberOfItemsPerRow: Int = 3 {
        didSet {
            invalidateLayout()
        }
    }
    
    
    // MARK: - Lifecycle
    override func prepare() {
        super.prepare()
        guard let currentCollectionView = collectionView else { return }
        scrollDirection = .vertical
        var newItemSize = itemSize
        let itemsPerRow = CGFloat(max(numberOfItemsPerRow, 1))
        let totalSpacingBetweenCells = minimumInteritemSpacing * (itemsPerRow - 1.0)
        newItemSize.width = (currentCollectionView.bounds.size.width - totalSpacingBetweenCells) / itemsPerRow
        if itemSize.height > 0 {
            let itemAspectRatio = itemSize.width / itemSize.height
            newItemSize.height = newItemSize.width / itemAspectRatio
        }
        itemSize = newItemSize
    }
}
