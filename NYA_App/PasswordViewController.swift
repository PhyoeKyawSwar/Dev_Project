//
//  PasswordViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 8/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    var email = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        lblTitle.setNormalLabel(text: "Create Password", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        
        txtPassword.setNormalTextFieldLayout()
        txtPassword.placeholder = "Password"
        txtPassword.delegate = self
        txtPassword.isSecureTextEntry = true
      
        txtConfirmPassword.setNormalTextFieldLayout()
        txtConfirmPassword.placeholder = "Confirm Password"
        txtConfirmPassword.delegate = self
        txtConfirmPassword.isSecureTextEntry = true
        
        btnNext.setButtonLayout(color: BOTTOM_COLOR, title: "Next")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
        if txtConfirmPassword.text != "" && txtPassword.text != ""
        {
            if txtConfirmPassword.text == txtPassword.text
            {
                let controller = AppStoryboard.Signup.instance.instantiateViewController(withIdentifier: "UserNameViewController") as! UserNameViewController
                controller.email = email
                controller.password = txtConfirmPassword.text!
                self.navigationController?.pushViewController(controller, animated: true)
            }
            else
            {
                showAlert(title: "Information", message: "Password not match. Please enter again.")
            }
        }
        else
        {
            showAlert(title: "Information", message: "Please enter password.")
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

extension PasswordViewController : UITextFieldDelegate {
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


