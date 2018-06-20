//
//  MenuDetailViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 26/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
class MenuDetailViewController: UIViewController {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var tblMenuDetail: UITableView!
    
    var MenuArray = [Dictionary<String,Any>]()
    var menu_id = Int()
    var shop_id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()

       
        txtSearch.setSearchTextFieldLayout()
        self.getmenuList()
        self.txtSearch.autocorrectionType = .no
        self.addDoneButtonOnKeyboard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        var attributeValue = txtSearch.text!
        var namePredicate = NSPredicate(format: "firstName like %@",attributeValue)
        
        let menu_array = MenuArray as! NSArray
        let filteredArray = menu_array.filter { namePredicate.evaluate(with: $0) }
        print("names = ,\(filteredArray)");
    }
    func getmenuList()
    {
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "menus/\(menu_id)/sub_menus") { (response) in
            if response.error == nil
            {
                if response.status == 200
                {
                    if let dict = response.result as? Dictionary<String,Any>
                    {
                        if let array = dict["data"] as? [Dictionary<String,Any>]
                        {
                            self.MenuArray = array
                            
                            DispatchQueue.main.async {
                                
                                self.tblMenuDetail.rowHeight = 120
                                self.tblMenuDetail.estimatedRowHeight = UITableViewAutomaticDimension
                                
                                self.tblMenuDetail.delegate = self
                                self.tblMenuDetail.dataSource = self
                                self.tblMenuDetail.reloadData()
                                HUD.hide()
                            }
                        }
                    }
                }
                else
                {
                     self.showAlert(title: "Error", message:"Something Wrong !")
                }
                
            }
            else
            {
                 self.showAlert(title: "Error", message:( response.error?.localizedDescription)!)
            }
        }
    }
    @IBAction func onClickClear(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        txtSearch.text = ""
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

extension MenuDetailViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuDetailTableViewCell") as! MenuDetailTableViewCell
        
        //cell.operateMenuData(dataDict: MenuArray[indexPath.row])
        let menu = MenuArray[indexPath.row]
        cell.lblName.text = menu["name"] as? String ?? ""
        cell.lblDesc.text = menu ["description"] as? String ?? ""
        cell.lblPrice.setNormalLabel(text: "\(menu["price"] as? String ?? "") Ks", color: BOTTOM_COLOR, size: 15.0, font_name: LIGHT_FONT)
        
        cell.imgMenu.setimage(url_string: "\(image_url_host)\(menu["image"] as? String ?? "" )")
        cell.imgSp.backgroundColor = UIColor.lightGray
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "ReviewMenuViewController") as! ReviewMenuViewController
        let menu = MenuArray[indexPath.row]
        
        controller.menu_id = menu["id"] as! Int
        controller.menuName = menu["name"] as? String ?? ""
        controller.imageString = menu["image"] as? String ?? ""
        controller.shop_id = shop_id
        controller.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
