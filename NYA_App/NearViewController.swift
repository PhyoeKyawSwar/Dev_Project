//
//  NearViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 8/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class NearViewController: UIViewController {

    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imgShop: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSearchBy: UILabel!
    @IBOutlet weak var btnNearMe: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    
    var name = String()
    var shop_name = String()
    var category_id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgCover.backgroundColor = LIGHT_GRAY_COLOR
        self.imgShop.layer.cornerRadius = 50
        self.imgShop.backgroundColor = UIColor.darkGray
        self.imgShop.clipsToBounds = true
        
        self.lblSearchBy.text = "Search By"
        self.lblSearchBy.textColor = BOTTOM_COLOR
        self.lblSearchBy.font = UIFont(name: BOLD_FONT, size: TITLE_FONT_SIZE)
       
        self.lblSearchBy.text = shop_name 
        self.lblSearchBy.textColor = GRAY_COLOR
        self.lblSearchBy.font = UIFont(name: BOLD_FONT , size: NORMAL_FONT_SIZE)
        
        self.setButtonLayout(btn: btnNearMe, title: "Near Me")
        self.setButtonLayout(btn: btnLocation, title: "Location")
        
        self.lblName.text = name
        
       
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickLocation(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
       /* let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
       // controller.isFromShopList = true
        controller.category_id = category_id
        self.navigationController?.pushViewController(controller, animated: true)
 */
        
        let controller = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Map_ViewController") as! Map_ViewController
         controller.category_id = category_id
        //controller.name = self.title!
         controller.isFromShopDetail = false
        
        self.navigationController?.pushViewController(controller, animated: true )
        
    }
    @IBAction func onClickNearMe(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "NearbyListViewController") as! NearbyListViewController
        controller.category_id = self.category_id
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

    func setButtonLayout(btn : UIButton , title : String)
    {
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(BOTTOM_COLOR, for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = BOTTOM_COLOR.cgColor
        btn.layer.borderWidth = 1.0
        
    }
}
