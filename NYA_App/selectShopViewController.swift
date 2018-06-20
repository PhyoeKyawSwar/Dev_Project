//
//  selectShopViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 12/3/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
class selectShopViewController: UIViewController {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var tblShop: UITableView!
    var shopArray = [[String : Any]]()
    var selected_shop = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.addDoneButtonOnKeyboard()
        self.txtSearch.setSearchTextFieldLayout()
        // Do any additional setup after loading the view.
    }
    
   
 func addDoneButtonOnKeyboard()
 {
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
        self.searchShop()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchShop()
    {
        //search/shop?name
        HUD.show(.systemActivity)
        APIFunction.sharedInstance.apiGETMethod(method: "search/shop?name=\(txtSearch.text!)") { (response) in
            if response.error == nil
            {
                if response.status == 200
                {
                    if let data = response.result as? Dictionary<String,Any>
                    {
                        if let data_array = data["data"] as? [[String : Any]]
                        {
                            self.shopArray = data_array
                            
                            if self.shopArray.count > 0
                            {
                                OperationQueue.main.addOperation {
                                    self.tblShop.delegate = self
                                    self.tblShop.dataSource = self
                                    self.tblShop.reloadData()
                                    
                                }
                            }
                            else
                            {
                                self.showAlert(title: "Information", message: "No Shop found !")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension selectShopViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as! EventTableViewCell
        
        cell.setShopData(event: shopArray[indexPath.row])
        cell.accessoryType = .none
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        
        let dict = shopArray[indexPath.row]
      
        let index =  selected_shop.index { (dict) -> Bool in
            return true
        }
        
        self.selected_shop.remove(at: index!)
        
        var shop_array : [String : Any] = ["shopArray" : selected_shop]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getShopArray"), object: nil, userInfo: shop_array )
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .checkmark
        self.selected_shop.append(shopArray[indexPath.row])
        
        var shop_array : [String : Any] = ["shopArray" : selected_shop]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getShopArray"), object: nil, userInfo: shop_array )
    }
}
