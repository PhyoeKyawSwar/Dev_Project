//
//  MenuViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 19/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var tblMenu: UITableView!
    
    var menuArray = [Dictionary<String,Any>]()
    var popular = [Menu]()
    var shop_id = Int()
    var menuDict = Dictionary<String,Any>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblMenu.delegate = self
        tblMenu.dataSource = self
        tblMenu.reloadData()
        
        txtSearch.setSearchTextFieldLayout()
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

extension MenuViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        
        let dict = menuArray[indexPath.row]
        cell.lblMenu.setNormalLabel(text: dict["name"] as? String ?? "", color:  GRAY_COLOR, size: 18.0, font_name: LIGHT_FONT)
        cell.imgSp.backgroundColor = GRAY_COLOR
        cell.imgArrow.image = #imageLiteral(resourceName: "right-arrow")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "MenuDetailViewController") as! MenuDetailViewController
        let dict = menuArray[indexPath.row]
        controller.menu_id = dict["id"] as! Int
        controller.shop_id = shop_id
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
