//
//  ChooseDriverCell.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/19/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import Cosmos

class ChooseDriverCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTruckNumber: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    
    @IBOutlet weak var btnNextOtlt: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
