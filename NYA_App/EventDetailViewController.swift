//
//  EventDetailViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 18/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Social
import FBSDKShareKit
import FBSDKLoginKit
import PKHUD
class EventDetailViewController: UIViewController ,FBSDKAppInviteDialogDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var btnInterest: UIButton!
    @IBOutlet weak var btnGoing: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var btnViewReview: UIButton!
    @IBOutlet weak var lblGoing: UILabel!
    @IBOutlet weak var lblGoingValue: UILabel!
    @IBOutlet weak var imgVerticalSp: UIImageView!
    @IBOutlet weak var lblInterest: UILabel!
    @IBOutlet weak var lblInterestValue: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var imgAboutSp: UIImageView!
    @IBOutlet weak var lblEventDetail: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var imgInfoSp: UIImageView!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblShopAddress: UILabel!
    @IBOutlet weak var imgVerticalSp1: UIImageView!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var lblInterestTxt: UILabel!
    @IBOutlet weak var lblGoingTxt: UILabel!
    @IBOutlet weak var lblShareTxt: UILabel!
    var Event_ID = Int()
    var event = EventDetail()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.getEventDetail()
        self.perform(#selector(self.setscrollSize), with: nil, afterDelay: 3.0)
        // Do any additional setup after loading the view.
    }
    
    func setscrollSize()
    {
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1200)
    }

    func setupUI()
    {
        lblDate.text = ""
        lblInfo.setNormalLabel(text: "Shop Info", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        lblRate.text = ""
        lblAbout.setNormalLabel(text: "About", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        lblGoing.setNormalLabel(text: "GOING", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        lblInterest.setNormalLabel(text: "INTERESTED", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        
         lblInterestTxt.setNormalLabel(text: "Interested", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
         lblGoingTxt.setNormalLabel(text: "Going", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
         lblShareTxt.setNormalLabel(text: "Share", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
        lblShopName.text = ""
        lblEventName.text = ""
        lblGoingValue.text = ""
        lblEventDetail.text = ""
        lblShopAddress.text = ""
        lblInterestValue.text = ""
        
        self.imgInfoSp.backgroundColor = UIColor.lightGray
        self.imgAboutSp.backgroundColor = UIColor.lightGray
        self.imgVerticalSp.backgroundColor = UIColor.lightGray
        self.imgVerticalSp1.backgroundColor = UIColor.lightGray
        
        
        self.setButton(color: UIColor.white, title: "View More", btn: btnViewMore)
        self.btnGoing.setImage(#imageLiteral(resourceName: "going before"), for: .normal)
        self.btnShare.setImage(#imageLiteral(resourceName: "share before"), for: .normal)
        self.btnInterest.setImage(#imageLiteral(resourceName: "interested before"), for: .normal)
        self.btnPhone.setImage(#imageLiteral(resourceName: "phone"), for: .normal)
        
        ratingView.isUserInteractionEnabled = true
        
        
    }
    
    func setButton(color : UIColor , title : String , btn : UIButton)
    {
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = color.cgColor
        
        btn.setTitleColor(color, for: .normal)
        btn.setTitle(title, for: .normal)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEventDetail()
    {
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "events/\(self.Event_ID)") { (response) in
            if response.error == nil
            {
                if response.status == 200
                {
                    if let dict = response.result as? Dictionary<String,Any>
                    {
                        if let data_dict = dict["data"] as? Dictionary<String,Any>
                        {
                            let event_detail = EventDetail()
                             self.event = event_detail.operateData(dataDict: data_dict)
                            print("Data Dict",data_dict)
                            self.title = self.event.name
                            self.lblEventName.setNormalLabel(text: "\(self.event.name)", color: BOTTOM_COLOR, size: 18.0, font_name: LIGHT_FONT)
                            
                            self.imgCover.setimage(url_string: "\(image_url_host)/\(self.event.image)")
                            self.lblDate.setNormalLabel(text: "\(self.event.timeline)", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
                            self.lblGoingValue.setNormalLabel(text: "\(self.event.going_count)", color: BOTTOM_COLOR, size: 15.0, font_name: LIGHT_FONT)
                            self.lblEventDetail.setNormalLabel(text: "\(self.event.desc)", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
                            
                            self.lblInterestValue.setNormalLabel(text: "\(self.event.interest_count)", color: BOTTOM_COLOR, size: 15.0, font_name: LIGHT_FONT)
                            
                            if let dict = self.event.brief_review as? BriefReview
                            {
                                
                                if let rate = dict.rating as? Float
                                {
                                    self.lblRate.setNormalLabel(text: "\(rate)", color: BOTTOM_COLOR, size: 18.0, font_name: LIGHT_FONT)
                                    self.ratingView.value = CGFloat(rate)
                                    
                                }
                                
                            }
                            if let info = self.event.shop_info as? ShopInfo
                            {
                                self.lblShopName.setNormalLabel(text: "\(info.name)", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
                                self.lblShopAddress.setNormalLabel(text: "\(info.address)", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
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
        }
    }
    @IBAction func onClickViewMore(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
    }
    @IBAction func onClickInterest(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        self.interested()
    }
    
    func interested()
    {
        var is_interested = ""
        
        if event.is_interest == true
        {
            is_interested = "false"
        }
        else
        {
            is_interested = "true"
        }
        APIFunction.sharedInstance.url_string = "interested_event"
        let params = ["interested_event" : event.id , "interested" : is_interested ] as! [String: Any]
        APIFunction.sharedInstance.apiFunction(method: "interested_event", parameter: params, methodType: "POST") { (response, status) in
            if status == 201
            {
                if let data = response["data"] as? [String : Any]
                {
                    if data["interested"] as? String == "true"
                    {
                        DispatchQueue.main.async {
                            self.btnInterest.tintColor = BOTTOM_COLOR
                            
                        }
                         self.lblInterestTxt.setNormalLabel(text: "Interested", color: BOTTOM_COLOR, size: 15.0, font_name: LIGHT_FONT)
                        
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.btnInterest.tintColor = GRAY_COLOR
                            
                        }
                        self.lblInterestTxt.setNormalLabel(text: "Interested", color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
                        
                    }
                }
            }
        }
    }
    @IBAction func onClickGoing(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
        let controller = AppStoryboard.NewFeed.instance.instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController
        controller.is_from_shop = false
        controller.is_from_Newfeed = false
        controller.from_id = self.Event_ID
        var dict = ["id" : self.Event_ID , "name" : self.lblEventName.text!] as [String : Any]
        let array = [dict]
        controller.ShowPlaceArray = array
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func onClickShare(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
            let facebookShare = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookShare?.setInitialText(lblEventName.text)
        facebookShare?.add(imgCover.image)
       // facebookShare?.add(URL(string: "www.google.com"))
        self.present(facebookShare!, animated: true, completion: nil)
            
       
    }
    
    @IBAction func onClickViewReview(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
    }
    @IBAction func onClickPhone(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("Did complete sharing.. ")
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        print("Error tool place in appInviteDialog \(error)")
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

