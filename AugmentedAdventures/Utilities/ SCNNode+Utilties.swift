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
}

