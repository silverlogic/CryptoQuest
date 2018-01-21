//
//  HealthBarNode.swift
//  CryptoQuest
//
//  Created by Vasilii Muravev on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import SceneKit

let healthBarBlockSize: CGFloat = evilBubbleRadius * 0.3
private let distanceBetween: CGFloat = healthBarBlockSize * 0.2
private var healthColor = UIColor.colorFromHexValue(0x00a651)
private var hittedColor = UIColor.colorFromHexValue(0xff0000)

class HealthBarNode: BaseNode {
    
    // MARK: - Public Instance Attributes
    private(set) var livesLeft: Int
    private var healthPoints: Int
    private weak var healthBoxesNode: BaseNode!
    
    
    // MARK: - Initializers
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("unavailable")
    }
    
    init(healthPoints: Int = 3) {
        self.healthPoints = max(healthPoints, 1)
        livesLeft = healthPoints
        super.init()
        addHealthBoxes()
    }
}


// MARK: - Public Instance Methods
extension HealthBarNode {
    func hitted() {
        guard livesLeft > 0 else {
            return
        }
        livesLeft -= 1
        let box = healthBoxesNode.childNodes[livesLeft].geometry as! SCNBox
        box.materials = [
            SCNMaterial(color: hittedColor)
        ]
    }
}


// MARK: - Private Instance Methods
private extension HealthBarNode {
    func addHealthBoxes() {
        let healthBar = BaseNode()
        for index in 0..<healthPoints {
            let box = healthBox()
            box.position = SCNVector3(
                CGFloat(index) * healthBarBlockSize + CGFloat(index) * distanceBetween,
                0.0,
                0.0
            )
            healthBar.addChildNode(box)
        }
        healthBar.position = SCNVector3(
            -(CGFloat(healthPoints) * healthBarBlockSize + CGFloat(healthPoints - 1) * distanceBetween) * 0.5 + healthBarBlockSize * 0.5,
            0.0,
            0.0
        )
        addChildNode(healthBar)
        healthBoxesNode = healthBar
    }
    
    func healthBox() -> BaseNode {
        let geometry = SCNBox(
            width: healthBarBlockSize,
            height: healthBarBlockSize,
            length: healthBarBlockSize,
            chamferRadius: healthBarBlockSize * 0.1
        )
        geometry.materials = [
            SCNMaterial(color: healthColor),       // back
//            SCNMaterial(color: healthColor),    // left
//            SCNMaterial(color: healthColor),      // front
//            SCNMaterial(color: healthColor),    // right
//            SCNMaterial(color: healthColor),    // top
//            SCNMaterial(color: healthColor)      // bottom
        ]
        return BaseNode(geometry: geometry)
    }
}
