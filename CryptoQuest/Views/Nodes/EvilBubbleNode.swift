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
    private var forceTimer: Timer? = nil
    private(set) weak var healthBar: HealthBarNode! = nil
    private weak var coinNode: CoinNode! = nil
    
    
    // MARK: - Initializers
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("unavailable")
    }
    
    init(_ coinType: CryptoCreatureName = .bitcoin) {
        let geometry = SCNSphere(radius: evilBubbleRadius)
        geometry.materials = [
            SCNMaterial(color: UIColor.colorFromHexValue(0xf7931a, alpha: 0.45))
        ]
        super.init()
        self.geometry = geometry
        physicsBody = {
            let physics = SCNPhysicsBody(type: .dynamic, shape: nil)
            physics.mass = 1000.0  // Kg
            physics.damping = 0.0  // 0.0 -> 1.0
            physics.friction = 1.0 // 0.0 -> 1.0
            physics.categoryBitMask = CollisionCategory.evilBubble.rawValue
            physics.collisionBitMask = CollisionCategory.evilBubble.rawValue | CollisionCategory.ball.rawValue
            physics.isAffectedByGravity = false
            return physics
        }()
        let coin = CoinNode(coinType)
        addChildNode(coin)
        coin.runAction(
            SCNAction.repeatForever(SCNAction.rotateBy(x: -CGFloat.pi, y: 0.0, z: 0.0, duration: 2.0))
        )
        coin.action = { [weak self] _ in
            guard let strongSelf = self,
                  let action = strongSelf.action else {
                return
            }
            action(strongSelf)
        }
        coinNode = coin
        let healthBar = HealthBarNode(healthPoints: coinType.health())
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
        forceTimer?.invalidate()
        var repeats = 0
        forceTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { [weak self] timer in
            guard animationMaxRepeats > repeats else {
                timer.invalidate()
                self?.forceTimer = nil
                return
            }
            repeats += 1
            self?.applyRandomForce(with: magnitude)
        })
        applyRandomForce(with: magnitude)
    }
    
    func hitted(_ walletNode: SCNNode) {
        healthBar.hitted()
        guard healthBar.livesLeft == 0 else {
            return
        }
        physicsBody = nil
        geometry?.materials[0].diffuse.contents = UIColor.clear
        healthBar.isHidden = true
        forceTimer?.invalidate()
        forceTimer = nil
        DispatchQueue.main.async { [weak self] in
            self?.coinNode.fly(to: walletNode)
        }
    }
}
