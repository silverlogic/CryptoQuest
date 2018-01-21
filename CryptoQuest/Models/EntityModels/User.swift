//
//  User.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/21/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import Foundation

struct User {
    
    // MARK: - Public Instance Attributes
    var userId: Int
    var bitcoinAmount: Float
    var bitcoinCashAmount: Float
    var veztAmount: Float
    var ethereumAmount: Float
    var litecoinAmount: Float
    var neoAmount: Float
}


// MARK: - Public Class Methods
extension User {
    static func mockUser2() -> User {
        return User(
            userId: 2,
            bitcoinAmount: 0.0012892,
            bitcoinCashAmount: 0.00210707,
            veztAmount: 2.9891344961,
            ethereumAmount: 0.00358395,
            litecoinAmount: 0.01985001,
            neoAmount: 0.03507049
        )
    }
    
    static func mockUser3() -> User {
        return User(
            userId: 3,
            bitcoinAmount: 0.0,
            bitcoinCashAmount: 0.0,
            veztAmount: 0.0,
            ethereumAmount: 0.0,
            litecoinAmount: 0.0,
            neoAmount: 0.0
        )
    }
}
