//
//  ViewController.swift
//  SafeZone
//
//  Created by McCormack on 11/12/17.
//  Copyright © 2017 McCormack. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
//import Firebase

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    
    @IBOutlet weak var map: MKMapView!

    
    
    var myLocation = CLLocation()
    
    var groupLocation = CLLocation() //will need to get from user
    var groupLocRadius: Double = 500.0 //will need to get from user
    var wantsUpdate: Bool = false
  
    @IBAction func updateLoc(_ sender: UIBarButtonItem) {
        let somePoint1 = LocationPoint(title: "User1Location", locationName: "User1", coordinate: myLocation.coordinate)
        print(myLocation.coordinate)
        
        map.addAnnotation(somePoint1)
        
        locationManager.requestAlwaysAuthorization()
        
        let currRegion = CLCircularRegion(center: groupLocation.coordinate, radius: groupLocRadius, identifier: "SafeZone")
        locationManager.startMonitoring(for: currRegion)
        
        

    }
    
    
    func getFirebaseInfo(){
        
     //
        //var ref: DatabaseReference!
        
//        ref = Database.database().reference()
//        ref.
    }
    
    @IBAction func setDestination(_ sender: UIButton) {
        let address="Washington"
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            
            self.updateLocationView(newLocation: location)
            self.monitorRegionAtLocation(center: location.coordinate, identifier: "SafeZone")
        }
    
    }
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //completeSearchResults.delegate=(self as! MKLocalSearchCompleterDelegate)
    }
    
    func updateLocationView(newLocation: CLLocation) {
        
        let geoLocation = CLGeocoder()
        
        geoLocation.reverseGeocodeLocation(newLocation, completionHandler: { (data, error) -> Void in
            let mark = data!
            let loc: CLPlacemark = mark[0]
            self.map.centerCoordinate = newLocation.coordinate
            let areaAddress = loc.locality
            let reg = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500, 1500)
            self.map.setRegion(reg, animated: true)
            self.map.showsUserLocation = true
        })
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations[0]
        
        let accuracy = myLocation.horizontalAccuracy
        print("accuracy is \(accuracy)")
        
        //references Shrikar Archak
        //updateLocationView(myLocation: myLocation)
        

        
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
                let maxDistance = groupLocRadius
                let region = CLCircularRegion(center: center, radius: maxDistance, identifier: identifier)
                region.notifyOnExit = true
                locationManager.startMonitoring(for: region)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //alert if out of region
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            triggerLeftArea(regionID: identifier)
            
        }
    }
    
    func triggerLeftArea(regionID: String) {
        //alert everyone
        //called when user's location has crossed boundary and remained out for 20 seconds
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

