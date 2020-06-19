//
//  JobRequestCell.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/11/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class JobRequestCell: UICollectionViewCell {

    @IBOutlet weak var viewCellMain: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.viewCellMain.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)

    }

}
