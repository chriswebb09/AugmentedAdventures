//
//  UIStoryboard+Extension.swift
//  AugmentedAdventures
//
//  Created by Christopher Webb-Orenstein on 10/31/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

// MARK: - Storyboard

extension UIStoryboard {
    
    // Enumeration of all storyboard names used in the app
    
    enum Storyboard: String {
        case start, remoteControl, portal, airport, gremlins
        
        // The name of the storyboard's file, returned with capitalization applied
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) throws {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>() throws -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            let error = StoryboardIdentifiableError.unrecognizedIdentifier
            print("\(error.localizedDescription): \(T.storyboardIdentifier)")
            throw error
        }
        return viewController
    }
}

// MARK: - Storyboard Identifiable Error

// MARK: - View Controller

extension UIViewController: StoryboardIdentifiable { }

