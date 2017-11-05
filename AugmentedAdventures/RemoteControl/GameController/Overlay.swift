//
//  Overlay.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 11/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class Overlay: SKScene {
    
    private var overlayNode: SKNode
    public var controlOverlay: ControlOverlay?
    
    // MARK: - Initialization
    init(size: CGSize, controller: GameController) {
        overlayNode = SKNode()
        super.init(size: size)
        
        let w: CGFloat = size.width
        let h: CGFloat = size.height
        
        scaleMode = .resizeFill
        
        addChild(overlayNode)
        overlayNode.position = CGPoint(x: 0.0, y: h)
        
        controlOverlay = ControlOverlay(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: w, height: h))
        controlOverlay!.leftPad.delegate = controller
        controlOverlay!.rightPad.delegate = controller
        controlOverlay!.buttonA.delegate = controller
        controlOverlay!.buttonB.delegate = controller
        addChild(controlOverlay!)
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout2DOverlay() {
        overlayNode.position = CGPoint(x: 0.0, y: size.height)
    }
    
    func showVirtualPad() {
        controlOverlay!.isHidden = false
    }
    
    func hideVirtualPad() {
        controlOverlay!.isHidden = true
    }
}
