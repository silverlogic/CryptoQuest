//
//  CollisionCategory.swift
//  CryptoQuest
//
//  Created by Vasilii Muravev on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

enum CollisionCategory: Int {
    case floor      = 0b1
    case ball       = 0b10
    case coin       = 0b100
    case evilBubble = 0b1000
}
