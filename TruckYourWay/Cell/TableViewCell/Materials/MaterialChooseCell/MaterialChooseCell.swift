//
//  MaterialChooseCell.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/15/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class MaterialChooseCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imgViewMaterial: UIImageView!
    @IBOutlet weak var btnMaterialImageZoomOtlt: MyButton!
    
    @IBOutlet weak var lblLoads: UILabel!
    
    @IBOutlet weak var materialName: UILabel!
    @IBOutlet weak var btnMinusOtlt: MyButton!
    
    @IBOutlet weak var txtFieldTotalQuantity: CustomTxtField!
    //    @IBOutlet weak var lblIncreaseTotal: UILabel!
    
    @IBOutlet weak var lblInstructionCategory: UILabel!
    
    @IBOutlet weak var lblInstructionCategoryHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelUUID: UILabel!

    @IBOutlet weak var btnShowPopUpForAvaliableMaterialOtlt: UIButton!
    
    @IBOutlet weak var btnPlusOtlt: MyButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
