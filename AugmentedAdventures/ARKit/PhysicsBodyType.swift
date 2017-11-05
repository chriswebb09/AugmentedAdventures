//
//  PhysicsBodyType.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 11/4/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

enum PhysicsBodyType: Int {
    case projectile = 10 // ball
    case goalFrame = 11 // goal frame (cross bar)
    case plane = 12 // ground
    case goalPlane = 13  // goal scoring plane (detect goal)
}
