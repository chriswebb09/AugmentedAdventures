//
//   SCNNode+Utilties.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import SceneKit

// MARK: - SCNNode extension

extension SCNNode {
    
    func setUniformScale(_ scale: Float) {
        self.scale = SCNVector3Make(scale, scale, scale)
    }
    
    func renderOnTop() {
        self.renderingOrder = 2
        if let geom = self.geometry {
            for material in geom.materials {
                material.readsFromDepthBuffer = false
            }
        }
        for child in self.childNodes {
            child.renderOnTop()
        }
    }
    
    func rotateObject(degreesHorizontal: CGFloat, degreesVertical: CGFloat) {
        let rotateAction1 = SCNAction.rotateBy(x: 0, y: CGFloat(degreesVertical.toRadians), z: CGFloat(degreesHorizontal.toRadians), duration: 0.01)
        self.runAction(SCNAction.sequence([rotateAction1]))
    }
    
    
    
    func moveForward(by meters: Float) {
        position = SCNVector3(position.x, position.y, position.z - meters)
    }
    
    func pitchUp(by degree: Float) {
        eulerAngles.x = degree
    }
    
    func increaseAltitude(by meters: Float) {
        position = SCNVector3(position.x, position.y + meters, position.z)
    }
    
}

func nodeWithModelName(_ modelName: String) -> SCNNode {
    return SCNScene(named: modelName)!.rootNode.clone()
}
