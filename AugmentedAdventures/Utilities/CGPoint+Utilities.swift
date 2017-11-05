//
//  CGPoint+Utilities.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import SceneKit

// MARK: - CGPoint extensions

extension CGPoint {
    
    init(_ size: CGSize) {
        self.x = size.width
        self.y = size.height
    }
    
    init(_ vector: SCNVector3) {
        self.x = CGFloat(vector.x)
        self.y = CGFloat(vector.y)
    }
    
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return (self - point).length()
    }
    
    func length() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
    
    func midpoint(_ point: CGPoint) -> CGPoint {
        return (self + point) / 2
    }
    
    func friendlyString() -> String {
        return "(\(String(format: "%.2f", x)), \(String(format: "%.2f", y)))"
    }
}
