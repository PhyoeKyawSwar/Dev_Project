
//
//  MapViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 17/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class annotation_Class: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var detail: NSDictionary!
    var title: String?
    var subtitle: String?
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
class MapViewController: UIViewController  {
    
    let locationManager = CLLocationManager()
    
    var custom_annotation = annotation_Class(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    
    @IBOutlet weak var mapView: MKMapView!
    var annotationArray = [MKAnnotation]()
    var user_Lat = 0.0
    var user_Long = 0.0
    var index = 0
    var category_id = 0
    
    var shopArray = [NearShop]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        print("Location service enable ",CLLocationManager.locationServicesEnabled())
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        locationManager.startUpdatingLocation()
        
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        
       // self.perform(#selector(self.getnearbyRestaurant), with: nil, afterDelay: 2.0)
        

        // Do any additional setup after loading the view.
    }
    
    func getNearByShops()
    {
        // shop_groups/1/shops_near_by?lat=16.840067&&lng=96.127909
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
                            self.shopArray = [NearShop]()
                            for dict in data_array
                            {
                                let d = dict as! NSDictionary
                                //  print("Dictionary",d)
                                let near = NearShop()
                                let dict = near.operateData(dataDict: dict)
                                self.shopArray.append(dict)
                                
                                    let latitude = dict.lat
                                    let longitude = dict.lng
                                    
                                    self.custom_annotation =  annotation_Class(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                                
                                    self.custom_annotation.title = dict.name
                                    self.custom_annotation.subtitle =  dict.address
                                    
                                    self.custom_annotation.detail = d
                                
                                    self.annotationArray.append(self.custom_annotation)
                                    self.mapView.addAnnotations(self.annotationArray)
                                
                                let latDelta:CLLocationDegrees = 0.05
                                
                                let lonDelta:CLLocationDegrees = 0.05
                                
                                let span = MKCoordinateSpanMake(latDelta, lonDelta)
                                
                                let location = CLLocationCoordinate2DMake(self.user_Lat, self.user_Long)
                                
                                let region = MKCoordinateRegionMake(location, span)
                                
                                self.mapView.setRegion(region, animated: false)
                                
                               
                            
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

    func getNearByShop_without_category()
    {
        let latDelta:CLLocationDegrees = 0.005
        
        let lonDelta:CLLocationDegrees = 0.005
        
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location = CLLocationCoordinate2DMake(user_Lat, user_Long)
        
        let region = MKCoordinateRegionMake(location, span)
        
        self.mapView.setRegion(region, animated: false)
        
        
        //shops_near_by?lat=16.840067&&lng=96.127909
        APIFunction.sharedInstance.apiGETMethod(method: "shops_near_by?lat=\(user_Lat)&&lng=\(user_Long)") { (response) in
            if response.error == nil
            {
                if response.status == 200
                {
                    if let dict = response.result as? Dictionary<String,Any>
                    {
                        if let data_array = dict["data"] as? [Dictionary<String,Any>]
                        {
                            self.shopArray = [NearShop]()
                            
                            for dict in data_array
                            {
                                let d = dict as! NSDictionary
                                //  print("Dictionary",d)
                                let near = NearShop()
                                let dict = near.operateData(dataDict: dict)
                                self.shopArray.append(dict)
                                
                                    let latitude = dict.lat
                                    let longitude = dict.lng
                                    
                                    self.custom_annotation =  annotation_Class(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                                    
                                    
                                    self.custom_annotation.title = dict.name
                                    self.custom_annotation.subtitle =  dict.address
                                    
                                    self.custom_annotation.detail = d
                                    
                                    self.annotationArray.append(self.custom_annotation)
                                    self.mapView.addAnnotations(self.annotationArray)
                            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func drawRoute(dest_Lat : Float , dest_Long : Float , Title : String)
    {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: user_Lat, longitude: user_Long), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(dest_Lat), longitude: CLLocationDegrees(dest_Long)), addressDictionary: nil))
        print("lat long",dest_Lat,dest_Long , user_Lat , user_Long)
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            print("Error",error?.localizedDescription)
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.add(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    

}

extension MapViewController : CLLocationManagerDelegate , MKMapViewDelegate
{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.fillColor = UIColor.red
        polylineRenderer.lineWidth = 2
        return polylineRenderer
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        user_Lat = Double(locValue.latitude)
        user_Long = Double(locValue.longitude)
        
        print("user lat \(user_Lat) user long \(user_Long)" )
        
        if category_id == 0
        {
            self.getNearByShop_without_category()
            
        }
        else
        {
            self.getNearByShops()
        }
        
        
        
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "Identifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        
        if let annotationView = annotationView {
            
            annotationView.canShowCallout = true
            annotationView.image = #imageLiteral(resourceName: "map_icon")
            annotationView.tag = index
            index += 1
            
            
        }
        
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as! annotation_Class
        print("sender tag",view.tag)
        
        let dict = shopArray[view.tag]
       /* let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "ShopDetailViewController") as! ShopDetailViewController
        controller.is_from_map = true
        controller.detail_Dict = annotation.detail
        self.navigationController?.pushViewController(controller, animated: true)
*/
        self.drawRoute(dest_Lat: Float(dict.lat), dest_Long: Float(dict.lng), Title: dict.name)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    /*func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as! annotation_Class
        print("sender tag",view.tag)
        
        let controller = story_board.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.DetailDict = annotation.detail
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        
        locationManager.stopUpdatingLocation()
        
    }
 */
    
}
