//
//  PortalViewController.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//
// Adapted From: https://github.com/bjarnel/arkit-portal

import ARKit
import SceneKit

class PortalViewController: UIViewController, Controller {
    
    var type: ControllerType = .portal
    
    @IBOutlet weak var planeSearchLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    
    private func updatePlaneOverlay() {
        DispatchQueue.main.async {
            self.planeSearchLabel.isHidden = self.currentPlane != nil
            if self.planeCount == 0 {
                self.planeSearchLabel.text = "Move around to allow the app the find a plane..."
            } else {
                self.planeSearchLabel.text = "Tap on a plane surface to place board..."
            }
        }
    }
    
    var planeCount = 0 {
        didSet {
            updatePlaneOverlay()
        }
    }
    
    var currentPlane:SCNNode? {
        didSet {
            updatePlaneOverlay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planeCount = 0
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = false
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(didTap))
        sceneView.addGestureRecognizer(tap)
    }
}

extension PortalViewController: ARSCNViewDelegate {
    
    // this func from Apple ARKit placing objects demo
    func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
        if sceneView.scene.lightingEnvironment.contents == nil {
            if let environmentMap = UIImage(named: "Media.scnassets/environment_blur.exr") {
                sceneView.scene.lightingEnvironment.contents = environmentMap
            }
        }
        sceneView.scene.lightingEnvironment.intensity = intensity
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        runSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func runSession() {
        sceneView.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.worldAlignment = .gravityAndHeading
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
    
    @objc func didTap(_ sender:UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        let results = sceneView.hitTest(location, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        guard results.count > 0,
            let anchor = results[0].anchor,
            let plane = sceneView.node(for: anchor) else { return }
        
        currentPlane = plane
        
        let wallNode = SCNNode()
        wallNode.position = SCNVector3.positionFromTransform(results[0].worldTransform)
        
        let sideLength = PortalConstants.Wall.length * 3
        let halfSideLength = sideLength * 0.5
        Portal.createEndWallSegment(with: wallNode, for: sideLength)
        Portal.createSideASegment(with: wallNode, for: sideLength)
        Portal.createSideBSegment(with: wallNode, for: sideLength)
        let doorSideLength = (sideLength - PortalConstants.Door.width) * 0.5
        Portal.createLeftDoorNode(with: wallNode, for: doorSideLength, halfSideLength: halfSideLength)
        Portal.createRightDoorNode(with: wallNode, for: doorSideLength, halfSideLength: halfSideLength)
        Portal.createNodeAboveDoor(with: wallNode)
        Portal.createFloorNode(with: wallNode)
        Portal.createRoofNode(with: wallNode)
        
        sceneView.scene.rootNode.addChildNode(wallNode)
        let floor = createFloor()
        let floorShadowNode = SCNNode(geometry:floor)
        floorShadowNode.position = SCNVector3.positionFromTransform(results[0].worldTransform)
        sceneView.scene.rootNode.addChildNode(floorShadowNode)
        setupLight(targetNode: floorShadowNode, position: SCNVector3.positionFromTransform(results[0].worldTransform))
    }
    
    func setupLight(targetNode: SCNNode, position: SCNVector3) {
        let light = createLight()
        let constraint = SCNLookAtConstraint(target: targetNode)
        constraint.isGimbalLockEnabled = true
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(position.x, position.y + Float(PortalConstants.Door.height), position.z - Float(PortalConstants.Wall.length))
        lightNode.constraints = [constraint]
        sceneView.scene.rootNode.addChildNode(lightNode)
    }
    
    /// MARK: - ARSCNViewDelegate
    
    // this func from Apple ARKit placing objects demo
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            if let lightEstimate = self.sceneView.session.currentFrame?.lightEstimate {
                self.enableEnvironmentMapWithIntensity(lightEstimate.ambientIntensity / 40)
            } else {
                self.enableEnvironmentMapWithIntensity(25)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        planeCount += 1
    }
}
