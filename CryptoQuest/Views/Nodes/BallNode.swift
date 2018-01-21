//
//  BallNode.swift
//  CryptoQuest
//
//  Created by Vasilii Muravev on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import SceneKit

class BallNode: BaseNode {
    
    // MARK: - Initializers
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("unavailable")
    }
    
    override init() {
        let geometry = SCNSphere(radius: 0.3)
        geometry.materials = [SCNMaterial(image: #imageLiteral(resourceName: "ballTexture"))]
        super.init()
        self.geometry = geometry
        physicsBody = {
            let physics = SCNPhysicsBody(type: .dynamic, shape: nil)
            physics.mass = 0.5      // Kg
            physics.damping = 0.0   // 0.0 -> 1.0
            physics.friction = 0.0  // 0.0 -> 1.0
            physics.categoryBitMask = CollisionCategory.ball.rawValue
            physics.contactTestBitMask = CollisionCategory.coin.rawValue | CollisionCategory.evilBubble.rawValue
            physics.collisionBitMask = CollisionCategory.ball.rawValue | CollisionCategory.evilBubble.rawValue
            return physics
        }()
    }
}
