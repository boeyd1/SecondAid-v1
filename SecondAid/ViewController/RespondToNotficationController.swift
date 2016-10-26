//
//  RespondToNotficationController.swift
//  SecondAid
//
//  Created by Desmond Boey on 16/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation


class RespondToNotficationController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var comingButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var walkingRoute : MKRoute!

    @IBOutlet weak var directionView: UIPickerView!
    
    var directionData : [String] = [String]()
    
    @IBAction func comingButtonTapped(sender: AnyObject) {
        
        if let button = comingButton {
            if !button.selected {
                ParseHelper.addCurrentResponderToAlert(alert!)
                button.selected = true
            }
            else {
                ParseHelper.removeCurrentResponderFromAlert(alert!)
                button.selected = false
            }
        }
    }
    //add code to add directions from user to alerter
    
    var alert : Alerts!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        
        self.directionView.delegate = self
        self.directionView.dataSource = self
        
        if ParseHelper.currentUserResponded(alert){
            comingButton.selected = true
        }
        
        self.mapView.delegate = self
        
        let annotation = PointColorAnnotation.createAnnotationForAlert(alert)
        
        self.mapView.addAnnotation(annotation)
        
        let walkingRouteRequest = MKDirectionsRequest()
        
        walkingRouteRequest.source = MKMapItem.mapItemForCurrentLocation()
        
        walkingRouteRequest.transportType = MKDirectionsTransportType.Walking
        
        
        //creating destination
        let alertLocation = alert.alertLocation.location()
        let alertLocationPlacemark = MKPlacemark(coordinate: alertLocation.coordinate, addressDictionary: nil)
        let destination = MKMapItem(placemark: alertLocationPlacemark)
        
        
        walkingRouteRequest.destination = destination
        
        let walkingRouteDirections = MKDirections(request: walkingRouteRequest)
        
        walkingRouteDirections.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse?, error: NSError?) in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            
            
            let overlays = self.mapView.overlays
            self.mapView.removeOverlays(overlays)
            
            self.walkingRoute = response!.routes[0]
            self.mapView.addOverlay(self.walkingRoute.polyline, level: MKOverlayLevel.AboveRoads)
            
            self.mapView.setVisibleMapRect(self.walkingRoute.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(35.0, 35.0, 35.0, 35.0) , animated: true)
            
            for routeStep in self.walkingRoute.steps{
                self.directionData.append("\(routeStep.instructions) in \(Int(routeStep.distance))m")
            }
            self.directionView.reloadAllComponents()
        }
        
    }
    
    //MARK: Pickerview methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return directionData.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = directionData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
        pickerLabel.textAlignment = .Left
        pickerLabel.adjustsFontSizeToFitWidth = true
        pickerLabel.attributedText = myTitle
        pickerLabel.numberOfLines = 3
        return pickerLabel
    }

    
    //MARK: Mapview methods
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let draw = MKPolylineRenderer(overlay: overlay)
        draw.strokeColor = UIColor.purpleColor()
        draw.lineWidth = 3.0
        return draw
    }
    
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
