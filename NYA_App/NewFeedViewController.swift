//
//  NewFeedViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 2/1/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import PKHUD
class NewFeedViewController: UIViewController {
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var btnCreatePoll: UIButton!
    
    var newFeedArray = [NewFeedObject]()
    
    @IBOutlet weak var tblNewFeed: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imgIcon.layer.cornerRadius = 25
        imgIcon.clipsToBounds = true
        imgIcon.backgroundColor = LIGHT_GRAY_COLOR
         self.getNewFeed()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        
    }
    @IBAction func onClickCreate(_ sender: Any) {
        let button = sender as! UIButton
        button.animate()
        let controller = AppStoryboard.NewFeed.instance.instantiateViewController(withIdentifier: "CreateViewController") as! CreateViewController
        controller.is_from_Newfeed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getNewFeed()
    {
        HUD.show(.systemActivity)
        
        APIFunction.sharedInstance.apiGETMethod(method: "going_plans") { (response) in
            if response.error == nil
            {
                if response.status == 200
                {
                    if let dataDict = response.result as? [String : Any]
                    {
                        print("Result" , dataDict)
                        let dataArray = dataDict["data"] as? [Dictionary<String , Any>]
                        
                        for dict in dataArray!
                        {
                            let newfeed = NewFeedObject()
                            let new_feed = newfeed.operateData(dictionary: dict)
                            self.newFeedArray.append(new_feed)
                            
                           
                            
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.tblNewFeed.delegate = self
                self.tblNewFeed.dataSource = self
                self.tblNewFeed.reloadData()
                HUD.hide()
            }
        }
    }
    
    func join(sender : UIButton)
    {
        let dictionary = newFeedArray[sender.tag]
        let controller = AppStoryboard.NewFeed.instance.instantiateViewController(withIdentifier: "NewFeedDetailViewController") as! NewFeedDetailViewController
        controller.newFeedObj = dictionary
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

extension NewFeedViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newFeedArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewFeedTableViewCell") as! NewFeedTableViewCell
        let dict = newFeedArray[indexPath.row]
        
        cell.lblPlace1.text = ""
        cell.lblPlace2.text = ""
        cell.lblPlace3.text = ""
        cell.imgPlace1.layer.cornerRadius = 7.5
        cell.imgPlace1.backgroundColor = UIColor.lightGray
        cell.imgPlace2.layer.cornerRadius = 7.5
        cell.imgPlace2.backgroundColor = UIColor.lightGray
        cell.imgPlace3.layer.cornerRadius = 7.5
        cell.imgPlace3.backgroundColor = UIColor.lightGray
        
        cell.lblPlace1.isHidden = true
        cell.imgPlace1.isHidden = true
        cell.lblPlace2.isHidden = true
        cell.imgPlace2.isHidden = true
        cell.lblPlace3.isHidden = true
        cell.imgPlace3.isHidden = true
        if dict.going_place.count > 0
        {
            for index in 0...dict.going_place.count - 1
            {
                let dictionary = dict.going_place[index]
                if index == 0
                {
                    cell.lblPlace1.isHidden = false
                    cell.imgPlace1.isHidden = false
                    cell.lblPlace1.setNormalLabel(text: dictionary["name"] as! String, color: BLACK_COLOR, size: 13.0, font_name: LIGHT_FONT)
                    
                    
                }
                else if index == 1
                {
                    cell.lblPlace2.isHidden = false
                    cell.imgPlace2.isHidden = false
                     cell.lblPlace2.setNormalLabel(text: dictionary["name"] as! String, color: BLACK_COLOR, size: 13.0, font_name: LIGHT_FONT)
                }
                else
                {
                    cell.lblPlace3.isHidden = false
                    cell.imgPlace3.isHidden = false
                     cell.lblPlace3.setNormalLabel(text: dictionary["name"] as! String, color: BLACK_COLOR, size: 13.0, font_name: LIGHT_FONT)
                }
            }
        }
        else
        {
            cell.lblPlace1.isHidden = false
            cell.imgPlace1.isHidden = false
            cell.lblPlace1.setNormalLabel(text: dict.event_name, color: BLACK_COLOR, size: 13.0, font_name: LIGHT_FONT)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dict.date_time)
        
        formatter.dateFormat = "dd/MMM/yyyy HH:mm:ss"
        let dateString = formatter.string(from: date!)
        let dateArray = dateString.components(separatedBy: " ")
        if dateArray.count > 0
        {
            let date_string = dateArray[0]
            let day_month = date_string.components(separatedBy: "/")
            if day_month.count > 0
            {
                
                cell.lblDate.setNormalLabel(text: "\(day_month[1]) \(day_month[0]) ", color: PINK_COLOR, size: 15.0, font_name: BLACK_FONT)
                
            }
            
          cell.txtTime.text = dateArray[1]
          cell.txtTime.textAlignment = .center
          cell.txtTime.isUserInteractionEnabled = false
            
        }
        
        cell.lblGoing.setNormalLabel(text: "", color: BLACK_COLOR, size: 13.0, font_name: LIGHT_FONT)
        cell.lblGoingCount.setNormalLabel(text: "\(dict.going_count) going", color: LIGHT_GRAY_COLOR, size: 13.0, font_name: LIGHT_FONT)
        cell.lblGroupName.setNormalLabel(text: "\(dict.group_name)", color: BLACK_COLOR, size: 15.0, font_name: BLACK_FONT)
        
        cell.lblStart.setNormalLabel(text: "Start Time", color: BLACK_COLOR, size: 13.0, font_name: LIGHT_FONT)
        cell.btnJoin.setTitle("JOIN", for: .normal)
        cell.btnJoin.setTitleColor(PINK_COLOR, for: .normal)
        cell.btnJoin.layer.borderColor = PINK_COLOR.cgColor
        cell.btnJoin.layer.borderWidth = 1
        cell.btnJoin.layer.cornerRadius = 5
        cell.btnJoin.tag = indexPath.row
        cell.btnJoin.addTarget(self, action: #selector(self.join(sender:)), for: .touchUpInside)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
       
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictionary = newFeedArray[indexPath.row]
        let controller = AppStoryboard.NewFeed.instance.instantiateViewController(withIdentifier: "NewFeedDetailViewController") as! NewFeedDetailViewController
        controller.newFeedObj = dictionary
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

