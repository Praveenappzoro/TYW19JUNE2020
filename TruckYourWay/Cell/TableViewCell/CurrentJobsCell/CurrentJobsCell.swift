//
//  CurrentJobsCell.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/22/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class CurrentJobsCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lbl_BillId: UILabel!
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