//
//  RatingCell1.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/20/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import Cosmos

class RatingCell1: UICollectionViewCell {

    //#MARK:- View1 Outlts
    @IBOutlet weak var viewPage1: UIView!
    @IBOutlet weak var lblDescPage1: UILabel!
     @IBOutlet weak var ratingViewPage1: CosmosView!
    @IBOutlet weak var btnNextPage1: CustomButton!
    
    //#MARK:- View2 Outlts
    @IBOutlet weak var viewPage2: UIView!
    @IBOutlet weak var imgViewDriverPage2: UIImageView!
    @IBOutlet weak var lblDescPage2: UILabel!
    @IBOutlet weak var ratingViewPage2: CosmosView!
    @IBOutlet weak var btnNextPage2: CustomButton!
    
    //#MARK:- View3 Outlts
    @IBOutlet weak var viewPage3: UIView!
    
    @IBOutlet weak var lblDescPage3: UILabel!
    
    @IBOutlet weak var textView: CustomTextView!
    @IBOutlet weak var btnBackPage3: CustomButton!
    @IBOutlet weak var btnNextPage3: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         self.textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}
