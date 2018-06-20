//
//  ChatListViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 10/1/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import FirebaseDatabase
import FirebaseStorage
import PKHUD

class ChatListViewController: UIViewController {

     var user_ref : DatabaseReference!
   // @IBOutlet weak var btnChat: UIButton!
   // @IBOutlet weak var btnGroup: UIButton!
   // @IBOutlet weak var btnPublic: UIButton!
    @IBOutlet weak var tblChatList: UITableView!
    var fromHome = Bool()
    @IBOutlet weak var segment: UISegmentedControl!
    
    
    var userArray = [[String : Any]]()
    var previewMessage = [String]()
    var groupArray = [GroupChatList]()
    var public_array = [[String : Any]]()
    
    var tableStatus = 0   // 0 for private  , 1 for group and 2 for public

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Chat"
       
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if fromHome == true{
            self.getNoti()
           // btnChat.setTitleColor(LIGHT_GRAY_COLOR, for: .normal)
           // btnGroup.setTitleColor(LIGHT_GRAY_COLOR, for: .normal)
           // btnPublic.setTitleColor(BOTTOM_COLOR, for: .normal)
            
        }
        else
        {
           // btnChat.setTitleColor(BOTTOM_COLOR, for: .normal)
           // btnGroup.setTitleColor(LIGHT_GRAY_COLOR, for: .normal)
           // btnPublic.setTitleColor(LIGHT_GRAY_COLOR, for: .normal)
            
            self.getfriend_list()
        }
        
       
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickPublic(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
       // btnChat.setTitleColor(LIGHT_GRAY_COLOR, for: .normal)
       // btnGroup.setTitleColor(LIGHT_GRAY_COLOR, for: .normal)
       // btnPublic.setTitleColor(BOTTOM_COLOR, for: .normal)
       
        self.getNoti()
    }
    func getNoti()
    {
        tableStatus = 2
        HUD.show(.systemActivity)
        
        
        APIFunction.sharedInstance.apiGETMethod(method: "notifications") { (response) in
            if response.error == nil
            {
                if let data = response.result as? [String : Any]
                {
                    self.public_array  = data["data"] as! [[String : Any]]
                }
            }
            DispatchQueue.main.async {
                self.tblChatList.rowHeight = 70
                self.tblChatList.estimatedRowHeight = UITableViewAutomaticDimension
                
                self.tblChatList.delegate = self
                self.tblChatList.dataSource = self
                self.tblChatList.reloadData()
                HUD.hide()
            }
            
        }
    }
    @IBAction func onClickGroup(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
       // btnChat.setTitleColor(LIGHT_GRAY_COLOR, for: .normal)
       // btnGroup.setTitleColor(BOTTOM_COLOR, for: .normal)
       // btnPublic.setTitleColor(LIGHT_GRAY_COLOR, for: .normal)
       // self.getGroupList()
        
    }
    
    @IBAction func onClickSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0
        {
            tableStatus = 3
             self.getfriend_list()
        }
        else
        {
            self.getGroupList()
        }
    }
    func getGroupList()
    {
        
        //group_chats
        groupArray = [GroupChatList]()
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "group_chats") { (response) in
            if response.status == 200
            {
               if let dict = response.result
               {
                    let data_dict = dict as? Dictionary<String,Any>
                    let array = data_dict!["data"] as? [Dictionary<String,Any>]
                   for dict in array!
                    {
                        let list = GroupChatList()
                        
                      var group = list.operateDate(dict: dict)
                      print("dict name" , group.name)
                       self.groupArray.append(group)
                    }
                
                    self.tableStatus = 1
                OperationQueue.main.addOperation {
                    self.tblChatList.rowHeight = 70
                    self.tblChatList.estimatedRowHeight = UITableViewAutomaticDimension
                    
                    self.tblChatList.delegate = self
                    self.tblChatList.dataSource = self
                    
                    self.tblChatList.reloadData()
                }
                }
            }
            DispatchQueue.main.async {
                HUD.hide()
            }
        }
    }
    @IBAction func onClickChat(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        tableStatus = 3
       // btnChat.setTitleColor(BOTTOM_COLOR, for: .normal)
       // btnGroup.setTitleColor(LIGHT_GRAY_COLOR, for: .normal)
       // btnPublic.setTitleColor(LIGHT_GRAY_COLOR, for: .normal)
        self.getfriend_list()
        

    }
        
    func getfriend_list()
    {
        HUD.show(.systemActivity)
        self.userArray = [[String : Any]]()
    
        Firebase_Constant.refs.databasechat.child("users/\(UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String)").observe(DataEventType.value, with: { (snapshot) in
            
            print("Friend",snapshot.value)
            print("Unique string " , UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String)
            if let data = snapshot.value as? [String : Any]
            {
               for key in data.keys
               {
                print("Key :::::",key)
                 if key == "friendList"
                  {
                    let dict = data["friendList"] as! [String : Any]
                    
                    for key in dict.keys{
                        let dictionary = dict[key]
                        self.userArray.append(dictionary as! [String : Any])
                        
                    }
                }
                }
              
               
              
            }
            print("User array count",self.userArray.count)
            DispatchQueue.main.async {
                HUD.hide()
                self.tblChatList.rowHeight = 70
                self.tblChatList.estimatedRowHeight = UITableViewAutomaticDimension
                self.tblChatList.delegate = self
                self.tblChatList.dataSource = self
                self.tblChatList.reloadData()
            }
        })
        
       
        
        
            
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       
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

extension ChatListViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableStatus == 1
        {
            return groupArray.count
        }
        else if tableStatus == 2
        {
            return public_array.count
        }
        else
        {
            return userArray.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell") as! ChatListTableViewCell
        
        cell.imgProfile.layer.cornerRadius = 25
        cell.imgProfile.clipsToBounds = true
        cell.imgProfile.backgroundColor = LIGHT_GRAY_COLOR
        if tableStatus == 1
        {
            let group = groupArray[indexPath.row]
            print("Group name in table",group.name)
            cell.lblName.text = group.name
            cell.lblName.font = UIFont(name: BLACK_FONT, size: NORMAL_FONT_SIZE)
            
            cell.lblPreviousText.isHidden = true
            cell.profileWidth.constant = 0
           
        }
        else if tableStatus == 2
        {
            let data = public_array[indexPath.row]
           // let data = dict["data"] as! [String : Any]
            
            cell.lblName.text = data["title"] as! String
            cell.lblName.font = UIFont(name: BLACK_FONT, size: NORMAL_FONT_SIZE)
            
            cell.lblPreviousText.text = data["message"] as! String
            cell.lblPreviousText.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
            cell.lblPreviousText.textColor = LIGHT_GRAY_COLOR
             cell.profileWidth.constant = 0
        }
        else
        {
            let private_chat = userArray[indexPath.row]
            
            cell.lblName.text = private_chat["name"] as! String
            cell.lblName.font = UIFont(name: BLACK_FONT, size: NORMAL_FONT_SIZE)
            
            if let profile_pic = private_chat["profile_picture"] as? String
            {
                cell.imgProfile.setimage(url_string: "\(image_url_host)/\(profile_pic)")
            }
            cell.lblPreviousText.text = ""
            cell.lblPreviousText.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
            cell.lblPreviousText.textColor = LIGHT_GRAY_COLOR
             cell.profileWidth.constant = 50
            
           // cell.lblName.text = private_chat["name"] as! String
           // cell.lblPreviousText.text = previewMessage[indexPath.row]
            
        }
        
        cell.lblName.font = UIFont(name: BOLD_FONT, size: TITLE_FONT_SIZE)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableStatus == 1
        {
            let chat = groupArray[indexPath.row]
            let controller = AppStoryboard.User.instance.instantiateViewController(withIdentifier: "MessangerViewController") as! MessangerViewController
            controller.groupUniqueString = chat.unique_string
            controller.isGroup = true
            if chat.type == 1
            {
                controller.isFromShop = true
            }
            else
            {
                controller.isFromShop = false
            }
            controller.is_for_create = false
            //controller.groupID = chat.id
            controller.from_group_list = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else if tableStatus == 2
        {
            let dict = public_array[indexPath.row]
            let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "NotiDetailViewController") as! NotiDetailViewController
            controller.detailDict = dict
            self.navigationController?.pushViewController(controller, animated: true)
           
            
        }
        else
        {
            let private_chat = userArray[indexPath.row]
            let controller = AppStoryboard.User.instance.instantiateViewController(withIdentifier: "MessangerViewController") as! MessangerViewController
            controller.private_Chat_String = private_chat["private_chat_id"] as! String
            controller.isGroup = false
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
}
