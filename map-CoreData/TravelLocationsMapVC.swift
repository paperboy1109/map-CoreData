//
//  TravelLocationsMapVC.swift
//  map-CoreData
//
//  Created by Daniel J Janiak on 7/19/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsMapVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure the map */
        // map.delegate = self
        
        /* Configure the gesture recognizer */
        let touchAndHold = UILongPressGestureRecognizer(target: self, action: #selector(TravelLocationsMapVC.createNewAnnotation(_:)))
        touchAndHold.minimumPressDuration = 0.8
        
        mapView.addGestureRecognizer(touchAndHold)
        
    }
    
    
    // MARK: - Helpers
    
    func createNewAnnotation(gestureRecognizer:UIGestureRecognizer) {
        
        // Only save a location once for a given long press
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            /* Get the tapped location */
            
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            
            let newCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                
                var title = ""
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    print("There was an error with your request: \(error)")
                    return
                }
                
                /* GUARD: Was location data returned? */
                guard let placemarks = placemarks else {
                    print("No location data was returned")
                    return
                }
                
                /* Describe the tapped location */
                let newTravelLocation = placemarks[0]
                
                var subThoroughfare: String = ""
                var thoroughfare: String = ""
                var comma: String = ""
                var city: String = ""
                
                if newTravelLocation.locality != nil {
                    city = newTravelLocation.locality!
                }
                
                if newTravelLocation.thoroughfare != nil {
                    thoroughfare = newTravelLocation.thoroughfare!
                    comma = ","
                }
                
                if newTravelLocation.subThoroughfare != nil {
                    subThoroughfare = newTravelLocation.subThoroughfare!
                }
                
                title = "\(subThoroughfare) \(thoroughfare)\(comma) \(city)"
                
                if title == "" {
                    title = "Added \(NSDate())"
                }
                
                /* Create the new annotation */
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                annotation.title = title
                
                self.mapView.addAnnotation(annotation)
            }
            

        }
        
    }
    
    
    
    
    
    
    
}





