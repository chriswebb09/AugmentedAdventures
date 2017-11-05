//
//  AirportViewController.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 11/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import ARKit
import SceneKit

class AirportViewController: UIViewController, Controller {
    var type: ControllerType = .airport
    
    @IBOutlet weak var sceneView: AirportSceneView!
    
}
