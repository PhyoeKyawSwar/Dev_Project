//
//  MenuTableViewCell.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 19/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
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
