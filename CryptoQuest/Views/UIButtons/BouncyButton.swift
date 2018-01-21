//
//  BouncyButton.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import SSBouncyButton
import UIKit

final class BouncyButton: SSBouncyButton {
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setBackgroundImage(UIImage(), for: .normal)
        setBackgroundImage(UIImage(), for: .selected)
    }
}
