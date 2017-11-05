//
//  SCNVector3+Extension.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    func distance(to anotherVector: SCNVector3) -> Float {
        return sqrt(pow(anotherVector.x - x, 2) + pow(anotherVector.z - z, 2))
    }
    
    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    func distance(receiver:SCNVector3) -> Float{
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}

func createLight() -> SCNLight {
    let light = SCNLight()
    // [SceneKit] Error: shadows are only supported by spot lights and directional lights
    light.type = .spot
    light.spotInnerAngle = 70
    light.spotOuterAngle = 120
    light.zNear = 0.00001
    light.zFar = 5
    light.castsShadow = true
    light.shadowRadius = 200
    light.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    light.shadowMode = .deferred
    return light
}

func createFloor() -> SCNFloor {
    let floor = SCNFloor()
    floor.reflectivity = 0
    floor.firstMaterial?.diffuse.contents = UIColor.white
    floor.firstMaterial?.colorBufferWriteMask = SCNColorMask(rawValue: 0)
    return floor
}

