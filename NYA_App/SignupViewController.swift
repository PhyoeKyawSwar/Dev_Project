//
//  SignupViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 28/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import PKHUD
class SignupViewController: UIViewController {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var imgVerticalSp: UIImageView!
    @IBOutlet weak var lblNya: UILabel!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var btnEmailSignup: UIButton!
    @IBOutlet weak var imgBottomSp: UIImageView!
    @IBOutlet weak var lblAlreadyAcc: UILabel!
    @IBOutlet weak var btnSignin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imgIcon.image = #imageLiteral(resourceName: "icon")
        imgVerticalSp.backgroundColor = TOP_COLOR
        
        lblNya.font = UIFont(name: BOLD_FONT, size: 65)
        if  lblNya.applyGradientWith(startColor: TOP_COLOR, endColor: BOTTOM_COLOR)
        {
            
        }
        else
        {
            
        }
        btnEmailSignup.setTitle("Sign up with email", for: .normal)
        btnEmailSignup.setTitleColor(BOTTOM_COLOR, for: .normal)
        
        
        btnFacebook.layer.cornerRadius = 5
        
        imgBottomSp.backgroundColor = GRAY_COLOR
        
       lblAlreadyAcc.setNormalLabel(text: "Already have an account?", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        lblOR.setNormalLabel(text: "-------- OR --------", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        
        btnSignin.setTitle("Sign in", for: .normal)
        btnSignin.setTitleColor(BOTTOM_COLOR, for: .normal)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClickEmailSignup(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        let controller = AppStoryboard.Signup.instance.instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func onClickSignIn(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(controller, animated: true, completion: nil)

    }
    @IBAction func onClickFb(_ sender: Any) {
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
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, relationship_status, email , picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let fbDetails = result as! NSDictionary
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
                        print("FB Access token", FBSDKAccessToken.current().tokenString)
                        print(fbDetails)
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
