//
//  OpenTableViewCell.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 28/4/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class OpenTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
