//
//  NewFeedDetailViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 9/3/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class NewFeedDetailViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dateTimeView: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var tblPlace: UITableView!
    @IBOutlet weak var tblPlaceHeight: NSLayoutConstraint!
    @IBOutlet weak var goingView: UIView!
    @IBOutlet weak var lblGoing: UILabel!
    @IBOutlet weak var goingCollection: UICollectionView!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var imgTopBG: UIImageView!
    
    var forEvent = false
    
    var EventArray = [Dictionary<String,Any>]()
    
    var newFeedObj = NewFeedObject()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupData()
        // Do any additional setup after loading the view.
    }
    
    func setupData()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: newFeedObj.date_time)
        
        formatter.dateFormat = "dd/MMM/yyyy HH:mm:ss"
        let dateString = formatter.string(from: date!)
        let dateArray = dateString.components(separatedBy: " ")
        if dateArray.count > 0
        {
            let date_string = dateArray[0]
            let day_month = date_string.components(separatedBy: "/")
            if day_month.count > 0
            {
                
                lblDate.setNormalLabel(text: "\(day_month[1]) \(day_month[0]) ", color: PINK_COLOR, size: 15.0, font_name: BLACK_FONT)
                
            }
            
            txtTime.text = dateArray[1]
            txtTime.textAlignment = .center
            txtTime.isUserInteractionEnabled = false
            
        }
        
        btnJoin.setTitle("JOIN", for: .normal)
        btnJoin.setTitleColor(PINK_COLOR, for: .normal)
        btnJoin.layer.borderColor = PINK_COLOR.cgColor
        btnJoin.layer.borderWidth = 1
        btnJoin.layer.cornerRadius = 5
        
        lblStart.setNormalLabel(text: "Start Time", color: BLACK_COLOR, size: 13.0, font_name: LIGHT_FONT)
        self.lblGoing.setNormalLabel(text: "\(newFeedObj.going_count) going", color: GRAY_COLOR, size: 13.0, font_name: LIGHT_FONT)
        
        if newFeedObj.going_place.count > 0
        {
            forEvent = false
            
            tblPlaceHeight.constant = CGFloat(50 * newFeedObj.going_place.count)
        }
        else
        {
            forEvent = true
            
            let dict = ["event_id" : newFeedObj.event_id , "event_name" : newFeedObj.event_name] as! [String : Any]
            EventArray.append(dict)
            
            tblPlaceHeight.constant = CGFloat(50 * EventArray.count)
        }
        self.tblPlace.backgroundColor = UIColor.clear
        self.tblPlace.delegate = self
        self.tblPlace.dataSource = self
        self.tblPlace.reloadData()
        
        goingCollection.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        goingCollection.dataSource = self
        goingCollection.delegate = self
        goingCollection.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension NewFeedDetailViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forEvent == true
        {
            return EventArray.count
        }
        else
        {
            return newFeedObj.going_place.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell") as! PlaceTableViewCell
        
        var dict = Dictionary<String,Any>()
        
        if forEvent == true
        {
            dict = EventArray[indexPath.row]
            cell.lblPlaceName.text = dict["event_name"] as! String ?? ""
            
            
        }
        else
        {
            dict = newFeedObj.going_place[indexPath.row]
            cell.lblPlaceName.text = dict["name"] as! String ?? ""
            
            
        }
        
        cell.lblPlaceName.font = UIFont(name: LIGHT_FONT, size: NORMAL_FONT_SIZE)
        
        cell.btnRadio.layer.cornerRadius = 10
        cell.btnRadio.backgroundColor = LIGHT_GRAY_COLOR
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
    }
}

extension NewFeedDetailViewController : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newFeedObj.going_user.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let user = newFeedObj.going_user[indexPath.item]
        if (user["profile_picture"] as? String ?? "").contains("/storage")
        {
            cell.imgIcon.setUserimage(url_string: "\(image_url_host)\(user["profile_picture"] as? String ?? "")")
            
        }
        else
        {
            cell.imgIcon.setUserimage(url_string: "\(user["profile_picture"] as? String ?? "")")
            
        }
        
 
        cell.imgIcon.layer.cornerRadius = 25
        cell.imgIcon.clipsToBounds = true
        
        cell.lblTitle.text = user["name"] as? String ?? ""
        cell.lblTitle.font = UIFont(name: LIGHT_FONT, size: TITLE_FONT_SIZE)
        
        
        return cell
    }
}
