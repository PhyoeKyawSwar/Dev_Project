//
//  NearbyViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 8/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import CoreLocation
import PKHUD
import GoogleMaps
import GooglePlaces
import MapKit
import CoreLocation

class NearbyViewController: UIViewController {

    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    var isFromShopList  = Bool()
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    var user_Lat = 0.0
    var user_Long = 0.0
    var category_id = Int()
    var custom_annotation = annotation_Class(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    var annotationArray = [MKAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        
        placesClient = GMSPlacesClient.shared()
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: user_Lat,
                                              longitude: user_Long,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
      
        
        
        // Do any additional setup after loading the view.
    }
    
    func getNearByShop_without_category()
    {
        //shops_near_by?lat=16.840067&&lng=96.127909
    }
    
    
    
    /// for Route
    
  /*  func getDirections(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: @escaping ((_ status: String,_ success: Bool) -> Void)) {
        if let originLocation = origin {
            if let destinationLocation = destination {
                var directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
                
                directionsURLString = directionsURLString.addingPercentEscapes(using: .utf8)!
                
                let directionsURL = NSURL(string: directionsURLString)
                
                DispatchQueue.async(DispatchQueue.main, { () -> Void in
                    let directionsData = NSData(contentsOfURL: directionsURL!)
                    
                    var error: NSError?
                    let dictionary: Dictionary<NSObject, AnyObject> = NSJSONSerialization.JSONObjectWithData(directionsData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as Dictionary<NSObject, AnyObject>
                    
                    if (error != nil) {
                        println(error)
                        completionHandler(status: "", success: false)
                    }
                    else {
                        let status = dictionary["status"] as String
                        
                        if status == "OK" {
                            self.selectedRoute = (dictionary["routes"] as Array<Dictionary<NSObject, AnyObject>>)[0]
                            self.overviewPolyline = self.selectedRoute["overview_polyline"] as Dictionary<NSObject, AnyObject>
                            
                            let legs = self.selectedRoute["legs"] as Array<Dictionary<NSObject, AnyObject>>
                            
                            let startLocationDictionary = legs[0]["start_location"] as Dictionary<NSObject, AnyObject>
                            self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as Double, startLocationDictionary["lng"] as Double)
                            
                            let endLocationDictionary = legs[legs.count - 1]["end_location"] as Dictionary<NSObject, AnyObject>
                            self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as Double, endLocationDictionary["lng"] as Double)
                            
                            self.originAddress = legs[0]["start_address"] as String
                            self.destinationAddress = legs[legs.count - 1]["end_address"] as String
                            
                            self.calculateTotalDistanceAndDuration()
                            
                            completionHandler(status: status, success: true)
                        }
                        else {
                            completionHandler(status: status, success: false)
                        }
                    }
                })
            }
            else {
                completionHandler(status: "Destination is nil.", success: false)
            }
        }
        else {
            completionHandler(status: "Origin is nil", success: false)
        }
    }
    */
    func drowRoute(destination : String)
    {
        let origin = "\(user_Lat),\(user_Long)"
       // let destination = "16.817054,96.130976"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyBiA375drbfbPE26ciIN7CDFKUGeXbyZFw"
        
        print("url string",urlString)
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
                    print("Routes",routes)
                    self.mapView.clear()
                    
                    OperationQueue.main.addOperation({
                        for route in routes
                        {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points = routeOverviewPolyline.object(forKey: "points")
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3
                            
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            
                            polyline.map = self.mapView
                            
                        }
                    })
                }catch let error as NSError{
                    print("error:\(error)")
                }
            }
        }).resume()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNearByShops()
    {
       // shop_groups/1/shops_near_by?lat=16.840067&&lng=96.127909
        HUD.show(.systemActivity)
        ///categories/1/shops_near_by?
        //shop_groups/\(category_id)/shops_near_by?lat=\(user_Lat)&&lng=\(user_Long
        APIFunction.sharedInstance.apiGETMethod(method: "categories/\(category_id)/shops_near_by?lat=\(user_Lat)&&lng=\(user_Long)") { (response) in
            if response.error == nil
            {
                if response.status == 200
                {
                    if let dict = response.result as? Dictionary<String,Any>
                    {
                        if let data_array = dict["data"] as? [Dictionary<String,Any>]
                        {
                            for dict in data_array
                            {
                                let d = dict as! NSDictionary
                                //  print("Dictionary",d)
                                let near = NearShop()
                                let dict = near.operateData(dataDict: dict)
                                
                                
                                let latitude = dict.lat
                                let longitude = dict.lng
                                
                               // self.drowRoute(destination: "\(dict.lat),\(dict.lng)")
                                let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                let marker = GMSMarker(position: position)
                                marker.title = dict.name
                                marker.map = self.mapView
                                
                                self.custom_annotation =  annotation_Class(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                                
                                
                                self.custom_annotation.title = dict.name
                                self.custom_annotation.subtitle =  dict.address
                                
                                self.custom_annotation.detail = d
                                
                                self.annotationArray.append(self.custom_annotation)
                                
                                
                                
                                
                                
                            }
                            
                        }
                    }
                    else
                    {
                        self.showAlert(title: "Information", message: "Something Wrong !")
                    }
                    
                }
                else
                {
                    self.showAlert(title: "Error", message: (response.error?.localizedDescription)!)
                }
                
                self.locationManager.stopUpdatingLocation()
                
                
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NearbyViewController : CLLocationManagerDelegate
{
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        user_Lat = location.coordinate.latitude
        user_Long = location.coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        self.getNearByShops()
        
        
        if isFromShopList == false
        {
            self.getNearByShop_without_category()
        }
        
       // listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    
}


