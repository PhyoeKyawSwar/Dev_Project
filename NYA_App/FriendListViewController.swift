//
//  FriendListViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 18/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
import CoreLocation
class FriendListViewController: UIViewController {

    @IBOutlet weak var tblFriend: UITableView!
    var userArray = [User]()
    var search_userArray = [User]()
    var objMeta = MetaObject()
    var current_page = 1
    var friend_Array = [User]()
    
    var user_Lat = 0.0
    var user_Long = 0.0
    var forView = String()
    var fromPlan = false
    var forSearch = false
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
   
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet weak var btnClear: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = self.forView
      
        txtSearch.setSearchTextFieldLayout()
        self.txtSearch.autocorrectionType = .no
        
        if forView == "NearBy"
        {
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
            locationManager.delegate = self

        }
        else
        {
            self.getUser()
            
        }
        
        self.addDoneButtonOnKeyboard()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUser()
    {
        self.forSearch = false
        HUD.show(.systemActivity)
        //people_near_by?lat=16.840067&&lng=96.127909
        var urlString = ""
        if forView == "NearBy"
        {
             urlString = "people_near_by?lat=\(user_Lat)&&lng=\(user_Long)"
           
        }
        else
        {
            urlString = "users?page=\(current_page)"
        }
        APIFunction.sharedInstance.apiGETMethod(method: urlString ) { (response) in
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
                                let user = User()
                                let dict = user.operateUserData(dataDict: dict)
                                print("user info",dict.name,dict.unique_string)
                                self.userArray.append(dict)
                            }
                            
                            print("Data Array",self.userArray)
                            
                            if self.userArray.count > 0
                            {
                                DispatchQueue.main.async {
                                    self.tblFriend.rowHeight = 110
                                    self.tblFriend.estimatedRowHeight = UITableViewAutomaticDimension
                                    
                                    self.tblFriend.delegate = self
                                    self.tblFriend.dataSource = self
                                    self.tblFriend.reloadData()
                                }
                                
                            }
                        }
                        if let meta = dict["meta"] as? Dictionary<String,Any>
                        {
                            let meta_object = MetaObject()
                            self.objMeta = meta_object.operateData(dataDict: meta)
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
            
            DispatchQueue.main.async {
                HUD.hide()
            }
        }
    }
    
    func searchUser()
    {
        self.forSearch = true
        //search/user_by_name
        HUD.show(.systemActivity)
        
        APIFunction.sharedInstance.apiGETMethod(method: "search/user_by_name?name=\(txtSearch.text!)") { (response) in
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
                                let user = User()
                                let dict = user.operateUserData(dataDict: dict)
                                self.search_userArray.append(dict)
                            }
                            
                            print("Data Array",self.search_userArray)
                            
                            
                                DispatchQueue.main.async {
                                    self.tblFriend.rowHeight = 110
                                    self.tblFriend.estimatedRowHeight = UITableViewAutomaticDimension
                                    
                                    self.tblFriend.delegate = self
                                    self.tblFriend.dataSource = self
                                    self.tblFriend.reloadData()
                                }
                                
                            
                        }
                        if let meta = dict["meta"] as? Dictionary<String,Any>
                        {
                            let meta_object = MetaObject()
                            self.objMeta = meta_object.operateData(dataDict: meta)
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
            
            DispatchQueue.main.async {
                HUD.hide()
            }
        }
       /* let parameter = ["name" : txtSearch.text] as! Dictionary<String, String>
        APIFunction.sharedInstance.apiPOSTMethod(method: "search/user_by_name", parems: parameter ) { (response) in
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
                                let user = User()
                                let dict = user.operateUserData(dataDict: dict)
                                self.search_userArray.append(dict)
                            }
                            
                            print("Data Array",self.search_userArray)
                            
                            if self.search_userArray.count > 0
                            {
                                DispatchQueue.main.async {
                                    self.tblFriend.rowHeight = 110
                                    self.tblFriend.estimatedRowHeight = UITableViewAutomaticDimension
                                    
                                    self.tblFriend.delegate = self
                                    self.tblFriend.dataSource = self
                                    self.tblFriend.reloadData()
                                }
                                
                            }
                        }
                        if let meta = dict["meta"] as? Dictionary<String,Any>
                        {
                            let meta_object = MetaObject()
                            self.objMeta = meta_object.operateData(dataDict: meta)
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
 
            DispatchQueue.main.async {
                HUD.hide()
            }
 
        }
 */
    }

    @IBAction func onClickClear(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        txtSearch.text = ""
    }
    func addDoneButtonOnKeyboard(){
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.insert(flexSpace, at: 0)
        items.insert(done, at: 1)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.txtSearch.inputAccessoryView = doneToolbar
        
    }
    func doneButtonAction()
    {
        
        self.view.endEditing(true)
        //self.search_userArray = [User]()
        self.searchUser()
    }
    
    func addFriend(sender : UIButton)
    {
        var user = User()
        if forSearch == true
        {
            user = search_userArray[sender.tag]
        }
        else
        {
            user = userArray[sender.tag]
        }
        HUD.show(.systemActivity)
        let parameter  = ["requested_user_id":user.id] as! [String : Any]
        APIFunction.sharedInstance.USER_ID = user.id
        APIFunction.sharedInstance.url_string = "add_friend"
        APIFunction.sharedInstance.apiFunction(method: "add_friend", parameter: parameter, methodType: "POST") { (data, statusCode) in
            
            if statusCode == 201
            {
                DispatchQueue.main.async {
                   /* let indexPath = IndexPath(item: sender.tag, section: 0)
                    let cell = self.tblFriend.cellForRow(at: indexPath) as! FriendTableViewCell
                    
                    self.setButton(title: "Friend", color: BOTTOM_COLOR, btn: cell.btnAddFriend)
                    self.tblFriend.reloadRows(at: [indexPath], with: .none)
 
                     
 */
                    
                    let array = self.userArray
                    self.userArray = [User]()
                    
                    for id in 0...array.count - 1
                    {
                        if id != sender.tag
                        {
                            self.userArray.append(array[id])
                        }
                        else
                        {
                            let user = array[sender.tag]
                            user.friend_status = "Pending"
                            self.userArray.append(user)
                        }
                    }
                    
                    self.forView = "Friend"
                    self.tblFriend.reloadData()
                   // self.getUser()
                }
                self.showAlert(title: "Information", message: "Successfully added this user!")
            }
            else
            {
                self.showAlert(title: "Information", message: "Unable to add this user right now.")
            }
            DispatchQueue.main.async {
                HUD.hide()
            }
            
        }
    }
    
    func setButton (title : String , color : UIColor , btn : UIButton )
    {
        DispatchQueue.main.async {
            
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = color.cgColor
        
        btn.setTitleColor(color, for: .normal)
        btn.setTitle(title, for: .normal)
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

extension FriendListViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.forSearch == true
        {
            return search_userArray.count
        }
        else
        {
            return userArray.count
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell") as! FriendTableViewCell
        let dict = userArray[indexPath.row]
        print("User name",dict.name , dict.friend_status)
        cell.setData(data: dict , fromView : self.forView)
        
        cell.btnAddFriend.tag = indexPath.row
            if dict.friend_status == "no"
            {
                self.setButton(title: "Add Friend", color: GRAY_COLOR, btn: cell.btnAddFriend)
                
            }
            else if dict.friend_status == "confirmed"
            {
                self.setButton(title: "Friend", color: BOTTOM_COLOR, btn: cell.btnAddFriend)
                
            }
            else
            {
                self.setButton(title: "Pending", color: GRAY_COLOR, btn: cell.btnAddFriend)
                
            }
        
        cell.btnAddFriend.addTarget(self, action: #selector(self.addFriend(sender:)), for: .touchUpInside)
        let lastItemReached = dict.isEqual(self.userArray.last as! User)
        
        if fromPlan == true
        {
            cell.selectionStyle = UITableViewCellSelectionStyle.blue
        }
        else
        {
          cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        if self.forSearch == true
        {
            if lastItemReached && indexPath.row == self.search_userArray.count - 1 && self.current_page < objMeta.last_page
            {
                current_page += 1
                self.searchUser()
            }
        }
        else
        {
            if self.forView == "Friend"
            {
                if lastItemReached && indexPath.row == self.userArray.count - 1 && self.current_page <= objMeta.last_page
                {
                    current_page += 1
                    self.getUser()
                }
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if fromPlan == false
      {
        let dict = userArray[indexPath.row]
        let controller = AppStoryboard.User.instance.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        controller.is_User = false
        controller.User_Dict = dict
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
       
        }
        else
        {
            let cell = tableView.cellForRow(at: indexPath) as! FriendTableViewCell
            cell.imgCheck.image = #imageLiteral(resourceName: "check")
            friend_Array.append(userArray[indexPath.row])
            
            var user_array : [String : Any] = ["user_array" : friend_Array]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getUserArray"), object: nil, userInfo: user_array )
        }
        
       
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if fromPlan == false
        {
            let cell = tableView.cellForRow(at: indexPath) as! FriendTableViewCell
            
            cell.imgCheck.image = #imageLiteral(resourceName: "uncheck")
        }
    }
}

extension FriendListViewController : CLLocationManagerDelegate
{
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        user_Lat = location.coordinate.latitude
        user_Long = location.coordinate.longitude
        
       self.getUser()
        
        // listLikelyPlaces()
    }
    
    
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
