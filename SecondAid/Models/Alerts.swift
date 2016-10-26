//
//  Alerts.swift
//  SecondAid
//
//  Created by Desmond Boey on 11/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse
import UIKit
import CoreLocation

class Alerts : PFObject, PFSubclassing {
    
    //allows direct assignment to columns in "Alerts" class in Parse
    @NSManaged var fromUser: PFUser
    @NSManaged var alertDescription: String
    @NSManaged var numOfResponders: Int
    @NSManaged var responders : PFRelation
    @NSManaged var alertLocation : PFGeoPoint
    
    
    
    //need to add this property in order to enable a background task
    //var alertUploadTask : UIBackgroundTaskIdentifier?
    
    //protocol (PFSubclassing): for Parse to recognize associated class
    static func parseClassName() -> String {
        return "Alerts"
    }
    
    //boilerplate
    override init () {
        super.init()
    }
    //boilerplate
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    func fetchAlerts(){
        //fetch alerts from Parse
        
        
    }
    
    func uploadAlert(descr: [String], location: CLLocation?){
        //upload alerts to Parse with description
        let descriptionInOneString = translateArrayToSingleString(descr)
        alertDescription = descriptionInOneString
        fromUser = PFUser.currentUser()!
        alertLocation = PFGeoPoint(location: location)
        
        
        do{
            try save()
        }catch let error as NSError{
            ErrorHandling.alertDidNotUploadErrorHandler(error)
        }
        
    }
    
    
    
    func translateArrayToSingleString (descriptionAsArray: [String]) -> String {
        var stringBuilder = "Victim's condition: "
        stringBuilder += "\(descriptionAsArray[0])  |  "
        stringBuilder += "Other information:"
        stringBuilder += "\(descriptionAsArray[1])"
        
        return stringBuilder
    }


}

extension NSDate {
    func hour() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        
        //Return Minute
        return minute
    }
    
    func seconds() -> Int
    {
        //Get Seconds
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Second, fromDate: self)
        let seconds = components.second
        
        //Return Seconds
        return seconds
    }

}
