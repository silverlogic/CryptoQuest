//
//  CryptoDexCollectionViewCell.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/21/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import UIKit

final class CryptoDexCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var cryptoCreatureImageView: UIImageView!
    @IBOutlet private weak var cryptoCreatureNameLabel: UILabel!
    @IBOutlet private weak var cryptoAmountLabel: UILabel!
}


// MARK: - Public Instance Attributes
extension CryptoDexCollectionViewCell {
    func configure(cryptoImage: UIImage, cryptoName: String, cryptoAmount: Float) {
        cryptoCreatureImageView.image = cryptoImage
        cryptoCreatureNameLabel.text = cryptoName
        cryptoAmountLabel.text = "\(cryptoAmount)"
    }
}
