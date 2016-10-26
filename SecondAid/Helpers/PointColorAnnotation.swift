//
//  PointColorAnnotation.swift
//  SecondAid
//
//  Created by Desmond Boey on 21/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PointColorAnnotation: MKPointAnnotation {
    
    var pinColor: UIColor
    
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
    
    static func createAnnotationForAlert(alert: Alerts) -> PointColorAnnotation{
        let annotation = PointColorAnnotation(pinColor: UIColor.redColor())
        
        if alert.numOfResponders > 0 {
            annotation.pinColor = UIColor.greenColor()
        }
        
        let alertLatitude = alert.alertLocation.latitude
        let alertLongitude = alert.alertLocation.longitude
        
        let clLocation = CLLocation(latitude: alertLatitude, longitude: alertLongitude)
        
        let alertCoordinate = CLLocationCoordinate2D(latitude: alertLatitude, longitude: alertLongitude)
        
        annotation.coordinate = alertCoordinate
        
        let annotationTitle = "\(alert.createdAt!.hour()):\(alert.createdAt!.minute())"
        
        annotation.title = annotationTitle
        
        let annotationSubtitle : String?
        
        let distanceFromUser = String(Int(clLocation.distanceFromLocation(LocMgr.sharedInstance.lastLocation!)))
        
        annotationSubtitle = ("Approx distance from me: \(distanceFromUser) metres")
        
        
        annotation.subtitle = annotationSubtitle
        
        return annotation
    }

}
