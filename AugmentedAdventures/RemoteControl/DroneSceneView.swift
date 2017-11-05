//
//  DroneSceneView.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 11/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import ARKit
import SceneKit

class DroneSceneView: ARSCNView {
    
    var helicopterNode: SCNNode!
    var blade1Node: SCNNode!
    var blade2Node: SCNNode!
    var rotorR: SCNNode!
    var droneData: DroneData = DroneData()
    var rotorL: SCNNode!
    
    func setupDrone() {
        scene = SCNScene(named: "Models.scnassets/gamedrone.scn")!
        helicopterNode = scene.rootNode.childNode(withName: "helicopter", recursively: false)
        helicopterNode.position = SCNVector3(helicopterNode.position.x, helicopterNode.position.y, helicopterNode.position.z - 1)
        blade1Node = helicopterNode?.childNode(withName: "Rotor_R_2", recursively: true)
        blade2Node = helicopterNode?.childNode(withName: "Rotor_L_2", recursively: true)
        rotorR = blade1Node?.childNode(withName: "Rotor_R", recursively: true)
        rotorL = blade2Node?.childNode(withName: "Rotor_L", recursively: true)
        styleDrone()
        spinBlades()
    }
    
    func styleDrone() {
        let bodyMaterial = SCNMaterial()
        bodyMaterial.diffuse.contents = UIColor.black
        helicopterNode.geometry?.materials = [bodyMaterial]
        scene.rootNode.geometry?.materials = [bodyMaterial]
        let bladeMaterial = SCNMaterial()
        bladeMaterial.diffuse.contents = UIColor.gray
        let rotorMaterial = SCNMaterial()
        rotorMaterial.diffuse.contents = UIColor.darkGray
        blade1Node.geometry?.materials = [rotorMaterial]
        blade2Node.geometry?.materials = [rotorMaterial]
        rotorR.geometry?.materials = [bladeMaterial]
        rotorL.geometry?.materials = [bladeMaterial]
    }
    
    func spinBlades() {
        let rotate = SCNAction.rotateBy(x: 0, y: 0, z: 200, duration: 0.5)
        let moveSequence = SCNAction.sequence([rotate])
        let moveLoop = SCNAction.repeatForever(moveSequence)
        rotorL.runAction(moveLoop)
        rotorR.runAction(moveLoop)
    }
    
    func moveTo(vector: SCNVector3) {
        DispatchQueue.main.async {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            self.helicopterNode.position = SCNVector3(self.helicopterNode.position.x + vector.x, self.helicopterNode.position.y, self.helicopterNode.position.z + vector.z)
            self.blade2Node.runAction(SCNAction.rotateBy(x: 0.1, y: 0, z: 0, duration: 1.5))
            self.blade1Node.runAction(SCNAction.rotateBy(x: 0.1, y: 0, z: 0, duration: 1.5))
            SCNTransaction.commit()
            self.blade2Node.runAction(SCNAction.rotateBy(x: -0.1, y: 0, z: 0, duration: 1.75))
            self.blade1Node.runAction(SCNAction.rotateBy(x: -0.1, y: 0, z: 0, duration: 1.75))
        }
    }
    
    func changeAltitude(value: Float) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        helicopterNode.position = SCNVector3(helicopterNode.position.x, self.helicopterNode.position.y + value, helicopterNode.position.z)
        SCNTransaction.commit()
    }
}
