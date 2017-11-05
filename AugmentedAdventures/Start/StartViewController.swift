//
//  ViewController.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class StartViewController: UIViewController, Controller {
    var type: ControllerType = .start
    weak var delegate: StartViewControllerDelegate?
    @IBOutlet var startView: UIView!
    
    
    @IBAction func navigateToRemote(_ sender: Any) {
        delegate?.navigateToRemote()
    }
    
    @IBAction func navigateToPortal(_ sender: Any) {
        delegate?.navigateToPortal()
    }
    
    @IBAction func navigateToAirport(_ sender: Any) {
        delegate?.navigateToAirport()
    }
    
}
