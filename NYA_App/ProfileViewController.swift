//
//  ProfileViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 13/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import SDWebImage
import PKHUD
class ProfileViewController: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnFollow: UIButton!
     @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var Review_View: UIView!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblReviewValue: UILabel!
    @IBOutlet weak var Follow_View: UIView!
    @IBOutlet weak var lblFollow: UILabel!
    @IBOutlet weak var lblFollowValue: UILabel!
    @IBOutlet weak var Polls_View: UIView!
    @IBOutlet weak var lblPolls: UILabel!
    @IBOutlet weak var lblPollsValue: UILabel!
    @IBOutlet weak var imgFeature1: UIImageView!
    @IBOutlet weak var imgFeature2: UIImageView!
    @IBOutlet weak var imgFeature3: UIImageView!
    @IBOutlet weak var imgFeature4: UIImageView!
    @IBOutlet weak var btnLinkFB: UIButton!
    @IBOutlet weak var lblReviews: UILabel!
    
    @IBOutlet weak var ActionHeight: NSLayoutConstraint!
    @IBOutlet weak var btnUpdateFeature: UIButton!
    var User_Dict = User()
    
    var imageString1 = String()
    var imageString2 = String()
    var imageString3 = String()
    var imageString4 = String()
    
    var imageStringArray = [String]()
    
    var imageTag = Int()
    var edit_Button = UIBarButtonItem()
    var user_id = Int()
    var is_User = Bool()
    
    var imageArray = [FeaturedImage]()
    @IBOutlet weak var btnPreviousReview: UIButton!
    @IBOutlet weak var fbButtonHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getProfile()
    }
    func setUpUI()
    {
        print("User dict",self.User_Dict)
        self.imgProfile.layer.cornerRadius = 50
        self.imgProfile.clipsToBounds = true
        
        if self.is_User == false
        {
            ActionHeight.constant = 40
            self.setButton(color: GRAY_COLOR, title: "Add Friend", btn: btnAdd)
            self.setButton(color: GRAY_COLOR, title: "Follow", btn: btnFollow)
            self.setButton(color: GRAY_COLOR, title: "Message", btn: btnMessage)
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 0.0
            
            if User_Dict.friend_status == "no"
            {
                self.btnAdd.setTitleColor(LIGHT_GRAY_COLOR, for: .normal)
                self.btnAdd.setTitle("Add Friend", for: .normal)
                
            }
            else if User_Dict.friend_status == "confirmed"
            {
                self.btnAdd.setTitleColor(BOTTOM_COLOR, for: .normal)
                self.btnAdd.setTitle("Friend", for: .normal)
                
            }
            else
            {
                self.btnAdd.setTitle("Pending", for: .normal)
                self.btnAdd.setTitleColor(LIGHT_GRAY_COLOR, for: .normal)
            }
        }
        else
        {
            ActionHeight.constant = 0
            edit_Button = UIBarButtonItem(image: #imageLiteral(resourceName: "edit_icon"), style: .plain, target: self, action: #selector(self.editClick))
            self.navigationItem.rightBarButtonItem = edit_Button
            
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 1.0
            self.setButton(color: UIColor.clear, title: "", btn: btnAdd)
            self.setButton(color: UIColor.clear, title: "", btn: btnFollow)
            self.setButton(color: UIColor.clear, title: "", btn: btnMessage)
            self.navigationItem.rightBarButtonItem = edit_Button
        }
        
        if User_Dict.follow_status == true
        {
            self.btnFollow.setTitle("Following", for: .normal)
            self.btnFollow.setTitleColor(BOTTOM_COLOR, for: .normal)
        }
        
       
        
        print("profile ##### " ,self.User_Dict.profile_picture)
        if self.User_Dict.profile_picture.contains("/storage")
        {
            self.imgProfile.setUserimage(url_string: "\(image_url_host)\(self.User_Dict.profile_picture)")
            
        }
        else
        {
             self.imgProfile.setUserimage(url_string: self.User_Dict.profile_picture)
            
        }
        
        lblName.setNormalLabel(text: self.User_Dict.name, color: BLACK_COLOR, size: 18.0, font_name: BOLD_FONT)
        
        user_id = User_Dict.id
        
        lblBio.setNormalLabel(text: self.User_Dict.bio, color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        
        lblReview.setNormalLabel(text: "REVIEWS", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        
        lblFollow.setNormalLabel(text: "FOLLOWERS", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        
        lblPolls.setNormalLabel(text: "POLLS", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        
        lblReviewValue.text = ""
        lblFollowValue.text = ""
        lblPollsValue.text = ""
        
        if let array = self.User_Dict.images as? [FeaturedImage]
        {
            
            self.imageArray = array
            if self.imageArray.count > 0
            {
              self.setFeatureImages()
            }
            
            
        }
        
        lblReviewValue.setNormalLabel(text: "\(User_Dict.reviews )", color: BOTTOM_COLOR, size: 15.0, font_name: LIGHT_FONT)
        
        lblFollowValue.setNormalLabel(text: "\(User_Dict.followers)", color: BOTTOM_COLOR, size: 15.0, font_name: LIGHT_FONT)
        
        lblPollsValue.setNormalLabel(text: "\(User_Dict.polls)", color: BOTTOM_COLOR, size: 15.0, font_name: LIGHT_FONT)
        
        self.setButton(color: BOTTOM_COLOR, title: "Update Feature Photo", btn: btnUpdateFeature)
        self.setButton(color: BOTTOM_COLOR, title: "Link to Facebook", btn: btnLinkFB)
        self.setButton(color: BOTTOM_COLOR, title: "See your Previous Reviews", btn: btnPreviousReview)
        
        
        
        imgFeature1.isUserInteractionEnabled = true
        let gesture1 = UITapGestureRecognizer(target: self, action:#selector(self.tapImage1(tap: )))
        imgFeature1.addGestureRecognizer(gesture1)
        
        imgFeature2.isUserInteractionEnabled = true
        let gesture2 = UITapGestureRecognizer(target: self, action:#selector(self.tapImage2(tap: )))
        imgFeature2.addGestureRecognizer(gesture2)
        
        imgFeature3.isUserInteractionEnabled = true
        let gesture3 = UITapGestureRecognizer(target: self, action:#selector(self.tapImage3(tap: )))
        imgFeature3.addGestureRecognizer(gesture3)
        
        imgFeature4.isUserInteractionEnabled = true
        let gesture4 = UITapGestureRecognizer(target: self, action:#selector(self.tapImage4(tap: )))
        imgFeature4.addGestureRecognizer(gesture4)
        
        self.perform(#selector(self.setScrollSize), with: nil, afterDelay: 3.0)
        
       
    }
    func setScrollSize ()
    {
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1500)
    }
    func tapImage1(tap : UITapGestureRecognizer)
    {
        imageTag = 1
        self.showImagePicker()
    }
    func tapImage2(tap : UITapGestureRecognizer)
    {
        imageTag = 2
        self.showImagePicker()
    }
    func tapImage3(tap : UITapGestureRecognizer)
    {
        imageTag = 3
        self.showImagePicker()
    }
    func tapImage4(tap : UITapGestureRecognizer)
    {
        imageTag = 4
        self.showImagePicker()
    }
    
    func setButton(color : UIColor , title : String , btn : UIButton)
    {
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = color.cgColor
       
        btn.setTitleColor(color, for: .normal)
        btn.setTitle(title, for: .normal)
        
    }
    @IBAction func onClickPreviousReview(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        let controller = AppStoryboard.User.instance.instantiateViewController(withIdentifier: "PreviousReviewViewController") as! PreviousReviewViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func editClick()
    {
        let controller = AppStoryboard.User.instance.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        controller.user_dict = self.User_Dict
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func getProfile ()
    {
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "users/\(self.User_Dict.id)") { (response) in
            print("Http status code",response.status)
            if response.error == nil
            {
                if response.status == 200
                {
                    if let dict = response.result as? Dictionary<String,Any>
                    {
                        let user_dict = dict["data"] as! Dictionary<String,Any>
                        OperationQueue.main.addOperation {
                            
                            let user = User()
                            print("User dict",user_dict)
                            self.User_Dict = user.operateUserData(dataDict: user_dict)
                            
                            UserDefaults.standard.set(self.User_Dict.name , forKey: "USER_NAME")
                            UserDefaults.standard.set(self.User_Dict.id , forKey: "USER_ID")
                            DispatchQueue.main.async {
                                self.setUpUI()
                                
                            }
                            
                            
                        }
                    }
                }
                else
                {
                     self.showAlert(title: "Error", message: "Something wrong !")
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
    
    func setFeatureImages()
    {
       
            for index in 0...self.imageArray.count - 1
            {
                if index == 0
                {
                    if let dict1 = self.imageArray[0] as? FeaturedImage
                    {
                        if let imageurl1 = dict1.image as? String
                        {
                            self.imgFeature1.setimage(url_string:"\(image_url_host)\(imageurl1)")
                        }
                    }
                }
                if index == 1
                {
                    if let dict2 = self.imageArray[1] as? FeaturedImage
                    {
                        if let imageurl2 = dict2.image as? String
                        {
                            self.imgFeature2.setimage(url_string:"\(image_url_host)\(imageurl2)")
                        }
                    }
                }
                
                if index == 2
                {
                    if let dict3 = self.imageArray[2] as? FeaturedImage
                    {
                        if let imageurl3 = dict3.image as? String
                        {
                            self.imgFeature3.setimage(url_string:"\(image_url_host)\(imageurl3)")
                        }
                    }
                }
                if index == 3
                {
                    if let dict4 = self.imageArray[3] as? FeaturedImage
                    {
                        if let imageurl4 = dict4.image as? String
                        {
                            self.imgFeature4.setimage(url_string:"\(image_url_host)\(imageurl4)")
                        }
                    }
                }
                
            }
            
        
        
    }
    @IBAction func onClickUpdateFeature(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        HUD.show(.systemActivity)
        
        let parameter  = ["images":imageStringArray] as! [String : Any]
        APIFunction.sharedInstance.USER_ID = self.user_id
        APIFunction.sharedInstance.url_string = "users/\(self.user_id)/images"
        APIFunction.sharedInstance.apiFunction(method: "users/\(self.user_id)/images", parameter: parameter, methodType: "POST") { (data, status) in
            
            print(data, status  )
            
            if status == 201
            {
                if let array = data["data"] as? [FeaturedImage]
                {
                    self.imageArray = array
                    if self.imageArray.count > 0
                    {
                        self.setFeatureImages()
                    }
                    
                    DispatchQueue.main.async {
                        HUD.hide()
                        
                    }
                    
                }
            }
            else
            {
                self.showAlert(title: "Information", message: "Something wrong ")
            }
            DispatchQueue.main.async {
                HUD.hide()
            }
        }
        /*APIFunction.sharedInstance.apiFunction(method: "users/\(self.user_id)/images", parameter: parameter, methodType: "POST") { (data,statusCode) in
            print("Data :::::",data)
            if let array = data["data"] as? [FeaturedImage]
            {
                 self.imageArray = array
                    if self.imageArray.count > 0
                    {
                        self.setFeatureImages()
                    }
                    
                DispatchQueue.main.async {
                    HUD.hide()
                    
                }
                
            }
        }*/
 
       /* APIFunction.sharedInstance.apiPOSTMethod(method: "users/\(self.user_id)/images", parems: parameter) { (response) in
            print("Response",response.)
        }
 */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClickAdd(_ sender: Any) {
        //users/id/add_friend
        let button = sender as! UIButton
        button.animate()
        HUD.show(.systemActivity)
        let parameter  = ["requested_user_id":self.user_id] as! [String : Any]
        APIFunction.sharedInstance.USER_ID = self.user_id
        APIFunction.sharedInstance.url_string = "add_friend"
        APIFunction.sharedInstance.apiFunction(method: "add_friend", parameter: parameter, methodType: "POST") { (data, statusCode) in
            
            if statusCode == 201
            {
                if let dataDict = data as? Dictionary<String,Any>
                {
                    let dataDict = data["data"] as? Dictionary<String,Any>
                    let add = AddFriend()
                    let dict = add.operateData(dictData: dataDict!)
                    
                    print("Follow ::::: ",dict.follow)
                    
                    DispatchQueue.main.sync {
                        if dict.follow == false
                        {
                            self.setButton(color: GRAY_COLOR, title: "Add Friend", btn: self.btnAdd)
                            self.setButton(color: GRAY_COLOR, title: "Follow", btn: self.btnFollow)
                            
                        }
                        else
                        {
                            self.setButton(color: GRAY_COLOR, title: "\(add.friend_status)", btn: self.btnAdd)
                            self.setButton(color: BOTTOM_COLOR, title: "Follow", btn: self.btnFollow)
                            
                        }
                    }
                    
                }
            }
            else
            {
                self.showAlert(title: "Information", message: "Something wrong!")
            }
            
             DispatchQueue.main.sync {
                    HUD.hide()
            }
        }
        /*APIFunction.sharedInstance.apiFunction(method: "users/id/add_friend", parameter: parameter, methodType: "POST") { (data) in
            print("Data :::::",data)
            if let dataDict = data as? Dictionary<String,Any>
            {
                let dataDict = data["data"] as? Dictionary<String,Any>
                let add = AddFriend()
                let dict = add.operateData(dictData: dataDict!)
                
                print("Follow ::::: ",dict.follow)
                
                DispatchQueue.main.sync {
                    if dict.follow == false
                    {
                        self.setButton(color: GRAY_COLOR, title: "Add Friend", btn: self.btnAdd)
                        self.setButton(color: GRAY_COLOR, title: "Follow", btn: self.btnFollow)
                        
                    }
                    else
                    {
                        self.setButton(color: GRAY_COLOR, title: "\(add.friend_status)", btn: self.btnAdd)
                        self.setButton(color: BOTTOM_COLOR, title: "Follow", btn: self.btnFollow)
                        
                    }
                }
               
            }
           
        }
 */
 
    }
    @IBAction func onClickFollow(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        HUD.show(.systemActivity)
        let para  = ["requested_user_id" : self.User_Dict.id , "following" : 1] as! [String : Any]
        APIFunction.sharedInstance.url_string = "follow"
        APIFunction.sharedInstance.apiFunction(method: "follow", parameter: para, methodType: "POST") { (data, status) in
            print("Data",data)
            if status == 201
            {
                if let dict = data as? [String : Any]
                {
                    
                        var message = ""
                    let data_dict = dict["data"] as? [String : Any]
                    let follow_status = data_dict!["following"] as? Bool
                        if follow_status == true
                        {
                            message = "You successfully followed \(self.User_Dict.name)"
                            self.btnFollow.setTitle("Following", for: .normal)
                            self.btnFollow.setTitleColor(BOTTOM_COLOR, for: .normal)
                        }
                        else
                        {
                            message = "You can't follow \(self.User_Dict.name) right now"
                        }
                        self.showAlert(title: "Following", message: message)
                    
                }
            }
            DispatchQueue.main.async {
                HUD.hide()
            }
        }
    }
   
    
    @IBAction func onClickMessage(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
       /* let controller = AppStoryboard.User.instance.instantiateViewController(withIdentifier: "MessangerViewController") as! MessangerViewController
        controller.userDict = User_Dict
        controller.private_Chat_String = User_Dict.unique_string
        controller.isGroup = false
        self.navigationController?.pushViewController(controller, animated: true)
 */
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        controller.selectedIndex = 1
        self.present(controller, animated: true, completion:nil)
    }
    @IBAction func onClickLinkFB(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
    }
    
    @IBAction func onClickAddphoto(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
       
        self.showImagePicker()
        
    }
    
    func showImagePicker ()
    {
        let alert = UIAlertController(title: "Choose Photo", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {
            action in
            
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let newImage = image.resizeImage(image: image, targetSize: CGSize(width: 185, height: 120))
        switch imageTag {
        case 0 :
            imgProfile.image = image
            break
        case 1 :
            imageString1 = convertImageToBase64(image: newImage)
            imgFeature1.image = image
            imageStringArray.append(imageString1)
            break
        case 2 :
            imageString2 = convertImageToBase64(image: newImage)
            imgFeature2.image = image
            imageStringArray.append(imageString2)
            break
        case 3 :
            imageString3 = convertImageToBase64(image: newImage)
            imgFeature3.image = image
            imageStringArray.append(imageString3)
            break
        case 4 :
            imageString4 = convertImageToBase64(image: newImage)
            imgFeature4.image = image
            imageStringArray.append(imageString4)
            break
        default:
            break
        }
        
        dismiss(animated:true, completion: nil)
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
