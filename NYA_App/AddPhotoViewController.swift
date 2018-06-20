//
//  AddPhotoViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 28/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
class AddPhotoViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAddphoto: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    var userImage = UIImage()
    @IBOutlet weak var btnSignup: UIButton!
    
    var email = String()
    var password = String()
    var user_name = String()
    var birthday = String()
    var gender = String()
     var imageString = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imgProfile.image = #imageLiteral(resourceName: "camera")
        imgProfile.layer.cornerRadius = 50
        imgProfile.clipsToBounds = true
        
        lblTitle.setNormalLabel(text: "Add profile picture", color: BOTTOM_COLOR, size: 18.0, font_name: LIGHT_FONT)
        
        btnAddphoto.setButtonLayout(color: BOTTOM_COLOR, title: "Add a photo")
        btnSignup.setButtonLayout(color: BOTTOM_COLOR, title: "Sign Up")
        
        btnSkip.setTitle("Skip", for: .normal)
        btnSkip.setTitleColor(BOTTOM_COLOR, for: .normal)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickSkip(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
       /* let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.present(controller, animated: true, completion: nil)
 */
        self.signUp()
    }
    @IBAction func onClickAddphoto(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
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
        let newImage = image.resizeImage(image: image, targetSize: CGSize(width: 200, height: 200))
        imgProfile.image = newImage
        
        imageString = convertImageToBase64(image: newImage)
        
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func onClickSignup(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        self.signUp()
       /* if Reachability.isConnectedToNetwork() == true
        {
            self.signUp()
            print("Internet Connection Available!")
        }
        else
        {
            print("Internet Connection not Available!")
           showAlert(title: "Information", message: "Please check your connection.")
            
        }
 */
       
    }
    
    func signUp()
    {
        HUD.show(.systemActivity)
        let devicetoken = UIDevice.current.identifierForVendor?.uuidString
        
        let paraDict = ["name" : user_name , "username":user_name , "email" : email , "password" : password , "password_confirmation" : password , "birthday" : birthday , "gender" : gender , "profile_picture" : imageString , "device_type" : "ios" , "device_token" : devicetoken] as! [String:Any]
        APIFunction.sharedInstance.url_string =  "register"
        APIFunction.sharedInstance.apiFunction(method: "register" , parameter: paraDict, methodType: "POST") { (data, statusCode) in
            
            if statusCode == 200
            {
                if let data_dict = data as? Dictionary<String,Any>
                {
                    UserDefaults.standard.set(data_dict["access_token"], forKey: "ACCESS_TOKEN")
                    UserDefaults.standard.set(data_dict["refresh_token"], forKey: "REFRESH_TOKEN")
                    UserDefaults.standard.set("", forKey: "FB_PICTURE")
                    
                    self.getProfile()
                   
                }
            }
            else
            {
                if let data_dict = data as? Dictionary<String,Any>
                {
                    let message = data_dict["message"] as? String ?? ""
                    self.showAlert(title: "Information", message: message)
                }
            }
            DispatchQueue.main.async {
                HUD.hide()
            }
        }
       /* APIFunction.sharedInstance.apiFunction(method: "register", parameter: paraDict, methodType: "POST") { (data) in
            
            print("Data ::::::",data)
            if let data_dict = data as? Dictionary<String,Any>
            {
                UserDefaults.standard.set(data_dict["access_token"], forKey: "ACCESS_TOKEN")
                UserDefaults.standard.set(data_dict["refresh_token"], forKey: "REFRESH_TOKEN")
                
                OperationQueue.main.addOperation {
                    self.gotoTabbarController(storyBoardID: "TabBarController")
                    HUD.hide()
                }
            }
            
        }
 */
     /*   APIFunction.sharedInstance.apiPOSTMethod(method : "register" ,parems: paraDict) { (response) in
            
            if response.error == nil
            {
                if let data_dict = response.result as? Dictionary<String,Any>
                {
                    if let error = data_dict["error"] as? String
                    {
                        self.showAlert(title: error, message: data_dict["message"] as! String)
                    }
                    else
                    {
                        UserDefaults.standard.set(data_dict["access_token"], forKey: "ACCESS_TOKEN")
                        UserDefaults.standard.set(data_dict["refresh_token"], forKey: "REFRESH_TOKEN")
                        
                        OperationQueue.main.addOperation {
                            self.gotoTabbarController(storyBoardID: "TabBarController")
                            HUD.hide()
                        }
                    }
                    
                }
            }
            else
            {
                self.showAlert(title: "Error", message: (response.error?.localizedDescription)!)
            }
            
            OperationQueue.main.addOperation {
                
                HUD.hide()
            }
            
            
        }*/
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
                        let user_dict = dict["data"] as! Dictionary<String,Any>
                        OperationQueue.main.addOperation {
                            
                            let user = User()
                            var User_Dict = user.operateUserData(dataDict: user_dict)
                            
                            UserDefaults.standard.set(User_Dict.name , forKey: "USER_NAME")
                            UserDefaults.standard.set(User_Dict.id , forKey: "USER_ID")
                            
                            OperationQueue.main.addOperation {
                                self.gotoTabbarController(storyBoardID: "TabBarController")
                                HUD.hide()
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
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
