//
//  HomeViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 22/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import SDWebImage
import Auk
import PKHUD

class HomeViewController: _BaseViewController {
    
    @IBOutlet weak var imgSlider: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var homeCollection: UICollectionView!
    @IBOutlet weak var tblEvent: UITableView!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var ScrollHeight: NSLayoutConstraint!
    @IBOutlet weak var tblEventHeight: NSLayoutConstraint!
    var categoryArray = [Category]()
    var ads_array = [AdsImage]()
    var eventArray = [Event]()
    var imageCount = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
       self.navigationItem.titleView = txtSearch
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "bell"), style: .plain, target: self, action: #selector(self.gotoNoti))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "planner"), style: .plain, target: self, action: nil)
        //self.setUpNavTitleConfiguration()
        print("in home view")
        self.getCategory()
        self.getEventList()
        self.getADsList()
        self.getProfile()
        self.addDoneButtonOnKeyboard()
        
        self.tblEvent.rowHeight = 110
        self.tblEvent.estimatedRowHeight = UITableViewAutomaticDimension
        
        txtSearch.delegate = self
        txtSearch.tintColor = PINK_COLOR
       // self.slideShow()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        homeCollection.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoNoti()
    {
      let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
       // controller.fromHome = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
        
    func getADsList()
    {
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "advertisements") { (response) in
            
                    if response.error == nil
                    {
                        if let data_array = response.result as? Dictionary<String,Any>
                        {
                            if response.status == 200
                            {
                                if let ad_array = data_array["data"] as? [Dictionary<String, Any>]
                                {
                                    print("Ad array",ad_array)
                                    for ads_image in ad_array
                                    {
                                        
                                        let ads = AdsImage()
                                        
                                        let obj_ads = ads.operateAdsImage(dataDict: ads_image)
                                        
                                        self.ads_array.append(obj_ads)
                                        self.imageslide()
                                    }
                                    
                                    
                                    
                                }
                            }
                            else
                            {
                                self.showAlert(title: "Information", message: "Something Wrong")
                            }
                            
                            
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
    func getEventList()
    {
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "events"){ (response) in
            
                    if response.error == nil
                    {
                        if let dataDict = response.result as? Dictionary<String,Any>
                        {
                            if response.status == 200
                            {
                                if let data_array = dataDict["data"] as? [Dictionary<String,Any>]
                                {
                                    for e in data_array
                                    {
                                        let event = Event()
                                        
                                        let obj_event = event.operateEvent(dataDict: e)
                                        self.eventArray.append(obj_event)
                                        
                                    }
                                    if self.eventArray.count > 0
                                    {
                                        DispatchQueue.main.async {
                                            self.tblEventHeight.constant = CGFloat(150 * self.eventArray.count)
                                            self.tblEvent.delegate = self
                                            self.tblEvent.dataSource = self
                                            self.tblEvent.reloadData()
                                        }
                                    }
                                }
                            }
                            else
                            {
                                self.showAlert(title: "Information", message: "Something Wrong")
                            }
                            
                            
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
    func getCategory()
    {
         HUD.show(.systemActivity)
        self.showGrayBG(status: true)
        APIFunction.sharedInstance.apiGETMethod(method: "categories") { (response) in
            
                    if response.error == nil
                    {
                        if let data_array = response.result as? Dictionary<String,Any>
                        {
                            if response.status == 200
                            {
                                if let array = data_array["data"] as? [Dictionary<String, Any>]
                                {
                                    
                                    for cat in array
                                    {
                                        let category = Category()
                                        let objcat = category.operateCategory(dataDict: cat)
                                        self.categoryArray.append(objcat)
                                    }
                                    
                                    for index in 0...self.categoryArray.count - 1
                                    {
                                        let temp = self.categoryArray[index]
                                        print("Category :::::::::" , temp.name)
                                        
                                    }
                                    
                                    if self.categoryArray.count > 0
                                    {
                                        DispatchQueue.main.async {
                                            
                                            var height = (80 * (self.categoryArray.count / 5) )
                                            if (self.categoryArray.count % 5) > 0
                                            {
                                                height += 80
                                            }
                                            
                                            self.collectionHeight.constant = CGFloat(height)
                                            self.homeCollection.delegate = self
                                            self.homeCollection.dataSource = self
                                        }
                                    }
                                    
                                }
                            }
                            else
                            {
                                self.showAlert(title: "Infromation", message: "Something Wrong")
                            }
                            
                        }
                    }
                    else
                    {
                        self.showAlert(title: "Error", message: (response.error?.localizedDescription)!)
                    }
                
            DispatchQueue.main.async {
                HUD.hide()
                self.showGrayBG(status: false)
            }
            
        }
    }
    
    @IBAction func Tap_Ads(_ sender: UITapGestureRecognizer) {
        let ads = ads_array[scrollView.auk.currentPageIndex!]
        print("ads ",ads.shopID)
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "ShopDetailViewController") as! ShopDetailViewController
        controller.shopID = ads.shopID
        controller.is_from_map = false
        
        //controller.groupID = categoryID
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func imageslide()
    {
        scrollView.auk.settings.placeholderImage = #imageLiteral(resourceName: "placeholder_image")

        scrollView.auk.settings.contentMode = .scaleAspectFill
        scrollView.auk.settings.pageControl.pageIndicatorTintColor = UIColor.white
        scrollView.auk.settings.pageControl.currentPageIndicatorTintColor = UIColor(red:0.858, green:0, blue:0.918, alpha:1)
        
        if scrollView.auk.images.count == 0 && ads_array.count > 0 {
            
            scrollView.auk.startAutoScroll(delaySeconds: 3.0, forward: true, cycle: true, animated: true)
            
                DispatchQueue.main.async
                {
                    for slide in self.ads_array
                    {
                        self.scrollView.auk.settings.placeholderImage = #imageLiteral(resourceName: "image_placeholder")
                        self.scrollView.auk.show(url: "\(image_url_host)\(slide.image)")
                    }
                }
            
            
        }
        else
        {
            self.scrollView.auk.settings.placeholderImage = #imageLiteral(resourceName: "icon")
        }
        
        
        
    }
    
    func getProfile ()
    {
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "user") { (response) in
            print("Http status code",response.status)
            if response.error == nil
            {
                if response.status == 200
                {
                    if let dict = response.result as? Dictionary<String,Any>
                    {
                        let user_dict = dict["data"] as! Dictionary<String,Any>
                        OperationQueue.main.addOperation {
                            
                            let user = User()
                            var User_Dict = user.operateUserData(dataDict: user_dict)
                            
                            UserDefaults.standard.set(User_Dict.name , forKey: "USER_NAME")
                            UserDefaults.standard.set(User_Dict.id , forKey: "USER_ID")
                            UserDefaults.standard.set(User_Dict.unique_string , forKey: "SIGN_UP_UNIQUE_STRING")
                            
                            
                           
                            
                        }
                    }
                }
                else
                {
                    self.showAlert(title: "Error", message: "Something wrong !")
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
        
        self.txtSearch.inputAccessoryView = doneToolbar
        
    }
    func doneButtonAction()
    {
        
        self.view.endEditing(true)
        self.txtSearch.resignFirstResponder()
       self.gotoSearchResultView()
        
    }
    
    func gotoSearchResultView()
    {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "HomeSearchViewController") as! HomeSearchViewController
        controller.searchText = txtSearch.text!
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

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth:CGFloat = 0
        var cellHeight:CGFloat = 0
        
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            // IPAD
            
            cellWidth = collectionView.frame.width / 6
            cellHeight = 80
        } else {
            // IPHONE
            
            cellWidth = (collectionView.frame.width / 5)
            cellHeight = 80
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let obj = categoryArray[indexPath.item] as! Category
        
        print("index ",indexPath.item , obj.name)
       // cell.setShadow()
        cell.setCollectionData(category: obj)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = categoryArray[indexPath.item]
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "ShopGroupViewController") as! ShopGroupViewController
        controller.categoryID = dict.id
        controller.title = dict.name
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as! EventTableViewCell
        
        cell.setEventData(event: eventArray[indexPath.row])
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = eventArray[indexPath.row]
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        controller.Event_ID = dict.id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension HomeViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.gotoSearchResultView()
        return true
    }
}
/*extension HomeViewController : UIScrollViewDelegate
{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        if translation.y > 0
        {
            // react to dragging down
            UIView.animate(withDuration: 0.5, animations: {
                self.ScrollHeight.constant = 180 // heightCon is the IBOutlet to the constraint
                self.view.layoutIfNeeded()
            })
        }
        else
        {
            // react to dragging up
            UIView.animate(withDuration: 0.5, animations: {
               
                self.ScrollHeight.constant = 0.0 // heightCon is the IBOutlet to the constraint
                self.view.layoutIfNeeded()
            })
        }
    }
}*/

