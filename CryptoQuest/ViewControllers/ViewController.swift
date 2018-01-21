//
//  ViewController.swift
//  CryptoQuest
//
//  Created by Emanuel  Guerrero on 1/20/18.
//  Copyright © 2018 SilverLogic, LLC. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    private weak var lightNode: SCNNode!
    private weak var cameraLightNode: SCNNode!
    private var contentScaleFactor: CGFloat = 1.3
    private var exposureOffset: CGFloat = -1
    private var minimumExposure: CGFloat = -1

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
//        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        addFlyingCoins()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}


// MARK: - ARSessionDelegate
extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        guard let cameraVector = sceneView.session.currentFrame?.cameraVector() else {
//            return
//        }
//        print(cameraVector.direction * 100)
    }
}


// MARK: - SCNPhysicsContactDelegate
extension ViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var evilBubble: EvilBubbleNode! = nil
        if contact.nodeA is EvilBubbleNode {
            evilBubble = contact.nodeA as? EvilBubbleNode
        } else if contact.nodeB is EvilBubbleNode {
            evilBubble = contact.nodeB as? EvilBubbleNode
        }
        guard evilBubble != nil else {
            return
        }
        evilBubble.healthBar.hitted()
//        var coinNode: CoinNode! = nil
//        let coinNodeA: CoinNode? = contact.nodeA.parentOfType()
//        let coinNodeB: CoinNode? = contact.nodeB.parentOfType()
//        if coinNodeA != nil {
//            coinNode = coinNodeA
//        } else if coinNodeB != nil {
//            coinNode = coinNodeB
//        }
//        guard coinNode != nil else {
//            return
//        }
//        coinNode.physicsBody?.clearAllForces()
    }
}


// MARK: - UIResponder
extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        throwTheBall()
    }
}


// MARK: - Private Instance Methods
private extension ViewController {
    
    /// Sets up the Scene.
    func setupScene() {
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.antialiasingMode = .multisampling4X
        sceneView.automaticallyUpdatesLighting = false
        sceneView.contentScaleFactor = contentScaleFactor
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            camera.exposureOffset = exposureOffset
            camera.minimumExposure = minimumExposure
        }
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = false
        sceneView.scene.physicsWorld.contactDelegate = self
        let lightNode = SCNNode()
        let light = SCNLight()
        light.type = SCNLight.LightType.ambient
        light.color = UIColor(white: 0.72, alpha: 1.0)
        lightNode.light = light
        sceneView.scene.rootNode.addChildNode(lightNode)
        self.lightNode = lightNode
        if let pointOfView = sceneView.pointOfView {
            let cameraLightNode = SCNNode()
            let cameraLight = SCNLight()
            cameraLight.type = SCNLight.LightType.omni
            cameraLight.color = UIColor(white: 0.95, alpha: 1.0)
            cameraLightNode.light = cameraLight
            cameraLightNode.position = SCNVector3Make(0, 1.2, 1.2)
            pointOfView.addChildNode(cameraLightNode)
            self.cameraLightNode = lightNode
        }
    }
    
    func throwTheBall() {
        guard let cameraVector = sceneView.session.currentFrame?.cameraVector() else {
            return
        }
        let ball = BallNode()
        ball.position = cameraVector.position
        let forceVector = ball.position.forceVector(
            to: cameraVector.direction * 10,
            by: 1.0,
            with: sceneView.scene.physicsWorld.gravity
        )
        sceneView.scene.rootNode.addChildNode(ball)
        ball.physicsBody?.applyForce(forceVector, asImpulse: true)
    }
    
    func addFlyingCoins() {
        let bubble = EvilBubbleNode()
        bubble.position = SCNVector3(0.0, 0.0, -8.0)
        sceneView.scene.rootNode.addChildNode(bubble)
        bubble.startFlyingRandomly()
        bubble.healthBar.look(at: sceneView.pointOfView!, offset: nil)
    }
}
