//
//  ConfirmationRowCell.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/17/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class ConfirmationRowCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblMaterialCategory: UILabel!
    @IBOutlet weak var lblMaterialQuantity: UILabel!
    @IBOutlet weak var lblMaterialCost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
