//
//  ReviewMenuViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 3/12/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
import SDWebImage
import HCSStarRatingView
class ReviewMenuViewController: UIViewController {

    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var imgMenu: UIImageView!
    @IBOutlet weak var tblReview: UITableView!
    var ReviewArray = [ReviewObject]()
    var menu_id = Int()
    var menuName = String()
    var imageString = String()
    var shop_id = Int()
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imgMenuHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnWriteReview: UIButton!
    @IBOutlet weak var imgTrans: UIImageView!
    @IBOutlet weak var ReviewView: UIView!
    @IBOutlet weak var lblReviewTitle: UILabel!
    @IBOutlet weak var PostReviewValue: HCSStarRatingView!
    @IBOutlet weak var txtReviewText: UITextView!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var ReviewViewBottomHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = menuName
        self.getReview()
        
        imgMenu.setimage(url_string: "\(image_url_host)\(imageString)")
        // Do any additional setup after loading the view.
        self.txtComment.setChatTextFieldLayout(placeholder: "Write Comment")
        self.addDoneButtonOnKeyboard()
        
       self.hideReviewForm(status: true)
        
        self.bottomView.isHidden = true
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapFunction()
    {
        self.hideReviewForm(status: true)
    }
    func hideReviewForm(status : Bool)
    {
        self.imgTrans.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        if status == true
        {
            self.imgTrans.isHidden = true
            self.ReviewView.isHidden = true
        }
        else
        {
            self.imgTrans.isHidden = false
            self.ReviewView.isHidden = false
            self.ReviewView.layer.cornerRadius = 5
            self.ReviewView.layer.borderColor = LIGHT_GRAY_COLOR.cgColor
            self.ReviewView.layer.borderWidth = 1
            
            self.lblReviewTitle.text = "Write Review"
            self.lblReviewTitle.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
            
            self.btnPost.setTitle("Post", for: .normal)
            self.txtReviewText.delegate = self
            self.txtReviewText.text = "Write Review"
            self.txtReviewText.textColor = LIGHT_GRAY_COLOR
            self.txtReviewText.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
            
            let gesture = UITapGestureRecognizer(target: self, action:#selector(self.tapFunction))
            gesture.numberOfTapsRequired = 1
            imgTrans.isUserInteractionEnabled = true
            imgTrans.addGestureRecognizer(gesture)
            
        }
    }
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
        
        self.txtReviewText.inputAccessoryView = doneToolbar
        
    }
    func doneButtonAction()
    {
        self.view.endEditing(true)
        bottomViewHeight.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.imgMenuHeight.constant = 200 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
    }
    
    
    func writeReview()
    {
        HUD.show(.systemActivity)
        
        var reviewText = txtReviewText.text!
        if reviewText == "Write Review"
        {
            reviewText = ""
        }
        let parameter  = ["description" : reviewText , "rating" : PostReviewValue.value ,"images":[]] as! [String : Any]
        APIFunction.sharedInstance.url_string = "shops/\(shop_id)/sub_menus/\(menu_id)/reviews"
        APIFunction.sharedInstance.apiFunction(method: "shops/\(shop_id)/sub_menus/\(menu_id)/reviews", parameter: parameter, methodType: "POST") { (response, status) in
            print(response, status  )
            
            if status == 201
            {
                self.getReview()
            }
            else
            {
                
            }
        }
        
            
            DispatchQueue.main.async {
                HUD.hide()
            }
        }
        
    
    func getReview()
    {
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "sub_menus/\(menu_id)/users") { (response) in
            
            print ("Response " , response.result)
           if response.error == nil
           {
            
            if response.status == 200
            {
                if let dict = response.result as? Dictionary<String,Any>
                {
                    if let array = dict["data"] as? [Dictionary<String,Any>]
                    {
                        let review = ReviewObject()
                        self.ReviewArray = review.operateData(dataDict: array)
                        
                        
                        if self.ReviewArray.count > 0
                        {
                            DispatchQueue.main.async {
                                self.lblReview.text = "\(self.ReviewArray.count) Reviews"
                                self.lblReview.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
                                self.lblReview.textColor = BOTTOM_COLOR
                                
                                self.tblReview.delegate = self
                                self.tblReview.dataSource = self
                                self.tblReview.reloadData()
                                
                            }
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
            self.showAlert(title: "Information", message: (response.error?.localizedDescription)!)
            }
            
            DispatchQueue.main.async {
                HUD.hide()
            }
        }
    }
    
    
   
    @IBAction func onClickPost(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        if self.txtReviewText.text != ""
        {
            self.hideReviewForm(status: true)
            self.writeReview()
        }
    }
    
    @IBAction func onClickWriteReview(_ sender: Any) {
       // self.hideReviewForm(status: false)
        
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewViewController
        controller.is_from_shop = false
        controller.shop_id = self.shop_id
        controller.menu_id = self.menu_id
        self.present(controller, animated: true, completion: nil)
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

extension ReviewMenuViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ReviewArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell") as! ReviewTableViewCell
        let obj = self.ReviewArray[indexPath.row]
        cell.setupData(dict: obj)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
}

extension ReviewMenuViewController : UITextViewDelegate
{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.txtReviewText.textColor = UIColor.black
        self.txtReviewText.text = ""
        UIView.animate(withDuration: 0.5, animations: {
            self.ReviewViewBottomHeight.constant = 255
            self.view.layoutIfNeeded()
        })
        
        return true
    }
   /* func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        bottomViewHeight.constant  = 255
        UIView.animate(withDuration: 0.5, animations: {
            self.imgMenuHeight.constant = 0.0 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        bottomViewHeight.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.imgMenuHeight.constant = 200 // heightCon is the IBOutlet to the constraint
            self.view.layoutIfNeeded()
        })
        
        return true
    }
 */
}

extension ReviewMenuViewController : UIScrollViewDelegate
{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        if translation.y > 0
        {
            // react to dragging down
            UIView.animate(withDuration: 0.5, animations: {
                self.imgMenuHeight.constant = 200 // heightCon is the IBOutlet to the constraint
                self.view.layoutIfNeeded()
            })
        }
        else
        {
            // react to dragging up
            UIView.animate(withDuration: 0.5, animations: {
                self.imgMenuHeight.constant = 0.0 // heightCon is the IBOutlet to the constraint
                self.view.layoutIfNeeded()
            })
        }
    }
}
