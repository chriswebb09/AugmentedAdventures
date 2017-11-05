//
//  Gremlins.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 11/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import ARKit
import SceneKit

class GremlinsViewController: UIViewController, Controller {
    var type: ControllerType = .gremlins
    
    @IBOutlet weak var sceneView: GremlinsSceneView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runSession()
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe))
        sceneView.addGestureRecognizer(swipeGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        sceneView.addGestureRecognizer(pinchGesture)
    }
    
    func runSession() {
        sceneView.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.worldAlignment = .gravityAndHeading
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
}

extension GremlinsViewController: ARSCNViewDelegate {
    
    @objc func handleSwipe(_ gestureRecognize: UIPanGestureRecognizer){
        if gestureRecognize.state == .changed {
            let translation = gestureRecognize.translation(in: self.view)
            let degreesHorizontal = translation.x / CGFloat(90)
            let degreesVertical = translation.y / CGFloat(90)
           // self.sceneView.pikachuNode.rotateObject(degreesHorizontal: degreesHorizontal, degreesVertical: degreesVertical)
          //  self.sceneView.pickachuFNode.rotateObject(degreesHorizontal: degreesHorizontal, degreesVertical: degreesVertical)
        }
    }
    
    
    @objc func handlePinch(_ pinchRecognize: UIPinchGestureRecognizer) {
        
        let scale = Float(pinchRecognize.scale / 10)
       /// let currentScale =  self.sceneView.pikachuNode.scale.x
      //  let newScale = scale / currentScale
       // self.sceneView.pikachuNode.scale.x = newScale
        //self.sceneView.pikachuNode.scale.y = newScale
        //self.sceneView.pikachuNode.scale.z = newScale
    }
}
