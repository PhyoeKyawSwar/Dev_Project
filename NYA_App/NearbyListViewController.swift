//
//  NearbyListViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 31/3/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import CoreLocation
import PKHUD
class NearbyListViewController: UIViewController {

    @IBOutlet weak var tblNear: UITableView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var shopArray = [Dictionary<String , Any>]()
    var category_id = Int()
    var user_Lat = 0.0
    var user_Long = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        // Do any additional setup after loading the view.
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
        APIFunction.sharedInstance.apiGETMethod(method: "categories/\(self.category_id)/shops_near_by?lat=\(user_Lat)&&lng=\(user_Long)") { (response) in
            if response.error == nil
            {
                if response.status == 200
                {
                    if let data = response.result as? Dictionary<String,Any>
                    {
                        if let data_array = data["data"] as? [Dictionary<String,Any>]
                        {
                            self.shopArray = data_array
                            
                            if self.shopArray.count > 0
                            {
                                OperationQueue.main.addOperation {
                                    self.tblNear.delegate = self
                                    self.tblNear.dataSource = self
                                    self.tblNear.reloadData()
                                    
                                }
                            }
                            else
                            {
                                self.showAlert(title: "Information", message: "No Shop found !")
                            }
                            
                        }
                        else
                        {
                            self.showAlert(title: "Information", message: "No Shop found !")
                        }
                        
                    }
                }
                else
                {
                    self.showAlert(title: "Information", message: "No Shop found !")
                }
                
            }
            DispatchQueue.main.async {
                HUD.hide()
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
extension NearbyListViewController : CLLocationManagerDelegate
{
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        user_Lat = location.coordinate.latitude
        user_Long = location.coordinate.longitude
        
        
        
        self.getNearByShops()
        
        
        
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

extension NearbyListViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyListTableViewCell") as! NearbyListTableViewCell
        let dict = shopArray[indexPath.row]
        cell.lblName.text = dict["name"] as? String ?? ""
        cell.lblAddress.text = dict["address"] as? String ?? ""
        cell.lblDistance.text = "\(dict["distance"] as? Float ?? 0.0) KM"
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = shopArray[indexPath.row]
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "ShopDetailViewController") as! ShopDetailViewController
        controller.shopID = dict["id"] as! Int
        controller.is_from_map = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
 
    
}
