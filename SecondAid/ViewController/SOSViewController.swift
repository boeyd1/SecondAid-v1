//
//  SOSViewController.swift
//  SecondAid
//
//  Created by Desmond Boey on 9/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import CoreLocation




class SOSViewController: UIViewController {
    
    @IBOutlet weak var lightBulb: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    
    //cannot have outlets connected in main storyboard but not included in the code here
    @IBOutlet weak var victimConditionTextView: UITextView!
    @IBOutlet weak var otherInfoTextView: UITextView!
    
    //cannot use @IBOutlet var collectionView: Array<UITextView>?
    var arrayOfUITextViews : [UITextView]!
    
    var alertViewController : UIAlertController!
    
    var keyboardIsDisplayed = false
    
    //weak var delegate : PasswordPromptDelegate?
    
    @IBAction func helpButtonTapped(sender: AnyObject) {
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways{
            ErrorHandling.locationServiceNotEnabledError()
            return
        }
        
        if !helpButton.selected {
            let promptUserForPassword = PasswordPrompt()
            alertViewController = promptUserForPassword.createPrompt()
            
            promptUserForPassword.delegate = self
            
            self.presentViewController(alertViewController, animated: true, completion: nil)
        }else{
            loadDefaultView()
            if let collectionOfViews = self.arrayOfUITextViews {
                for textViews in collectionOfViews{
                    textViews.text = ""
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // assign alert view controller
        
        
        //assign UITextViews to predefined array
        arrayOfUITextViews = [victimConditionTextView,otherInfoTextView]
        
        setTextViewBorder(arrayOfUITextViews)
        
        loadDefaultView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Keyboard Fix
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
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
    
    @IBOutlet weak var stackViewToBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonToBottomConstraintTemp: NSLayoutConstraint!
    @IBOutlet weak var buttonToBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewToButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    func keyboardWillShow(notification: NSNotification){
        if keyboardIsDisplayed == false {
            stackViewToButtonConstraint.active = false
            stackViewToBottomConstraint.active = true
            buttonToBottomConstraint.active = false
            buttonToBottomConstraintTemp.active = true
            stackViewHeightConstraint.active = true
            
            view.frame.origin.y -= getKeyboardHeight(notification)
            
            keyboardIsDisplayed = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if keyboardIsDisplayed == true {
            stackViewToButtonConstraint.active = true
            stackViewToBottomConstraint.active = false
            buttonToBottomConstraint.active = true
            buttonToBottomConstraintTemp.active = false
            stackViewHeightConstraint.active = false
            
            view.frame.origin.y += getKeyboardHeight(notification)
            
            keyboardIsDisplayed = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: Load views
    func setTextViewEditing (textViewArray: [UITextView]) {
        if let collectionOfViews = self.arrayOfUITextViews {
            for textViews in collectionOfViews {
                if helpButton.selected {
                    textViews.editable = false
                    textViews.scrollRangeToVisible(NSMakeRange(0, 0))
                    textViews.textColor = UIColor.lightGrayColor()
                }
                else {
                    textViews.editable = true
                    textViews.textColor = UIColor.blackColor()
                }
            }
        }
    }
    
    func setTextViewBorder(textViewArray: [UITextView]){
        if let collectionOfViews = self.arrayOfUITextViews {
            for textViews in collectionOfViews {
                textViews.layer.borderWidth = 1.0
                textViews.layer.cornerRadius = 3
                textViews.layer.borderColor = UIColor.lightGrayColor().CGColor
            }
        }
    }
    
    func loadAlertSentView(){
        self.helpButton.selected = true
        self.lightBulb.image = UIImage(named: "LightbulbRed")
        self.infoLabel.text = "Alert Sent!"
        
        setTextViewEditing(arrayOfUITextViews)
        
    }
    
    func loadDefaultView(){
        self.helpButton.selected = false
        lightBulb.image = UIImage(named: "LightbulbOff")
        self.infoLabel.text = " "
        
        setTextViewEditing(arrayOfUITextViews)
        
    }
    
    //MARK: Upload alerts
    
    func uploadAlert(){
        //code for sending alert info to parse
        LocMgr.sharedInstance.startUpdatingLocation()
        var arrayOfAlerterInputText = [String]()
        if let collectionOfViews = self.arrayOfUITextViews {
            for textViews in collectionOfViews{
                arrayOfAlerterInputText.append(textViews.text)
            }
        }
        let alert = Alerts()
        
        //put coordinates in here
        
        let currentLocation = LocMgr.sharedInstance.lastLocation
        
        
        /* PFGeoPoint doesn't require specifying lat and lon
         let currLocCoord : (Double,Double) = (currentLocation!.coordinate.latitude, currentLocation!.coordinate.longitude)
         */
        
        alert.uploadAlert(arrayOfAlerterInputText, location: currentLocation)
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        let oneSignal = appDelegate!.oneSignal
        
        oneSignal?.promptLocation()
        
        oneSignal?.postNotification(["contents": ["en": "Test Message"], "include_player_ids": ["f9f444b9-672d-429c-9e02-790bc26aa191","f0d80c03-5a53-4c12-be5a-ce69e04161f5","20a192b4-e0e0-40fe-a160-d13e075cda1e","610509cd-44a2-4274-94d0-bcac54edfc51"]], onSuccess: { (_: [NSObject : AnyObject]!) in
            print ("success")
            }, onFailure: { (error: NSError!) in
                print("error")
        })
        
    }
}


extension SOSViewController : PasswordPromptDelegate {
    
    func passwordSubmitted(inputPassword: String) {
        
        let passwordMatch = ParseHelper.passwordMatchesWithCurrentUser(inputPassword)
        
        if passwordMatch {
            loadAlertSentView()
            uploadAlert()
        }
        else{
            setTextViewEditing(arrayOfUITextViews)
            infoLabel.text = "Incorrect password. Please try again!"
        }
    }
}