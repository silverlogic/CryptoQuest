//
//  UserLocationMarker.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation
import GoogleMaps

final class UserLocationMarker: GMSMarker {
    
    // MARK: - Initializers
    override init() {
        super.init()
        self.icon = #imageLiteral(resourceName: "icon-userlocation-vertical")
        self.appearAnimation = .pop
    }
}
