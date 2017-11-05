//
//  Float+Extension.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 11/4/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

extension FloatingPoint {
    var toRadians: Self { return self * .pi / 180 }
    var toDegrees: Self { return self * 180 / .pi }
}
