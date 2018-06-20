//
//  MessangerViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 27/1/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import PKHUD
class MessangerViewController: UIViewController , UIGestureRecognizerDelegate{

    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnAddWidth: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var bottomViewSpace: NSLayoutConstraint!
    
    var userDict = User()
    
    var ref_obj : DatabaseReference!
    var ref: DatabaseReference!
    var ref_message : DatabaseReference!
    
    var ref_privat_chat : DatabaseReference!
    
    var private_Chat_String = String()
    var message_array = NSMutableArray()
    var receiver_id = String()
    var receiver_name = String()
    var sender_id = String()
    var senderDisplayName = String()
    var planDict = [String : Any] ()
    var going_places = [String : Any]()
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgPlace: UIImageView!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var lblGoingCount: UILabel!
    @IBOutlet weak var groupViewHeight: NSLayoutConstraint!
    var isGroup = Bool()
    var time = String()
    var place = String()
    var going_count = Int()
    var groupName = String()
    var groupID = Int()
    var memberID_string = [String]()
    var member_ID = [Int]()
    var groupUniqueString  = String()
    var from_group_list = Bool()
    var isFromShop = Bool()
    var is_from_Newfeed = Bool()
    var From_ID = Int()
    
    var is_for_create = Bool()
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var btnPlan: UIButton!
    @IBOutlet weak var btnPoll: UIButton!
    
    var clickAdd = Bool()
    @IBOutlet weak var pollview: UIView!
    @IBOutlet weak var lblPoll: UILabel!
    @IBOutlet weak var txtQuestion: UITextField!
   
    @IBOutlet weak var btnAddOption: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgTrans: UIImageView!
    var pollOptions = [String]()
    var optionCount = 0
    var isShowAddOption = false
    @IBOutlet weak var AnswerView: UIView!
    @IBOutlet weak var btnRadio: UIButton!
    var optionArray = [String]()
    @IBOutlet weak var scrollView: UIScrollView!
    
    var voteDict = Dictionary<String,Any>()
    var voteDict1 = Dictionary<String,Any>()
    var voteDict2 = Dictionary<String,Any>()
    var voteDict3 = Dictionary<String,Any>()
    var voteDict4 = Dictionary<String,Any>()
    
 
    @IBAction func onClickRadio(_ sender: Any) {
        
        let dict = poll_options_Array[0]
        if is_btnradio_select == false
        {
            is_btnradio_select = true
            btnRadio.setBackgroundImage(#imageLiteral(resourceName: "click"), for: .normal)
            if txtAnswer.text != ""
            {
                optionArray.append(txtAnswer.text!)
            }
            
            if isForVote == true
            {
               voteDict = ["poll_option_id" : dict ["id"] as! Int , "user_id" : UserDefaults.standard.value(forKey: "USER_ID") as! Int] as! Dictionary<String,Any>
                voteArray.append(voteDict)
            }
         
        }
        else
        {
            is_btnradio_select = false
            btnRadio.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
           if let index = self.optionArray.index(of: txtAnswer.text!)
           {
               self.optionArray.remove(at: index)
            }
            if isForVote == true
            {
               
                if let index = voteArray.index(where: {$0["poll_option_id"] as! Int == voteDict["poll_option_id"] as! Int})
                {
                    voteArray.remove(at: index)
                }
                
            }
            
        }
    }
    @IBOutlet weak var txtAnswer: UITextField!
    @IBOutlet weak var AnswerView1: UIView!
    @IBOutlet weak var btnRadio1: UIButton!
    @IBAction func onClickRadio1(_ sender: Any) {
        let dict = poll_options_Array[1]
 
        if is_btnradio1_select == false
        {
            is_btnradio1_select = true
            btnRadio1.setBackgroundImage(#imageLiteral(resourceName: "click"), for: .normal)
            if txtAnswer1.text != ""
            {
                optionArray.append(txtAnswer1.text!)
            }
            if isForVote == true
            {
                 voteDict1 = ["poll_option_id" : dict ["id"] as! Int , "user_id" : UserDefaults.standard.value(forKey: "USER_ID") as! Int] as! Dictionary<String,Any>
                voteArray.append(voteDict1)
                
            }
 
        }
        else
        {
            is_btnradio1_select = false
            btnRadio1.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
            if let index = self.optionArray.index(of: txtAnswer1.text!)
            {
                self.optionArray.remove(at: index)
                
            }
            if isForVote == true
            {
                if let index = voteArray.index(where: {$0["poll_option_id"] as! Int == voteDict1["poll_option_id"] as! Int})
                {
                    voteArray.remove(at: index)
                }
                
                
            }
        }
    }
    @IBOutlet weak var txtAnswer1: UITextField!
    @IBOutlet weak var AnswerView2: UIView!
    @IBOutlet weak var btnRadio2: UIButton!
    @IBAction func onClickRadio2(_ sender: Any) {
        let dict = poll_options_Array[2]
 
        if is_btnradio2_select == false
        {
            is_btnradio2_select = true
            btnRadio.setBackgroundImage(#imageLiteral(resourceName: "click"), for: .normal)
            if txtAnswer2.text != ""
            {
                optionArray.append(txtAnswer2.text!)
            }
            
            if isForVote == true
            {
                 voteDict2 = ["poll_option_id" : dict ["id"] as! Int , "user_id" : UserDefaults.standard.value(forKey: "USER_ID") as! Int] as! Dictionary<String,Any>
                voteArray.append(voteDict2)
                
            }
            
            
            
        }
        else
        {
            is_btnradio2_select = false
            btnRadio.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
            if let index = self.optionArray.index(of: txtAnswer2.text!)
            {
                self.optionArray.remove(at: index)
                
            }
            if isForVote == true
            {
                if let index = voteArray.index(where: {$0["poll_option_id"] as! Int == voteDict2["poll_option_id"] as! Int})
                {
                    voteArray.remove(at: index)
                }
                
                
            }
        }
    }
    @IBOutlet weak var txtAnswer2: UITextField!
    
    @IBOutlet weak var AnswerView3: UIView!
    @IBOutlet weak var btnRadio3: UIButton!
    @IBAction func onClickRadio3(_ sender: Any) {
        let dict = poll_options_Array[3]
 
        if is_btnradio3_select == false
        {
            is_btnradio3_select = true
            btnRadio3.setBackgroundImage(#imageLiteral(resourceName: "click"), for: .normal)
            if txtAnswer3.text != ""
            {
                optionArray.append(txtAnswer3.text!)
            }
            
            if isForVote == true
            {
                 voteDict3 = ["poll_option_id" : dict ["id"] as! Int , "user_id" : UserDefaults.standard.value(forKey: "USER_ID") as! Int] as! Dictionary<String,Any>
                voteArray.append(voteDict3)
                
            }
            
            
            
        }
        else
        {
            is_btnradio3_select = false
            btnRadio3.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
            if let index = self.optionArray.index(of: txtAnswer3.text!)
            {
                self.optionArray.remove(at: index)
                
            }
            if isForVote == true
            {
                if let index = voteArray.index(where: {$0["poll_option_id"] as! Int == voteDict3["poll_option_id"] as! Int})
                {
                    voteArray.remove(at: index)
                }
                
                
            }
        }
    }
    @IBOutlet weak var txtAnswer3: UITextField!
    @IBOutlet weak var AnswerView4: UIView!
    @IBOutlet weak var btnRadio4: UIButton!
    @IBOutlet weak var txtAnswer4: UITextField!
    @IBAction func onClickRadio4(_ sender: Any) {
        let dict = poll_options_Array[4]

        if is_btnradio4_select == false
        {
            is_btnradio4_select = true
            btnRadio4.setImage(#imageLiteral(resourceName: "click"), for: .normal)
            if txtAnswer4.text != ""
            {
                optionArray.append(txtAnswer4.text!)
            }
            if isForVote == true
            {
                 voteDict4 = ["poll_option_id" : dict ["id"] as! Int , "user_id" : UserDefaults.standard.value(forKey: "USER_ID") as! Int] as! Dictionary<String,Any>
                voteArray.append(voteDict4)
                
            }
            
            
            
        }
        else
        {
            is_btnradio4_select = false
            btnRadio4.setImage(#imageLiteral(resourceName: "unclick"), for: .normal)
            if let index = self.optionArray.index(of: txtAnswer4.text!)
            {
                self.optionArray.remove(at: index)
                
            }
            if isForVote == true
            {
                if let index = voteArray.index(where: {$0["poll_option_id"] as! Int == voteDict4["poll_option_id"] as! Int})
                {
                    voteArray.remove(at: index)
                }
                
            }
        }
    }
    @IBOutlet weak var answerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var answerView1Height: NSLayoutConstraint!
    @IBOutlet weak var answerView2Height: NSLayoutConstraint!
    @IBOutlet weak var answerView3Height: NSLayoutConstraint!
    @IBOutlet weak var answerView4Height: NSLayoutConstraint!
    
    var is_btnradio_select = Bool()
    var is_btnradio1_select = Bool()
    var is_btnradio2_select = Bool()
    var is_btnradio3_select = Bool()
    var is_btnradio4_select = Bool()
    
    @IBOutlet weak var pollDetailView: UIView!
    @IBOutlet weak var lblPollTitle: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var imgPoll: UIImageView!
    @IBOutlet weak var poll1View: UIView!
    @IBOutlet weak var lblPoll1: UILabel!
    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var poll2View: UIView!
    @IBOutlet weak var lblPoll2: UILabel!
    @IBOutlet weak var progress2: UIProgressView!
    @IBOutlet weak var poll3View: UIView!
    @IBOutlet weak var lblPoll3: UILabel!
    @IBOutlet weak var progress3: UIProgressView!
    @IBOutlet weak var poll4View: UIView!
    @IBOutlet weak var lblPoll4: UILabel!
    @IBOutlet weak var progress4: UIProgressView!
    @IBOutlet weak var poll5View: UIView!
    @IBOutlet weak var lblPoll5: UILabel!
    @IBOutlet weak var progress5: UIProgressView!
    @IBOutlet weak var btnvote: UIButton!
    @IBAction func onClickVote(_ sender: Any) {
        self.isShowAddOption = false
        self.isForVote = true
        self.showVote()
    }
    @IBOutlet weak var pollDetailHeight: NSLayoutConstraint!
    var isForVote = false
    var Question = ""
    var poll_options_Array = [Dictionary<String,Any>]()
    var vote_poll_id = Int()
    var voteArray = [Dictionary<String,Any>]()
    override func viewDidLoad() {
        super.viewDidLoad()

         txtMessage.setChatTextFieldLayout(placeholder: "Write Message")
        bottomViewSpace.constant = 0
        txtMessage.delegate = self
        clickAdd = false
        addView.isHidden = true
        self.hideVote()
        if isGroup == true
        {
            lblTime.text = time
            lblPlace.text = place
            lblGoingCount.text = "\(going_count) going"
            self.title = groupName
            groupViewHeight.constant =  76
            
            imgTime.image = #imageLiteral(resourceName: "wall-clock")
            imgPlace.image = #imageLiteral(resourceName: "map-localization")
            
            self.groupView.layer.shadowColor = UIColor.lightGray.cgColor
            self.groupView.layer.shadowOpacity = 0.5
            self.groupView.layer.shadowOffset = CGSize.zero
            self.groupView.layer.shadowRadius = 2
            self.groupView.layer.cornerRadius = 5
            self.groupView.isUserInteractionEnabled = true
            
            btnAddWidth.constant = 40
            
           
        }
        else
        {
            self.lblTime.text = ""
            self.lblPlace.text = ""
            self.lblGoingCount.text = ""
            groupViewHeight.constant = 0
            btnAddWidth.constant = 0
            
        }
        
        self.addDoneButtonOnKeyboard()
        
        self.answerView1Height.constant = 0
        self.answerView2Height.constant = 0
        self.answerView3Height.constant = 0
        self.answerView4Height.constant = 0
        
        txtAnswer1.isHidden = true
        btnRadio1.isHidden = true
        
        txtAnswer2.isHidden = true
        btnRadio2.isHidden = true
        
        txtAnswer3.isHidden = true
        btnRadio3.isHidden = true
        
        txtAnswer4.isHidden = true
        btnRadio4.isHidden = true
        
         btnRadio.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
        is_btnradio_select = false
        is_btnradio1_select = false
        is_btnradio2_select = false
        is_btnradio3_select = false
        is_btnradio4_select = false
        
        self.btnDone.backgroundColor = PINK_COLOR
        
        self.hideVoteView()
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
       
        if isGroup == true
        {
            if is_for_create == true  
            {
              self.createGroupChat()
            
            }
            self.getFirebaseGroupInfo()
            self.getGroupMessage()
            
            
        }
        else
        {
         print("Private chat string", self.private_Chat_String)
            self.getPrivateMessage()
        }
     
    }
    
   
    func getFirebaseGroupInfo()
    {
        print("Group string" , groupUniqueString)
        Firebase_Constant.refs.databaseRoot.child("chat/group_chat/\(groupUniqueString)").observe(DataEventType.value, with: { (snapshot) in
            if let data = snapshot.value as? [String : Any]
            {
                print("Data ::::", data)
              let group_id = data["group_id"] as! Int
                self.groupID = group_id
 
        print("from shop" , self.isFromShop)
                if self.isFromShop == true
                {
                     self.getGroupInfoDetail(idx: self.groupID)
                }
                else
                {
                    self.getEventInfo(idx: self.groupID)
                }
                
               
            }
        })
 
 
    }
    
    func getEventInfo(idx : Int)
    {
        APIFunction.sharedInstance.apiGETMethod(method: "event_going_plans/\(idx)") { (response) in
            if response.error == nil
            {
                if response.status == 200
                {
                    if let dict = response.result as? [String : Any]
                    {
                        self.planDict = dict["data"] as! [String : Any]
                        self.title = self.planDict["group_name"] as? String ?? ""
                        
                        DispatchQueue.main.async {
                            self.going_places = ["id" : self.planDict["event_id"] as! Int , "name" : self.planDict["event_name"] as! String]
                            self.lblPlace.text = self.going_places["name"] as? String ?? ""
                            
                            self.lblTime.text = self.planDict["date_time"] as? String ?? ""
                            
                            self.lblGoingCount.text = "\(self.planDict["going_count"] as? Int ?? 0) going"
                        }
                        
                    }
                }
            }
        }
    }
    func getGroupInfoDetail (idx : Int)
    {
        //shop_going_plans/7
        APIFunction.sharedInstance.apiGETMethod(method: "shop_going_plans/\(idx)") { (response) in
            if response.error == nil
            {
                if response.status == 200
                {
                    if let dict = response.result as? [String : Any]
                    {
                        self.planDict = dict["data"] as! [String : Any]
                        self.title = self.planDict["group_name"] as? String ?? ""
                        
                        DispatchQueue.main.async {
                            if let array = self.planDict["going_places"] as? [[String : Any]]
                            {
                                if array.count > 0
                                {
                                    self.going_places = array[0]
                                }
                               
                                
                            }
                            
                             self.lblPlace.text = self.going_places["name"] as? String ?? ""
                            
                            self.lblTime.text = self.planDict["date_time"] as? String ?? ""
                            
                            self.lblGoingCount.text = "\(self.planDict["going_count"] as? Int ?? 0) going"
                        }
                       
                     }
                }
            }
        }
        
    }
    func getGroupMessage()
    {
         Firebase_Constant.refs.databaseRoot.child("chat/group_message").child(self.groupUniqueString).observe(DataEventType.childAdded, with: { (snapshot) in
            if let data = snapshot.value as? [String : Any]
            {
                print("Data ::::", data)
                if  data["message_type"] as! String == "text"
                {
                     self.getGroupMSG(createAt: data["createdAt"] as! Int64, message: data["message"] as! String, messageType: data["message_type"] as! String, senderID: data["sender_id"] as! Int , poll_id: 0)
                }
               else
                {
                    self.getGroupMSG(createAt: data["createdAt"] as! Int64, message: data["message"] as! String, messageType: data["message_type"] as! String, senderID: data["sender_id"] as! Int, poll_id : data["poll_id"] as! Int)
                }
                
            }
        })
        
    }
    func getGroupMSG(createAt : Int64 , message : String , messageType  : String , senderID : Int , poll_id : Int)
    {
        
        let message = ["createdAt" : createAt , "message" : message , "message_type" : messageType, "sender_id" : senderID , "poll_id" : poll_id] as! [String : Any]
        self.message_array.add(message)
        tblMessage.delegate = self
        tblMessage.dataSource = self
        tblMessage.reloadData()
        
    }
    
    
    func createGroupChat()
    {
        print("Group unique string ::::::",self.groupUniqueString)
        Firebase_Constant.refs.databasechat.child("users").observe(DataEventType.childAdded, with: { (snapshot) in
            
            if snapshot.hasChild("\(UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String)")
            {
                print("Value not have")
                self.ref_obj = Firebase_Constant.refs.databasechat.child("users").child("\(UserDefaults.standard.value(forKey: "SIGN_UP_UNIQUE_STRING") as! String)")
                
                let value =  ["group_chat_id" : self.groupUniqueString] as [String : Any]
                self.ref_obj.updateChildValues(value)
                
            }
            if self.is_from_Newfeed == true
            {
                for index in 0 ... self.memberID_string.count - 1
                {
                    
                    var unique_string = self.memberID_string[index]
                    if snapshot.hasChild("\(unique_string)")
                    {
                        self.ref_obj = Firebase_Constant.refs.databasechat.child("users").child("\(unique_string)")
                        
                        let value =  ["group_chat_id" : self.groupUniqueString] as [String : Any]
                        self.ref_obj.updateChildValues(value)
                        
                    }
                    
                    
                }
                
            }
           
        })
        
        Firebase_Constant.refs.databasegroup.observe(DataEventType.childAdded, with: { (snapshot) in
            print("Group chat snapshot :::::",snapshot)
            if !snapshot.hasChild("\(self.groupUniqueString)")
            {
                
            self.ref_obj = Firebase_Constant.refs.databasegroup.child(self.groupUniqueString)
            
                let group = ["group_name" : self.groupName , "group_id" : self.groupID , "member" : self.memberID_string ,"place" : self.place , "time" : self.time] as! [String : Any]
                self.ref_obj.setValue(group)
            }
            else
            {
                print("Already exist group")
            }
        })
 
        
       Firebase_Constant.refs.databasegroup.child("\(self.groupUniqueString)").observe(DataEventType.value, with: { (snapshot) in
            if snapshot.hasChild("\(self.groupUniqueString)")
            {
                
                let data = snapshot.value as? [String : Any]
                self.lblTime.text = data!["time"] as! String
                self.lblPlace.text = data!["place"] as! String
                
                
            }
        })
 
 
    }
    
    func getPrivateMessage()
    {

        Firebase_Constant.refs.databasechat.child("private_chat/\(self.private_Chat_String)").observe(DataEventType.childAdded, with: { (snapshot) in
            //self.message_array = NSMutableArray()
            
            if let data = snapshot.value as? [String : Any]
            {
                print("Data ::::", data)
               // for key in data.keys{
                  //  let dictionary = data[key] as! [String : Any]
                    self.getPrivateMsg(createAt: data["createdAt"] as! Int64, message: data["message"] as! String , userID: (data["sender_id"] as! Int))
                   // }
                
            }
        })
    
    }
    
    func getPrivateMsg(createAt : Int64 , message : String , userID : Int)
    {
        let message = ["createdAt": createAt, "message": message, "sender_id" : userID] as [String : Any]
        
        
        message_array.add(message)
        tblMessage.delegate = self
        tblMessage.dataSource = self
        tblMessage.reloadData()
    }
    func getMessage(idx : String , name : String ,text : String ,type : String ,updateDate : String)
    {
        let message = ["sender_id": idx, "name": name, "text": text ,"type" : type , "update_date" : updateDate] as [String : Any]
        
        message_array.add(message)
        tblMessage.delegate = self
        tblMessage.dataSource = self
        tblMessage.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onClickAdd(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        if clickAdd == false
        {
            addView.isHidden = false
            clickAdd = true
        }
        else
        {
            addView.isHidden = true
            clickAdd = false
        }
    }
    
    @IBAction func onClickSend(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
       if isGroup == true
       {
       // self.ref_obj = Firebase_Constant.refs.databaseRoot.child("chat/group_message").child(self.groupUniqueString).childByAutoId()
        
        self.ref_obj = Firebase_Constant.refs.databasechat.child("group_message/\(self.self.groupUniqueString)").childByAutoId()
        
        let currentTimeStamp = Date().toMillis()
        let  message = ["createdAt": currentTimeStamp, "message" : txtMessage.text , "sender_id" : UserDefaults.standard.value(forKey: "USER_ID") as! Int , "message_type" : "text"] as [String : Any]
        
        self.ref_obj.setValue(message)
        
        }
        else
       {
        self.ref_privat_chat = Firebase_Constant.refs.databasechat.child("private_chat/\(self.private_Chat_String)").childByAutoId()
        let currentTimeStamp = Date().toMillis()
        let  message = ["createdAt": currentTimeStamp, "message" : txtMessage.text , "sender_id" : UserDefaults.standard.value(forKey: "USER_ID") as! Int] as [String : Any]
        self.ref_privat_chat.setValue(message)
        
        
        }
        txtMessage.text = ""
        
        
        //finishSendingMessage()
    }
    
    func createPollinFirebase ( id : Int , poll_obj : [String : Any])
    {
        self.ref_obj = Firebase_Constant.refs.databaseRoot.child("chat/group_message").child(self.groupUniqueString).childByAutoId()
        
        let currentTimeStamp = Date().toMillis()
        let  message = ["createdAt": currentTimeStamp, "message" : "" , "sender_id" : UserDefaults.standard.value(forKey: "USER_ID") as! Int , "message_type" : "poll" , "poll_id" : id] as [String : Any]
        
        self.ref_obj.setValue(message)
        
         self.ref_obj = Firebase_Constant.refs.databaseRoot.child("chat/poll").child("\(id)")
        self.ref_obj.setValue(poll_obj)
        
        self.ref_obj = Firebase_Constant.refs.databaseRoot.child("chat/group_message").child(self.groupUniqueString).childByAutoId()
        
    }
    
    @IBAction func onClickGroup(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
        self.gotoEditView()
       
    }
    func gotoEditView()
    {
        if isFromShop == true
        {
            let controller = AppStoryboard.NewFeed.instance.instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController
            controller.is_from_shop = true
            controller.is_from_Newfeed = true
            controller.from_id = self.From_ID
            controller.is_for_edit = true
            controller.edit_dictionary = planDict
            controller.is_from_shop = isFromShop
            let dict = ["id" : going_places["id"] as! Int  , "name" : going_places["name"] as! String] as [String : Any]
            let array = [dict]
            controller.ShowPlaceArray = array
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    @IBAction func onClickPlan(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        isFromShop = true
       self.gotoEditView()
    }
    @IBAction func onClickPoll(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        self.isForVote = false
        self.isShowAddOption = true
        self.showVote()
        
    }
    
    func showVote()
    {
        if isForVote == false
        {
            if isShowAddOption == false
            {
                btnAddOption.isHidden = true
            }
            else
            {
                btnAddOption.isHidden = false
            }
            
            if optionCount > 4
            {
                btnAddOption.isHidden = true
                
            }
            else
            {
                btnAddOption.isHidden = false
                
            }
            self.pollview.isHidden = false
            self.imgTrans.isHidden = false
            self.imgTrans.backgroundColor = UIColor(white: 0, alpha: 0.3)
            self.pollview.layer.cornerRadius = 10
            self.lblPoll.text = "Poll"
            self.lblPoll.font = UIFont(name: BLACK_FONT, size: 13.0)
            self.txtQuestion.placeholder = "Add Question"
            self.btnAddOption.setTitle("Add Option", for: .normal)
            
        }
        else
        {
            if isShowAddOption == false
            {
                btnAddOption.isHidden = true
            }
            else
            {
                btnAddOption.isHidden = false
            }
            self.pollview.isHidden = false
            self.imgTrans.isHidden = false
            self.imgTrans.backgroundColor = UIColor(white: 0, alpha: 0.3)
            self.pollview.layer.cornerRadius = 10
            self.lblPoll.text = "Poll"
            self.lblPoll.font = UIFont(name: BLACK_FONT, size: 13.0)
            self.txtQuestion.text = Question
            
            self.pollDetailView.isHidden = true
            if poll_options_Array.count > 0
            {
                for index in 0...poll_options_Array.count - 1
                {
                    let option = self.poll_options_Array[index]
                    if index == 0
                    {
                        self.answerViewHeight.constant = 50
                        self.txtAnswer.isHidden = false
                        self.btnRadio.isHidden = false
                        self.txtAnswer.text = option["name"] as? String
                        btnRadio.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
                        
                        txtAnswer1.isHidden = true
                        btnRadio1.isHidden = true
                        txtAnswer2.isHidden = true
                        btnRadio2.isHidden = true
                        txtAnswer3.isHidden = true
                        btnRadio3.isHidden = true
                        txtAnswer4.isHidden = true
                        btnRadio4.isHidden = true
                    }
                    else if index == 1
                    {
                        self.answerView1Height.constant = 50
                        txtAnswer1.isHidden = false
                        btnRadio1.isHidden = false
                        self.txtAnswer1.text = option["name"] as? String
                        
                        btnRadio1.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
                        
                        txtAnswer2.isHidden = true
                        btnRadio2.isHidden = true
                        txtAnswer3.isHidden = true
                        btnRadio3.isHidden = true
                        txtAnswer4.isHidden = true
                        btnRadio4.isHidden = true
                        
                    }
                    else if index == 2
                    {
                        self.answerView2Height.constant = 50
                        txtAnswer2.isHidden = false
                        btnRadio2.isHidden = false
                        self.txtAnswer2.text = option["name"] as? String
                        
                        btnRadio2.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
                        
                        txtAnswer3.isHidden = true
                        btnRadio3.isHidden = true
                        txtAnswer4.isHidden = true
                        btnRadio4.isHidden = true
                        
                    }
                    else if index == 3
                    {
                        self.answerView3Height.constant = 50
                        txtAnswer3.isHidden = false
                        btnRadio3.isHidden = false
                        self.txtAnswer3.text = option["name"] as? String
                        
                        btnRadio3.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
                        
                        txtAnswer4.isHidden = true
                        btnRadio4.isHidden = true
                    }
                    else
                    {
                        self.answerView4Height.constant = 50
                        txtAnswer4.isHidden = false
                        btnRadio4.isHidden = false
                        self.txtAnswer4.text = option["name"] as? String
                        
                        btnRadio4.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
                    }
                    
                   
                }
               
                }
                
               
        }
       
        
    }
    func hideVote()
    {
        self.pollDetailHeight.constant = 0
        self.pollview.isHidden = true
        self.imgTrans.isHidden = true
    }
    @IBAction func onClickAddOption(_ sender: Any) {
        if optionCount <= 4
        {
            optionCount += 1
            if optionCount == 0
            {
                self.answerViewHeight.constant = 50
                btnRadio.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
            }
           else if optionCount == 1
            {
                self.answerView1Height.constant = 50
                txtAnswer1.isHidden = false
                btnRadio1.isHidden = false
                btnRadio1.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
               
            }
            else if optionCount == 2
            {
                self.answerView2Height.constant = 50
                txtAnswer2.isHidden = false
                btnRadio2.isHidden = false
                 btnRadio2.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
            }
            else if optionCount == 3
            {
                self.answerView3Height.constant = 50
                txtAnswer3.isHidden = false
                btnRadio3.isHidden = false
                 btnRadio3.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
            }
            else
            {
                self.answerView4Height.constant = 50
                txtAnswer4.isHidden = false
                btnRadio4.isHidden = false
                 btnRadio4.setBackgroundImage(#imageLiteral(resourceName: "unclick"), for: .normal)
            }
            
             btnAddOption.isHidden = false
        }
        if optionCount == 4
        {
            btnAddOption.isHidden = true
        }
       
    }
    
    func createPoll()
    {
        /*
         {
         "user_id": 1,
         "question": "Where do you want to go?",
         "options": [
         {"name": "option one"},
         {"name": "Option Tow" }
         ]
         }
 */
    
        var params = [String : Any]()
        var option = [[String : String]]()
        
        for poll in optionArray
        {
            let dict = ["name" : poll]
            option.append(dict)
        }
        params = ["user_id" : UserDefaults.standard.value(forKey: "USER_ID") as! Int , "question" : txtQuestion.text! , "options" : option ]
        ///group_chats/1/polls"
        APIFunction.sharedInstance.url_string = "group_chats/\(groupID)/polls"
        APIFunction.sharedInstance.apiFunction(method: "group_chats/\(groupID)/polls", parameter: params, methodType: "POST") { (data, status) in
            if status == 201
            {
                print("Data :::: " , data)
                if let dict = data["data"] as? [String : Any]
                {
                    self.createPollinFirebase(id: dict["id"] as! Int, poll_obj: dict)
                }
            }
            else
            {
                self.showAlert(title: "Information", message: "Something Wrong")
            }
        }
    }
    @IBAction func onClickDone(_ sender: Any) {
        if isForVote == false
        {
            if optionArray.count > 0
            {
                self.createPoll()
            }
            
        }
        else
        {
            self.vote_Poll()
        }
        
        tblMessage.reloadData()
        
    }
    func vote_Poll()
    {
        /*
         /polls/1/
         {
         "votings": [
         {"poll_option_id": 1, "user_id": 1 },
         {"poll_option_id": 2, "user_id": 1 }
         ]
         }
 */
        let param = ["votings" : voteArray] as! [String : Any]
     HUD.show(.systemActivity)
     APIFunction.sharedInstance.url_string = "polls/\(vote_poll_id)/votings"
        APIFunction.sharedInstance.apiFunction(method: "polls/\(vote_poll_id)/votings", parameter: param, methodType: "POST") { (data, status) in
            print(data)
            if status == 200
            {
                if let dataDict = data["data"] as? [[String:Any]]
                {
                   self.ref_obj = Firebase_Constant.refs.databaseRoot.child("chat/poll").child("\(self.vote_poll_id)").child("options")
                    self.ref_obj.setValue(dataDict)
                }
            }
            else
            {
              self.showAlert(title: "Information", message: "Something Wrong! Please try again")
            }
            
            DispatchQueue.main.async {
                self.hideVote()
                
                HUD.hide()
            }
            
        }
       
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        self.hideVote()
    }
    
    func onclickRadio(_sender : UIButton)
    {
         print("Radio" , _sender.tag)
        if _sender.imageView?.image == #imageLiteral(resourceName: "unclick")
        {
            _sender.setImage(#imageLiteral(resourceName: "click"), for: .normal)
        }
        else
        {
            _sender.setImage(#imageLiteral(resourceName: "unclick"), for: .normal)
        }
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
        
        txtQuestion.inputAccessoryView = doneToolbar
        txtAnswer.inputAccessoryView = doneToolbar
        txtAnswer1.inputAccessoryView = doneToolbar
        txtAnswer2.inputAccessoryView = doneToolbar
        txtAnswer3.inputAccessoryView = doneToolbar
        txtAnswer4.inputAccessoryView = doneToolbar
        
    }
    func doneButtonAction()
    {
        self.view.endEditing(true)
       
    }
    
    func hideVoteView()
    {
        self.pollDetailHeight.constant = 0
        self.imgTrans.isHidden = true
        self.pollDetailView.isHidden = true
        self.pollview.isHidden = true
        
        
    }
    
    func showVoteView(sender : UIButton)
    {
        print("poll id ::::",sender.tag)
        vote_poll_id = sender.tag
        
        isShowAddOption = false
        isForVote = true
        self.pollDetailHeight.constant = 400
        self.imgTrans.isHidden = false
        self.imgTrans.backgroundColor = UIColor(white: 0, alpha: 0.3)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapImage(_sender:)))
        gesture.numberOfTapsRequired = 1
        self.imgTrans.isUserInteractionEnabled = true
        self.imgTrans.addGestureRecognizer(gesture)
        
        self.pollDetailView.isHidden = false
        self.pollDetailView.backgroundColor = UIColor.white
        
        self.btnvote.backgroundColor = PINK_COLOR
        
        progress1.transform = CGAffineTransform(scaleX: 1, y: 3)
        progress2.transform = CGAffineTransform(scaleX: 1, y: 3)
        progress3.transform = CGAffineTransform(scaleX: 1, y: 3)
        progress4.transform = CGAffineTransform(scaleX: 1, y: 3)
        progress5.transform = CGAffineTransform(scaleX: 1, y: 3)
        
        self.poll1View.isHidden = true
        self.poll2View.isHidden = true
        self.poll3View.isHidden = true
        self.poll4View.isHidden = true
        self.poll5View.isHidden = true
        
        self.progress1.setProgress(0.0, animated: true)
        self.progress2.setProgress(0.0, animated: true)
        self.progress3.setProgress(0.0, animated: true)
        self.progress4.setProgress(0.0, animated: true)
        self.progress5.setProgress(0.0, animated: true)
        
        Firebase_Constant.refs.databaseRoot.child("chat/poll").child("\(sender.tag)").observe(DataEventType.value, with: { (snapshot) in
            if let data = snapshot.value as? [String : Any]
            {
             
                print("poll Data ::::", data)
                self.lblPollTitle.setNormalLabel(text: "Poll", color: BLACK_COLOR, size: 15.0, font_name: BLACK_FONT)
                self.lblQuestion.setNormalLabel(text: data["question"] as! String, color: BLACK_COLOR, size: 15.0, font_name: BLACK_FONT)
                self.Question = data["question"] as! String
                if let option_Array = data["options"] as? [Dictionary<String,Any>]
                {
                    self.poll_options_Array = option_Array
                    if option_Array.count > 0
                    {
                        for index in 0...option_Array.count - 1
                        {
                            if index == 0
                            {
                                self.poll1View.isHidden = false
                                if let dict = option_Array[index] as? Dictionary<String,Any>
                                {
                                    self.lblPoll1.text = dict["name"] as? String
                                    if let percent = dict["percent"] as? Int
                                    {
                                        self.progress1.setProgress(Float(percent) / 100.0, animated: false)
                                       
                                    }
                                }
                            }
                            else if index == 1
                            {
                                self.poll2View.isHidden = false
                                if let dict = option_Array[index] as? Dictionary<String,Any>
                                {
                                    self.lblPoll2.text = dict["name"] as? String
                                    if let percent = dict["percent"] as? Int
                                    {
                                        self.progress2.setProgress(Float(percent) / 100.0, animated: true)
                                    }
                                }
                            }
                            else if index == 2
                            {
                                self.poll3View.isHidden = false
                                if let dict = option_Array[index] as? Dictionary<String,Any>
                                {
                                    self.lblPoll3.text = dict["name"] as? String
                                    if let percent = dict["percent"] as? Int
                                    {
                                        self.progress3.setProgress(Float(percent) / 100.0, animated: true)
                                    }
                                }
                            }
                            else if index == 3
                            {
                                self.poll4View.isHidden = false
                                if let dict = option_Array[index] as? Dictionary<String,Any>
                                {
                                    self.lblPoll4.text = dict["name"] as? String
                                    if let percent = dict["percent"] as? Int
                                    {
                                        self.progress4.setProgress(Float(percent) / 100.0, animated: true)
                                    }
                                }
                            }
                            else
                            {
                                self.poll5View.isHidden = false
                                if let dict = option_Array[index] as? Dictionary<String,Any>
                                {
                                    self.lblPoll5.text = dict["name"] as? String
                                    if let percent = dict["percent"] as? Int
                                    {
                                        self.progress5.setProgress(Float(percent) / 100.0, animated: true)
                                    }
                                }
                            }
                        }
                    }
                   
                }
                
                
            }
        })
        
    }
    func tapImage(_sender : UITapGestureRecognizer)
    {
        self.hideVoteView()
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

extension MessangerViewController : UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        bottomViewSpace.constant  = 200
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        bottomViewSpace.constant = 0
        return true
    }
}

extension MessangerViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
           return message_array.count
       
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        cell.lblIncomingMessage.text = ""
        cell.lblOutgoingMessage.text = ""
        if isGroup == true{
            let message = message_array[indexPath.row] as! [String:Any]
            print("Message ::::::: ",message)
            if let id = message["sender_id"] as? Int
            {
                if message["message_type"] as! String == "text"
                {
                    if id == UserDefaults.standard.value(forKey: "USER_ID") as! Int
                    {
                        cell.lblOutgoingMessage.text = message["message"] as! String
                    }
                    else
                    {
                        cell.lblIncomingMessage.text = message["message"] as! String
                    }
                    cell.btnVote.isHidden = true
                }
                else
                {
                    cell.btnVote.isHidden = false
                    let poll_id = message["poll_id"] as! Int
                    
                    cell.btnVote.tag = poll_id
                    cell.btnVote.addTarget(self, action: #selector(self.showVoteView), for: .touchUpInside)
                    
                   
                    
                }
                
            }
        }
        else
        {
            let message = message_array[indexPath.row] as! [String : Any]
            print("Message ::::::: ",message)
            if let id = message["sender_id"] as? Int
            {
                if id == UserDefaults.standard.value(forKey: "USER_ID") as! Int
                {
                    cell.lblOutgoingMessage.text = message["message"] as! String
                }
                else
                {
                    cell.lblIncomingMessage.text = message["message"] as! String
                }
            }
            cell.btnVote.isHidden = true
        }
        
        cell.lblIncomingMessage.font = UIFont(name: THIN_FONT, size: NORMAL_FONT_SIZE)
        cell.lblOutgoingMessage.font = UIFont(name: THIN_FONT, size: NORMAL_FONT_SIZE)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("index",indexPath.row )
    }
    
}

