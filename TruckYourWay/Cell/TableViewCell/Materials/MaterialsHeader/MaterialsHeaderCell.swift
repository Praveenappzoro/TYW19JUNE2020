//
//  MaterialsHeaderCell.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/12/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class MaterialsHeaderCell: UITableViewCell {

    @IBOutlet weak var viewForFooter: UIView!
    @IBOutlet weak var btnFooterNext: CustomButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDropDownOtlt: UIButton!
    @IBOutlet weak var btnOverDropDownOtlt: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
