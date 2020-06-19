//
//  ExtensionDate.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 3/30/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import Foundation


extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds))
    }
}
