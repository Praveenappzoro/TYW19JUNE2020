//
//  TruckCartModel.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 3/5/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import Foundation

class TruckCartModel: NSObject, NSCoding {
    
    //ScheduleTime
    var selected_Date: String = ""
    var delivery_type: String = ""
    var later_start: Int = 0
    var later_end: Int = 0
    var pickedCordinates = NSMutableDictionary()
    var currentlyWhichNoDriverRequest: Int = 1
    var totalDriverNeeded: Int = 0
    var selectedServiceType: String = ""
    var selectedJobIndex: Int = -1
    
    var selectedDeliveryIndex: Int = -1
    var selectedHaulingIndex: Int = -1
    var selectedServiceIndex: Int = -1
    
    var selectedDeliveryMaterialType: NSMutableDictionary = NSMutableDictionary()
    var arrSelectedDeliveryMaterial: NSMutableArray = NSMutableArray()
    var isDeliveryMeterialLoadedByLocation: Bool = false

    var selectedServicesServiceType: String = ""
    var selectedMaterialType: String = ""

    var isBobcatNeeded: Bool = false
    var arrSelectedServiceList: NSMutableArray = []
    
    var contact_name: String = ""
    var contact_no: String = ""
    var instruction: String = ""
    
    var arrConfirmation: NSMutableArray = []
    var dictConfirmation : NSMutableDictionary = [:]
    var dictBillDetails : NSMutableDictionary = [:]
    var dictSpecialInstraction : NSMutableDictionary = [:]

    var billId: String = ""
    
    var badgeNumber: Int = 0

    override init() {
        
    }
    
    required init(_ sDate: String?, _ dType: String?, _ lStart: Int?, _ lEnd: Int?, _ pCoord: NSMutableDictionary?, _ selectedService: String?, _ sIndex: Int?, _ deliveryIndex: Int?, _ haulingIndex: Int?, _ serviceIndex: Int?, _ sdMaterialType: NSMutableDictionary?, _ sdMaterial: NSMutableArray?, _ isDeliverySelByLoc: Bool?, _ sssType: String?, _ isBobCNeeded:Bool?, _ arraySSList: NSMutableArray?, _ cName: String? , _ cContact: String?, _ instruct: String?, _ arrConfirm: NSMutableArray?, _ dicConfirm: NSMutableDictionary?, _ dictBill: NSMutableDictionary?, _ bId: String?, _ badge: Int?, _ selectedMType: String?, _ driverNoSelected: Int?, _ tvNeeded: Int?) {
        ///
        self.selected_Date = sDate ?? ""
        self.delivery_type = dType ?? ""
        self.later_start = lStart ?? 0
        self.later_end = lEnd ?? 0
        ////
        self.pickedCordinates = pCoord ?? NSMutableDictionary()
        ////
        self.selectedServiceType = selectedService ?? ""
        self.selectedJobIndex = sIndex ?? -1
        self.selectedDeliveryIndex = deliveryIndex ?? -1
        self.selectedHaulingIndex = haulingIndex ?? -1
        self.selectedServiceIndex = serviceIndex ?? -1
        self.selectedMaterialType = selectedMType ?? ""
        self.selectedDeliveryMaterialType = sdMaterialType ?? NSMutableDictionary()
        self.arrSelectedDeliveryMaterial = sdMaterial ?? NSMutableArray()
        self.isDeliveryMeterialLoadedByLocation = isDeliverySelByLoc ?? false
        self.selectedServicesServiceType = sssType ?? ""
        
        self.arrSelectedServiceList = arraySSList ?? NSMutableArray()
        self.isBobcatNeeded = isBobCNeeded ?? false
        
        self.contact_name = cName ?? ""
        self.contact_no = cContact ?? ""
        self.instruction = instruct ?? ""
        
        self.arrConfirmation = arrConfirm ?? []
        self.dictConfirmation = dicConfirm ?? [:]
        self.dictBillDetails = dictBill ?? [:]
        
        self.billId = bId ?? ""
        
        self.badgeNumber = badge ?? 0
        self.currentlyWhichNoDriverRequest = driverNoSelected ?? 1
        self.totalDriverNeeded = tvNeeded ?? 0
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let selected_Date = aDecoder.decodeObject(forKey: "selected_Date")
        let delivery_type = aDecoder.decodeObject(forKey: "delivery_type")
        let later_start = aDecoder.decodeInteger(forKey: "later_start")
        let later_end = aDecoder.decodeInteger(forKey: "later_end")
        
        let pickedCordinates = aDecoder.decodeObject(forKey: "pickedCordinates")
        
        let selectedService = aDecoder.decodeObject(forKey: "selectedServiceType")
        let sIndex = aDecoder.decodeInteger(forKey: "selectedJobIndex")
        
        let haulingIndex = aDecoder.decodeInteger(forKey: "selectedHaulingIndex")
        let serviceIndex = aDecoder.decodeInteger(forKey: "selectedServiceIndex")
        let deliveryIndex = aDecoder.decodeInteger(forKey: "selectedDeliveryIndex")
        
        let selectedDeliveryMaterialType = aDecoder.decodeObject(forKey: "selectedDeliveryMaterialType")
        let arrSelectedDeliveryMaterial = aDecoder.decodeObject(forKey: "arrSelectedDeliveryMaterial")
        let isDeliveryMeterialLoadedByLocation = aDecoder.decodeObject(forKey: "isDeliveryMeterialLoadedByLocation")
        let sssType = aDecoder.decodeObject(forKey: "selectedServicesServiceType")

        
        let arraySSList = aDecoder.decodeObject(forKey: "arrSelectedServiceList")
        let isBobCNeeded = aDecoder.decodeObject(forKey: "isBobcatNeeded")
        
        let cName = aDecoder.decodeObject(forKey: "contact_name")
        let cContact = aDecoder.decodeObject(forKey: "contact_no")
        let instruct = aDecoder.decodeObject(forKey: "instruction")
        let selectedMType = aDecoder.decodeObject(forKey: "instruction")

        let arrConfirm = aDecoder.decodeObject(forKey: "arrConfirmation")
        let dicConfirm = aDecoder.decodeObject(forKey: "dictConfirmation")
        let dictBill = aDecoder.decodeObject(forKey: "dictBillDetails")

        let bId = aDecoder.decodeObject(forKey: "billId")
        let badge = aDecoder.decodeInteger(forKey: "badgeNumber")
        let driverNoSelected = aDecoder.decodeInteger(forKey: "currentlyWhichNoDriverRequest")
        let tvNeeded = aDecoder.decodeInteger(forKey: "totalDriverNeeded")
        
        
        
        self.init((selected_Date as! String), (delivery_type as! String), later_start, later_end, pickedCordinates as? NSMutableDictionary, selectedService as? String, sIndex, deliveryIndex, haulingIndex, serviceIndex, selectedDeliveryMaterialType as? NSMutableDictionary, arrSelectedDeliveryMaterial as? NSMutableArray, isDeliveryMeterialLoadedByLocation as? Bool, sssType as? String, isBobCNeeded as? Bool, arraySSList as? NSMutableArray, cName as? String, cContact as? String, instruct as? String, arrConfirm as? NSMutableArray, dicConfirm as? NSMutableDictionary, dictBill as? NSMutableDictionary, bId as? String, badge, selectedMType as? String, driverNoSelected as? Int, tvNeeded as? Int)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(selected_Date, forKey: "selected_Date")
        aCoder.encode(delivery_type, forKey: "delivery_type")
        aCoder.encode(later_start, forKey: "later_start")
        aCoder.encode(later_end, forKey: "later_end")
        
        aCoder.encode(pickedCordinates, forKey: "pickedCordinates")
        
        aCoder.encode(selectedServiceType, forKey: "selectedServiceType")
        aCoder.encode(selectedJobIndex, forKey: "selectedJobIndex")

        aCoder.encode(selectedDeliveryIndex, forKey: "selectedDeliveryIndex")
        aCoder.encode(selectedHaulingIndex, forKey: "selectedHaulingIndex")
        aCoder.encode(selectedServiceIndex, forKey: "selectedServiceIndex")

        aCoder.encode(selectedDeliveryMaterialType, forKey: "selectedDeliveryMaterialType")
        aCoder.encode(arrSelectedDeliveryMaterial, forKey: "arrSelectedDeliveryMaterial")
        aCoder.encode(isDeliveryMeterialLoadedByLocation, forKey: "isDeliveryMeterialLoadedByLocation")
        
        aCoder.encode(selectedServicesServiceType, forKey: "selectedServicesServiceType")
        
        aCoder.encode(arrSelectedServiceList, forKey: "arrSelectedServiceList")
        aCoder.encode(isBobcatNeeded, forKey: "isBobcatNeeded")

        aCoder.encode(contact_name, forKey: "contact_name")
        aCoder.encode(contact_no, forKey: "contact_no")
        aCoder.encode(instruction, forKey: "instruction")
        
        aCoder.encode(arrConfirmation, forKey: "arrConfirmation")
        aCoder.encode(dictConfirmation, forKey: "dictConfirmation")
        aCoder.encode(dictBillDetails, forKey: "dictBillDetails")
        aCoder.encode(billId, forKey: "billId")

        aCoder.encode(badgeNumber, forKey: "badgeNumber")
        aCoder.encode(selectedMaterialType, forKey: "selectedMaterialType")
        aCoder.encode(currentlyWhichNoDriverRequest, forKey: "currentlyWhichNoDriverRequest")
        aCoder.encode(totalDriverNeeded, forKey: "totalDriverNeeded")
    }
    
}
