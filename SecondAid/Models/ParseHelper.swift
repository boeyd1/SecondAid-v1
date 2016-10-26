//
//  ParseHelper.swift
//  SecondAid
//
//  Created by Desmond Boey on 13/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse
import CoreLocation

class ParseHelper {
    
    //parse user class
    static let ParseUserClass = "User"
    static let ParseUserPhoneNum = "phoneNumber"
    static let ParseUserLocation = "currLocation"
    static let ParseUserExperience = "firstAidExperience"
    static let ParseUserUsername = "username"
    static let ParseUserPassword = "password"
    
    //parse alerts class
    static let ParseAlertsClass = "Alerts"
    static let ParseAlertsCreatedAt = "createdAt"
    static let ParseAlertsFromUser = "fromUser"
    static let ParseAlertsDescription = "alertDescription"
    static let ParseAlertsNumOfResponders = "numOfResponders"
    static let ParseAlertsResponders = "responders"
    static let ParseAlertsLocation = "alertLocation"
    
    //MARK: ParseHelper functions
    
    //add a parameter to limit alerts to mapview rect region
    static func downloadAlerts (fromTime: NSDate, minsAgo: Double, completionBlock: PFQueryArrayResultBlock){
        
        let date = NSDate()
        let timeAgo = date.dateByAddingTimeInterval(-minsAgo * 60)
        
        let query = Alerts.query()
        query!.whereKey(ParseAlertsCreatedAt, greaterThanOrEqualTo: timeAgo)
        
        query!.orderByAscending(ParseAlertsNumOfResponders)
        query!.addAscendingOrder(ParseAlertsCreatedAt)
        
        query!.findObjectsInBackgroundWithBlock(completionBlock)
        
        /*
         do{
         try query!.findObjects()
         
         } catch let error as NSError{
         ErrorHandling.defaultErrorHandler(error)
         }
         */
        
        //retrieves all the alerts starting from fromTime
        //Parse data formatting: "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        
    }
 
    static func addCurrentResponderToAlert(alert: Alerts) {
        let user = PFUser.currentUser()!
        let relation = alert.relationForKey(ParseAlertsResponders)
        
        relation.addObject(user)
        alert.incrementKey(ParseAlertsNumOfResponders)
        do {
            try alert.save()
        }catch let error as NSError{
            ErrorHandling.defaultErrorHandler(error)
        }

    }
    
    static func removeCurrentResponderFromAlert(alert: Alerts) {
        let user = PFUser.currentUser()!
        let relation = alert.relationForKey(ParseAlertsResponders)
        
        relation.removeObject(user)
        alert.incrementKey(ParseAlertsNumOfResponders, byAmount: -1)
        do {
            try alert.save()
        }catch let error as NSError{
            ErrorHandling.defaultErrorHandler(error)
        }
    }
    
    static func getAlertsByDistAndTime(minsAgo: Double,currLocation: CLLocation, distInKm: Double, block: PFQueryArrayResultBlock) {
        
        let date = NSDate()
        let timeAgo = date.dateByAddingTimeInterval(-minsAgo * 60)
        
        let query = Alerts.query()
        query!.whereKey(ParseAlertsCreatedAt, greaterThanOrEqualTo: timeAgo)
        
        let userLocation = PFGeoPoint(location: currLocation)
        query!.whereKey(ParseAlertsLocation, nearGeoPoint: userLocation, withinKilometers: distInKm)
        query!.orderByAscending(ParseAlertsNumOfResponders)
        query!.addAscendingOrder(ParseAlertsCreatedAt)
        
        query!.findObjectsInBackgroundWithBlock(block)
    }
    
    static func currentUserResponded (alert: Alerts) -> Bool {
        var currUserResponded = false
        
        let query = Alerts.query()!
        query.whereKey(ParseAlertsResponders, equalTo: PFUser.currentUser()!)
        
        do{
            let alertResult = try query.findObjects() as? [Alerts]
            if alertResult != nil && alertResult!.contains(alert) {
                currUserResponded = true
            }
        
        }catch let error as NSError {
            ErrorHandling.defaultErrorHandler(error)
        }
        
        return currUserResponded
    }
    
    static func getNumOfResponders(alert: Alerts, block: PFIntegerResultBlock){
        let relation = alert.relationForKey(ParseAlertsResponders)
        relation.query().countObjectsInBackgroundWithBlock(block)
    }
    
        
    static func passwordMatchesWithCurrentUser (inputPasscode: String) -> Bool {
        
        let userInput =
        inputPasscode
        
        let actualPasscode = PFUser.currentUser()?.valueForKey("passcode") as? String
        print(actualPasscode)
    
        if userInput == actualPasscode {
            return true
        }
        
        return false
        
    }
}
//contains method needs to compare objectId and if they are the same they should be considered the same object
extension PFObject {
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
}



extension PFGeoPoint {
    
    func location() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}


//MARK: Unused codes

/*  static func uploadAlert (user: PFUser, description: String){
 let alertObject = PFObject(className: ParseAlertsClass)
 alertObject[ParseAlertsFromUser] = user
 alertObject[ParseAlertsDescription] = description
 
 alertObject.saveInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
 }
 
 *//*
    static func getCurrentLocation() -> PFGeoPoint{
        var currGeoPoint = PFGeoPoint()
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint?, error: NSError?) in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            if geoPoint != nil {
               currGeoPoint = geoPoint!
            }
        }
        
        return currGeoPoint
        
    }
    */