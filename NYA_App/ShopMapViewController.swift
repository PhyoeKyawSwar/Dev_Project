//
//  ShopMapViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 19/5/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ShopMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var custom_annotation = annotation_Class(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    var annotationArray = [MKAnnotation]()
    var user_Lat = 0.0
    var user_Long = 0.0

    var detailShop = ShopDetail()
    
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
        
        self.setAnnotation()
        
        // Do any additional setup after loading the view.
    }
    
    func setAnnotation()
    {
      
        
        self.custom_annotation =  annotation_Class(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(detailShop.lat), longitude: CLLocationDegrees(detailShop.lng)))
        
        self.custom_annotation.title = detailShop.name
        self.custom_annotation.subtitle =  detailShop.address
        
        self.annotationArray.append(self.custom_annotation)
        self.mapView.addAnnotations(self.annotationArray)
        
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(detailShop.lat), longitude: CLLocationDegrees(detailShop.lng)), span: span)
        mapView.setRegion(region, animated: true)
        
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

}

extension ShopMapViewController : CLLocationManagerDelegate , MKMapViewDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        user_Lat = Double(locValue.latitude)
        user_Long = Double(locValue.longitude)
        print("user lat \(user_Lat) user long \(user_Long)" )
       
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
            
        }
        
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as! annotation_Class
        print("sender tag",view.tag)
        
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "ShopDetailViewController") as! ShopDetailViewController
        controller.is_from_map = true
        controller.detail_Dict = annotation.detail
        self.navigationController?.pushViewController(controller, animated: true)
        
        
        locationManager.stopUpdatingLocation()
        
    }
  
}

