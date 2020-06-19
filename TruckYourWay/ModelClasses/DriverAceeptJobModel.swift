//
//  DriverAceeptJobModel.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 3/14/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import Foundation

class DriverAceeptJobModel: NSObject, NSCoding {

    var isFromNotification: Bool = false
    var arrConfirmation: NSMutableArray = []
    var dictConfirmation : NSMutableDictionary = [:]
    var dictBillDetails : NSMutableDictionary = [:]
    var selectedServiceType: String = ""
    var contact_name: String = ""
    var contact_no: String = ""
    var instruction: String = ""
    var screenComeFrom: String = ""
    var globalCurrentLoad = 1
    var globalTotalLoads = 0
    var jobTypeStr = ""
    var isRepeatTimer: Bool = true
    var isLaterJob: Bool = false
    var jobStatus: Int = 0
    
    
    var loadAmount: Int = 0
    var loadUnit: String = "Tons"
    var loadImage: UIImage = UIImage()
    var invoiceNumber: String = ""
    var str_Invoice_Image: String = ""
    var dateAccepted: Int = 0
    
    var currentMaterialIndex = 0
    var materialLoaded = 0
    
    override init() {
        
    }
    
    
    required init(_ isFromNoti: Bool?, _ arrayConfrm: NSMutableArray?, _ dicConfrm: NSMutableDictionary?, _ dicBill: NSMutableDictionary?, _ selectedService: String?, _ cName: String?, _ cContact: String?, _ instruct: String?, _ screenComeFrm: String?, _ globCurrLoad: Int?,  _ globTotalLoad: Int?, _ jobType: String?, _ isReptTmr: Bool?, _ jStatus: Int?, _ loadAmt: Int?, _ loadUt: String?, _ loadImg: UIImage?, _ loadInvoiceNum: String?, _ strInvoiceImg: String?, dateAccept: Int?, _ cMaterialIndex: Int?, _ loadedMat: Int?, _ isLater: Bool?) {
        
        self.isFromNotification = isFromNoti ?? false
        self.arrConfirmation = arrayConfrm ?? []
        self.dictConfirmation = dicConfrm ?? [:]
        self.dictBillDetails = dicBill ?? [:]
        self.selectedServiceType = selectedService ?? ""
        self.contact_name = cName ?? ""
        self.contact_no = cContact ?? ""
        self.instruction = instruct ?? ""
        self.screenComeFrom = screenComeFrm ?? ""
        self.globalCurrentLoad = globCurrLoad ?? 0
        self.globalTotalLoads = globTotalLoad ?? 0
        self.jobTypeStr = jobType ?? ""
        self.isRepeatTimer = isReptTmr ?? true
        self.jobStatus = jStatus ?? 0
        
        self.loadAmount = loadAmt ?? 0
        self.loadUnit = loadUt ?? "Tons"
        self.loadImage = loadImg ?? UIImage()
        self.invoiceNumber = loadInvoiceNum ?? ""
        self.str_Invoice_Image = strInvoiceImg ?? ""
        self.dateAccepted = dateAccept ?? 0
        
        self.currentMaterialIndex = cMaterialIndex ?? 0
        self.materialLoaded = loadedMat ?? 0
        self.isLaterJob = isLater ?? false
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let isFromNoti = aDecoder.decodeBool(forKey: "isFromNotification")
        let isLater = aDecoder.decodeBool(forKey: "isLaterJob")
        let arrConf = aDecoder.decodeObject(forKey: "arrConfirmation")
        let dictConf = aDecoder.decodeObject(forKey: "dictConfirmation")
        let dictBillD = aDecoder.decodeObject(forKey: "dictBillDetails")
        let selectedService = aDecoder.decodeObject(forKey: "selectedServiceType")
        let con_name = aDecoder.decodeObject(forKey: "contact_name")
        let con_no = aDecoder.decodeObject(forKey: "contact_no")
        let instruct = aDecoder.decodeObject(forKey: "instruction")
        let screenComeF = aDecoder.decodeObject(forKey: "screenComeFrom")
        let gCurrentLoad = aDecoder.decodeInteger(forKey: "globalCurrentLoad")
        let gTotalLoads = aDecoder.decodeInteger(forKey: "globalTotalLoads")
        let jobType = aDecoder.decodeObject(forKey: "jobTypeStr")
        let isRepeatT = aDecoder.decodeObject(forKey: "isRepeatTimer")
        let jStatus = aDecoder.decodeInteger(forKey: "jobStatus")
        
        let loadAmt = aDecoder.decodeInteger(forKey: "loadAmount")
        let loadUt = aDecoder.decodeObject(forKey: "loadUnit")
        let loadImg = aDecoder.decodeObject(forKey: "loadImage")
        let invoiceNum = aDecoder.decodeObject(forKey: "invoiceNumber")
        let str_Invc_Img = aDecoder.decodeObject(forKey: "str_Invoice_Image")
        let dateAccept = aDecoder.decodeInteger(forKey: "dateAccepted")

        let cMatIndex = aDecoder.decodeInteger(forKey: "currentMaterialIndex")
        let loadedMat = aDecoder.decodeInteger(forKey: "materialLoaded")

        self.init(isFromNoti, arrConf as? NSMutableArray, dictConf as? NSMutableDictionary, dictBillD as? NSMutableDictionary, selectedService as? String, con_name as? String, con_no as? String, instruct as? String, screenComeF as? String, gCurrentLoad, gTotalLoads, jobType as? String, isRepeatT as? Bool, jStatus, loadAmt, loadUt as? String, loadImg as? UIImage, invoiceNum as? String, str_Invc_Img as? String, dateAccept: dateAccept, cMatIndex, loadedMat, isLater)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(isFromNotification, forKey: "isFromNotification")
        aCoder.encode(arrConfirmation, forKey: "arrConfirmation")
        aCoder.encode(dictConfirmation, forKey: "dictConfirmation")
        aCoder.encode(dictBillDetails, forKey: "dictBillDetails")
        aCoder.encode(selectedServiceType, forKey: "selectedServiceType")
        aCoder.encode(contact_name, forKey: "contact_name")
        aCoder.encode(contact_no, forKey: "contact_no")
        aCoder.encode(instruction, forKey: "instruction")
        aCoder.encode(screenComeFrom, forKey: "screenComeFrom")
        aCoder.encode(globalCurrentLoad, forKey: "globalCurrentLoad")
        aCoder.encode(globalTotalLoads, forKey: "globalTotalLoads")
        aCoder.encode(jobTypeStr, forKey: "jobTypeStr")
        aCoder.encode(isRepeatTimer, forKey: "isRepeatTimer")
        aCoder.encode(jobStatus, forKey: "jobStatus")        
        aCoder.encode(loadAmount, forKey: "loadAmount")
        aCoder.encode(loadUnit, forKey: "loadUnit")
        aCoder.encode(loadImage, forKey: "loadImage")
        aCoder.encode(invoiceNumber, forKey: "invoiceNumber")
        aCoder.encode(str_Invoice_Image, forKey: "str_Invoice_Image")
        aCoder.encode(dateAccepted, forKey: "dateAccepted")
        aCoder.encode(isLaterJob, forKey: "isLaterJob")
        aCoder.encode(currentMaterialIndex, forKey: "currentMaterialIndex")
        aCoder.encode(materialLoaded, forKey: "materialLoaded")
    }
    
}

