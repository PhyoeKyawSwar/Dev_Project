//
//  ShopDetailViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 12/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import HCSStarRatingView
import PKHUD
import ActiveLabel
class ShopDetailViewController: UIViewController  {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var shopInfoView: UIView!
    @IBOutlet weak var shopLogo: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var btnGoing: UIButton!
   // @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var RateView: UIView!
    @IBOutlet weak var imgVerticalSeparator: UIImageView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var RatingView: HCSStarRatingView!
    @IBOutlet weak var lblRateValue: UILabel!
    @IBOutlet weak var lblTotalRate: UILabel!
    @IBOutlet weak var lblPoll: UILabel!
    @IBOutlet weak var lblPollValue: UILabel!
    @IBOutlet weak var AboutView: UIView!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var imgAboutSp: UIImageView!
    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var lblAddress: ActiveLabel!
    @IBOutlet weak var btnShowBranches: UIButton!
    @IBOutlet weak var imgClock: UIImageView!
    @IBOutlet weak var lblOpeningHour: ActiveLabel!
    @IBOutlet weak var imgWeb: UIImageView!
    @IBOutlet weak var lblWebSite: ActiveLabel!
    
    @IBOutlet weak var btnMoreAbout: UIButton!
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var imgMenuSeparator: UIImageView!
    @IBOutlet weak var lblPopular: UILabel!
    @IBOutlet weak var lblFirstMenu: UILabel!
    @IBOutlet weak var lblSecondMenu: UILabel!
    @IBOutlet weak var btnMoreMenu: UIButton!
    @IBOutlet weak var ReviewTblView: UIView!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var imgReviewSeparator: UIImageView!
    @IBOutlet weak var tblReview: UITableView!
    var review_imageArray = [String]()
    
    @IBOutlet weak var btnViewMoreReview: UIButton!
    var env_Array = [Environment]()
    var menu_Array = [Menu]()
    
    var menukey = [Dictionary<String,Any>]()
    var menuDict = Dictionary<String,Any>()
    
    var shopDetail = ShopDetail()
    var groupID = Int()
    
    @IBOutlet weak var reviewTableHeight: NSLayoutConstraint!
    @IBOutlet weak var btnReview: UIButton!
    
    @IBOutlet weak var reviewHeight: NSLayoutConstraint!
    var shopID = Int()
    var ReviewArray = [ReviewObject]()
    
    var is_from_map = Bool()
    var detail_Dict = NSDictionary()
    var phoneArray = [String]()
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var btnClosePopup: UIButton!
    @IBOutlet weak var tblPopup: UITableView!
    var imgTrans = UIImageView()
    var sub_popup_view = UIView()
    @IBOutlet weak var menuViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
       // self.perform(#selector(self.setscrollSize), with: nil, afterDelay: 3.0)
        self.setupUI()
        
        if is_from_map == true
        {
            self.shopID = detail_Dict["id"] as! Int
        }
        self.getShopDetail()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setscrollSize()
    {
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1200.0)
    }
    
    func getShopDetail()
    {
        
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "shops/\(shopID)") { (response) in
            
            if response.error == nil
            {
                if let data_dict = response.result as? Dictionary<String,Any>
                {
                    
                    if response.status == 200
                    {
                        if let shop_dict = data_dict["data"] as? Dictionary<String,Any>
                        {
                            
                            print("Shop detail" , shop_dict)
                            
                            var shop = ShopDetail()
                            self.shopDetail = shop.operateData(dataDict: shop_dict)
                            // print("Shop Dict ::::",shop_dict)
                            OperationQueue.main.addOperation {
                                self.title = self.shopDetail.name
                                self.lblName.setNormalLabel(text: self.shopDetail.name, color: BLACK_COLOR, size: 18.0, font_name: BOLD_FONT)
                                self.shopLogo.setimage(url_string:"\(image_url_host)\(self.shopDetail.profile_photo)")
                                self.imgCover.setimage(url_string: "\(image_url_host)\(self.shopDetail.cover_photo)")
                               // self.lblAddress.setNormalLabel(text: self.shopDetail.address, color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
                                
                              
                                //self.lblWebsite.setNormalLabel(text: self.shopDetail.website, color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
                                
                                self.lblWebSite.numberOfLines = 0
                                self.lblWebSite.enabledTypes = [.mention, .hashtag, .url]
                                self.lblWebSite.text = self.shopDetail.website
                                self.lblWebSite.textColor = .blue
                                self.lblWebSite.handleURLTap { url in UIApplication.shared.open(url, options: [:], completionHandler: nil) }
                                
                                self.lblAddress.numberOfLines = 0
                                self.lblAddress.enabledTypes = [ActiveType.custom(pattern: self.shopDetail.address)]
                                self.lblAddress.text = self.shopDetail.address
                                self.lblAddress.textColor = .blue
                                self.lblAddress.handleCustomTap(for: ActiveType.custom(pattern: self.shopDetail.address), handler: { (handle) in
                                    let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Map_ViewController") as! Map_ViewController
                                    controller.isFromShopDetail = true
                                    controller.shopDetail = self.shopDetail
                                    //controller.detailShop = self.shopDetail
                                    //controller.groupID = categoryID
                                    self.navigationController?.pushViewController(controller, animated: true)
                                    
                                })
                                
                               // self.lblOpeningHour.setNormalLabel(text: self.shopDetail.opening_hour, color: GRAY_COLOR, size: 15.0, font_name: LIGHT_FONT)
                                self.lblOpeningHour.numberOfLines = 0
                                self.lblOpeningHour.enabledTypes = [ActiveType.custom(pattern: self.shopDetail.opening_hour)]
                                self.lblOpeningHour.text = self.shopDetail.opening_hour
                                self.lblOpeningHour.textColor = .blue
                                self.lblOpeningHour.handleCustomTap(for: ActiveType.custom(pattern: self.shopDetail.opening_hour), handler: { (handle) in
                                    
                                        self.imgTrans.frame = CGRect(origin: CGPoint.zero, size: self.view.frame.size)
                                        self.imgTrans.backgroundColor = UIColor(white: 0, alpha: 0.7)
                                        
                                        self.sub_popup_view.frame = CGRect(x:( self.view.frame.size.width / 2) - 175, y: ( self.view.frame.size.height / 2) - 200, width: 350, height: 400)
                                        self.sub_popup_view.backgroundColor = UIColor.clear
                                        self.popupView.layer.cornerRadius = 5
                                        self.sub_popup_view.layer.cornerRadius = 5
                                        self.sub_popup_view.addSubview(self.popupView)
                                        self.view.addSubview(self.imgTrans)
                                        self.view.addSubview(self.sub_popup_view)
                                        
                                        self.sub_popup_view.transform = .identity
                                 
                                    self.tblPopup.delegate = self
                                    self.tblPopup.dataSource = self
                                    self.tblPopup.reloadData()
                                })
                                
                                self.groupID = self.shopDetail.shop_group_id
                                if self.shopDetail.phone_no != ""
                                {
                                    if self.shopDetail.phone_no.contains(",")
                                    {
                                        self.phoneArray = self.shopDetail.phone_no.components(separatedBy: ",")
                                    }
                                    else
                                    {
                                        self.phoneArray.append(self.shopDetail.phone_no)
                                    }
                                   
                                }
                                
                                if let dict = shop.brief_review as? BriefReview
                                {
                                    if let total = dict.total as? Int
                                    {
                                        self.lblTotalRate.setNormalLabel(text: "\(total)", color: BOTTOM_COLOR, size: 18.0, font_name: LIGHT_FONT)
                                        
                                    }
                                    if let rate = dict.rating as? Float
                                    {
                                        self.lblRateValue.setNormalLabel(text: "\(rate)", color: BOTTOM_COLOR, size: 18.0, font_name: LIGHT_FONT)
                                        self.RatingView.value = CGFloat(rate)
                                        
                                    }
                                    
                                }
                                if self.shopDetail.is_subscribe == false
                                {
                                    self.setButton(color: GRAY_COLOR, title: "Subscribe", btn: self.btnSubscribe)
                                }
                                else
                                {
                                    self.setButton(color: BOTTOM_COLOR, title: "Subscribe", btn: self.btnSubscribe)
                                }
                                
                                if self.shopDetail.is_going == false
                                {
                                    self.setButton(color: GRAY_COLOR, title: "Going", btn: self.btnGoing)
                                }
                                else
                                {
                                    self.setButton(color: BOTTOM_COLOR, title: "Going", btn: self.btnGoing)
                                }
                                
                                self.lblPollValue.setNormalLabel(text: "\(self.shopDetail.polls)", color: BOTTOM_COLOR, size: 18.0, font_name: LIGHT_FONT)
                                
                                if let review = shop_dict["customer_reviews"] as? [Dictionary<String,Any>]
                                {
                                    let review_obj = ReviewObject()
                                    self.ReviewArray = review_obj.operateData(dataDict: review)
                                    // self.ReviewArray = review as! [Dictionary<String,Any>]
                                    
                                    if self.ReviewArray.count > 0
                                    {
                                        self.reviewTableHeight.constant = CGFloat(200 * self.ReviewArray.count)
                                        self.reviewHeight.constant = self.reviewTableHeight.constant + 80.0
                                        DispatchQueue.main.async {
                                            self.tblReview.dataSource = self
                                            self.tblReview.delegate = self
                                            self.tblReview.reloadData()
                                        }
                                        
                                    }
                                   
                                }
                                
                                
                                
                                self.env_Array = self.shopDetail.environment
                                
                                
                                // self.menu_Array = shopDetail.most_popular
                                if let menu = shop_dict["menus"] as? [Dictionary<String,Any>]
                                {
                                    print("Menu ",menu)
                                    
                                    self.menukey = menu
                                    
                                    if self.menukey.count > 0
                                    {
                                        self.btnMoreMenu.isHidden = false
                                        for index in 0 ... self.menukey.count - 1
                                        {
                                            if index == 0
                                            {
                                                if let key1 = self.menukey[0] as? Dictionary<String,Any>
                                                {
                                                    self.lblPopular.text = key1["name"] as? String ?? ""
                                                    self.menuViewHeight.constant += 100.0
                                                }
                                            }
                                            if index == 1
                                            {
                                                if let key2 = self.menukey[1] as? Dictionary<String,Any>
                                                {
                                                    self.lblFirstMenu.text = key2["name"] as? String ?? ""
                                                     self.menuViewHeight.constant += 50.0
                                                }
                                                
                                            }
                                            if index == 2
                                            {
                                                if let key3 = self.menukey[2] as? Dictionary<String,Any>
                                                {
                                                    self.lblSecondMenu.text = key3["name"] as? String ?? ""
                                                     self.menuViewHeight.constant += 50.0
                                                }
                                                
                                            }
                                        }
                                    }
                                    else
                                    {
                                        self.menuViewHeight.constant = 0.0
                                        self.btnMoreMenu.isHidden = true
                                    }
                                }
                                self.scrollView.updateContentView()
                                
                            }
                        }
                    }
                    else
                    {
                        self.showAlert(title: "Information", message: "Something wrong")
                    }
                    
                }
                else
                {
                    self.showAlert(title: "Information", message: "Something wrong")
                }
                
            }
            else
            {
                self.showAlert(title: "Error", message:( response.error?.localizedDescription)!)
            }
        }
        
        DispatchQueue.main.async {
            HUD.hide()
        }
        
    }
    
    
    @IBAction func onClickMoreReview(_ sender: Any) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "MoreReviewViewController") as! MoreReviewViewController
        controller.reviewArray = ReviewArray
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func setupUI()
    {
        lblMenu.setNormalLabel(text: "Menu", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        lblReview.setNormalLabel(text: "Review", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        lblAbout.setNormalLabel(text: "About", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        
        
        imgAboutSp.backgroundColor = UIColor.gray
        imgMenuSeparator.backgroundColor = UIColor.gray
        imgReviewSeparator.backgroundColor = UIColor.gray
        imgVerticalSeparator.backgroundColor = UIColor.gray
        
        imgMap.image = #imageLiteral(resourceName: "map-localization")
        imgWeb.image = #imageLiteral(resourceName: "web-www-world-grid")
        imgClock.image = #imageLiteral(resourceName: "wall-clock")
        
        lblPopular.text = ""
        lblFirstMenu.text = ""
        lblSecondMenu.text = ""
        
        /* btnGoing.setButtonLayout(color: GRAY_COLOR, title: "Going")
         btnMessage.setButtonLayout(color: GRAY_COLOR, title: "Message")
         btnCall.setButtonLayout(color: GRAY_COLOR, title: "Call")
         */
        self.setButton(color: GRAY_COLOR, title: "Going", btn: btnGoing)
      //  self.setButton(color: GRAY_COLOR, title: "Message", btn: btnMessage)
        self.setButton(color: GRAY_COLOR, title: "Call Now", btn: btnCall)
        
        self.setButton(color: UIColor.white, title: "View More", btn: btnViewMore)
        
        lblRate.setNormalLabel(text: "Reviews", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        lblRateValue.setNormalLabel(text: "0", color: BOTTOM_COLOR, size: 18.0, font_name: LIGHT_FONT)
        lblTotalRate.setNormalLabel(text: "0", color: BOTTOM_COLOR, size: 18.0, font_name: LIGHT_FONT)
        
        lblPoll.setNormalLabel(text: "Polls", color: GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        
       // btnMoreAbout.setTitle("Load More", for: .normal)
        btnMoreMenu.setTitle("Load More", for: .normal)
       // btnShowBranches.setTitle("Show all branches >", for: .normal)
        
        RatingView.isUserInteractionEnabled = false
        
    }
    
    func setButton(color : UIColor , title : String , btn : UIButton)
    {
        DispatchQueue.main.async {
            btn.layer.borderWidth = 1
            btn.layer.cornerRadius = 5
            btn.layer.borderColor = color.cgColor
            btn.setTitleColor(color, for: .normal)
            btn.setTitle(title, for: .normal)
            
        }
        
    }
    
    @IBAction func onClickMoreMenu(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        controller.menuArray = menukey
        controller.menuDict = menuDict
        controller.shop_id = shopID
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func onClickMoreAbout(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
    }
    @IBAction func onClickCall(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
        let callAction = UIAlertController(title: "Call to", message: "", preferredStyle: .actionSheet)
        
        for phone in phoneArray
        {
            callAction.addAction(UIAlertAction(title: phone, style: .default, handler: { (action) in
                let phone_no = phone.replacingOccurrences(of: " ", with: "")
                if let url = URL(string: "tel://\(phone_no)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }))
        }
        callAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(callAction, animated: true, completion: nil)
        
    }
    @IBAction func onClickGoing(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        
        if self.shopDetail.is_going == false
        {
           /* let controller = AppStoryboard.NewFeed.instance.instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController
            controller.is_from_shop = true
            controller.from_id = shopDetail.id
            controller.from_name = shopDetail.name
            self.navigationController?.pushViewController(controller, animated: true)
 */
            let controller = AppStoryboard.NewFeed.instance.instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController
            controller.is_from_shop = true
            controller.is_from_Newfeed = false
            controller.from_id = shopDetail.id
            var dict = ["id" : shopDetail.id , "name" : shopDetail.name] as [String : Any]
            let array = [dict]
            controller.ShowPlaceArray = array
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    @IBAction func onClickClosePopup(_ sender: Any) {
        self.imgTrans.removeFromSuperview()
        self.sub_popup_view.removeFromSuperview()
    }
    @IBAction func onClickMessage(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
    }
    @IBAction func onClickSubscribe(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        var is_subscribe = ""
        
        if shopDetail.is_subscribe == true
        {
            is_subscribe = "false"
        }
        else
        {
            is_subscribe = "true"
        }
       APIFunction.sharedInstance.url_string = "subscribe"
        let params = ["shop_group_id" : groupID , "subscribe" : is_subscribe ] as! [String: Any]
        APIFunction.sharedInstance.apiFunction(method: "subscribe", parameter: params, methodType: "POST") { (response, status) in
            if status == 201
            {
                if let data = response["data"] as? [String : Any]
                {
                    if data["subscribe"] as? String == "true"
                    {
                       self.setButton(color: BOTTOM_COLOR, title: "Subscribe", btn: self.btnSubscribe)
                    }
                    else
                    {
                        self.setButton(color: GRAY_COLOR, title: "Subscribe", btn: self.btnSubscribe)
                    }
                 }
            }
        }
    }
    @IBAction func onClickReview(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewViewController
        controller.is_from_shop = true
        controller.shop_id = self.shopID
        self.present(controller, animated: true, completion: nil)
        
    }
    @IBAction func onClickViewMore(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "ViewMoreViewController") as! ViewMoreViewController
        controller.shopID = self.shopID
        //controller.environmentArray = env_Array
        //controller.menuArray = menu_Array
        self.navigationController?.pushViewController(controller, animated: true)
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

extension ShopDetailViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100
        {
            return self.shopDetail.opening_hour_detail.count
        }
        return ReviewArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpenTableViewCell") as! OpenTableViewCell
            let open = self.shopDetail.opening_hour_detail[indexPath.row]
            
            cell.lblDay.setNormalLabel(text: open.day, color: GRAY_COLOR, size: 13.0, font_name: LIGHT_FONT)
            cell.lblTime.setNormalLabel(text: "\(open.open_time) - \(open.close_time)", color: GRAY_COLOR, size: 13.0, font_name: LIGHT_FONT)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell") as! ReviewTableViewCell
            let dict = ReviewArray[indexPath.row]
            
            cell.setupData(dict: dict)
            
            if dict.images.count > 0
            {
                review_imageArray = dict.images
                cell.reviewCollection.register(UINib(nibName: "ShowReviewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShowReviewCollectionViewCell")
                
                cell.reviewCollection.delegate = self
                cell.reviewCollection.dataSource = self
                cell.reviewCollection.reloadData()
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        }
       
    }
}
extension ShopDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return review_imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowReviewCollectionViewCell", for: indexPath) as! ShowReviewCollectionViewCell
        cell.imgReview.setimage(url_string: "\(image_url_host)\(review_imageArray[indexPath.item])")
        
        return cell
    }
}
extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}


