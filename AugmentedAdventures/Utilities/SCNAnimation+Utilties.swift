//
//  SCNAnimation+Utilties.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import SceneKit

extension SCNAnimation {
    
    static func fromFile(named name: String, inDirectory: String ) -> SCNAnimation? {
        let animScene = SCNScene(named: name, inDirectory: inDirectory)
        var animation: SCNAnimation?
        animScene?.rootNode.enumerateChildNodes({ (child, stop) in
            if !child.animationKeys.isEmpty {
                let player = child.animationPlayer(forKey: child.animationKeys[0])
                animation = player?.animation
                stop.initialize(to: true)
            }
        })
        
        animation?.keyPath = name
        
        return animation
    }
}

