//
//  EmailViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 28/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.setNormalLabel(text: "Email", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        txtEmail.setNormalTextFieldLayout()
        txtEmail.placeholder = "Email"
        txtEmail.delegate = self
        // Do any additional setup after loading the view.
        btnNext.setButtonLayout(color: BOTTOM_COLOR, title: "Next")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
        if txtEmail.text != ""
        {
            let controller = AppStoryboard.Signup.instance.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
            controller.email = txtEmail.text!
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else
        {
            showAlert(title: "Information", message: "Please fill email.")
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


extension EmailViewController : UITextFieldDelegate {
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

