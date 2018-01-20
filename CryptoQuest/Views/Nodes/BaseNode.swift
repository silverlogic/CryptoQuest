//
//  BaseNode.swift
//  CryptoQuest
//
//  Created by Vasilii Muravev on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import SceneKit

typealias ActionNodeClosure = (_ node: SCNNode) -> Void

protocol ActionNodeProtocol: class {
    
    // MARK: - Instance Attributes
    var action: ActionNodeClosure? { get set }
}

class BaseNode: SCNNode, ActionNodeProtocol {
    
    // MARK: - ActionNodeProtocol Attributes
    var action: ActionNodeClosure?
    
    
    // MARK: - Initializers
    override init() {
        super.init()
    }
    
    init(geometry: SCNGeometry?) {
        super.init()
        self.geometry = geometry
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
