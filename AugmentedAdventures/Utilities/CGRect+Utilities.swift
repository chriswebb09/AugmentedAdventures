//
//  CGRect+Utilities.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

// MARK: - CGRect extensions

extension CGRect {
    
    var mid: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
