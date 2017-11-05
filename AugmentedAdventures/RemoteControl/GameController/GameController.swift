//
//  GameController.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 11/5/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import GameController
import GameplayKit
import SceneKit

class GameController: NSObject {
    
    weak var delegate: GameControllerDelegate?
    var droneData = DroneData()
    var overlay: Overlay?
    var reset: Bool = true
    
    var direction: vector_float2 {
        get {
            return droneData.direction
        }
        set {
            var direction = newValue
            let l = simd_length(direction)
            if l > 1.0 {
                direction *= 1 / l
            }
            droneData.direction = direction
            if reset == false {
                delegate?.updateDroneData(data: droneData)
            }
        }
    }
    
    private var gamePadCurrent: GCController?
    private var gamePadLeft: GCControllerDirectionPad?
    private var gamePadRight: GCControllerDirectionPad?
    
    private var scene: SCNScene?
    
    func setupGameController() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleControllerDidConnect),
            name: NSNotification.Name.GCControllerDidConnect, object: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleControllerDidDisconnect),
            name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        guard let controller = GCController.controllers().first else {
            return
        }
        registerGameController(controller)
    }
    
    @objc func handleControllerDidConnect(_ notification: Notification) {
        if gamePadCurrent != nil { return }
        guard let gameController = notification.object as? GCController else { return }
        registerGameController(gameController)
    }
    
    @objc func handleControllerDidDisconnect(_ notification: Notification) {
        guard let gameController = notification.object as? GCController else { return }
        if gameController != gamePadCurrent { return }
        unregisterGameController()
        for controller: GCController in GCController.controllers() where gameController != controller {
            registerGameController(controller)
        }
    }
    
    func registerGameController(_ gameController: GCController) {
        
        var buttonA: GCControllerButtonInput?
        var buttonB: GCControllerButtonInput?
        
        if let gamepad = gameController.extendedGamepad {
            self.gamePadLeft = gamepad.leftThumbstick
            self.gamePadRight = gamepad.rightThumbstick
            buttonA = gamepad.buttonA
            buttonB = gamepad.buttonB
        } else if let gamepad = gameController.gamepad {
            self.gamePadLeft = gamepad.dpad
            buttonA = gamepad.buttonA
            buttonB = gamepad.buttonB
        } else if let gamepad = gameController.microGamepad {
            self.gamePadLeft = gamepad.dpad
            buttonA = gamepad.buttonA
            buttonB = gamepad.buttonX
        }
        
        weak var weakController = self
        
        gamePadLeft!.valueChangedHandler = {(_ dpad: GCControllerDirectionPad, _ xValue: Float, _ yValue: Float) -> Void in
            guard let strongController = weakController else { return }
            strongController.droneData.direction = simd_make_float2(xValue, -yValue)
        }
        
        if let gamePadRight = self.gamePadRight {
            gamePadRight.valueChangedHandler = {(_ dpad: GCControllerDirectionPad, _ xValue: Float, _ yValue: Float) -> Void in
                guard let strongController = weakController else { return }
                strongController.droneData.altitude = simd_make_float2(xValue, yValue)
            }
        }
        
        buttonA?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let strongController = weakController else { return }
            strongController.action()
        }
        
        buttonB?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let strongController = weakController else { return }
            strongController.action()
        }
    }
    
    func unregisterGameController() {
        gamePadLeft = nil
        gamePadRight = nil
        gamePadCurrent = nil
        overlay!.showVirtualPad()
    }
    
    func action() {
        print("ACTION")
    }
}

extension GameController: ButtonOverlayDelegate {
    
    func didPress(_ button: ButtonOverlay) {
        
    }
    
    func willPress(_ button: ButtonOverlay) {
        
    }
}

extension GameController: PadOverlayDelegate {
    
    func padOverlayVirtualStickInteractionDidStart(_ padNode: PadOverlay) {
        if padNode == overlay!.controlOverlay!.leftPad {
            direction = float2(Float(padNode.stickPosition.x), Float(padNode.stickPosition.y))
            reset = false
        }
        if padNode == overlay!.controlOverlay!.rightPad {
            droneData.altitude = float2(Float(padNode.stickPosition.x), Float(padNode.stickPosition.y))
            reset = false
        }
    }
    
    func padOverlayVirtualStickInteractionDidChange(_ padNode: PadOverlay) {
        if padNode == overlay!.controlOverlay!.leftPad {
            print(padNode.stickPosition)
            direction = float2(Float(padNode.stickPosition.x), -Float(padNode.stickPosition.y))
            delegate?.changeAltitude(altitude: droneData.altitude.y)
            reset = false
        }
        
        if padNode == overlay!.controlOverlay!.rightPad {
            droneData.altitude = float2(Float(padNode.stickPosition.x), Float(padNode.stickPosition.y))
            delegate?.changeAltitude(altitude: droneData.altitude.y)
            reset = false
        }
    }
    
    func padOverlayVirtualStickInteractionDidEnd(_ padNode: PadOverlay) {
        if padNode == overlay!.controlOverlay!.leftPad {
            direction = [0, 0]
            reset = true
        }
        if padNode == overlay!.controlOverlay!.rightPad {
            droneData.altitude = [0, 0]
        }
    }
}
