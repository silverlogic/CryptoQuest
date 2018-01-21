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
    case shitCoin = "ShitCoin"
    
    func frontImage() -> UIImage {
        switch self {
        case .bitcoin:
            return #imageLiteral(resourceName: "icon-bitcoin")
        case .bitcoinCash:
            return #imageLiteral(resourceName: "icon-bitcoincash")
        case .ethereum:
            return #imageLiteral(resourceName: "icon-ether")
        case .litecoin:
            return #imageLiteral(resourceName: "icon-litecoin")
        case .shitCoin:
            return #imageLiteral(resourceName: "icon-shitcoin")
        case .vezt:
            return #imageLiteral(resourceName: "icon-vezt")
        }
    }
    
    func backImage() -> UIImage {
        switch self {
        case .bitcoin:
            return #imageLiteral(resourceName: "icon-bitcoinback")
        case .bitcoinCash:
            return #imageLiteral(resourceName: "icon-bitcoincashback")
        case .ethereum:
            return #imageLiteral(resourceName: "icon-etherback")
        case .litecoin:
            return #imageLiteral(resourceName: "icon-litecoinback")
        case .shitCoin:
            return #imageLiteral(resourceName: "icon-shitcoinback")
        case .vezt:
            return #imageLiteral(resourceName: "icon-veztback")
        }
    }
    
    func pinIcon() -> UIImage {
        switch self {
        case .bitcoin:
            return #imageLiteral(resourceName: "icon-bitcoin-character-map")
        case .bitcoinCash:
            return #imageLiteral(resourceName: "icon-bitcoincash-character-map")
        case .ethereum:
            return #imageLiteral(resourceName: "icon-ethereum-character-map")
        case .litecoin:
            return #imageLiteral(resourceName: "icon-litecoin-character-map")
        case .vezt:
            return #imageLiteral(resourceName: "icon-vezt-character-map")
        case .shitCoin:
            return UIImage()
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .bitcoin:
            return UIColor.colorFromHexValue(0xf7931a)
        case .bitcoinCash:
            return UIColor.colorFromHexValue(0x4cc947)
        case .ethereum:
            return UIColor.colorFromHexValue(0x8a92b2)
        case .litecoin:
            return UIColor.colorFromHexValue(0xbebebe)
        case .vezt:
            return UIColor.colorFromHexValue(0x40cca7)
        case .shitCoin:
            return UIColor.colorFromHexValue(0x94674d)
        }
    }
    
    func health() -> Int {
        switch self {
        case .bitcoin:
            return 3
        case .bitcoinCash:
            return 3
        case .ethereum:
            return 3
        case .litecoin:
            return 3
        case .vezt:
            return 3
        case .shitCoin:
            return 9
        }
    }
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
        self.icon = creatureName.pinIcon()
        self.appearAnimation = .pop
    }
}
