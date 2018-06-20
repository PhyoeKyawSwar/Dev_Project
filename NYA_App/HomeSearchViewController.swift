//
//  HomeSearchViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 17/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
class HomeSearchViewController: UIViewController {

   // @IBOutlet weak var btnShop: UIButton!
    //@IBOutlet weak var btnEvent: UIButton!
    @IBOutlet weak var tblSearch: UITableView!
    var searchText = String()
    
    @IBOutlet weak var segment: UISegmentedControl!
    var shopArray = [Dictionary<String , Any>]()
    var eventArray = [Event]()
    
    var forShop = true
    override func viewDidLoad() {
        super.viewDidLoad()

       // self.setButton(color: BOTTOM_COLOR, title: "Shop", btn: self.btnShop)
       // self.setButton(color: GRAY_COLOR, title: "Event", btn: self.btnEvent)
        
        self.title = searchText
        self.searchHome()
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    
    func searchHome()
    {
        //search/shop_and_event?name=
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "search/shop_and_event?name=\(searchText)") { (response) in
            if response.error == nil
            {
                if let dataDict = response.result as? Dictionary<String,Any>
                {
                    if response.status == 200
                    {
                        if let event_array = dataDict["events"] as? [Dictionary<String,Any>]
                        {
                            for e in event_array
                            {
                                let event = Event()
                                
                                let obj_event = event.operateEvent(dataDict: e)
                                self.eventArray.append(obj_event)
                            }
                           /* if self.eventArray.count == 0
                            {
                                 self.showAlert(title: "Information", message: "No Event found !")
                                
                            }
 */
                           
                        }
                        else
                        {
                            self.showAlert(title: "Information", message: "No Event found !")
                        }
                        
                        if let shop_array = dataDict["shops"] as? [Dictionary<String,Any>]
                        {
                            self.shopArray = shop_array
                            
                           /* if self.shopArray.count ==  0
                            {
                              self.showAlert(title: "Information", message: "No Shop found !")
                            }
 
 */
                            
                        }
                        else
                        {
                            self.showAlert(title: "Information", message: "No Shop found !")
                        }
                        
                        
                        DispatchQueue.main.async {
                            self.tblSearch.delegate = self
                            self.tblSearch.dataSource = self
                            self.tblSearch.reloadData()
                        }
                    }
                    else
                    {
                        self.showAlert(title: "Information", message: "Something Wrong")
                    }
                    
                    
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
    
    func setButton(color : UIColor , title : String , btn : UIButton)
    {
        btn.setTitleColor(color, for: .normal)
        btn.setTitle(title, for: .normal)
        
    }

    @IBAction func onClickSegment(_ sender: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0
        {
            forShop = true
            
        }
        else
        {
            forShop = false
        }
        self.searchHome()
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

extension HomeSearchViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forShop == true
        {
            return shopArray.count
        }
        else
        {
            return eventArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as! EventTableViewCell
        
        if forShop == true
        {
             cell.setShopData(event: shopArray[indexPath.row])
        }
        else
        {
            cell.setEventData(event: eventArray[indexPath.row])
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if forShop == true
        {
            let dict = shopArray[indexPath.row]
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "ShopDetailViewController") as! ShopDetailViewController
            controller.shopID = dict["id"] as! Int
            controller.is_from_map = false
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else
        {
            let dict = eventArray[indexPath.row]
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
            controller.Event_ID = dict.id
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
