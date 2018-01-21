//
//  MorphingLabel.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation
import LTMorphingLabel

final class MorphingLabel: LTMorphingLabel {
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.morphingEffect = .sparkle
    }
}
