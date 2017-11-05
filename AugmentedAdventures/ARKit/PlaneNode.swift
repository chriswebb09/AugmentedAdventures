//
//  PlaneNode.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import ARKit

class Plane: SCNNode {
    
    var anchor: ARPlaneAnchor
    var occlusionNode: SCNNode?
    let occlusionPlaneVerticalOffset: Float = -0.01  // The occlusion plane should be placed 1 cm below the actual
    // plane to avoid z-fighting etc.
    var debugVisualization: PlaneDebugVisualization?
    var focusSquare: FocusSquare?
    
    init(_ anchor: ARPlaneAnchor, _ showARPlaneVisualizations: Bool, _ shouldUseGrassPlane: Bool, _ shouldUseOrigin: Bool) {
        self.anchor = anchor
        super.init()
        self.showARPlaneVisualizations(showARPlaneVisualizations, shouldUseGrassPlane, shouldUseOrigin)
        createOcclusionNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ anchor: ARPlaneAnchor) {
        self.anchor = anchor
        debugVisualization?.update(anchor)
        updateOcclusionNode()
    }
    
    func showARPlaneVisualizations(_ show: Bool, _ shouldUseGrassPlane: Bool, _ shouldUseOrigin: Bool) {
        if show {
            if debugVisualization == nil {
                DispatchQueue.global().async {
                    self.debugVisualization = PlaneDebugVisualization(anchor: self.anchor, shouldUseGrassPlane: shouldUseGrassPlane, shouldUseOrigin: shouldUseOrigin)
                    DispatchQueue.main.async {
                        self.addChildNode(self.debugVisualization!)
                    }
                }
            }
        } else {
            debugVisualization?.removeFromParentNode()
            debugVisualization = nil
        }
    }
    
    // MARK: Private
    
    private func createOcclusionNode() {
        // Make the occlusion geometry slightly smaller than the plane.
        let occlusionPlane = SCNPlane(width: CGFloat(anchor.extent.x - 0.05), height: CGFloat(anchor.extent.z - 0.05))
        let material = SCNMaterial()
        material.colorBufferWriteMask = []
        material.isDoubleSided = true
        occlusionPlane.materials = [material]
        
        occlusionNode = SCNNode()
        occlusionNode!.geometry = occlusionPlane
        occlusionNode!.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
        occlusionNode!.position = SCNVector3Make(anchor.center.x, occlusionPlaneVerticalOffset, anchor.center.z)
        self.addChildNode(occlusionNode!)
    }
    
    private func updateOcclusionNode() {
        guard let occlusionNode = occlusionNode, let occlusionPlane = occlusionNode.geometry as? SCNPlane else {
            return
        }
        occlusionPlane.width = CGFloat(anchor.extent.x - 0.05)
        occlusionPlane.height = CGFloat(anchor.extent.z - 0.05)
        
        occlusionNode.position = SCNVector3Make(anchor.center.x, occlusionPlaneVerticalOffset, anchor.center.z)
    }
}
