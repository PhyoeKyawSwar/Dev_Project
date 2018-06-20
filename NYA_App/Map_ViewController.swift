//
//  Map_ViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 24/5/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class Map_ViewController: UIViewController {
    let locationManager = CLLocationManager()
    
    var custom_annotation = annotation_Class(coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    
   // var annotationArray = [MKAnnotation]()
    var user_Lat = 0.0
    var user_Long = 0.0
    
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    var index = 0
    var category_id = 0
    
    var shopArray = [NearShop]()
    var polyLineArray = [GMSPolyline]()
    
    var isFromShopDetail = Bool()
    var shopDetail = ShopDetail()
    
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
        
        placesClient = GMSPlacesClient.shared()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: user_Lat,
                                              longitude: user_Long,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
       // mapView.isHidden = true
 
        self.setupMapView(userLat: user_Lat, userLong: user_Long ,title: "Current Location" , address:  "" , id: 0)
        if isFromShopDetail == true
        {
            self.setupMapView(userLat: Double(shopDetail.lat), userLong: Double(shopDetail.lng), title: shopDetail.name, address: shopDetail.address , id: shopDetail.id)
        }
       
        // Do any additional setup after loading the view.
    }
    
   
    /*override func loadView() {
       
       /* let camera = GMSCameraPosition.camera(withLatitude: user_Lat, longitude: user_Long, zoom: zoomLevel)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isHidden = false
        view = mapView
        */
       
    }*/
    
    func setupMapView(userLat : Double , userLong : Double , title : String , address : String , id : Int)
    {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: userLat, longitude: userLong)
        marker.title = title
        if title == "Current Location"
        {
            marker.icon = #imageLiteral(resourceName: "current_location")
          
        }
        else
        {
            marker.icon = #imageLiteral(resourceName: "map_icon")
            
        }
        marker.snippet = address
        marker.userData = ["shopID" : id]
        marker.map = mapView
        
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNearByShops()
    {
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
                                
                              self.setupMapView(userLat: latitude, userLong: longitude ,title: dict.name, address: dict.address , id: dict.id)
                               
                               /* var current_location = CLLocationCoordinate2D()
                                current_location.latitude = self.user_Lat
                                current_location.longitude = self.user_Long
                                
                                var dest_location = CLLocationCoordinate2D()
                                dest_location.latitude = latitude
                                dest_location.longitude = longitude
                                
                                self.getPolylineRoute(from: current_location, to: dest_location)
 */
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
                                self.setupMapView(userLat: latitude, userLong: longitude ,title: dict.name , address:  dict.address,id: dict.id)
                                
                                /*var current_location = CLLocationCoordinate2D()
                                current_location.latitude = self.user_Lat
                                current_location.longitude = self.user_Long
                                
                                var dest_location = CLLocationCoordinate2D()
                                dest_location.latitude = latitude
                                dest_location.longitude = longitude
                                
                                self.getPolylineRoute(from: current_location, to: dest_location)
 */
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
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&key=AIzaSyB73WN2yHi3pGPCuonei0mcvGMLOs_XlJ4")!
        print("URL ::::::",url.absoluteString)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
               
            }
            else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        guard let routes = json["routes"] as? NSArray else {
                            DispatchQueue.main.async {
                                
                            }
                            return
                        }
                        
                        
                        if (routes.count > 0) {
                            for index in 0...routes.count - 1
                            {
                                
                                let overview_polyline = routes[index] as? NSDictionary
                                let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                                
                                let points = dictPolyline?.object(forKey: "points") as? String
                                
                                self.showPath(polyStr: points!)
                                
                                DispatchQueue.main.async {
                                    
                                    let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                                    let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(170, 30, 30, 30))
                                    self.mapView!.moveCamera(update)
                                }
                            }
                            
                            
                        }
                        else {
                            DispatchQueue.main.async {
                              
                            }
                        }
                    }
                }
                catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        
                    }
                }
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String){
        
        for line in polyLineArray
        {
            line.map = nil
        }
        
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline()
        polyline.path = path
        polyline.strokeWidth = 4.0
        polyline.strokeColor = UIColor.blue
        polyline.map = mapView // Your map view
        polyLineArray.append(polyline)
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

extension Map_ViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        user_Lat = Double(locValue.latitude)
        user_Long = Double(locValue.longitude)
        
         self.setupMapView(userLat: user_Lat, userLong: user_Long ,title: "Current Location" , address:  "" , id: 0)
        print("user lat \(user_Lat) user long \(user_Long)" )
        
        
        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude,
                                              longitude: locValue.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        if isFromShopDetail == false
        {
            if category_id == 0
            {
                self.getNearByShop_without_category()
                
            }
            else
            {
                self.getNearByShops()
            }
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
}
extension Map_ViewController: GMSMapViewDelegate {
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
        var userData = marker.userData as! [String : Int]
        var shopid = userData["shopID"]
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "ShopDetailViewController") as! ShopDetailViewController
        controller.is_from_map = false
        controller.shopID = shopid!
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
   /* func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("didTapMarker")
        
        var current_location = CLLocationCoordinate2D()
        current_location.latitude = user_Lat
        current_location.longitude = user_Long
        
        var dest_location = CLLocationCoordinate2D()
        dest_location.latitude = marker.position.latitude
        dest_location.longitude = marker.position.longitude
        self.getPolylineRoute(from: current_location, to: dest_location)
        
        return true
    }
 */
 
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        var current_location = CLLocationCoordinate2D()
        current_location.latitude = user_Lat
        current_location.longitude = user_Long
        
        var dest_location = CLLocationCoordinate2D()
        dest_location.latitude = marker.position.latitude
        dest_location.longitude = marker.position.longitude
        self.getPolylineRoute(from: current_location, to: dest_location)
        
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = marker.title
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = marker.snippet
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: 1.0)
        view.addSubview(lbl2)
        
        return view
    }

}
