//
//  ShopListViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 22/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
import CoreLocation
class ShopListViewController: _BaseViewController {
    
    @IBOutlet weak var tblShop: UITableView!
    var categoryID = Int()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var shopArray = [Dictionary<String , Any>]()
    
    var user_Lat = 0.0
    var user_Long = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            self.getShopList()
          
       
            
       
        // Do any additional setup after loading the view.
        
      
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getShopList()
    {
        HUD.show(.systemActivity)
        //self.showLoading(alertInitiate: true, title: "", message: "Getting Shop List")
        APIFunction.sharedInstance.apiGETMethod(method: "shop_groups/\(categoryID)/shops") { (response) in
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
                                    self.tblShop.delegate = self
                                    self.tblShop.dataSource = self
                                    self.tblShop.reloadData()
                                    
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
            else
            {
                self.showAlert(title: "Error", message: (response.error?.localizedDescription)!)
            }
            
            DispatchQueue.main.async {
                HUD.hide()
            }
           
            
        }
    }
    
    func getNearByShops()
    {
        // shop_groups/1/shops_near_by?lat=16.840067&&lng=96.127909
        HUD.show(.systemActivity)
        ///categories/1/shops_near_by?
        //shop_groups/\(category_id)/shops_near_by?lat=\(user_Lat)&&lng=\(user_Long
        APIFunction.sharedInstance.apiGETMethod(method: "categories/\(self.categoryID)/shops_near_by?lat=\(user_Lat)&&lng=\(user_Long)") { (response) in
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
                                    self.tblShop.delegate = self
                                    self.tblShop.dataSource = self
                                    self.tblShop.reloadData()
                                    
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

extension ShopListViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as! EventTableViewCell
        
        cell.setShopData(event: shopArray[indexPath.row])
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = shopArray[indexPath.row]
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "ShopDetailViewController") as! ShopDetailViewController
        controller.shopID = dict["id"] as! Int
        controller.is_from_map = false
        
        //controller.groupID = categoryID
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}



