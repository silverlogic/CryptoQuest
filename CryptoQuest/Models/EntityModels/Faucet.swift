//
//  Faucet.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation

struct Faucet: Codable {
    
    // MARK: - Public Instance Attributes
    let faucetId: Int
    let coin: Coin
    let location: Location
    
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case faucetId = "id"
        case coin = "coin"
        case location = "location"
    }
}
