//
//  GenderViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 28/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class GenderViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    var gender = String()
    var email = String()
    var password = String()
    var user_name = String()
    var birthday = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.setNormalLabel(text: "What is your gender?", color: BOTTOM_COLOR, size: 18.0, font_name: LIGHT_FONT)
        lblMale.setNormalLabel(text: "Male", color: BOTTOM_COLOR, size: 15.0, font_name: LIGHT_FONT)
        lblFemale.setNormalLabel(text: "Female", color: BOTTOM_COLOR, size: 15.0, font_name: LIGHT_FONT)
        
        btnNext.setButtonLayout(color: BOTTOM_COLOR, title: "Next")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onClickMale(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        gender = "male"
        btnMale.setImage(#imageLiteral(resourceName: "male_selected"), for: .normal)
        btnFemale.setImage(#imageLiteral(resourceName: "female"), for: .normal)
    }
    @IBAction func onClickFemale(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        gender = "female"
        btnMale.setImage(#imageLiteral(resourceName: "male"), for: .normal)
        btnFemale.setImage(#imageLiteral(resourceName: "female_selected"), for: .normal)
    }
    @IBAction func onClickNext(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        if gender != ""
        {
            let controller = AppStoryboard.Signup.instance.instantiateViewController(withIdentifier: "AddPhotoViewController") as! AddPhotoViewController
            controller.email = email
            controller.password = password
            controller.user_name = user_name
            controller.birthday = birthday
            controller.gender =  gender
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else
        {
            showAlert(title: "Information", message: "Please select gender.")
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
