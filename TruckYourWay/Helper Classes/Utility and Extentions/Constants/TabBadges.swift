//
//  TabBadges.swift
//  TruckYourWay
//
//  Created by Anil Choudhary on 26/02/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import Foundation
import UIKit

func getBadgeNumber(totalMaterials:[DeliveryResponse]) -> Int
{
        var arrLocal : [DeliveryData] = []
        var arr : [DeliveryData] = []

        for item in totalMaterials {
            let arr = item.object
            
            var modal: DeliveryData
            var j : Int = 0
            while(j < (arr.count))
            {
                let dict = arr[j]
                modal = DeliveryData(id:dict.id,
                                     quantity:dict.quantity,
                                     size:dict.size,
                                     category:dict.category,
                                     material_image:dict.material_image,
                                     version_no:dict.version_no,
                                     status:dict.status, dis: "", uid: "")
                arrLocal.append(modal)
                j = j+1
            }
        }

        let ar =  arrLocal.filter({ (param) -> Bool in
            return param.quantity  > 0 ? true : false
        })
    return ar.count
}
