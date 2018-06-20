//
//  UserViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 28/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import SDWebImage
import PKHUD
class UserViewController: UIViewController {

    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var llbUsername: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblUser: UITableView!
    
    var  user_dict = Dictionary<String,Any>()
    var userDict = User()
    var tableArray = ["Timeline","Find Friends","People Nearby","Friend Request","Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgProfile.image = #imageLiteral(resourceName: "icon")
        imgProfile.layer.cornerRadius = 50
        imgProfile.clipsToBounds = true
        
       
        tblUser.delegate = self
        tblUser.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.getProfile()
        
    }
    
    func getProfile ()
    {
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "user") { (response) in
            print("Http status code",response.status)
           if response.error == nil
           {
            if response.status == 200
            {
                if let dict = response.result as? Dictionary<String,Any>
                {
                    self.user_dict = dict["data"] as! Dictionary<String,Any>
                    OperationQueue.main.addOperation {
                        
                        let user = User()
                        self.userDict = user.operateUserData(dataDict: self.user_dict)
                        self.llbUsername.setNormalLabel(text: self.userDict.name, color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
                        self.navigationItem.title = self.userDict.name
                        
                        if let profile_pic = UserDefaults.standard.value(forKey: "FB_PICTURE") as? String
                        {
                            if profile_pic != ""
                            {
                                 self.imgProfile.setUserimage(url_string: profile_pic)
                            }
                            else
                            {
                                self.imgProfile.setUserimage(url_string: "\(image_url_host)\(self.userDict.profile_picture)")
                                UserDefaults.standard.set(self.userDict.profile_picture, forKey: "User_Profile_Pic")
                            }
                           
                        }
                        else
                        {
                            self.imgProfile.setUserimage(url_string: "\(image_url_host)\(self.userDict.profile_picture)")
                            
                        }
                        
                        
                        UserDefaults.standard.set(self.userDict.name , forKey: "USER_NAME")
                        UserDefaults.standard.set(self.userDict.id , forKey: "USER_ID")
                        
                        
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

extension UserViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        cell.lblTitle.setNormalLabel(text: tableArray[indexPath.row], color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            let controller = AppStoryboard.User.instance.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            controller.User_Dict = userDict
            controller.is_User = true
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
       else if indexPath.row == 1
        {
            
            let controller = AppStoryboard.User.instance.instantiateViewController(withIdentifier: "FriendListViewController") as! FriendListViewController
           controller.forView = "Friend"
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if indexPath.row == 2
        {
            let controller = AppStoryboard.User.instance.instantiateViewController(withIdentifier: "FriendListViewController") as! FriendListViewController
            controller.forView = "NearBy"
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if indexPath.row == 3
        {
            let controller = AppStoryboard.User.instance.instantiateViewController(withIdentifier: "FriendRequestViewController") as! FriendRequestViewController
            controller.User_Dict = userDict
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
            
        else 
        {
            HUD.show(.systemActivity)
            let para = Dictionary<String,String>()
            APIFunction.sharedInstance.apiPOSTMethod(method: "logout", parems: para, completion: { (response) in
                if response.status == 200
                {
                    DispatchQueue.main.async {
                        HUD.hide()
                    }
                    let alert = UIAlertController(title: "Information", message: "Successfully logout!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                        UserDefaults.standard.set(nil, forKey: "ACCESS_TOKEN")
                        UserDefaults.standard.set(nil, forKey: "FB_PICTURE")
                        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        self.present(controller, animated: true, completion: nil)
                    }))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else
                {
                    self.showAlert(title: "Information", message: "Something Wrong , please try again!")
                }
            })
        }
    }
    
}
