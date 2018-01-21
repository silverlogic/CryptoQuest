//
//  CryptoCreatureMarker.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import GoogleMaps
import Foundation

// MARK: - Crypto Creature Name
enum CryptoCreatureName: String {
    case bitcoin = "Bitcoin"
    case bitcoinCash = "BitcoinCash"
    case ethereum = "Ethereum"
    case litecoin = "Litecoin"
    case vezt = "Vezt"
}


// MARK: - Crypto Creature Marker
final class CryptoCreatureMarker: GMSMarker {
    
    // MARK: - Public Instance Attributes
    let spawnId: Int
    let cryptoName: String
    
    
    // MARK: - Initializers
    init?(spawnId: Int, cryptoName: String) {
        self.spawnId = spawnId
        self.cryptoName = cryptoName
        guard let creatureName = CryptoCreatureName(rawValue: cryptoName) else { return nil }
        super.init()
        switch creatureName {
        case .bitcoin:
            self.icon = #imageLiteral(resourceName: "icon-bitcoin-character-map")
        case .bitcoinCash:
            self.icon = #imageLiteral(resourceName: "icon-bitcoincash-character-map")
        case .ethereum:
            self.icon = #imageLiteral(resourceName: "icon-ethereum-character-map")
        case .litecoin:
            self.icon = #imageLiteral(resourceName: "icon-litecoin-character-map")
        case .vezt:
            self.icon = #imageLiteral(resourceName: "icon-vezt-character-map")
        }
        self.appearAnimation = .pop
    }
}
