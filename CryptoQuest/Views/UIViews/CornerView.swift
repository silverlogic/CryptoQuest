//
//  CornerView.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/21/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import UIKit

final class CornerView: UIView {
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
    }
}
