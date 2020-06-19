//
//  ConsumerCompletedJobsCell.swift
//  TruckYourWay
//
//  Created by Anil Choudhary on 01/03/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import UIKit

class ConsumerCompletedJobsCell: UITableViewCell {

    
    @IBOutlet weak var lblDeliveryTypeAndDate: UILabel!
    
    @IBOutlet weak var lblOrderID: UILabel!
    
    @IBOutlet weak var lblTotalTons: UILabel!
    
    @IBOutlet weak var lblAmountPaid: UILabel!
    
    @IBOutlet weak var lblTotalLoads: UILabel!
    
    @IBOutlet weak var lblMaterials: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTruck: UILabel!
    @IBOutlet weak var lblBetweenPlaceholder: UILabel!
    @IBOutlet weak var lblBetweenValue: UILabel!
    @IBOutlet weak var stackViewBetween: UIStackView!
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
