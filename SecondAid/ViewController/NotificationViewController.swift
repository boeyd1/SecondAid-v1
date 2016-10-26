//
//  NotificationViewController.swift
//  SecondAid
//
//  Created by Desmond Boey on 9/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation
import Parse
import ParseUI
import RealmSwift

class NotificationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    //drag the tableview and not the tableViewCell!
    @IBOutlet weak var alertTableView: UITableView!
    
    @IBAction func unwindToNotificationViewController(segue: UIStoryboardSegue) {
    }
    
    var alerts: [Alerts] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.mapView.delegate = self
        
        NotificationHelper.notification.addObserver(self, selector: #selector(NotificationViewController.reloadMapAndTableView), name: NotificationHelper.ntfnInitialLocationSet, object: nil)
        //download alerts
        NotificationHelper.notification.addObserver(self, selector: #selector(NotificationViewController.viewDidAppear(_:)), name: NotificationHelper.ntfnAppEnteredForeground, object: nil)

<<<<<<< HEAD
=======
 
>>>>>>> parent of a01ba04... updated json
    }
 
    override func viewDidAppear(animated: Bool) {
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            return
        }
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways{
            ErrorHandling.mapWillNotLoadWarning()
        }else{
            LocMgr.sharedInstance.startUpdatingLocation()
            if let _ = LocMgr.sharedInstance.lastLocation {
                reloadMapAndTableView()
            }
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "displayRespondView" {
                let indexPath = alertTableView.indexPathForSelectedRow!
                
                let alert = alerts[indexPath.row]
                
                let respondToNotificationController = segue.destinationViewController as! RespondToNotficationController
                
                respondToNotificationController.alert = alert
            }
            
        }
    }
    
    func updateViewWithParseData(fromMinsAgo: Double){
        guard let currLocation = LocMgr.sharedInstance.lastLocation else {
            return
        }
        
        //download the alerts that are only within map view
        
        mapView.removeAnnotations(mapView.annotations)
        
        ParseHelper.getAlertsByDistAndTime(fromMinsAgo, currLocation: currLocation, distInKm: (RealmHelper.getDistance()/1000)) { (result: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            
            self.alerts = result as? [Alerts] ?? []
            self.alertTableView.reloadData()
            
            let alertsNearMe = result as? [Alerts]
            
            if let thisAlert = alertsNearMe {
                for alert in thisAlert {
                    
                    let annotation = PointColorAnnotation.createAnnotationForAlert(alert)
                    
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func reloadMapView(){
        let center = LocMgr.sharedInstance.getCenter()
        let existingDist = RealmHelper.getDistance()
        let region = MKCoordinateRegionMakeWithDistance(center, existingDist, existingDist)
        
        self.mapView.setRegion(region, animated: false)

    }
    
    //MARK: AnnotationView methods
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "greenPin")
        
        //so that all information, including color, is captured in the passed in annotation 
        let pointColorAnnotation = annotation as! PointColorAnnotation
        
        pinView.pinTintColor = pointColorAnnotation.pinColor
        pinView.annotation = annotation
        
        pinView.canShowCallout = true
        
        return pinView
    }
}

//need to link (ctrl+drag) from tableview in main.storyboard to the viewcontroller icon (yellow circle with white square) to allow it to be controlled by view controller
extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //use an array that stores all the alerts (alerts limited to last 10 mins)
        return alerts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlertTableViewCell") as! alertTableViewCell
        
        //set active alert in the relevant row
        let activeAlert = alerts[indexPath.row]
        
        cell.delegate = self
        
        cell.alert = activeAlert
        
        return cell
        
    }
}

extension NotificationViewController : AlertTableViewCellDelegate {
    func reloadMapAndTableView(){
        reloadMapView()
        updateViewWithParseData(10)
        print("reloadMapAndTableView")
    }
}


/* uncomment when need to make map populate with alerts and annotations based on user decision of map view
 func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
 let viewRegion = mapView.region
 }
 */

