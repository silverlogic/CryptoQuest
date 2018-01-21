//
//  EvilBubbleNode.swift
//  CryptoQuest
//
//  Created by Vasilii Muravev on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import SceneKit

let evilBubbleRadius: CGFloat = 1.0
private let animationMaxRepeats = 200
private let magnitude: UInt32 = 1000

class EvilBubbleNode: BaseNode {
    
    // MARK: - Private Instance Attributes
    private var timer: Timer? = nil
    private(set) weak var healthBar: HealthBarNode! = nil
    
    
    // MARK: - Initializers
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("unavailable")
    }
    
    override init() {
        let geometry = SCNSphere(radius: evilBubbleRadius)
        geometry.materials = [
            SCNMaterial(color: UIColor.colorFromHexValue(0xf7931a, alpha: 0.5))
        ]
        super.init()
        self.geometry = geometry
        physicsBody = {
            let physics = SCNPhysicsBody(type: .dynamic, shape: nil)
            physics.mass = 1000.0  // Kg
            physics.damping = 0.0  // 0.0 -> 1.0
            physics.friction = 1.0 // 0.0 -> 1.0
            physics.categoryBitMask = CollisionCategory.evilBubble.rawValue
            physics.contactTestBitMask = CollisionCategory.ball.rawValue | CollisionCategory.evilBubble.rawValue
            physics.collisionBitMask = CollisionCategory.evilBubble.rawValue | CollisionCategory.ball.rawValue
            physics.isAffectedByGravity = false
//            physics.velocityFactor = SCNVector3Zero
            return physics
        }()
        let coin = CoinNode()
        addChildNode(coin)
        coin.runAction(
            SCNAction.repeatForever(SCNAction.rotateBy(x: 0.0, y: CGFloat.pi, z: 0.0, duration: 2.0))
        )
        let healthBar = HealthBarNode(healthPoints: 5)
        healthBar.position = SCNVector3(
            0.0,
            evilBubbleRadius + healthBarBlockSize,
            0.0
        )
        addChildNode(healthBar)
        self.healthBar = healthBar
    }
    
    
    // MARK: - Public Instance Methods
    func startFlyingRandomly() {
        timer?.invalidate()
        var repeats = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { [weak self] timer in
            guard animationMaxRepeats > repeats else {
                timer.invalidate()
                self?.timer = nil
                return
            }
            repeats += 1
            self?.applyRandomForce(with: magnitude)
        })
        applyRandomForce(with: magnitude)
    }
}
