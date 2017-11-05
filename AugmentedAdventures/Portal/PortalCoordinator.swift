//
//  PortalCoordinator.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class PortalControllerCoordinator: ControllerCoordinator {
    
    var window: UIWindow
    
    var rootController: RootController!
    
    weak var delegate: ControllerCoordinatorDelegate?
    
    private var navigationController: UINavigationController {
        return UINavigationController(rootViewController: rootController)
    }
    
    var type: ControllerType {
        didSet {
            if let storyboard = try? UIStoryboard(.portal) {
                if let viewController: PortalViewController = try? storyboard.instantiateViewController() {
                    rootController = viewController
                }
            }
        }
    }
    
    init(window: UIWindow) {
        self.window = window
        type = .start
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

