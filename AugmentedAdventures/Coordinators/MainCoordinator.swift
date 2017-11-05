//
//  MainCoordinator.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class MainCoordinator: AppCoordinator {
    
    weak var delegate: ControllerCoordinatorDelegate?
    
    var childCoordinators: [ControllerCoordinator] = []
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        transitionCoordinator(type: .start)
    }
    
    func addChildCoordinator(_ childCoordinator: ControllerCoordinator) {
        childCoordinator.delegate = self
        childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
}

extension MainCoordinator: ControllerCoordinatorDelegate {
    
    func transitionCoordinator(type: CoordinatorType) {
        
        // Remove previous application flow
        
        childCoordinators.removeAll()
        
        switch type {

        case .start:
            
            let startCoordinator = StartControllerCoordinator(window: window)
            addChildCoordinator(startCoordinator)
            startCoordinator.delegate = self
            startCoordinator.type = .start
            startCoordinator.start()
        case .app:
            print("remore")
            let remoteCoordinator = RemoteControllerCoordinator(window: window)
            addChildCoordinator(remoteCoordinator)
            remoteCoordinator.delegate = self
            remoteCoordinator.type = .remoteControl
            remoteCoordinator.start()
        case .portal:
            let portalCoordinator = PortalControllerCoordinator(window: window)
            addChildCoordinator(portalCoordinator)
            portalCoordinator.delegate = self
            portalCoordinator.type = .portal
            portalCoordinator.start()
        case .airport:
            let airportCoordinator = AirportControllerCoordinator(window: window)
            addChildCoordinator(airportCoordinator)
            airportCoordinator.delegate = self
            airportCoordinator.type = .airport
            airportCoordinator.start()
        }
    }
}
