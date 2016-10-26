//
//  ContainerViewController.swift
//  SecondAid
//
//  Created by Desmond Boey on 11/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var redCrossButton: UIButton!
    @IBOutlet weak var availabilityStatusLabel: UILabel!
    
    @IBAction func redCrossButtonTapped(sender: AnyObject) {
        if redCrossButton.selected == false {
            self.redCrossButton.selected = true
            self.availabilityStatusLabel.text = "(Busy)"
        }
        else {
            self.redCrossButton.selected = false
            self.availabilityStatusLabel.text = "(Available)"
        }
    }
    
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        let logoutPrompt = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .Alert)
        logoutPrompt.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        let confirm = UIAlertAction(title: "Confirm", style: .Default) { (action) in
            LocMgr.sharedInstance.stopUpdatingLocation()
            PFUser.logOut()
            self.performSegueWithIdentifier("unwindToLoginViewController", sender: self)
        }
        logoutPrompt.addAction(confirm)
        
        let window = UIApplication.sharedApplication().windows[0]
        window.rootViewController?.presentViewControllerFromTopViewController(logoutPrompt, animated: true, completion: nil)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
    }
    
    
    
}
