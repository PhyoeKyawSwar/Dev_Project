//
//  LoginViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 21/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import PKHUD


class LoginViewController: UIViewController {

   
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var imgVerticalLine: UIImageView!
    @IBOutlet weak var lblNya: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnForgotPass: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // imgVerticalLine.backgroundColor = TOP_COLOR
        
       // lblNya.font = UIFont(name: BOLD_FONT, size: 65)
      /* if  lblNya.applyGradientWith(startColor: TOP_COLOR, endColor: BOTTOM_COLOR)
       {
        
       }
        else
       {
        
        }
        */
        txtUserName.setNormalTextFieldLayout()
        txtUserName.placeholder = "Username"
        txtUserName.delegate = self
        
        txtPassword.setPasswordTextFieldLayout()
        txtPassword.placeholder = "Password"
        txtPassword.delegate = self
    
       // txtUserName.text = "owner@email.com"
        //txtPassword.text = "secret"
        
        btnLogin.setButtonLayout(color: BOTTOM_COLOR, title: "LOGIN")
        
        btnSignUp.setTitle("New to NYA? Signup now", for: .normal)
        btnSignUp.setTitleColor(BOTTOM_COLOR, for: .normal)
        
        lblOR.setNormalLabel(text: "-------- OR --------", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        
        
       if let token = UserDefaults.standard.value(forKey: "ACCESS_TOKEN")
        {
            print("in token have")
            OperationQueue.main.addOperation {
               self.gotoTabbarController(storyBoardID: "TabBarController")
            }
        }
 

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClickSignup(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        let controller = AppStoryboard.Signup.instance.instantiateViewController(withIdentifier: "SignupNav") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func onClickForgotPass(_ sender: Any) {
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ForgotPassViewController") as! ForgotPassViewController
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func onClickLogin(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        if txtUserName.text != "" && txtPassword.text != ""
        {
            HUD.show(.systemActivity)
            let devicetoken = UIDevice.current.identifierForVendor?.uuidString
            
            let paraDict : Dictionary<String , String> = [ "email" : txtUserName.text! , "password" : txtPassword.text! ,"device_type" : "ios" , "device_token" : devicetoken!]
            
            APIFunction.sharedInstance.apiPOSTMethod(method: "login", parems: paraDict, completion: { (response) in
                
                if response.error == nil
                {
                    if response.status == 200
                    {
                        if let data_dict = response.result as? Dictionary<String,Any>
                        {
                            print("Data Dict",data_dict)
                            if let error = data_dict["error"] as? String
                            {
                                self.showAlert(title: error, message: data_dict["message"] as! String)
                            }
                            else
                            {
                                UserDefaults.standard.set(data_dict["access_token"], forKey: "ACCESS_TOKEN")
                                UserDefaults.standard.set(data_dict["refresh_token"], forKey: "REFRESH_TOKEN")
                                UserDefaults.standard.set("", forKey: "FB_PICTURE")
                                
                               // self.getProfile()
                                OperationQueue.main.addOperation {
                                    self.gotoTabbarController(storyBoardID: "TabBarController")
                                    HUD.hide()
                                }
                            }
                            
                        }
                    }
                    else
                    {
                        self.showAlert(title: "Information", message: "Something Wrong!")
                    }
                    
                }
                else
                {
                    self.showAlert(title: "Error", message: (response.error?.localizedDescription)!)
                }
                
                DispatchQueue.main.async {
                    HUD.hide()
                }
                
            })
        }
        else
        {
             self.showAlert(title: "Information", message: "Please enter your email and password.")
        }
    }
    
   
    @IBAction func onClickFBLogin(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
        HUD.show(.systemActivity)
        let loginManager = FBSDKLoginManager()
        print("LOGIN MANAGER: \(loginManager)")
        
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self)
        {
            result in
            
            print("FBResult",result)
            
            if (result.0 != nil)
            {
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, relationship_status, email ,picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let fbDetails = result as! NSDictionary
                        
                       print("FB Access token", FBSDKAccessToken.current().tokenString)
                        print(fbDetails)
                        if let dict = fbDetails as? NSDictionary
                        {
                            if let picture = dict["picture"] as? NSDictionary
                            {
                                if let data = picture["data"] as? NSDictionary
                                {
                                    UserDefaults.standard.set(data["url"], forKey: "FB_PICTURE")
                                    
                                }
                            }
                        }
                        
                        //UIDevice.currentDevice().identifierForVendor!.UUIDString
                        
                        let devicetoken = UIDevice.current.identifierForVendor?.uuidString
                        let dict : Dictionary<String,String> = ["token" : FBSDKAccessToken.current().tokenString , "device_type" : "ios" , "device_token" : devicetoken!]
                        APIFunction.sharedInstance.apiPOSTMethod(method: "social_login", parems: dict, completion: { (response) in
                            
                            if response.error == nil
                            {
                                if response.status == 200
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
                            
                            
                        })
                        
                      
                    }
                })

            }
            else
            {
                print("Error")
                DispatchQueue.main.async {
                    HUD.hide()
                }
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

extension LoginViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
}
