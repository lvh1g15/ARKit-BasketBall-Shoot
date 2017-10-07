//
//  ViewController.swift
//  basketballthrow
//
//  Created by Landon Vago-Hughes on 06/10/2017.
//  Copyright © 2017 Landon Vago-Hughes. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var planes: [String:SCNNode] = [:]
    var keyuuid: String = ""
    var scene: SCNBox!
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeUp()
//        createBall()
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.scene.physicsWorld.contactDelegate = self
//        let basket = SCNParticleSystem(named: "model.dae", inDirectory: nil)
//        scene.addParticleSystem(basket!, transform: <#SCNMatrix4#>)
    }
    
    func swipeUp() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported {
            let configuration = ARWorldTrackingConfiguration()
            self.sceneView.session.run(configuration)
            configuration.planeDetection = .horizontal
        } else if ARConfiguration.isSupported {
            guard let configuration = ARSession().configuration else { return }
            self.sceneView.session.run(configuration)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @objc func handleGesture(_ sender: UISwipeGestureRecognizer) {
        // throw ball once created it
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("called")
        let sphere = SCNSphere(radius: 0.1)
        let ballNode = SCNNode(geometry: sphere)
        let camera = self.sceneView.pointOfView!
        let position = SCNVector3(x: 0, y: 0, z: -1)
        ballNode.position = camera.convertPosition(position, to: nil)
        ballNode.rotation = camera.rotation
        let physicsShape = SCNPhysicsShape(geometry: sphere, options: nil)
        let ballphysics = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
        ballphysics.mass = 1.5
        ballphysics.restitution = 0.5
        ballphysics.categoryBitMask = CollisionTypes.shape.rawValue
        ballNode.physicsBody = ballphysics
        sceneView.scene.rootNode.addChildNode(ballNode)
    }
    
    struct CollisionTypes : OptionSet {
        let rawValue: Int
        
        static let bottom  = CollisionTypes(rawValue: 1 << 0)
        static let shape = CollisionTypes(rawValue: 1 << 1)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let plane = SCNBox(width: CGFloat(planeAnchor.extent.x), height: 0.005, length: CGFloat(planeAnchor.extent.z), chamferRadius: 0)
        // Handle new plane
        self.scene = plane
        let color = SCNMaterial()
        color.diffuse.contents = UIColor(red: 0, green: 0, blue: 1, alpha: 0.3)
        plane.materials = [color]
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(planeAnchor.center.x, -0.005, planeAnchor.center.z)
        node.addChildNode(planeNode)
        let key = planeAnchor.identifier.uuidString
        self.keyuuid = key
        self.planes[key] = planeNode
        print(planeNode.position.x, planeNode.position.y, planeNode.position.z)
        let body = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: plane, options: nil))
        body.restitution = 0.0
        body.friction = 1.0
        planeNode.physicsBody = body
        let virtualNode = VirtualObjectNode()
        DispatchQueue.main.async(execute: {
            planeNode.addChildNode(virtualNode)
        })
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if self.planes.count != 0 {
            return
        }
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let key = planeAnchor.identifier.uuidString
        if let existingPlane = self.planes[key] {
            if let geo = existingPlane.geometry as? SCNBox {
                geo.width = CGFloat(planeAnchor.extent.x)
                geo.length = CGFloat(planeAnchor.extent.z)
            }
            existingPlane.position = SCNVector3Make(planeAnchor.center.x, -0.005, planeAnchor.center.z)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let key = planeAnchor.identifier.uuidString
        if let existingPlane = self.planes[key] {
            existingPlane.removeFromParentNode()
            self.planes.removeValue(forKey: key)
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

