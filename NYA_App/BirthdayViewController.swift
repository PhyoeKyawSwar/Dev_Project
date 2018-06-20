//
//  BirthdayViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 28/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class BirthdayViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var customPickerView: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    var email = String()
    var password = String()
    var user_name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblTitle.setNormalLabel(text: "When's your birthday?", color: BOTTOM_COLOR, size: 18.0, font_name: LIGHT_FONT)
        
        txtBirthday.setNormalTextFieldLayout()
        txtBirthday.placeholder = "Birthday"
        txtBirthday.delegate = self
        
        btnNext.setButtonLayout(color: BOTTOM_COLOR, title: "Next")
        
        btnDone.setTitle("Done", for: .normal)
        btnDone.setTitleColor(BOTTOM_COLOR, for: .normal)
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.setTitleColor(BOTTOM_COLOR, for: .normal)
        
        self.hideDatePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideDatePicker ()
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.customPickerView.layer.add(transition, forKey: nil)
        UIView.commitAnimations()
        
        customPickerView.isHidden = true
        
        
    }
    func showDatePicker()
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.customPickerView.layer.add(transition, forKey: nil)
        UIView.commitAnimations()
        
        customPickerView.isHidden = false
        datepicker.datePickerMode = .date
        
    }
    

    @IBAction func onClickNext(_ sender: Any) {
        
        let button = sender as! UIButton
        button.animate()
        if txtBirthday.text != ""
        {
            let controller = AppStoryboard.Signup.instance.instantiateViewController(withIdentifier: "GenderViewController") as! GenderViewController
            controller.email = email
            controller.password = password
            controller.user_name = user_name
            controller.birthday = txtBirthday.text!
            
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        else
        {
            showAlert(title: "Information", message: "Please select Birthday.")
        }
    }
    @IBAction func onClickCancel(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        self.hideDatePicker()
    }
    @IBAction func onClickDone(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        self.hideDatePicker()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let preferDate = formatter.string(from: datepicker.date)
        print("Date ",preferDate)
        txtBirthday.text = preferDate

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

extension BirthdayViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.showDatePicker()
        return false
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



