//
//  LogInViewController.swift
//  SecondAid
//
//  Created by Desmond Boey on 26/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LogInViewController: UIViewController {
    
    var keyboardIsDisplayed = false
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        ActivityIndicator.startAnimating(self.view)
        
        var user = PFUser()
        
        user.email = emailField.text
        user.password = passwordField.text
        
        PFUser.logInWithUsernameInBackground(user.email!, password: user.password!) { (user: PFUser?, error: NSError?) in
            if let error = error{
                ErrorHandling.invalidLoginError(error)
                self.emailField.text = ""
                self.passwordField.text = ""
            }
            
            
            if let currUser = user {
                let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
                
                let oneSignal = appDelegate!.oneSignal
                
                oneSignal?.IdsAvailable({(userID: String!, pushToken: String!) in
                    currUser["oneSignalID"] = userID
                    currUser.saveInBackground()
                })
                self.performSegueWithIdentifier("displayMainStoryboard", sender: self)
            }
        }
        ActivityIndicator.stopAnimating(self.view)
    }
    
    
    
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if PFUser.currentUser() != nil {
            performSegueWithIdentifier("displayMainStoryboard", sender: self)
        }
    }
    
    override func viewDidAppear(animated: Bool){
        emailField.text = ""
        passwordField.text = ""
        dismissKeyboard()
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    //to allow unwinding from signup VC to login VC : auto-segue from button click : manual ones have to given identifiers so that they can be referred to
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "displayMainStoryboard" {


                let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
                
                let oneSignal = appDelegate!.oneSignal
                
                oneSignal?.registerForPushNotifications()
                
                let _ = LocMgr.sharedInstance
                LocMgr.sharedInstance.startUpdatingLocation()
                
            }
        }
    }
    
    //MARK: Keyboard functions
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification){
        if keyboardIsDisplayed == false {
            
            view.frame.origin.y -= 30
            
            keyboardIsDisplayed = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if keyboardIsDisplayed == true {
            
            view.frame.origin.y += 30
            keyboardIsDisplayed = false
        }
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
