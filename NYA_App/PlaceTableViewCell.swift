//
//  PlaceTableViewCell.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 10/1/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var imgVertical: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
