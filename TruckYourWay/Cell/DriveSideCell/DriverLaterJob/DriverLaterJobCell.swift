//
//  DriverLaterJobCell.swift
//  TruckYourWay
//
//  Created by Anil Choudhary on 18/02/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import UIKit

class DriverLaterJobCell: UITableViewCell {
   
    @IBOutlet weak var lblTotalPaid: UILabel!
    @IBOutlet weak var topTruckNumberContraint: NSLayoutConstraint!
    @IBOutlet weak var lblTruckNumberText: UILabel!
    @IBOutlet weak var lblTruckNo: UILabel!
    @IBOutlet weak var lblDeliveryTypeAndDate: UILabel!
    
    @IBOutlet weak var lblOrderID: UILabel!
    
    @IBOutlet weak var lblTotalTons: UILabel!
    
    @IBOutlet weak var lblTotalLoads: UILabel!
    
    @IBOutlet weak var lblMaterials: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var btnNextOtlt: UIButton!
    @IBOutlet weak var stackViewTotalPaid: UIStackView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
