//
//  SelectFriendViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 11/3/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
class SelectFriendViewController: UIViewController {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var tblFriend: UITableView!
    
    var friend_Array = [User]()
    var  current_page = 1
    var objMeta = MetaObject()
    var userArray = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getUser()
        self.addDoneButtonOnKeyboard()
        self.txtSearch.setSearchTextFieldLayout()
        self.tblFriend.allowsMultipleSelection = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickClear(_ sender: Any) {
        self.txtSearch.text = ""
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
        self.searchUser()
      
    }
    
    func searchUser()
    {
        HUD.show(.systemActivity)
        self.userArray = [User]()
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
                                self.userArray.append(dict)
                            }
                            
                            
                            DispatchQueue.main.async {
                                
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
    }
    
    func getUser()
    {
        self.userArray = [User]()
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "friends?page=\(current_page)") { (response) in
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
                                self.userArray.append(dict)
                            }
                            
                            print("Data Array",self.userArray)
                            
                            if self.userArray.count > 0
                            {
                                DispatchQueue.main.async {
                                    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SelectFriendViewController : UITableViewDelegate ,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell") as! FriendTableViewCell
        let user = userArray[indexPath.row]
        
        
        if user.profile_picture.contains("/storage")
        {
            cell.imgUser.setUserimage(url_string: "\(image_url_host)\(user.profile_picture)")
            
        }
        else
        {
            cell.imgUser.setUserimage(url_string: user.profile_picture)
            
        }
        cell.lblName.setNormalLabel(text: user.name, color: BLACK_COLOR, size: 15.0, font_name: LIGHT_FONT)
        
        
        if  indexPath.row == self.userArray.count - 1 && self.current_page < objMeta.last_page
        {
            current_page += 1
            self.getUser()
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.accessoryType = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
       
            if let index = self.friend_Array.index(of: userArray[indexPath.row]) {
                self.friend_Array.remove(at: index)
            }
        
        var user_array : [String : Any] = ["user_array" : friend_Array]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getUserArray"), object: nil, userInfo: user_array )
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .checkmark
            self.friend_Array.append(userArray[indexPath.row])
            
        var user_array : [String : Any] = ["user_array" : friend_Array]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getUserArray"), object: nil, userInfo: user_array )
    }
}
