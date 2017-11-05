//
//  Wall.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import SceneKit

final class Portal {
    
    static func createMaskingWallSegment(width: CGFloat, height: CGFloat, length: CGFloat) -> SCNBox {
        let maskingWallSegment = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
        maskingWallSegment.firstMaterial?.diffuse.contents = UIColor.red
        maskingWallSegment.firstMaterial?.transparency = 0.000001
        maskingWallSegment.firstMaterial?.writesToDepthBuffer = true
        return maskingWallSegment
    }
    
    static func createSegmentNode(for geometry: SCNBox) -> SCNNode {
        let segmentNode = SCNNode(geometry: geometry)
        segmentNode.renderingOrder = 200
        segmentNode.position = SCNVector3(PortalConstants.Wall.width * 0.5, 0, 0)
        return segmentNode
    }
    
    class func plane(pieces: Int, maskYUpperSide: Bool = true) -> SCNNode {
        let maskSegment = Portal.createMaskingWallSegment(width: PortalConstants.Wall.length * CGFloat(pieces), height: PortalConstants.Wall.width, length: PortalConstants.Wall.length * CGFloat(pieces))
        let maskNode = SCNNode(geometry: maskSegment)
        maskNode.renderingOrder = 100
        let segment = Portal.createSegment(pieces: CGFloat(pieces))
        let segmentNode = Portal.createSegmentNode(for: segment)
        let node = SCNNode()
        node.addChildNode(segmentNode)
        maskNode.position = SCNVector3(PortalConstants.Wall.width * 0.5, maskYUpperSide ? PortalConstants.Wall.width : -PortalConstants.Wall.width, 0)
        node.addChildNode(maskNode)
        return node
    }
    
    static func createFloorNode(with wallNode: SCNNode) {
        let floorNode = Portal.plane(pieces: 3, maskYUpperSide: false)
        floorNode.position = SCNVector3(0, 0, 0)
        wallNode.addChildNode(floorNode)
    }
    
    static func createRoofNode(with wallNode: SCNNode) {
        let roofNode = Portal.plane(pieces: 3, maskYUpperSide: true)
        roofNode.position = SCNVector3(0, Float(PortalConstants.Wall.height), 0)
        wallNode.addChildNode(roofNode)
    }
    
    static func createEndWallSegment(with wallNode: SCNNode, for length: CGFloat)  {
        let endWallSegmentNode = Portal.portalWall(length: length, maskXUpperSide: true)
        endWallSegmentNode.eulerAngles = SCNVector3(0, 90.0.toRadians, 0)
        endWallSegmentNode.position = SCNVector3(0, Float(PortalConstants.Wall.height * 0.5), Float(PortalConstants.Wall.length) * -1.5)
        wallNode.addChildNode(endWallSegmentNode)
    }
    
    static func createSideASegment(with wallNode: SCNNode, for length: CGFloat) {
        let sideAWallSegmentNode = Portal.portalWall(length: length, maskXUpperSide: true)
        sideAWallSegmentNode.eulerAngles = SCNVector3(0, 180.0.toRadians, 0)
        sideAWallSegmentNode.position = SCNVector3(Float(PortalConstants.Wall.length) * -1.5, Float(PortalConstants.Wall.height * 0.5), 0)
        wallNode.addChildNode(sideAWallSegmentNode)
    }
    
    static func createSideBSegment(with wallNode: SCNNode, for length: CGFloat) {
        let sideBWallSegmentNode = Portal.portalWall(length: length, maskXUpperSide: true)
        sideBWallSegmentNode.position = SCNVector3(Float(PortalConstants.Wall.length) * 1.5, Float(PortalConstants.Wall.height * 0.5), 0)
        wallNode.addChildNode(sideBWallSegmentNode)
    }
    
    static func createLeftDoorNode(with wallNode: SCNNode, for doorSideLength: CGFloat, halfSideLength: CGFloat) {
        let leftDoorSideNode = Portal.portalWall(length: doorSideLength, maskXUpperSide: true)
        leftDoorSideNode.eulerAngles = SCNVector3(0, 270.0.toRadians, 0)
        leftDoorSideNode.position = SCNVector3(Float(-halfSideLength + 0.5 * doorSideLength), Float(PortalConstants.Wall.height) * Float(0.5), Float(PortalConstants.Wall.length) * 1.5)
        wallNode.addChildNode(leftDoorSideNode)
    }
    
    static func createRightDoorNode(with wallNode: SCNNode, for doorSideLength: CGFloat, halfSideLength: CGFloat) {
        let rightDoorSideNode = Portal.portalWall(length: doorSideLength, maskXUpperSide: true)
        rightDoorSideNode.eulerAngles = SCNVector3(0, 270.0.toRadians, 0)
        rightDoorSideNode.position = SCNVector3(Float(halfSideLength - 0.5 * doorSideLength), Float(PortalConstants.Wall.height) * Float(0.5), Float(PortalConstants.Wall.length) * 1.5)
        wallNode.addChildNode(rightDoorSideNode)
    }
    
    static func createNodeAboveDoor(with wallNode: SCNNode) {
        let aboveDoorNode = Portal.portalWall(length: PortalConstants.Door.width, height: PortalConstants.Wall.height - PortalConstants.Door.height)
        aboveDoorNode.eulerAngles = SCNVector3(0, 270.0.toRadians, 0)
        aboveDoorNode.position = SCNVector3(0, Float(PortalConstants.Wall.height) - Float(PortalConstants.Wall.height - PortalConstants.Door.height) * 0.5, Float(PortalConstants.Wall.length) * 1.5)
        wallNode.addChildNode(aboveDoorNode)
    }
    
    class func portalWall(length: CGFloat = PortalConstants.Wall.length, height: CGFloat = PortalConstants.Wall.height, maskXUpperSide: Bool = true) -> SCNNode {
        let node = SCNNode()
        let portalWallSegment = Portal.createPortalWallSegment(height: height, length: length)
        let wallSegmentNode = SCNNode(geometry: portalWallSegment)
        wallSegmentNode.renderingOrder = 200
        node.addChildNode(wallSegmentNode)
        let maskingWallSegment = Portal.createMaskingWallSegment(width: PortalConstants.Wall.width, height: height, length: length)
        let maskingWallSegmentNode = Portal.createMaskingWallSegmentNode(for: maskingWallSegment, maskXUpperSide: maskXUpperSide)
        node.addChildNode(maskingWallSegmentNode)
        return node
    }
    
    static func createMaskingWallSegmentNode(for geometry: SCNBox, maskXUpperSide: Bool) -> SCNNode {
        let maskingWallSegmentNode = SCNNode(geometry: geometry)
        maskingWallSegmentNode.renderingOrder = 100   //everything inside the portal area must have higher rendering order...
        maskingWallSegmentNode.position = SCNVector3(maskXUpperSide ? PortalConstants.Wall.width : -PortalConstants.Wall.width, 0, 0)
        return maskingWallSegmentNode
    }
    
    class func createSegment(pieces: CGFloat) -> SCNBox {
        let segment = Portal.createTexturedWallSegment(width: PortalConstants.Wall.length * pieces, height: PortalConstants.Wall.width, length: PortalConstants.Wall.length * pieces)
        return segment
    }
    
    class func createPortalWallSegment(height: CGFloat, length: CGFloat) -> SCNBox {
        let portalWallSegment = Portal.createTexturedWallSegment(width: PortalConstants.Wall.width, height: height, length: length)
        return portalWallSegment
    }
    
    static func createTexturedWallSegment(width: CGFloat, height: CGFloat, length: CGFloat) -> SCNBox {
        let texturedWallSegment = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
        texturedWallSegment.firstMaterial?.diffuse.contents = UIImage(named: "Media.scnassets/slipperystonework-albedo.png")
        texturedWallSegment.firstMaterial?.ambientOcclusion.contents = UIImage(named: "Media.scnassets/slipperystonework-ao.png")
        texturedWallSegment.firstMaterial?.metalness.contents = UIImage(named: "Media.scnassets/slipperystonework-metalness.png")
        texturedWallSegment.firstMaterial?.normal.contents = UIImage(named: "Media.scnassets/slipperystonework-normal.png")
        texturedWallSegment.firstMaterial?.roughness.contents = UIImage(named: "Media.scnassets/slipperystonework-rough.png")
        texturedWallSegment.firstMaterial?.writesToDepthBuffer = true
        texturedWallSegment.firstMaterial?.readsFromDepthBuffer = true
        return texturedWallSegment
    }
}
