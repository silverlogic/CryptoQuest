//
//  Spawn.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation

struct Spawn: Codable {
    
    // MARK: - Public Instance Attributes
    let spawnId: Int
    let faucet: Faucet
    let amount: String
    let capturedByUserId: Int?
    
    
    // MARK: - Getters & Setters
    var spawnAmount: Float {
        return Float(amount) ?? 0
    }
    var cryptoCreatureMarker: CryptoCreatureMarker? {
        let cryptoName = faucet.coin.name
        guard let marker = CryptoCreatureMarker(spawnId: spawnId, cryptoName: cryptoName) else { return nil }
        marker.position = faucet.location.coordinate
        return marker
    }
    
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case spawnId = "id"
        case faucet = "faucet"
        case amount = "amount"
        case capturedByUserId = "captured_by"
    }
}
