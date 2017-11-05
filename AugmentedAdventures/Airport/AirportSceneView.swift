//
//  AirportSceneView.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 11/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import ARKit
import SceneKit

class AirportSceneView: ARSCNView {
    
    var airportNode: SCNNode!
    var planeNode: SCNNode!
    
    var runway: SCNNode!
    
    func setupScene() {
        scene = SCNScene()
        airportNode = nodeWithModelName("Models.scnassets/airfield/airfieldrunway.scn")
        airportNode.castsShadow = true
        // setupPlane()
    }
    
    func addAircraft(hitResult: ARHitTestResult, yOffset: Float)     {
        let  yOffset = 0.3
        DispatchQueue.main.async {
            for node in self.planeNode.childNodes {
                node.transform = SCNMatrix4Mult(node.transform, SCNMatrix4MakeRotation(-Float(Double.pi) / 2, 1, 0, 0))
                node.scale = SCNVector3(x: 0.25, y:0.25, z: 0.25)
            }
            
        }
        let size = planeNode.boundingBox.max
        let planeGeometry = SCNBox(width : CGFloat(size.x), height : CGFloat(size.y / 2), length: CGFloat(size.z), chamferRadius:0)
        let planeShape = SCNPhysicsShape(geometry: planeGeometry, options: nil)
        planeNode.physicsBody = SCNPhysicsBody(type : .dynamic, shape: planeShape)
        planeNode.physicsBody?.allowsResting = true 
        planeNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                        Float(yOffset), hitResult.worldTransform.columns.3.z)
        scene.rootNode.addChildNode(planeNode)
    }
    
    func moveTo(vector: SCNVector3) {
        DispatchQueue.main.async {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            self.planeNode.position = SCNVector3(self.planeNode.position.x + vector.x, self.planeNode.position.y, self.planeNode.position.z + vector.z)
            SCNTransaction.commit()
        }
    }
    
    func changeAltitude(value: Float) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        planeNode.position = SCNVector3(planeNode.position.x, planeNode.position.y + value, planeNode.position.z)
        SCNTransaction.commit()
    }
}
