//
//  ShopGroupViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 16/1/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
class ShopGroupViewController: UIViewController {

    @IBOutlet weak var tblShopGroup: UITableView!
    var categoryID = Int()
    var shopArray = [ShopGroup]()
    var nearyBy = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getShopGroupList()
        // Do any additional setup after loading the view.
        
        nearyBy = UIBarButtonItem(image: #imageLiteral(resourceName: "nearby_unactive"), style: .plain, target: self, action: #selector(self.nearbyClick))
        self.navigationItem.rightBarButtonItem = nearyBy

    }

    func nearbyClick()
    {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "NearViewController") as! NearViewController
        controller.category_id = categoryID
        controller.name = self.title!
       // controller.isFromShopDetail = false
        
        self.navigationController?.pushViewController(controller, animated: true )
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getShopGroupList()
    {
        HUD.show(.systemActivity)
        
        APIFunction.sharedInstance.apiGETMethod(method: "categories/\(categoryID)/shop_groups") { (response) in
            if response.error == nil
            {
                if response.status == 200
                {
                    print("Response ",response.result)
                    if let data = response.result as? Dictionary<String,Any>
                    {
                        if let data_array = data["data"] as? [Dictionary<String,Any>]
                        {
                            for dict in data_array
                            {
                                let shop = ShopGroup()
                                let dict = shop.operateEvent(dataDict: dict)
                                self.shopArray.append(dict)
                            }
                            
                            if self.shopArray.count > 0
                            {
                                DispatchQueue.main.async {
                                    self.tblShopGroup.reloadData()
                                    self.tblShopGroup.dataSource = self
                                    self.tblShopGroup.delegate = self
                                }
                               
                            }
                            else
                            {
                                self.showAlert(title: "Information", message: "No Shop found !")
                            }
                        
                    }
 
                }
                else
                {
                    self.showAlert(title: "Information", message: "No Shop found !")
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

extension ShopGroupViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as! EventTableViewCell
        let dict = shopArray[indexPath.row]
        cell.lblName.text = dict.name
        cell.lblName.textColor = GRAY_COLOR
        cell.lblName.font = UIFont(name: BOLD_FONT, size: TITLE_FONT_SIZE   )
        
        cell.imgLogo.setimage(url_string: "\(image_url_host)\(dict.image)")
        //cell.imgSp.backgroundColor = LIGHT_GRAY_COLOR
        cell.imgLogo.backgroundColor = LIGHT_GRAY_COLOR
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = shopArray[indexPath.row]
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "ShopListViewController") as! ShopListViewController
        controller.categoryID = dict.id
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
