//
//  StartCoordinator.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class StartControllerCoordinator: ControllerCoordinator {
    
    var window: UIWindow
    
    var rootController: RootController!
    
    weak var delegate: ControllerCoordinatorDelegate?
    
    private var navigationController: UINavigationController {
        return UINavigationController(rootViewController: rootController)
    }
    
    var type: ControllerType {
        didSet {
            if let storyboard = try? UIStoryboard(.start) {
                if let viewController: StartViewController = try? storyboard.instantiateViewController() {
                    viewController.delegate = self 
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

extension StartControllerCoordinator: StartViewControllerDelegate {
    
    func navigateToRemote() {
        self.delegate?.transitionCoordinator(type: .app)
    }
    
    func navigateToPortal() {
        delegate?.transitionCoordinator(type: .portal)
    }
}
