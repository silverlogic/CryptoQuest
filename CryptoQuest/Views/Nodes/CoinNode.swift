//
//  CoinNode.swift
//  CryptoQuest
//
//  Created by Vasilii Muravev on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import SceneKit

private let coinRadius: CGFloat = evilBubbleRadius * 0.5

class CoinNode: BaseNode {
    
    // MARK: - Initializers
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("unavailable")
    }
    
    override init() {
        let geometry = SCNCylinder(radius: coinRadius, height: coinRadius * 0.1)
        geometry.materials = [
            SCNMaterial(color: .red),
            SCNMaterial(color: .blue), // front
            SCNMaterial(color: .green) // back
        ]
        super.init()
        self.geometry = geometry
        eulerAngles = SCNVector3(0.5 * CGFloat.pi, 0.0, 0.0)
//        physicsBody = {
//            let physics = SCNPhysicsBody(type: .dynamic, shape: nil)
//            physics.mass = 1000.0  // Kg
//            physics.damping = 0.0  // 0.0 -> 1.0
//            physics.friction = 1.0 // 0.0 -> 1.0
//            physics.categoryBitMask = CollisionCategory.coin.rawValue
//            physics.contactTestBitMask = CollisionCategory.ball.rawValue
//            physics.collisionBitMask = CollisionCategory.coin.rawValue | CollisionCategory.ball.rawValue
//            physics.isAffectedByGravity = false
////            physics.velocityFactor = SCNVector3Zero
//            return physics
//        }()
    }
}
