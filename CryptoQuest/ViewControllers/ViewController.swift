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

    // MARK: - Public Instance Attributes
    var spawn: Spawn!
    var isWarning: Bool = false
    

    // MARK: - Private Instance Attributes
    @IBOutlet var sceneView: ARSCNView!
    private weak var lightNode: SCNNode!
    private weak var cameraLightNode: SCNNode!
    private var contentScaleFactor: CGFloat = 1.3
    private var exposureOffset: CGFloat = -1
    private var minimumExposure: CGFloat = -1
    private var isSceneSetupFinished: Bool = false
    private weak var walletImageView: UIImageView!
    private weak var warningView: WarningView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}


// MARK: - ARSessionDelegate
extension ViewController: ARSessionDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard !isSceneSetupFinished,
              sceneView.session.currentFrame?.cameraVector() != nil else {
            return
        }
        isSceneSetupFinished = true
        guard !isWarning else {
            shitCoinsAttack()
            return
        }
        guard let typeName = spawn.cryptoCreatureMarker?.cryptoName,
              let type = CryptoCreatureName(rawValue: typeName) else {
            return
        }
        addFlyingCoin(with: type)
    }
    
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
        evilBubbleHitted(contact.nodeA as? EvilBubbleNode)
        evilBubbleHitted(contact.nodeB as? EvilBubbleNode)
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
        // Setup wallet image view
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Wallet"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(
            x: view.bounds.width * 0.05,
            y: view.frame.height,
            width: view.bounds.width * 0.9,
            height: view.bounds.width * 0.6
        )
        view.addSubview(imageView)
        walletImageView = imageView
        // Setup warning view.
        let warningView = WarningView(frame: view.bounds)
        view.addSubview(warningView)
        view.bringSubview(toFront: warningView)
        self.warningView = warningView
        if isWarning {
            warningView.startAlarming()
        }
    }
    
    func throwTheBall() {
        guard let cameraVector = sceneView.session.currentFrame?.cameraVector() else {
            return
        }
        let ball = BallNode()
        ball.position = cameraVector.position
        ball.eulerAngles = SCNVector3(0.0, CGFloat.pi * 0.5, 0.0)
        let forceVector = ball.position.forceVector(
            to: cameraVector.direction * 10,
            by: 1.0,
            with: sceneView.scene.physicsWorld.gravity
        )
        sceneView.scene.rootNode.addChildNode(ball)
        ball.physicsBody?.applyForce(forceVector, asImpulse: true)
    }
    
    func addFlyingCoin(with type: CryptoCreatureName = .bitcoin, xOffset: Float = 0.0, yOffset: Float = 0.0, zOffset: Float = -6.0, isMegaShit: Bool = false) {
//        guard let cameraVector = sceneView.session.currentFrame?.cameraVector() else {
//            return
//        }
        let bubble = EvilBubbleNode(type, isMegaShit: isMegaShit)
        bubble.position = SCNVector3(
            xOffset,
            yOffset,
            zOffset
        )
//        bubble.position = SCNVector3(
//            cameraVector.direction.x * (4.0 + Float(arc4random_uniform(800)) / 100),
//            cameraVector.direction.y,
//            cameraVector.direction.z * (4.0 + Float(arc4random_uniform(800)) / 100)
//        )
        sceneView.scene.rootNode.addChildNode(bubble)
        bubble.startFlyingRandomly()
        bubble.healthBar.look(at: sceneView.pointOfView!, offset: nil)
        bubble.action = { [weak self, weak bubble] _ in
            // Coin in the wallet!
            bubble?.removeFromParentNode()
            self?.walletImageView.shake()
            self?.hideWalletView()
        }
    }
    
    func showWalletView() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 1.0, animations: {
                guard var walletFrame = self?.walletImageView.frame else {
                    return
                }
                walletFrame.origin.y -= walletFrame.size.height
                self?.walletImageView.frame = walletFrame
            })
        }
    }
    
    func hideWalletView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            UIView.animate(withDuration: 1.0, animations: {
                guard var walletFrame = self?.walletImageView.frame else {
                    return
                }
                walletFrame.origin.y += walletFrame.size.height
                self?.walletImageView.frame = walletFrame
            })
        }
    }

    func evilBubbleHitted(_ evilBubble: EvilBubbleNode?) {
        guard let evilBubble = evilBubble else {
            return
        }
        evilBubble.hitted(sceneView.pointOfView!)
        guard evilBubble.healthBar.livesLeft == 0 else {
            return
        }
        showWalletView()
    }
    
    func shitCoinsAttack() {
        addFlyingCoin(with: .shitCoin, xOffset: -2.0, yOffset: 2.0, zOffset: -6.0)
        addFlyingCoin(with: .shitCoin, xOffset: -2.0, yOffset: -2.0, zOffset: -6.0)
        addFlyingCoin(with: .shitCoin, xOffset: 2.0, yOffset: 2.0, zOffset: -6.0)
        addFlyingCoin(with: .shitCoin, xOffset: 2.0, yOffset: -2.0, zOffset: -6.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.addFlyingCoin(with: .shitCoin, xOffset: 0.0, yOffset: 0.0, zOffset: -6.0, isMegaShit: true)
        }
    }
}
