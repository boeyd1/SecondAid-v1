//
//  LocMgr.swift
//  SecondAid
//
//  Created by Desmond Boey on 26/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class LocMgr: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocMgr()
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var initialLocation: CLLocation? {
        didSet{
            NotificationHelper.notification.postNotificationName(NotificationHelper.ntfnInitialLocationSet, object: self)
            print("initialLocation updated")
        }
    }
    
    var shouldUpdateInitialLocation: Bool?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 30
        locationManager.allowsBackgroundLocationUpdates = true
        
        
        print("start location updating")
        
        locationManager.delegate = self
        
        shouldUpdateInitialLocation = true
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
        shouldUpdateInitialLocation = true
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    func getCenter() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lastLocation!.coordinate.latitude,longitude: lastLocation!.coordinate.longitude)
    }
    
    // CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("LOCATION UPDATING")
        guard let location = locations.last else {
            return
        }
        
        // singleton for getting last location
        self.lastLocation = location
        
        if shouldUpdateInitialLocation! {
            self.initialLocation = location
            shouldUpdateInitialLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        //ErrorHandling.defaultErrorHandler(error)
    }
    
}