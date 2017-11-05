//
//  AirportViewController.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 11/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import ARKit
import SceneKit

class AirportViewController: UIViewController, Controller {
    
    var type: ControllerType = .airport
    var arState: ARState = .reset
    var gameController: GameController?
    
    private var planes: [String : SCNNode] = [:]
    private var showPlanes: Bool = true
    
    var bottomNode: SCNNode!
    @IBOutlet weak var sceneView: AirportSceneView!
    
    var floorLocated: Bool = false
    var anchors: [ARAnchor] = []
    var airportPlaced: Bool = false
    var floorNode: SCNNode!
    var planeCanFly: Bool = false
    
    var nodeGenerator = NodeGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runSession()
        sceneView.setupScene()
        gameController = GameController()
        let overlay = Overlay(size: sceneView.bounds.size, controller: gameController!)
        sceneView.overlaySKScene = overlay
        gameController?.overlay = overlay
        gameController?.setupGameController()
        gameController?.delegate = self
        self.configureWorldBottom()
    }
    
    func runSession() {
        sceneView.delegate = self
        self.sceneView.scene.physicsWorld.contactDelegate = self
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.worldAlignment = .gravityAndHeading
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
    
    private func configureWorldBottom() {
        //let bottom = SCNPlane(width: 400000, height: 5400)
        let bottomPlane = SCNBox(width: 40000000, height: 0.015, length: 4000000, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(white: 1.0, alpha: 0.0)
        bottomPlane.materials = [material]
        
        let bottomNode = SCNNode(geometry: bottomPlane)
        bottomNode.position = SCNVector3(x: 0, y: -8, z: 0)
        let physicsBody = SCNPhysicsBody(type: .static , shape: SCNPhysicsShape(geometry: bottomPlane, options:[:]))
        physicsBody.categoryBitMask = CollisionTypes.bottom.rawValue
        physicsBody.contactTestBitMask = CollisionTypes.shape.rawValue
        bottomNode.physicsBody = physicsBody
        
        self.sceneView.scene.rootNode.addChildNode(bottomNode)
        self.sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let key = planeAnchor.identifier.uuidString
        let planeNode = NodeGenerator.generatePlaneFrom(planeAnchor: planeAnchor, physics: true, hidden: !self.showPlanes)
        node.addChildNode(planeNode)
        self.planes[key] = planeNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let key = planeAnchor.identifier.uuidString
        if let existingPlane = self.planes[key] {
            NodeGenerator.update(planeNode: existingPlane, from: planeAnchor, hidden: !self.showPlanes)
        }
    }
    
    private func nodeForScene(sceneName: String , nodeName: String) -> SCNNode? {
        let scene  =  SCNScene(named :sceneName)!
        return scene.rootNode.childNode(withName : nodeName, recursively : true)
    }
}

extension AirportViewController: GameControllerDelegate {
    func updateDroneData(data: DroneData) {
        let xWithSpeed = data.direction.x / 4
        let zWithSpeed = data.direction.y / 4
        let vector = SCNVector3(x: Float(xWithSpeed), y: sceneView.planeNode.position.y, z: Float(zWithSpeed))
        sceneView.moveTo(vector: vector)
    }
    
    func changeAltitude(altitude: Float) {
        let altChange = altitude / 4
        sceneView.changeAltitude(value: altChange)
    }
}

extension AirportViewController: ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        if hitResults.count > 0 {
            let result: ARHitTestResult = hitResults.first!
            self.sceneView.planeNode = nodeWithModelName("Models.scnassets/F15/fighter.scn")
            self.sceneView.scene.rootNode.addChildNode(self.sceneView.planeNode)
            sceneView.addAircraft(hitResult: result, yOffset: -10)
        }
    }
    
    func selectExistinPlane(location: CGPoint) {
        let hitResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        if hitResults.count > 0 {
            let result: ARHitTestResult = hitResults.first!
            if let planeAnchor = result.anchor as? ARPlaneAnchor {
                for var index in 0...anchors.count - 1 {
                    if anchors[index].identifier != planeAnchor.identifier {
                        sceneView.node(for: anchors[index])?.removeFromParentNode()
                    }
                    index += 1
                }
                anchors = [planeAnchor]
                // setPlaneTexture(node: sceneView.node(for: anchors[0])!)
            }
        }
    }
}






