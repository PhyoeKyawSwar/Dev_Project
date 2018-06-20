//
//  CreateViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 2/1/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
import EventKit
class CreateViewController: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var btnSelectDate: UIButton!
    @IBOutlet weak var tblPlace: UITableView!
    @IBOutlet weak var btnAddPlace: UIButton!
    @IBOutlet weak var btnSelectPrivacy: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var picker_view: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tblPlaceHeight: NSLayoutConstraint!
    @IBOutlet weak var ScrollHeight: NSLayoutConstraint!
    @IBOutlet weak var scroll_view: UIScrollView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imgTrans: UIImageView!
    
    @IBOutlet weak var SelectPlaceView: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblSelectPlace: UITableView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var tblSelectPlaceHeight: NSLayoutConstraint!
    @IBOutlet weak var btnAddPlaces: UIButton!
    
    @IBOutlet weak var friendView: UIView!
    var place_count = 0
    
    var placeArray = [[String : Any]]()
    var ShowPlaceArray = [[String : Any]]()
    @IBOutlet weak var friendCollectionView: UICollectionView!
    var friendArray = [User]()
    @IBOutlet weak var EditNameView: UIView!
    @IBOutlet weak var lblEditTitle: UILabel!
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var btnGroupDone: UIButton!
    
    var is_from_Newfeed = Bool()
    var is_from_shop = Bool()
    var from_id : Int!
    var from_name = String()
    var is_for_edit = Bool()
    var edit_dictionary = [String : Any]()
    
    @IBOutlet weak var btnGoing: UIButton!
    
    var going_date = String()
    var choose_date = Date()
    
    @IBOutlet weak var tblPrivacyHeight: NSLayoutConstraint!
    var timeString = String()
    @IBOutlet weak var tblPrivacy: UITableView!
    
    var privacy_id = Int()
    
    let privacyArray = [["privacy_id" : 1 , "privacy_name" : "Private"] , ["privacy_id" : 2 , "privacy_name" : "Friend Only"] , ["privacy_id" : 3 , "privacy_name" : "Public"]]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        picker_view.isHidden = true
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        btnSelectDate.layer.cornerRadius = 5
        btnSelectDate.layer.borderColor = LIGHT_GRAY_COLOR.cgColor
        btnSelectDate.layer.borderWidth = 1
        
        btnCreate.layer.cornerRadius = 5
        
       // btnSelectPrivacy.layer.borderWidth = 1
       // btnSelectPrivacy.layer.borderColor = GRAY_COLOR.cgColor
        
        scroll_view.backgroundColor = BG_COLOR
        topView.backgroundColor = LIGHT_PINK_COLOR
        
        lblDate.textColor = BOTTOM_COLOR
        
        imgTrans.backgroundColor = UIColor(white: 0, alpha: 0.3)
        imgTrans.isHidden = true
        
        SelectPlaceView.isHidden = true
        
        tblPlace.delegate = self
        tblPlace.dataSource = self
        tblPlace.tag = 100
       
        tblSelectPlace.delegate = self
        tblSelectPlace.dataSource = self
        tblSelectPlace.tag = 1000
        
        tblPrivacy.delegate = self
        tblPrivacy.dataSource = self
        tblPrivacy.tag = 10000
        
        btnClose.layer.cornerRadius = 20
        
        btnAddPlace.isHidden = false
        btnAddPlaces.isHidden = false
        
        tblSelectPlaceHeight.constant = 0
        SelectPlaceView.layer.cornerRadius = 5
        
        lblDate.text = "Date"
        lblDate.font = UIFont(name: BOLD_FONT, size: 30.0)
        
        
        txtGroupName.placeholder = "Set Group Name"
        txtGroupName.layer.cornerRadius = 5
        txtGroupName.layer.borderColor = GRAY_COLOR.cgColor
        txtGroupName.layer.borderWidth = 1
        
        let leftpaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
        txtGroupName.leftView = leftpaddingView
        txtGroupName.leftViewMode = .always
        txtGroupName.backgroundColor = UIColor.white
        self.addDoneButtonOnKeyboard()
        
        friendView.layer.cornerRadius = 5
        
        
        print("Edit Dictionary :::::",edit_dictionary)
        if is_from_Newfeed == false
        {
            self.btnAddPlaces.isHidden = true
            self.btnAddPlace.isHidden = true
            self.showPlaces()
        }
        
        if is_for_edit == true
        {
            print("Edit Dictionary" , edit_dictionary)
            let dateString = edit_dictionary["date_time"] as! String
            let dateArray = dateString.components(separatedBy: " ") as! [String]
            
            if dateArray.count > 0
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let date_string = dateArray[0]
                let yyyy_mm_Date = formatter.date(from: date_string)
                
                formatter.dateFormat = "dd/MMM/yyyy"
                let dd_mm_Date = formatter.string(from: yyyy_mm_Date!)
                print(dd_mm_Date)
                let dd_mm_Date_Array = dd_mm_Date.components(separatedBy: "/")
                if dd_mm_Date_Array.count > 0
                {
                    lblDate.text = "\(dd_mm_Date_Array[0]) \(dd_mm_Date_Array[1])"
                    lblDate.font = UIFont(name: BOLD_FONT, size: 30.0)
                    
                }
                self.btnSelectDate.setTitle(dateArray[1], for: .normal)
            }
            
            
            if let array = edit_dictionary["going_users"] as? [Dictionary<String , Any>]
            {
                for dict in array
                {
                    let user = User()
                    let dict = user.operateUserData(dataDict: dict)
                    self.friendArray.append(dict)
                }
                friendCollectionView.dataSource = self
                friendCollectionView.delegate = self
                friendCollectionView.reloadData()
            }
            if let places = edit_dictionary["going_places"] as? [[String:Any]]
            {
                for place in places
                {
                    placeArray.append(place)
                }
                
            }
            if let name = edit_dictionary["group_name"] as? String
            {
                self.txtGroupName.text = name
            }
            self.showPlaces()
            //self.btnSelectPrivacy.isHidden = true
            self.btnCreate.backgroundColor = UIColor.white
            self.btnCreate.setTitle("Leave Group", for: .normal)
            self.btnCreate.setTitleColor(PINK_COLOR, for: .normal)
            btnCreate.layer.cornerRadius = 5
            btnCreate.layer.borderColor = LIGHT_GRAY_COLOR.cgColor
            btnGoing.isHidden = false
           // self.btnSelectPrivacy.setBackgroundImage(UIImage(named : "privacy_btn"), for: .normal)
            self.btnSelectPrivacy.setTitle("Your Response", for: .normal)
            self.btnSelectPrivacy.setTitleColor(PINK_COLOR, for: .normal)
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.updatePlan))
            self.navigationItem.rightBarButtonItem = doneButton
        }
        else
        {
            self.btnSelectPrivacy.isHidden = false
            self.btnCreate.backgroundColor = PINK_COLOR
            self.btnCreate.setTitle("Create", for: .normal)
            self.btnCreate.setTitleColor(UIColor.white, for: .normal)
            btnGoing.isHidden = true
            self.btnSelectPrivacy.setBackgroundImage(UIImage(named : "privacy_btn"), for: .normal)
            self.btnSelectPrivacy.setTitle("Select Privacy", for: .normal)
        }
        
    }
    
    func updatePlan()
    {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         friendCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        friendCollectionView.dataSource = self
        friendCollectionView.delegate = self
        friendCollectionView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUserArray(notification:)), name: NSNotification.Name(rawValue: "getUserArray"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getShopArray(notification:)), name: NSNotification.Name(rawValue: "getShopArray"), object: nil)
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func getUserArray(notification: Notification){
        if let user = notification.userInfo?["user_array"] as? [User]
        {
            for dict in user
            {
                if !friendArray.contains(dict)
                {
                    self.friendArray.append(dict)
                }
            }
            
            friendCollectionView.dataSource = self
            friendCollectionView.delegate = self
            friendCollectionView.reloadData()
            
        }
    }
    
    @objc func getShopArray(notification: Notification){
        print("shop array",notification.userInfo?["shopArray"] as? [[String : Any]])
        if let user = notification.userInfo?["shopArray"] as? [[String : Any]]
        {
            for dict in user
            {
                
                    self.placeArray.append(dict)
                
            }
            
            self.showPlaces()
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        scroll_view.contentSize = CGSize(width: self.scroll_view.frame.size.width, height: 1000)
    }
    @IBAction func onClickSave(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        picker_view.isHidden = true
        imgTrans.isHidden = true
        
        choose_date = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yyyy hh:mm:ss aa"
        let dateString = formatter.string(from: choose_date)
        let dateArray = dateString.components(separatedBy: " ")
        if dateArray.count > 0
        {
            let date_string = dateArray[0]
            let day_month = date_string.components(separatedBy: "/")
            if day_month.count > 0
            {
                lblDate.text = "\(day_month[0]) \(day_month[1])"
                lblDate.font = UIFont(name: BOLD_FONT, size: 30.0)
               
            }
            
            btnSelectDate.setTitle("\(dateArray[1]) \(dateArray[2])", for: .normal)
            timeString = "\(dateArray[1]) \(dateArray[2])"
        }
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        going_date = formatter.string(from: choose_date)
    }
    @IBAction func onClickCancel(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        picker_view.isHidden = true
        imgTrans.isHidden = true
        
    }
    
    func goingPlan(is_going : Bool)
    {
        //shop_going_plans/1/going
        var shopIDArray = [Int]()
        
        for dict in self.placeArray
        {
            shopIDArray.append(dict["id"] as! Int)
        }
        
        let param = ["shop_ids" : shopIDArray , "is_going" : is_going] as! [String : Any]
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.url_string = "shop_going_plans/\(edit_dictionary["id"] as! Int)/going"
        APIFunction.sharedInstance.apiFunction(method: "shop_going_plans/\(edit_dictionary["id"] as! Int)/going", parameter: param, methodType: "POST") { (data, status) in
            if status == 201
            {
                self.showAlert(title: "Information", message: "You successfully response this Plan")
            }
            else
            {
                self.showAlert(title: "Information", message: "Something Wrong")
            }
            DispatchQueue.main.async {
                HUD.hide()
            }
        }
       
        
    }
    @IBAction func onClickPrivacy(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        if is_for_edit
        {
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Going", style: .default, handler: { (action) in
                self.goingPlan(is_going: true)
            }))
            alert.addAction(UIAlertAction(title: "Can't Go", style: .default, handler: { (action) in
                 self.goingPlan(is_going: false)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        else
        {
            tblPrivacyHeight.constant = 120
        }
        
    }
    @IBAction func onClickCreate(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        if is_for_edit == true
        {
            APIFunction.sharedInstance.apiDELETEMethod(method: "group_chats/\(edit_dictionary["id"] as! Int)", completion: { (response) in
                if response.status == 204
                {
                    self.showAlert(title: "Leave Group", message: "You successfully leave from this group.")
                    
                }
                else
                {
                    self.showAlert(title: "Leave Group", message: "You can't leave from this group right now. Please try again.")
                }
            })
        }
        else
        {
            if ShowPlaceArray.count > 0 && friendArray.count > 0
            {
                self.createPlan()
                
            }
            else
            {
                self.showAlert(title: "Information", message: "Please insert full data")
            }
        }
       
        
    }
    
    func leaveGroup()
    {
        
    }
    
    func createPlan()
    {
       
        HUD.show(.systemActivity)
        let place = ShowPlaceArray[0] as! [String : Any]
        var userArray = [Int]()
        var member_id_string = [String]()
        for user in friendArray
        {
            userArray.append(user.id)
            member_id_string.append(user.unique_string)
        }
        var para = [String : Any]()
        if is_from_Newfeed == false
        {
            if is_from_shop == true
            {
                para  = ["shop_id" : place["id"] as! Int , "privacy_id" :  privacy_id , "date_time" : going_date ,"users" : userArray , "group_name" : txtGroupName.text! , "type" : 1 ]
            }
            else
            {
                 para  = ["event_id" : place["id"] as! Int , "privacy_id" :  privacy_id , "date_time" : going_date ,"users" : userArray , "group_name" : txtGroupName.text! , "type" : 2]
            }
        }
        else
        {
            para  = ["shop_id" : place["id"] as! Int , "privacy_id" :  privacy_id , "date_time" : going_date ,"users" : userArray , "group_name" : txtGroupName.text! , "type" : 1 ]
        }
       
        
        APIFunction.sharedInstance.url_string = "going_plans"
        APIFunction.sharedInstance.apiFunction(method: "going_plans", parameter: para, methodType: "POST") { (data, status) in
            print("data :::::::",data)
            if status == 201
            {
                self.saveEvent()
                OperationQueue.main.addOperation {
                    
                    let data_dict = data["data"] as! Dictionary<String , Any>
                    let group = CreateGroup()
                    let groupResult = group.operateData(data_dict: data_dict)
                    print("group result ", groupResult.date_time , groupResult.unique_string)
                    let controller = AppStoryboard.User.instance.instantiateViewController(withIdentifier: "MessangerViewController") as! MessangerViewController
                    controller.isGroup = true
                    controller.time = groupResult.date_time
                    controller.groupName = self.txtGroupName.text!
                    controller.groupID = groupResult.id
                    controller.memberID_string = member_id_string
                    controller.member_ID = userArray
                    controller.going_count = 3
                    controller.groupUniqueString = groupResult.unique_string
                    controller.from_group_list = false
                    controller.is_for_create = true
                    controller.place = place["name"] as! String
                    if (self.from_id) != nil
                    {
                        controller.From_ID = self.from_id
                        
                    }
                    else
                    {
                        controller.From_ID = place["id"] as! Int
                    }
                    controller.is_from_Newfeed = self.is_from_Newfeed
                    controller.isFromShop = self.is_from_shop
                    controller.hidesBottomBarWhenPushed = true
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                }
              
            }
            
        }
        DispatchQueue.main.async {
            HUD.hide()
        }
    }
    
    func saveEvent()
    {
        let eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = self.txtGroupName.text!
                event.startDate = self.choose_date
                event.endDate = self.choose_date
                event.notes = "This is a note"
                var alarm:EKAlarm = EKAlarm(relativeOffset: -5)
                event.alarms = [alarm]

                event.addAlarm(EKAlarm(absoluteDate: event.startDate))
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            }
            else{
                
                let alert = UIAlertController(title: "Event could not save", message: (error as! NSError).localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
                
                print("failed to save event with error : \(error) or access not granted")
            }
        }
    }
    
    @IBAction func onClickDate(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        picker_view.isHidden = false
        imgTrans.isHidden = false
        
    }
    @IBAction func onClickAdd(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        //SelectPlaceView.isHidden = false
        let controller = AppStoryboard.NewFeed.instance.instantiateViewController(withIdentifier: "selectShopViewController") as! selectShopViewController
        self.navigationController?.pushViewController(controller, animated: true)
       // imgTrans.isHidden = false
        
    }
    @IBAction func onClickClose(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
      self.showPlaces()
        
    }
    @IBAction func onClickDone(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
       self.showPlaces()
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
        
        self.txtGroupName.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction(){
        view.endEditing(true)
        
    }

    func showPlaces()
    {
        tblPlaceHeight.constant = 0
        topViewHeight.constant = 110
        SelectPlaceView.isHidden = true
        imgTrans.isHidden = true
        if is_from_Newfeed == true
        {
            ShowPlaceArray = placeArray
            
        }
        
        tblPlace.backgroundColor = UIColor.clear
        tblPlaceHeight.constant = CGFloat(60 * ShowPlaceArray.count)
        topViewHeight.constant += tblPlaceHeight.constant
        
        if is_from_Newfeed == true
        {
            if ShowPlaceArray.count > 5
            {
                btnAddPlace.isHidden = true
            }
            else
            {
                btnAddPlace.isHidden = false
            }
        }
      
        tblPlace.reloadData()
    }
   
    @IBAction func onClickAddPlace(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
        if place_count < 5
        {
            btnAddPlaces.isHidden = false
            place_count += 1
            let place = "Place \(place_count)"
            let dict = ["id" : place_count , "name" : place] as [String : Any]
            placeArray.append(dict)
            print("place count ",placeArray.count)
            
            tblSelectPlaceHeight.constant = CGFloat(50 * place_count)
            tblSelectPlace.reloadData()
        }
        else
        {
            btnAddPlaces.isHidden = true
        }
        
        
        
        
    }
    @IBAction func onClickGoing(_ sender: Any) {
      let controller = AppStoryboard.NewFeed.instance.instantiateViewController(withIdentifier: "GoingViewController") as! GoingViewController
        var going = [User]()
        var invited = [User]()
        
        if let going_array = edit_dictionary["going_users"] as? [Dictionary<String , Any>]
        {
            for dict in going_array
            {
                let user = User()
                let dict = user.operateUserData(dataDict: dict)
                going.append(dict)
            }
        }
        if let invite_array = edit_dictionary["invited_users"] as? [Dictionary<String , Any>]
        {
            for dict in invite_array
            {
                let user = User()
                let dict = user.operateUserData(dataDict: dict)
                invited.append(dict)
            }
        }
        controller.going_users = going
        controller.invited_user = invited
        self.navigationController?.pushViewController(controller, animated: true)
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

extension CreateViewController : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if friendArray.count == 0
        {
            return 1
        }
        else
        {
            return friendArray.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
       
        
        cell.setShadow()
        if friendArray.count == 0
        {
            cell.lblAddFriend.isHidden = false
            cell.imgIcon.isHidden = true
            cell.lblTitle.isHidden = true
            cell.lblAddFriend.text = "Add Friend"
            cell.lblAddFriend.font = UIFont(name: BOLD_FONT, size: 15.0)
            
        }
        else
        {
            if indexPath.item == friendArray.count
            {
                cell.lblAddFriend.isHidden = false
                cell.lblAddFriend.text = "Add Friend"
                cell.lblAddFriend.font = UIFont(name: BOLD_FONT, size: TITLE_FONT_SIZE)
                
                cell.imgIcon.isHidden = true
                cell.lblTitle.isHidden = true
            }
            else
            {
                
                cell.lblAddFriend.isHidden = true
                cell.imgIcon.isHidden = false
                cell.lblTitle.isHidden = false
                
                let user = friendArray[indexPath.item]
                cell.imgIcon.setimage(url_string: "\(image_url_host)\(user.profile_picture)")
                cell.lblTitle.text = user.name
                cell.lblTitle.font = UIFont(name: LIGHT_FONT, size: TITLE_FONT_SIZE)
                cell.imgIcon.layer.cornerRadius = 25
                cell.imgIcon.clipsToBounds = true
                
            }
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if friendArray.count == 0
        {
            let controller = AppStoryboard.NewFeed.instance.instantiateViewController(withIdentifier: "SelectFriendViewController") as! SelectFriendViewController
           // controller.fromPlan = true
            controller.friend_Array = friendArray
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else
        {
            if indexPath.item == friendArray.count
            {
                  let controller = AppStoryboard.NewFeed.instance.instantiateViewController(withIdentifier: "SelectFriendViewController") as! SelectFriendViewController
                controller.friend_Array = friendArray
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
extension CreateViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if tableView.tag == 100
       {
            return ShowPlaceArray.count
        }
        else if tableView.tag == 10000
       {
            return privacyArray.count
       }
        else
       {
            return placeArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell") as! PlaceTableViewCell
            
            let place = ShowPlaceArray[indexPath.row] as! [String : Any]
            cell.lblPlaceName.text = place["name"] as! String ?? ""
            
          /*  if indexPath.row == ShowPlaceArray.count - 1
            {
               cell.imgVertical.isHidden  = true
            }
            else
            {
                cell.imgVertical.isHidden = false
            }
 */
            cell.imgVertical.isHidden = true
            
            cell.lblPlaceName.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
            
            cell.btnRadio.layer.cornerRadius = 10
            cell.btnRadio.backgroundColor = LIGHT_GRAY_COLOR
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            
        }
        else if tableView.tag == 1000
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell") as! PlaceTableViewCell
            
            let place = placeArray[indexPath.row] as! [String : Any]
            cell.lblPlaceName.text = place["name"] as! String ?? ""
            cell.lblPlaceName.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
            
            cell.btnRadio.layer.cornerRadius = 10
            cell.btnRadio.backgroundColor = LIGHT_GRAY_COLOR
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        else
        {
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyTableViewCell") as! PrivacyTableViewCell
            let privacy = privacyArray[indexPath.row]
            cell.lblCellTitle.text = privacy["privacy_name"] as? String ?? ""
            cell.lblCellTitle.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
            
            
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 10000
        {
            let privacy = privacyArray[indexPath.row]
            privacy_id = privacy["privacy_id"] as? Int ?? 0
            self.btnSelectPrivacy.setTitle(privacy["privacy_name"] as? String ?? "", for: .normal)
            self.btnSelectPrivacy.titleLabel?.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
             tblPrivacyHeight.constant = 0
        }
    }
}
