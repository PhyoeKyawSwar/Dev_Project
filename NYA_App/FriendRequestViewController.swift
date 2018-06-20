//
//  FriendRequestViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 16/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import FirebaseDatabase
import FirebaseStorage

class FriendRequestViewController: UIViewController {

    var ref: DatabaseReference!
    var user_ref : DatabaseReference!
    var accepted_ref : DatabaseReference!
    var acceptedFriend = AcceptFriend()
    
    var friendListArray = [[String : Any]]()
    @IBOutlet weak var tblFriendRequest: UITableView!
    var userArray = [User]()
    var objMeta = MetaObject()
    var User_Dict = User()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getUserArray()
        // Do any additional setup after loading the view.
    }

    func getUserArray()
    {
        HUD.show(.systemActivity)
       
        APIFunction.sharedInstance.apiGETMethod(method: "friend_requests" ) { (response) in
            if response.error == nil
            {
                if response.status == 200
                {
                    if let dict = response.result as? Dictionary<String,Any>
                    {
                        if let data_array = dict["data"] as? [Dictionary<String,Any>]
                        {
                            self.userArray = [User]()
                            
                            for dict in data_array
                            {
                                let user = User()
                                let dict = user.operateUserData(dataDict: dict)
                                self.userArray.append(dict)
                            }
                            
                            print("Data Array",self.userArray)
                            
                            if self.userArray.count >= 0
                            {
                                DispatchQueue.main.async {
                                    self.tblFriendRequest.rowHeight = 110
                                    self.tblFriendRequest.estimatedRowHeight = UITableViewAutomaticDimension
                                    
                                    self.tblFriendRequest.delegate = self
                                    self.tblFriendRequest.dataSource = self
                                    self.tblFriendRequest.reloadData()
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

    func setButton (title : String , color : UIColor , btn : UIButton )
    {
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = color.cgColor
        
        btn.setTitleColor(color, for: .normal)
        btn.setTitle(title, for: .normal)
        
    }
    
    func ReactFriendRequest (actionName : String , request_user_id : Int , request_user_name : String , User : User)
    {
        var parameter = [String : Any]()
        var method = ""
        if actionName.contains("delete")
        {
            parameter  = ["_method" : "delete" , "requested_user_id":request_user_id]
            method = "DELETE"
            
        }
        else
        {
            parameter  = ["_method" : "patch" , "requested_user_id":request_user_id]
            method = "PATCH"
            
        }
        APIFunction.sharedInstance.USER_ID = User_Dict.id
        APIFunction.sharedInstance.url_string = actionName
        APIFunction.sharedInstance.apiFunction(method: actionName, parameter: parameter, methodType:method ) { (data, status) in
            
            if status == 204 || status == 200
            {
                if let dict = data as? Dictionary<String,Any>
                {
                    if let data_dict = dict["data"] as? Dictionary<String,Any>
                    {
                        if !actionName.contains("delete")
                        {
                            let accept = AcceptFriend()
                            self.acceptedFriend = accept.operateUserData(dataDict: data_dict)
                            self.createPrivateChat(User : User)
                            self.createUserList(request_user_id: request_user_id, request_user_name: request_user_name , User : User)
                        }
                    }
                }
               
                self.getUserArray()
            }
            else
            {
                self.showAlert(title: "Information", message: "Can't accept or delete friend request right now")
            }
        }
    }
    
    func createPrivateChat(User : User)
    {
        Firebase_Constant.refs.databasechat.child("private_chat").observe(DataEventType.childAdded, with: { (snapshot) in
            
            if !snapshot.hasChild(self.acceptedFriend.unique_string)
            {
                print("Value not have")
                self.ref = Firebase_Constant.refs.databasechat.child("private_chat").child(self.acceptedFriend.unique_string).childByAutoId()
                let currentTimeStamp = Date().toMillis()
                let value = ["createdAt" : currentTimeStamp ?? 00 , "userID" : UserDefaults.standard.value(forKey: "USER_ID") as! Int , "message" : ""] as [String : Any]
 
 
                self.ref.setValue(value)
                
            }
            else
            {
                print("Already have")
            }
        })
        
        
    }
    
    func createUserList(request_user_id : Int , request_user_name : String , User : User)
    {
        // for current login user
        Firebase_Constant.refs.databasechat.child("users").observe(DataEventType.childAdded, with: { (snapshot) in
            
            if !snapshot.hasChild(UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String)
            {
                print("Value not have")
                self.user_ref = Firebase_Constant.refs.databasechat.child("users").child(UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String)
                
                var friend = [self.acceptedFriend.sender_unique_string : ["lastMessage" : [String : Any]() , "name" : request_user_name , "private_chat_id" : self.acceptedFriend.unique_string , "uniqueString" : self.acceptedFriend.sender_unique_string , "userID" : request_user_id ] as! [String : Any]]
                
                let currentTimeStamp = Date().toMillis()
                var profile_picture = ""
                if let profile_pic = UserDefaults.standard.value(forKey: "FB_PICTURE") as? String
                {
                    profile_picture = profile_pic
                }
                else
                {
                    if let user_profile_pic = UserDefaults.standard.value(forKey: "User_Profile_Pic") as? String
                    {
                        profile_picture = user_profile_pic
                    }
                    
                }
                    
                let value =  ["friendList" : friend , "private_chat_id" : self.acceptedFriend.unique_string , "name" : UserDefaults.standard.value(forKey: "USER_NAME") as! String , "uniqueString" : UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String , "userID" : UserDefaults.standard.value(forKey: "USER_ID") as! Int , "profile_picture" : profile_picture ] as [String : Any]
                self.user_ref.setValue(value)
                
               
                
            }
            else
            {
                print("Already have")
                 Firebase_Constant.refs.databasechat.child("users").child(UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String).child("friendList").child(self.acceptedFriend.sender_unique_string).observe(DataEventType.childAdded, with: { (snapshot) in
                
                if !snapshot.hasChild(self.acceptedFriend.sender_unique_string)
                {
                    self.user_ref =  Firebase_Constant.refs.databasechat.child("users").child(UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String).child("friendList").child(self.acceptedFriend.sender_unique_string)
                    
                    var friend = ["lastMessage" : [String : Any]() , "name" : request_user_name , "private_chat_id" : self.acceptedFriend.unique_string , "uniqueString" : self.acceptedFriend.sender_unique_string , "userID" : request_user_id ] as! [String : Any]
                    
                    Firebase_Constant.refs.databasechat.child("users").child(UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String).child("friendList").child(self.acceptedFriend.sender_unique_string).queryLimited(toLast: 1).observe(DataEventType.childAdded, with: { (snapshot) in
                        
                        if snapshot.hasChildren()
                        {
                            friend = ["lastMessage" : snapshot.value as! [String : Any] , "name" : request_user_name , "private_chat_id" : self.acceptedFriend.unique_string , "uniqueString" : self.acceptedFriend.sender_unique_string , "userID" : request_user_id ,"profile_picture" : User.profile_picture]
                        }
                        else
                        {
                            friend = ["lastMessage" : [String : Any]() , "name" : request_user_name , "private_chat_id" : self.acceptedFriend.unique_string , "uniqueString" : self.acceptedFriend.sender_unique_string , "userID" : request_user_id ,"profile_picture" : User.profile_picture ]
                        }
 
                    self.user_ref.setValue(friend)
                        
                   
                    
                    
                })
                   
                   
                }
                 })
                    
            }
        })
        
        
        
        // for accept friend user
        Firebase_Constant.refs.databasechat.child("users").observe(DataEventType.childAdded, with: { (snapshot) in
            
            if !snapshot.hasChild(self.acceptedFriend.sender_unique_string)
            {
                print("Value not have")
                self.accepted_ref = Firebase_Constant.refs.databasechat.child("users").child(self.acceptedFriend.sender_unique_string)
                
                var friend = [UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String:["lastMessage" : [String : Any]() , "name" : UserDefaults.standard.value(forKey: "USER_NAME") as! String , "private_chat_id" : self.acceptedFriend.unique_string , "uniqueString" : UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String , "userID" : UserDefaults.standard.value(forKey: "USER_ID") as! Int ] as! [String : Any]]
                
                let currentTimeStamp = Date().toMillis()
                let value =  ["friendList" : friend , "private_chat_id" : self.acceptedFriend.unique_string , "name" : request_user_name , "uniqueString" : self.acceptedFriend.sender_unique_string , "userID" : request_user_id , "profile_picture" : User.profile_picture] as [String : Any]
                self.accepted_ref.setValue(value)
                
                
                
            }
            else
            {
                print("Already have")
                Firebase_Constant.refs.databasechat.child("users").child(self.acceptedFriend.sender_unique_string).child("friendList").child(UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String).observe(DataEventType.childAdded, with: { (snapshot) in
                    
                    if !snapshot.hasChild(self.acceptedFriend.sender_unique_string)
                    {
                        self.accepted_ref =  Firebase_Constant.refs.databasechat.child("users").child(self.acceptedFriend.sender_unique_string).child("friendList").child(UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String)
                        
                        var friend = ["lastMessage" : [String : Any]() , "name" : UserDefaults.standard.value(forKey: "USER_NAME") as! String , "private_chat_id" : self.acceptedFriend.unique_string , "uniqueString" : UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String , "userID" : UserDefaults.standard.value(forKey: "USER_ID") as! Int ] as! [String : Any]
                        
                       
                        var profile_picture = ""
                        if let profile_pic = UserDefaults.standard.value(forKey: "FB_PICTURE") as? String
                        {
                            profile_picture = profile_pic
                        }
                        else
                        {
                            if let user_profile_pic = UserDefaults.standard.value(forKey: "User_Profile_Pic") as? String
                            {
                                profile_picture = user_profile_pic
                            }
                            
                        }
                        Firebase_Constant.refs.databasechat.child("users").child(self.acceptedFriend.sender_unique_string).child("friendList").child(UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String).queryLimited(toLast: 1).observe(DataEventType.childAdded, with: { (snapshot) in
                            
                            if snapshot.hasChildren()
                            {
                                friend = ["lastMessage" : snapshot.value as! [String : Any] , "name" : request_user_name , "private_chat_id" : self.acceptedFriend.unique_string , "uniqueString" : UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String , "userID" : UserDefaults.standard.value(forKey: "USER_ID") as! Int , "profile_picture" : profile_picture ]
                            }
                            else
                            {
                                friend = ["lastMessage" : [String : Any]() , "name" : request_user_name , "private_chat_id" : self.acceptedFriend.unique_string , "uniqueString" : UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String , "userID" : UserDefaults.standard.value(forKey: "USER_ID") as! Int ,"profile_picture" : profile_picture]
                            }
                            
                            self.accepted_ref.setValue(friend)
                            
                            
                            
                            
                        })
                        
                        
                    }
                })
                
            }
        })
    }
   /* func setupUserinFirebase(uniqueString : String , userID : Int , Name : String)
    {
        
        Firebase_Constant.refs.databasechat.child("users").observe(DataEventType.value, with: { (snapshot) in
            
            if !snapshot.hasChild(uniqueString)
            {
                print("Value not have")
                self.ref = Firebase_Constant.refs.databasechat.child("users").child(uniqueString)
                let value = ["friendList" : "" , "userID" : userID , "userName" : Name] as [String : Any]
                
                self.ref.setValue(value)
                
            }
            else
            {
                print("Already have")
            }
        })
        
        
        
        
    }
 */
    
    func confirmFriend(sender : UIButton)
    {
        print("tag :::::", sender.tag)
        let user = userArray[sender.tag]
        self.ReactFriendRequest(actionName: "accept_friend", request_user_id: user.id ,request_user_name: user.name  , User : user)
        
        
    }
    func cancelFriend(sender : UIButton)
    {
          print("tag :::::", sender.tag)
        let user = userArray[sender.tag]
        self.ReactFriendRequest(actionName: "delete_friend_request", request_user_id: user.id , request_user_name: user.name ,User: user)
        
    }
}

extension FriendRequestViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestTableViewCell") as! FriendRequestTableViewCell
        
        let user = userArray[indexPath.row]
        
        if user.profile_picture.contains("/storage")
        {
            cell.imgProfile.setUserimage(url_string: "\(image_url_host)\(user.profile_picture)")
            
        }
        else
        {
            cell.imgProfile.setUserimage(url_string: user.profile_picture)
            
        }
        
           cell.lblName.setNormalLabel(text: user.name, color: BLACK_COLOR, size: 15.0, font_name: BOLD_FONT)
        
        
        self.setButton(title: "Confirm", color: BOTTOM_COLOR, btn: cell.btnConfirm)
        self.setButton(title: "Delete", color: LIGHT_GRAY_COLOR, btn: cell.btnDelete)
        cell.btnConfirm.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnConfirm.addTarget(self, action: #selector(self.confirmFriend(sender:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(self.cancelFriend(sender:)), for: .touchUpInside)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.imgSp.backgroundColor = LIGHT_GRAY_COLOR
        return cell
    }
}
