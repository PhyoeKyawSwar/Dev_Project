//
//  ViewMoreViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 13/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import SDWebImage
import PKHUD
class ViewMoreViewController: UIViewController {
    
    @IBOutlet weak var MoreCollection: UICollectionView!
    
    @IBOutlet weak var imgTrans: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var environmentArray = [Environment]()
    var menuArray = [Menu]()
    
    @IBOutlet weak var btnClose: UIButton!
    var imageArray = [[String : Any]]()
    var shopID = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getMoreShopPhoto()
        print("Evn array count ",self.environmentArray.count)
         MoreCollection.register(UINib(nibName: "MoreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MoreCollectionViewCell")
        
         self.hideimageslide()
        // Do any additional setup after loading the view.
    }
    @IBAction func onClickSegment(_ sender: UISegmentedControl) {
      
        MoreCollection.reloadData()
    }
    
    func hideimageslide()
    {
     
        imgTrans.isHidden = true
        scrollView.isHidden = true
        btnClose.isHidden = true
    }
    func showimageslide()
    {
        imgTrans.isHidden = false
        imgTrans.backgroundColor = UIColor.black
        scrollView.isHidden = false
        btnClose.isHidden = false
        
        scrollView.auk.settings.placeholderImage = #imageLiteral(resourceName: "placeholder_image")
        
        scrollView.auk.settings.contentMode = .scaleAspectFill
        scrollView.auk.settings.pageControl.pageIndicatorTintColor = UIColor.white
        scrollView.auk.settings.pageControl.currentPageIndicatorTintColor = UIColor(red:0.858, green:0, blue:0.918, alpha:1)
        scrollView.auk.startAutoScroll(delaySeconds: 3.0, forward: true, cycle: true, animated: true)
        
        if scrollView.auk.images.count == 0 && imageArray.count > 0 {
            
            
            DispatchQueue.main.async
                {
                    for dict in self.imageArray
                    {
                       
                        self.scrollView.auk.show(url: "\(image_url_host)\(dict["image"] as! String)")
                    }
            }
            
            
        }
        else
        {
            self.scrollView.auk.settings.placeholderImage = #imageLiteral(resourceName: "placeholder_image")
        }
        
        
        
    }
    
    func getMoreShopPhoto()
    {
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "shops/\(self.shopID)/enviroment_images") { (response) in
            print("response",response.result)
            
            if response.error == nil
            {
                if response.status == 200
                {
                    if let dictionary = response.result as? [String : Any]
                    {
                        self.imageArray = (dictionary["data"] as? [[String : Any]])!
                        DispatchQueue.main.async
                            {
  
                                self.MoreCollection.delegate = self
                                self.MoreCollection.dataSource = self
                                self.MoreCollection.reloadData()
                                
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            HUD.hide()
            self.MoreCollection.delegate = self
            self.MoreCollection.dataSource = self
            self.MoreCollection.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onClickClose(_ sender: Any) {
        self.hideimageslide()
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
extension ViewMoreViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth:CGFloat = 0
        var cellHeight:CGFloat = 0
        
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            // IPAD
            // 4 COLUMN BASE
            cellWidth = collectionView.frame.width - 30 / 4
            cellHeight = cellWidth
        } else {
            // IPHONE
            // 2 COLUMN BASE
            cellWidth = (collectionView.frame.width - 10) / 2
            cellHeight = cellWidth
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreCollectionViewCell", for: indexPath) as! MoreCollectionViewCell
        
            let image = imageArray[indexPath.item]
            cell.titleHeight.constant = 40
            cell.lblTitle.isHidden = true
           // cell.lblTitle.setNormalLabel(text: menu.name, color: GRAY_COLOR, size: 10.0, font_name: LIGHT_FONT)
            cell.imgView.setimage(url_string:  "\(image_url_host)\(image["image"] as! String)")
            
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showimageslide()
    }
}
