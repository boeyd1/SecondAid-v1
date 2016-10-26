//
//  SignUpViewController.swift
//  SecondAid
//
//  Created by Desmond Boey on 26/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import ParseUI
import Parse


class SignUpViewController :UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 
    @IBOutlet weak var redCrossImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var experiencePickerView: UIPickerView!
    
    var pickerData : [String] = [String]()
    
    var arrayOfUITextFields : [UITextField]!

    
    var keyboardIsDisplayed = false
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        ActivityIndicator.startAnimating(self.view)
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        let oneSignal = appDelegate!.oneSignal
        
        var user = PFUser()
        
        oneSignal?.IdsAvailable({ (userID: String!, pushToken: String!) in
            
            user["oneSignalID"] = userID
            
            if !self.validateEmail(self.emailTextField.text!) {
                ErrorHandling.invalidEmail()
                ActivityIndicator.stopAnimating(self.view)
                return
            }
            user.email = self.emailTextField.text
            user.username = self.emailTextField.text
            
            if self.passwordTextField.text?.utf16.count < 6 {
                ErrorHandling.passwordTooShort()
                ActivityIndicator.stopAnimating(self.view)
                return
            }
            if self.passwordTextField.text != self.reEnterPasswordTextField.text {
                ErrorHandling.passwordDoNotMatch()
                ActivityIndicator.stopAnimating(self.view)
                return
            }
            user.password = self.passwordTextField.text
            user["passcode"] = user.password!.substringFromIndex(user.password!.endIndex.advancedBy(-4))
            
            if self.mobileNumberTextField.text!.utf16.count < 7 {
                ErrorHandling.invalidPhoneNum()
                ActivityIndicator.stopAnimating(self.view)
                return
            }
            user["phoneNumber"] = self.mobileNumberTextField.text
            user["firstAidExperience"] = self.pickerData[self.experiencePickerView.selectedRowInComponent(0)]
            
            user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) in
                if let error = error {
                    ErrorHandling.cannotSignup(error)
                }
                ActivityIndicator.stopAnimating(self.view)
                let alert = UIAlertController(title: "", message: "Signup Successful!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }

        })
    }
    
    override func viewDidLoad() {
        self.experiencePickerView.delegate = self
        self.experiencePickerView.dataSource = self
        
        pickerData = ["Part of Occupation", "First aid-certified", "Have knowledge", "No experience"]
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
            arrayOfUITextFields = [emailTextField, passwordTextField, reEnterPasswordTextField, mobileNumberTextField]
        
        for textFields in arrayOfUITextFields {
            textFields.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
            textFields.layer.borderWidth = 1.0
            textFields.layer.cornerRadius = 5
        }
        
        experiencePickerView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        experiencePickerView.layer.borderWidth = 1.0
        experiencePickerView.layer.cornerRadius = 5
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        for textFields in arrayOfUITextFields {
            textFields.text = ""
        }
        
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK: UIPicker delegate and datasource protocols
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
        pickerLabel.textAlignment = .Center
        pickerLabel.font = UIFont(name: "System", size: 13)
        pickerLabel.adjustsFontSizeToFitWidth = true
        pickerLabel.attributedText = myTitle
        
        return pickerLabel
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
    
    @IBOutlet weak var redCrossToTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackViewToTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackViewToCrossConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    
    func keyboardWillShow(notification: NSNotification){
        if keyboardIsDisplayed == false {
            
            redCrossToTopConstraint.active = false
            stackViewToTopConstraint.active = true
            stackViewToCrossConstraint.active = false
            redCrossImage.hidden = true
            stackViewHeightConstraint.active = true
            
            keyboardIsDisplayed = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if keyboardIsDisplayed == true {
            
            redCrossToTopConstraint.active = true
            stackViewToTopConstraint.active = false
            stackViewToCrossConstraint.active = true
            redCrossImage.hidden = false
            stackViewHeightConstraint.active = false
            
            keyboardIsDisplayed = false
        }
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail)
        
    }

}
