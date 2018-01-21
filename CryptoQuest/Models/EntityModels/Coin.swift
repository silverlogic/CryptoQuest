//
//  Coin.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation

struct Coin: Codable {
    
    // MARK: - Public Instance Attributes
    let coinId: Int
    let name: String
    
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case coinId = "id"
        case name = "name"
    }
}
