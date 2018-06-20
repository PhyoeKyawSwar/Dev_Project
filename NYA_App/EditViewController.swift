//
//  EditViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 16/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import TextFieldEffects
import PKHUD
class EditViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnChangeProfile: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: HoshiTextField!
    @IBOutlet weak var txtUserName: HoshiTextField!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblbio: UILabel!
    @IBOutlet weak var txtBio: HoshiTextField!
    @IBOutlet weak var UserInfoView: UIView!
    @IBOutlet weak var lblPersonalInfo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: HoshiTextField!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var txtGender: HoshiTextField!
    @IBOutlet weak var btnGender: UIButton!
    @IBOutlet weak var lblBirthday: UILabel!
    @IBOutlet weak var txtBirthday: HoshiTextField!
    @IBOutlet weak var btnBirthday: UIButton!
    @IBOutlet weak var lblTsp: UILabel!
    @IBOutlet weak var txtTsp: HoshiTextField!
    @IBOutlet weak var btnTsp: UIButton!
    @IBOutlet weak var lblLive: UILabel!
    @IBOutlet weak var txtLive: HoshiTextField!
    @IBOutlet weak var btnLive: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    
    @IBOutlet weak var customPickerView: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    @IBOutlet weak var genderPicker: UIPickerView!
    var isDatePicker = false
    var genderArray = ["male" , "female"]
    
    var imageString = String()
    
    var user_dict = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.perform(#selector(self.setscrollSize), with: nil, afterDelay: 3.0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideDatePicker()
        addDoneButtonOnKeyboard()
    }
    func setscrollSize()
    {
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 800.0)
    }
    
    func setUpUI()
    {
        self.imgProfile.layer.cornerRadius = 50
        self.imgProfile.clipsToBounds = true
        if let profile_pic = UserDefaults.standard.value(forKey: "FB_PICTURE") as? String
        {
            self.imgProfile.setUserimage(url_string: profile_pic)
        }
        else
        {
            self.imgProfile.setUserimage(url_string: "\(image_url_host)\(self.user_dict.profile_picture)")
            
        }
         lblName.setNormalLabel(text: "Name", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        lblbio.setNormalLabel(text: "Bio", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        lblTsp.setNormalLabel(text: "TownShip", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        lblLive.setNormalLabel(text: "Live in", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        lblEmail.setNormalLabel(text: "Email", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        lblGender.setNormalLabel(text: "Gender", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        lblBirthday.setNormalLabel(text: "Birthday", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        lblUserName.setNormalLabel(text: "Username", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        lblPersonalInfo.setNormalLabel(text: "Personal Infromation", color: GRAY_COLOR, size: 18.0, font_name: BOLD_FONT)
        
        
        self.setButton(color: GRAY_COLOR, title: "Only Me", btn: btnTsp)
        self.setButton(color: GRAY_COLOR, title: "Only Me", btn: btnLive)
        self.setButton(color: GRAY_COLOR, title: "Only Me", btn: btnEmail)
        self.setButton(color: GRAY_COLOR, title: "Only Me", btn: btnGender)
        self.setButton(color: GRAY_COLOR, title: "Only Me", btn: btnBirthday)
        self.setButton(color: GRAY_COLOR, title: "Change Profile", btn: btnChangeProfile)
        self.setButton(color: GRAY_COLOR, title: "Update", btn: btnUpdate)
        
        self.txtName.text = user_dict.name
        self.txtBio.text = user_dict.bio
        self.txtUserName.text = user_dict.user_name
        
        
        txtBirthday.delegate = self
        txtBio.delegate = self
        txtTsp.delegate = self
        txtLive.delegate = self
        txtName.delegate = self
        txtEmail.delegate = self
        txtGender.delegate = self
        txtUserName.delegate = self
        
    }

    func setButton(color : UIColor , title : String , btn : UIButton)
    {
        if btn != btnChangeProfile && btn != btnUpdate
        {
            btn.isHidden = true
        }
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 2
        btn.layer.borderColor = color.cgColor
        btn.setTitleColor(color, for: .normal)
        btn.setTitle(title, for: .normal)
        
    }
    
   /* func validTextfield() -> Bool
    {
        var validate = false
        
        
    }
 */
    
    func updateProfile()
    {
        
        HUD.show(.systemActivity)
        let dict  = ["id" : "\(user_dict.id)","name" : self.txtName.text! , "username" : self.txtUserName.text! , "bio" : self.txtBio.text! , "email" : self.txtEmail.text! , "gender" : self.txtGender.text! , "birthday" : self.txtBirthday.text! , "current_town" :self.txtLive.text! , "home_town" : self.txtTsp.text! , "profile_picture" :imageString] as! [String : Any]
        
        APIFunction.sharedInstance.USER_ID = user_dict.id
        APIFunction.sharedInstance.url_string = "users/\(user_dict.id)"
        APIFunction.sharedInstance.apiFunction(method: "users/\(user_dict.id)", parameter: dict, methodType: "PATCH") { (data, statusCode) in
            var message = ""
            if statusCode == 204
            {
                   message = "Successfully updated user info!"
                let alert = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            else
            {
                message = "Fail to update user info !"
                let alert = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            DispatchQueue.main.async {
                HUD.hide()
            }
           
        }
 
        /* APIFunction.sharedInstance.apiPATCHMethod(method: "users/\(user_dict.id)", parems: dict) { (response) in
            print("Update " , response.status)
        }
         
         APIFunction.sharedInstance.apiPOSTMethod(method: "users/\(user_dict.id)", parems: dict) { (response) in
         print("response",response.status)
         }
 */
        
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickChangeProfile(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        self.showImagePicker()
    }
    
    @IBAction func onClickLive(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
    }
    @IBAction func onClickBirthday(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
    }
    @IBAction func onClickTsp(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
    }
    @IBAction func onClickGender(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
    }
    @IBAction func onClickEmail(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
    }
    @IBAction func textfieldReturn(_ sender: HoshiTextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func onClickUpdate(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        self.updateProfile()
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
        let newImage = image.resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
        //let newImage = image.resized(toWidth: 100.0)
        imageString = convertImageToBase64(image: newImage)
       
        self.imgProfile.image = newImage
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func onClickTextField(_ sender: UITextField) {
        let button = sender as! UIButton
        button.animate()
        sender.resignFirstResponder()
        self.showDatePicker()
    }
    
    func hideDatePicker ()    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.customPickerView.layer.add(transition, forKey: nil)
        UIView.commitAnimations()
        customPickerView.isHidden = true
        
        
    }
    
    func showDatePicker()    {
        
        btnDone.setTitle("Done", for: .normal)
        btnDone.setTitleColor(BOTTOM_COLOR, for: .normal)
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.setTitleColor(BOTTOM_COLOR, for: .normal)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.customPickerView.layer.add(transition, forKey: nil)
        UIView.commitAnimations()
        if isDatePicker == true
        {
            self.datepicker.datePickerMode = .date
            self.datepicker.isHidden = false
            self.genderPicker.isHidden = true
        }
        else {
            self.genderPicker.isHidden = false
            self.datepicker.isHidden = true
            genderPicker.delegate = self
            genderPicker.dataSource = self
        }
        customPickerView.isHidden = false
        
        
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
    
    func addDoneButtonOnKeyboard(){
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.insert(flexSpace, at: 0)
        items.insert(done, at: 1)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.txtBio.inputAccessoryView = doneToolbar
        self.txtTsp.inputAccessoryView = doneToolbar
        self.txtLive.inputAccessoryView = doneToolbar
        self.txtName.inputAccessoryView = doneToolbar
        self.txtGender.inputAccessoryView = doneToolbar
        self.txtBirthday.inputAccessoryView = doneToolbar
        self.txtUserName.inputAccessoryView = doneToolbar
        self.txtEmail.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction(){
        view.endEditing(true)
    }


}

extension EditViewController : UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtGender.text = genderArray[row]
    }
}

extension EditViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtBirthday
        {
            txtBirthday.resignFirstResponder()
            isDatePicker = true
            self.showDatePicker()
            return false
        }
        if textField == txtGender
        {
            txtGender.resignFirstResponder()
            isDatePicker = false
            self.showDatePicker()
            return false
        }
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
