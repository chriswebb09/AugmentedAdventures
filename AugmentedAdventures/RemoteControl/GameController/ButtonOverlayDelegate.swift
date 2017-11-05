//
//  ButtonOverlayDelegate.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 11/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import SpriteKit

protocol ButtonOverlayDelegate: NSObjectProtocol {
    func willPress(_ button: ButtonOverlay)
    func didPress(_ button: ButtonOverlay)
}
