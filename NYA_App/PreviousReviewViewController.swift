//
//  PreviousReviewViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 17/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
class PreviousReviewViewController: UIViewController {

    @IBOutlet weak var btnShop: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var tblReview: UITableView!
    
    var menuArray = [PreviousReviewMenu]()
    var shopArray = [PreviousReviewShop]()
    var forMenu = false
    var objMeta = MetaObject()
    var current_page = 1
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setButton(color: BOTTOM_COLOR, title: "Shop", btn: self.btnShop)
        self.setButton(color: GRAY_COLOR, title: "Menu", btn: self.btnMenu)
        
       // self.btnShop.addBottomBorderWithColor(color: BOTTOM_COLOR, width: 2.0)
        //self.btnMenu.addBottomBorderWithColor(color: UIColor.clear, width: 0.0)
        
          self.getReview(url: "user/shop_reviews")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickShop(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        self.setButton(color: BOTTOM_COLOR, title: "Shop", btn: self.btnShop)
        self.setButton(color: GRAY_COLOR, title: "Menu", btn: self.btnMenu)
        //self.btnShop.addBottomBorderWithColor(color: BOTTOM_COLOR, width: 2.0)
        //self.btnMenu.addBottomBorderWithColor(color: UIColor.clear, width: 0.0)
        
        shopArray = [PreviousReviewShop]()
        forMenu = false
        self.current_page = 1
        self.getReview(url: "user/shop_reviews")
    }
    
    @IBAction func onClickMenu(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        self.setButton(color: GRAY_COLOR, title: "Shop", btn: self.btnShop)
        self.setButton(color: BOTTOM_COLOR, title: "Menu", btn: self.btnMenu)
       // self.btnShop.addBottomBorderWithColor(color: UIColor.clear, width: 0.0)
        //self.btnMenu.addBottomBorderWithColor(color: BOTTOM_COLOR, width: 2.0)
        
        menuArray = [PreviousReviewMenu]()
        forMenu = true
        self.current_page = 1
        self.getReview(url: "user/menu_reviews")
    }
    
    func setButton(color : UIColor , title : String , btn : UIButton)
    {
        btn.setTitleColor(color, for: .normal)
        btn.setTitle(title, for: .normal)
        
    }
    
    func getReview(url : String)
    {
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: url) { (response) in
            if response.error == nil
            {
                
                if response.status == 200
                {
                    if let dict = response.result as? Dictionary<String,Any>
                    {
                        if let array = dict["data"] as? [Dictionary<String,Any>]
                        {
                            for dict in array
                            {
                                if self.forMenu == true
                                {
                                    let review = PreviousReviewMenu()
                                    self.menuArray.append(review.operateData(dataDict: dict))
                                    if self.menuArray.count > 0
                                    {
                                        DispatchQueue.main.async {
                                            
                                            self.tblReview.delegate = self
                                            self.tblReview.dataSource = self
                                            self.tblReview.reloadData()
                                            
                                        }
                                    }
                                }
                                else
                                {
                                    let shop = PreviousReviewShop()
                                    self.shopArray.append(shop.operateData(dataDict: dict))
                                    if self.shopArray.count > 0
                                    {
                                        DispatchQueue.main.async {
                                            
                                            self.tblReview.delegate = self
                                            self.tblReview.dataSource = self
                                            self.tblReview.reloadData()
                                            
                                        }
                                    }
                                }
                                
                                if let meta = dict["meta"] as? Dictionary<String,Any>
                                {
                                    let meta_object = MetaObject()
                                    self.objMeta = meta_object.operateData(dataDict: meta)
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

extension PreviousReviewViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forMenu == true
        {
            return menuArray.count
        }
        else
        {
            return shopArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewWithImageTableViewCell") as! ReviewWithImageTableViewCell
        
        cell.scrollViewHeight.constant = 0
        if forMenu == true
        {
            let menu = menuArray[indexPath.row]
            cell.lblName.setNormalLabel(text: menu.menu_name, color: BLACK_COLOR, size: TITLE_FONT_SIZE, font_name: BOLD_FONT)
            cell.lblDescription.setNormalLabel(text: menu.desc, color: GRAY_COLOR, size: NORMAL_FONT_SIZE, font_name: LIGHT_FONT)
            cell.imgSp.backgroundColor = LIGHT_GRAY_COLOR
            cell.ratingView.value = CGFloat(menu.rating)
            cell.ratingView.isUserInteractionEnabled = false
            cell.imgView.setimage(url_string: "\(image_url_host)/\(menu.menu_image)")
            let lastItemReached = menu.isEqual(self.menuArray.last as! PreviousReviewMenu)
            
            if lastItemReached && indexPath.row == self.menuArray.count - 1 && self.current_page <= objMeta.last_page
            {
                current_page += 1
                self.getReview(url: "user/menu_reviews")
            }
        }
        else
        {
            let shop = shopArray[indexPath.row]
            cell.lblName.setNormalLabel(text: shop.shop_name, color: BLACK_COLOR, size: TITLE_FONT_SIZE, font_name: BOLD_FONT)
            cell.lblDescription.setNormalLabel(text: shop.desc, color: GRAY_COLOR, size: NORMAL_FONT_SIZE, font_name: LIGHT_FONT)
            cell.imgSp.backgroundColor = LIGHT_GRAY_COLOR
            cell.ratingView.value = CGFloat(shop.rating)
            cell.ratingView.isUserInteractionEnabled = false
            cell.imgView.setimage(url_string: "\(image_url_host)/\(shop.shop_profile_photo)")
            
            let lastItemReached = shop.isEqual(self.shopArray.last as! PreviousReviewShop)
            
            if lastItemReached && indexPath.row == self.shopArray.count - 1 && self.current_page <= objMeta.last_page
            {
                current_page += 1
                self.getReview(url: "user/shop_reviews")
            }
        }
        
        cell.pageControl.isHidden = true
        
        return cell
        
    }
}

