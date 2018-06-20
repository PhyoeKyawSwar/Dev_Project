//
//  ForgotPassViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 29/4/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
class ForgotPassViewController: UIViewController {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblForgot: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnReset: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        txtEmail.setNormalTextFieldLayout()
        txtEmail.placeholder = "Email"
        txtEmail.delegate = self
        btnReset.setButtonLayout(color: BOTTOM_COLOR, title: "Reset")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func forgotPass()
    {
       
        /*
         {
         "data": {
         "message": "We can't find a user with that e-mail address."
         }
         }
 */
        if txtEmail.text != ""
        {
            HUD.show(.systemActivity)
            let paraDict : Dictionary<String , String> = [ "email" : txtEmail.text!]
            
            APIFunction.sharedInstance.apiPOSTMethod(method: "password/email", parems: paraDict, completion: { (response) in
                
                if response.error == nil
                {
                    if response.status == 200
                    {
                        if let data_dict = response.result as? Dictionary<String,Any>
                        {
                            if let data_result = data_dict["data"] as? Dictionary<String,Any>
                            {
                                let alert = UIAlertController(title: "Forgot Password", message: data_result["message"] as? String ?? "", preferredStyle: .alert)
                                let ok_action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                    self.dismiss(animated: true, completion: nil)
                                })
                                alert.addAction(ok_action)
                                DispatchQueue.main.async {
                                    self.present(alert, animated: true, completion: nil)
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
            DispatchQueue.main.async {
                HUD.hide()
            }
             self.showAlert(title: "Information", message: "Please enter your email.")
        }
    }
    
    @IBAction func onClickReset(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
       self.forgotPass()
    }
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
extension ForgotPassViewController : UITextFieldDelegate {
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

