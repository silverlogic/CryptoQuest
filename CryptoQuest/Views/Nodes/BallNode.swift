//
//  BallNode.swift
//  CryptoQuest
//
//  Created by Vasilii Muravev on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import SceneKit

class BallNode: SCNNode {
    
    // MARK: - Initializers
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("unavailable")
    }
    
    override init() {
        let geometry = SCNSphere(radius: 0.5)
        geometry.materials = [SCNMaterial(color: .red)]
        super.init()
        self.geometry = geometry
        physicsBody = {
            let physics = SCNPhysicsBody(type: .dynamic, shape: nil)
            physics.mass = 0.5 // Kg
            physics.damping = 0.0 // 0.0 -> 1.0
            physics.friction = 0.0 // 0.0 -> 1.0
            return physics
        }()
    }
}
