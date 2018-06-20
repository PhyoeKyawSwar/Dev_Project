//
//  NewFeedTableViewCell.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 7/3/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class NewFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var lblGoing: UILabel!
    @IBOutlet weak var DateTimeView: UIView!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var PlacesView: UIView!
    @IBOutlet weak var imgPlace1: UIImageView!
    @IBOutlet weak var lblPlace1: UILabel!
    @IBOutlet weak var imgPlace2: UIImageView!
    @IBOutlet weak var lblPlace2: UILabel!
    @IBOutlet weak var imgPlace3: UIImageView!
    @IBOutlet weak var lblPlace3: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblGoingCount: UILabel!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var imgTopHeight: NSLayoutConstraint!
    @IBOutlet weak var placeViewHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
