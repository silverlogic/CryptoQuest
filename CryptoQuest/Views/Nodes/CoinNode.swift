//
//  CoinNode.swift
//  CryptoQuest
//
//  Created by Vasilii Muravev on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import SceneKit

private let coinRadius: CGFloat = evilBubbleRadius * 0.8

class CoinNode: BaseNode {
    
    // MARK: - Private Instance Attributes
    private var flyTimer: Timer? = nil
    
    
    // MARK: - Initializers
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("unavailable")
    }
    
    init(_ type: CryptoCreatureName = .bitcoin) {
        let geometry = SCNCylinder(radius: coinRadius, height: coinRadius * 0.2)
        geometry.materials = [
            SCNMaterial(color: type.color()),
            SCNMaterial.invertedByY(image: type.frontImage()), // front
            SCNMaterial(image: type.backImage()) // back
        ]
        super.init()
        self.geometry = geometry
        eulerAngles = SCNVector3(0.5 * CGFloat.pi, 0.0, -0.5 * CGFloat.pi)
    }
    
    
    // MARK: - Public Instance Methods
//    func applePhysics() {
//        physicsBody = {
//            let physics = SCNPhysicsBody(type: .dynamic, shape: nil)
//            physics.mass = 1000.0  // Kg
//            physics.damping = 0.0  // 0.0 -> 1.0
//            physics.friction = 1.0 // 0.0 -> 1.0
//            physics.categoryBitMask = CollisionCategory.coin.rawValue
//            physics.contactTestBitMask = CollisionCategory.ball.rawValue
//            physics.collisionBitMask = CollisionCategory.coin.rawValue | CollisionCategory.ball.rawValue
//            physics.isAffectedByGravity = false
//            //            physics.velocityFactor = SCNVector3Zero
//            return physics
//        }()
//    }
    func fly(to wallet: SCNNode) {
        let constraint = SCNDistanceConstraint(target: wallet)
        let distance = CGFloat(abs(presentation.worldPosition.distanceFromVector(wallet.presentation.worldPosition)))
        constraint.maximumDistance = distance
        constraints = [constraint]
        flyTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] timer in
            constraint.maximumDistance -= 0.025
            guard constraint.maximumDistance <= 0.0 else {
                return
            }
            self?.flyTimer?.invalidate()
            self?.flyTimer = nil
            guard let strongSelf = self,
                  let action = strongSelf.action else {
                return
            }
            action(strongSelf)
        })
    }
}
