//
//  ErrorHandling.swift
//  SecondAid
//
//  Created by Desmond Boey on 13/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import ConvenienceKit

/**
 This struct provides basic Error handling functionality.
 */
struct ErrorHandling {
    
    static let ErrorTitle           = "Error"
    static let ErrorOKButtonTitle   = "Ok"
    static let ErrorDefaultMessage  = "Something unexpected occurred. Please try again!"
    static let ErrorDidNotUploadMessage = "Your alert could not be uploaded. Please try again!"
    
    static let ErrorWarningTitle = "Warning"
    static let ErrorIgnoreButtonTitle = "Ignore"
    static let ErrorMapWillNotLoadMessage = "Alerts will not show up because you either disabled or did not authorize SecondAid to use location services."
    
    static let ErrorLocationServiceDisabledMessage = "Alert cannot be sent because you either disabled or did not authorize SecondAid to use location services."
    
    static let ErrorWrongInputMessage = "Invalid email/password. Please try again."
    
    /**
     This default error handler presents an Alert View on the topmost View Controller
     */
    static func defaultErrorHandler(error: NSError) {
        
        let alert = UIAlertController(title: ErrorTitle, message: ErrorDefaultMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ErrorOKButtonTitle, style: UIAlertActionStyle.Default, handler: nil))
        
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)
    }
    
    /**
     A PFBooleanResult callback block that only handles error cases. You can pass this to completion blocks of Parse Requests
     */
    static func errorHandlingCallback(success: Bool, error: NSError?) -> Void {
        if let error = error {
            ErrorHandling.defaultErrorHandler(error)
        }
    }
    
    static func alertDidNotUploadErrorHandler(error: NSError) {
        let alert = UIAlertController(title: ErrorTitle, message: ErrorDidNotUploadMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ErrorOKButtonTitle, style: UIAlertActionStyle.Default, handler: nil))
        
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)
    }
    
    static func mapWillNotLoadWarning() {
        let alert = UIAlertController(title: ErrorWarningTitle, message: ErrorMapWillNotLoadMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ErrorIgnoreButtonTitle, style: .Cancel, handler: nil))
        let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
            if let url = NSURL(string: "prefs:root=LOCATION_SERVICES") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alert.addAction(openAction)
        
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)
    }
    
    
    static func locationServiceNotEnabledError() {
        let alert = UIAlertController(title: ErrorTitle, message: ErrorLocationServiceDisabledMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
            if let url = NSURL(string: "prefs:root=LOCATION_SERVICES") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alert.addAction(openAction)
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)

    }
    
    static func invalidLoginError(error: NSError) {
        
        let alert = UIAlertController(title: ErrorTitle, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ErrorOKButtonTitle, style: UIAlertActionStyle.Default, handler: nil))
        
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)
    }
    
    static func passwordDoNotMatch() {
        
        let alert = UIAlertController(title: ErrorTitle, message: "Password inputs do not match", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ErrorOKButtonTitle, style: UIAlertActionStyle.Default, handler: nil))
        
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)
    }

    static func passwordTooShort() {
        
        let alert = UIAlertController(title: ErrorTitle, message: "Password has to contain at least 6 characters", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ErrorOKButtonTitle, style: UIAlertActionStyle.Default, handler: nil))
        
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)
    }
    
    static func invalidPhoneNum() {
        
        let alert = UIAlertController(title: ErrorTitle, message: "Invalid phone number.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ErrorOKButtonTitle, style: UIAlertActionStyle.Default, handler: nil))
        
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)
    }
    
    static func invalidEmail() {
        
        let alert = UIAlertController(title: ErrorTitle, message: "Invalid email address.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ErrorOKButtonTitle, style: UIAlertActionStyle.Default, handler: nil))
        
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)
    }
    
    static func cannotSignup(error: NSError) {
        
        let alert = UIAlertController(title: ErrorTitle, message: "Signup cannot be processed. \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: ErrorOKButtonTitle, style: UIAlertActionStyle.Default, handler: nil))
        
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(alert, animated: true, completion: nil)
    }

    
    
}
