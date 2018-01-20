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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.session.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}


extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        guard let cameraVector = sceneView.session.currentFrame?.cameraVector() else {
//            return
//        }
//        print(cameraVector.direction * 100)
    }
}


// MARK: - UIResponder
extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        throwTheBall()
//        guard let touchLocation = touches.first?.location(in: sceneView) else { return }
//        let results = sceneView.hitTest(touchLocation, options: [.boundingBoxOnly: true])
//        guard let result = results.first else { return }
    }
}


// MARK: - Private Instance Methods
private extension ViewController {
    func throwTheBall() {
        guard let cameraVector = sceneView.session.currentFrame?.cameraVector() else {
            return
        }
//        let direction = SCNVector3(10.0, 10.0, -10.0)
        let ball = BallNode()
        ball.position = cameraVector.position
        sceneView.scene.rootNode.addChildNode(ball)
        let gravity = sceneView.scene.physicsWorld.gravity
        let forceVector = ball.position.forceVector(
            to: cameraVector.direction * 10,
            by: 1,
            with: gravity
        )
        ball.physicsBody?.applyForce(forceVector, asImpulse: true)
        print(forceVector)
    }
}
