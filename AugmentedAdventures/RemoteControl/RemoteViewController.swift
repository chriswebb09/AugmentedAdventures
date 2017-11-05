//
//  RemoteViewController.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision

class RemoteViewController: UIViewController, Controller {
    
    var type: ControllerType = .remoteControl
    var gameController: GameController?
    
    @IBOutlet weak var sceneView: DroneSceneView!
    
    var processing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.showsStatistics = true
        sceneView.setupDrone()
        gameController = GameController()
        let overlay = Overlay(size: sceneView.bounds.size, controller: gameController!)
        sceneView.overlaySKScene = overlay
        gameController?.overlay = overlay
        gameController?.setupGameController()
        gameController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

extension RemoteViewController: ARSCNViewDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        return nil
    }
}

extension RemoteViewController: ARSessionDelegate {
    
    // MARK: - ARSessionDelegate
    
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
    }
}

extension RemoteViewController: GameControllerDelegate {
    
    func updateDroneData(data: DroneData) {
        let xWithSpeed = data.direction.x / 4
        let zWithSpeed = data.direction.y / 4
        let vector = SCNVector3(x: Float(xWithSpeed), y: sceneView.helicopterNode.position.y, z: Float(zWithSpeed))
        sceneView.moveTo(vector: vector)
    }
    
    func changeAltitude(altitude: Float) {
        var altChange = altitude / 4
        sceneView.changeAltitude(value: altChange)
    }
}
