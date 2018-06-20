//
//  FriendRequestTableViewCell.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 16/2/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgSp: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
