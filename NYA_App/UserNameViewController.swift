//
//  UserNameViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 28/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
class UserNameViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btnNext: UIButton!

    var password = String()
    var email = String()
    override func viewDidLoad() {
        super.viewDidLoad()

       
        lblTitle.setNormalLabel(text: "Create username", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        
        txtUserName.setNormalTextFieldLayout()
        txtUserName.placeholder = "Username"
        txtUserName.delegate = self
        
        btnNext.setButtonLayout(color: BOTTOM_COLOR, title: "Next")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkUserName()
    {
        //search/user_by_username?username=owner
       /* HUD.show(.systemActivity)
        let para = ["username" : txtUserName.text!]
        APIFunction.sharedInstance.apiPOSTMethod(method: "check_username", parems: para) { (response) in
            if response.status == 200
            {
                
                if let dict = response.result as? Dictionary<String,Any>
                {
                    if dict["status"] as! Int == 0
                    {
                        self.showAlert(title: "Information", message: dict["message"] as! String)
                    }
                    else
                    {
                        let controller = AppStoryboard.Signup.instance.instantiateViewController(withIdentifier: "BirthdayViewController") as! BirthdayViewController
                        controller.email = self.email
                        controller.password = self.password
                        controller.user_name = self.txtUserName.text!
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
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
 */
        
        HUD.show(.systemActivity)
        let devicetoken = UIDevice.current.identifierForVendor?.uuidString
        
        let paraDict = ["username" : txtUserName.text!] as! [String:Any]
        APIFunction.sharedInstance.url_string =  "check_username"
        APIFunction.sharedInstance.apiFunction(method: "check_username" , parameter: paraDict, methodType: "POST") { (data, statusCode) in
            
            if statusCode == 200
            {
                
                if let dict = data as? Dictionary<String,Any>
                {
                    if dict["status"] as! Int == 0
                    {
                        self.showAlert(title: "Information", message: dict["message"] as! String)
                    }
                    else
                    {
                         DispatchQueue.main.async {
                            let controller = AppStoryboard.Signup.instance.instantiateViewController(withIdentifier: "BirthdayViewController") as! BirthdayViewController
                            controller.email = self.email
                            controller.password = self.password
                            controller.user_name = self.txtUserName.text!
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                       
                    }
                }
            }
            else
            {
                self.showAlert(title: "Error", message:"Something Wrong, Please try again")
            }
            DispatchQueue.main.async {
                HUD.hide()
            }
       
    }
}

    @IBAction func onClickNext(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        if txtUserName.text != ""
        {
            
            self.checkUserName()
            
        }
        else
        {
            showAlert(title: "Information", message: "Please fill Username.")
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


extension UserNameViewController : UITextFieldDelegate {
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

