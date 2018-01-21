//
//  CoinNode.swift
//  CryptoQuest
//
//  Created by Vasilii Muravev on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import SceneKit

private let coinRadius: CGFloat = evilBubbleRadius * 0.8
private let megaCoinRadius: CGFloat = megaEvilBubbleRadius * 0.8

class CoinNode: BaseNode {
    
    // MARK: - Private Instance Attributes
    private var flyTimer: Timer? = nil
    private var initialType: CryptoCreatureName
    private(set) var isMegaShit: Bool

    
    // MARK: - Initializers
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("unavailable")
    }
    
    init(_ type: CryptoCreatureName = .bitcoin, isMegaShit: Bool = false) {
        self.isMegaShit = isMegaShit
        initialType = type
        super.init()
        geometry = SCNCylinder(
            radius: (isMegaShit ? megaCoinRadius : coinRadius),
            height: (isMegaShit ? megaCoinRadius : coinRadius) * 0.2
        )
        update(type: initialType)
        eulerAngles = SCNVector3(0.5 * CGFloat.pi, 0.0, -0.5 * CGFloat.pi)
    }
    
    
    // MARK: - Public Instance Methods
    func fly(to wallet: SCNNode) {
        let constraint = SCNDistanceConstraint(target: wallet)
        let distance = CGFloat(abs(presentation.worldPosition.distanceFromVector(wallet.presentation.worldPosition)))
        constraint.maximumDistance = distance
        constraints = [constraint]
        if initialType == .shitCoin {
            update(type: .bitcoin)
        }
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
    
    func update(type: CryptoCreatureName) {
        geometry?.materials = [
            SCNMaterial(color: type.color()),
            SCNMaterial.invertedByY(image: type.frontImage()), // front
            SCNMaterial(image: type.backImage()) // back
        ]
    }
}
