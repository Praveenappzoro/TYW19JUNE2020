
import UIKit
import CoreLocation

class SpecialInstructionsVC: UIViewController {

    @IBOutlet weak var btnTitleOtlt: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var textViewDeliveryInsc: UITextView!
    
    // Design for popUp view
    
    @IBOutlet weak var lblMaterialPickupTitle: UILabel!
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var viewSubViewPopUp: UIView!
    @IBOutlet weak var lblLoadOfLoad: UILabel!
    @IBOutlet weak var lblTotalDistanceWithDesc: UILabel!
    @IBOutlet weak var lblShowLocationOtlt: PaddingLabel!
    @IBOutlet weak var lblSpecialInstructionPlaceholder: UILabel!

    
    var driver_Id : String = ""
    var tracking_Id : String = ""
    var driver_Type : String = ""
    var consumer_Name : String = ""
    var consumer_contact_no : String = ""
    var consumer_instruction : String = ""
    var globalCurrentLoad = 1
    var globalTotalLoads = 0
    var jobTypeStr = ""
    var dictBillDetails = NSMutableDictionary()
    var dateAccepted: Int = 0
    var loginUserData:LoggedInUser!
    var dictConfirmation : NSMutableDictionary = [:]
    var arrConfirmation: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewPopUp.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appIsGoingInBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        if Constant.MyVariables.appDelegate.acceptJobModel != nil {
            let model = Constant.MyVariables.appDelegate.acceptJobModel!
            
            let driver_Id =  String(model.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
            let tracking_Id =  String(model.dictBillDetails.value(forKey: "id") as? Int ?? 0)
            let driver_Type = model.dictBillDetails.value(forKey: "driver_type") as? String ?? ""
            
            self.driver_Id = driver_Id
            self.tracking_Id = tracking_Id
            self.driver_Type = driver_Type
            self.consumer_Name = model.dictBillDetails.value(forKey: "contact_name") as? String ?? ""
            self.consumer_contact_no = model.dictBillDetails.value(forKey: "contact_no") as? String ?? ""
            self.consumer_instruction = model.dictBillDetails.value(forKey: "instruction") as? String ?? ""
            self.globalCurrentLoad = model.globalCurrentLoad
            self.globalTotalLoads = model.globalTotalLoads
            self.jobTypeStr = model.jobTypeStr
            
            self.dictBillDetails = model.dictBillDetails
            self.dateAccepted = model.dateAccepted
            self.dictConfirmation = model.dictConfirmation
            self.arrConfirmation = model.arrConfirmation
//            if model.jobStatus == 2 {
//                UIView.animate(withDuration: 0.25, animations: {
//                    self.viewPopUp.isHidden = false
//                    self.viewSubViewPopUp.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                });
//            }
        } else {
            Constant.MyVariables.appDelegate.acceptJobModel = DriverAceeptJobModel.init()
        }
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        let strLoads = "\("LOAD ")\(self.globalCurrentLoad)\(" of ")\(self.globalTotalLoads)"
        self.btnTitleOtlt.setTitle(strLoads, for: .normal)
        self.lblName.text = consumer_Name
        self.lblPhoneNo.text = consumer_contact_no
        self.textViewDeliveryInsc.text = consumer_instruction
        
        ///KRISHNA
        
        self.lblShowLocationOtlt.layer.cornerRadius = 25
        self.lblShowLocationOtlt.layer.masksToBounds = true
        self.lblShowLocationOtlt.layer.borderWidth = 5
        self.lblShowLocationOtlt.layer.borderColor = UIColor.init(red: 156.0/255.0, green: 190.0/255.0, blue: 56.0/255.0, alpha: 1.0).cgColor
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionLocationShow))
        self.lblShowLocationOtlt.addGestureRecognizer(tap)
        
        self.viewSubViewPopUp.layer.cornerRadius = 10
        self.viewSubViewPopUp.layer.masksToBounds = true
        ShowDataOnSreen()
        
       
    }
    
    func ShowDataOnSreen()
    {
        print(self.dictConfirmation)
        let dictt = self.dictConfirmation.value(forKey: "bill_details") as! NSDictionary
        self.dictBillDetails = dictt.mutableCopy() as! NSMutableDictionary
        print(Int(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "0")!)
        self.globalTotalLoads = Int(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "0")!
        
        let strLoads = "\("LOAD ")\(self.globalCurrentLoad)\(" of ")\(self.globalTotalLoads)"
        
        self.lblLoadOfLoad.text = strLoads
        
        let dropLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_latitude") as! String) ?? 0.0
        let dropLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_longitude") as! String) ?? 0.0
        let pickLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_latitude") as! String) ?? 0.0
        let pickLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_longitude") as! String) ?? 0.0
        
        let pickup_address = self.dictBillDetails.value(forKey: "pickup_address") as? String ?? ""
        
        let drop_address = self.dictBillDetails.value(forKey: "drop_address") as? String ?? ""
        
        let coordinate₀ = CLLocation(latitude: dropLat, longitude: dropLong)
        let coordinate₁ = CLLocation(latitude: pickLat, longitude: pickLong)
        
        let distanceInMilesInDouble = Double(((coordinate₀.distance(from: coordinate₁)/1000)*0.621371)) // result is in miles
        //        let distanceInMilesRound = Double(round(1000*distanceInMilesInDouble)/100)
        let doubleStr = String(format: "%.2f", distanceInMilesInDouble)
        
        let distanceInMilesRound = Double(doubleStr)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

        let moment = self.dictBillDetails.value(forKey: "moment") as? String
        let ddd = moment as! String
        let fullDate =  Date(timeIntervalSince1970: TimeInterval(ddd)!)
        let time = dateFormatterPrint.string(from: fullDate)
        
        let strType = "\(self.dictBillDetails.value(forKey: "type") as? String ?? "NOW")"
        let strTypeWithSpace = "\(strType.uppercased())\(", ")"
        let strAttributedTime = self.attributeDtailsBold(strBold: strTypeWithSpace, strNormal: time)
        
        let dealer_Name = self.dictBillDetails.value(forKey: "dealer_name") as? String ?? ""
        let jobType = (self.dictBillDetails.value(forKey: "job_type") as? String)?.uppercased() ?? ""
        
        let strFirstLine = "The material pickup location is:\n"
        let thirdLine = "\nThe address is:"

        var strAttributedTimeSecond: NSMutableAttributedString!
        if(jobType == "DELIVERY") {
            strAttributedTimeSecond = self.attributeDtailsBoldThird(strFirstNormal: strFirstLine, strSecondBold: dealer_Name, strthirdNormal: thirdLine)
            lblSpecialInstructionPlaceholder.text = "Special Delivery Instructions"

        } else {
            strAttributedTimeSecond = self.attributeDtailsBoldThird(strFirstNormal: "The material pickup address is:\n", strSecondBold: "", strthirdNormal: "")
            lblSpecialInstructionPlaceholder.text = "Special Hauling Instructions"

        }
        
        self.lblMaterialPickupTitle.attributedText = strAttributedTimeSecond
        
//        if(jobType == "DELIVERY")
//        {
//            let strAttributedLocationDelivery = self.attributeDtailsBold(strBold: "\(dealer_Name)\n", strNormal: pickup_address)
//            self.btnPickLocationOtlt.setAttributedTitle(strAttributedLocationDelivery, for: .normal)
//            self.btnJobSiteLocationOtlt.setTitle(drop_address, for: .normal)
//        }
//        else
//        {
//            let strAttributedLocationHauling = self.attributeDtailsBold(strBold: "\(dealer_Name)\n", strNormal: pickup_address)
//            self.btnPickLocationOtlt.setTitle(drop_address, for: .normal)
//            self.btnJobSiteLocationOtlt.setAttributedTitle(strAttributedLocationHauling, for: .normal)
//        }
        
//        self.btnPickLocationOtlt.titleLabel!.numberOfLines = 3
//        self.btnPickLocationOtlt.titleLabel!.lineBreakMode = .byWordWrapping
//        self.btnPickLocationOtlt.titleLabel!.adjustsFontSizeToFitWidth = true
//        self.btnJobSiteLocationOtlt.titleLabel!.numberOfLines = 3
//        self.btnJobSiteLocationOtlt.titleLabel!.lineBreakMode = .byWordWrapping
//        self.btnJobSiteLocationOtlt.titleLabel!.adjustsFontSizeToFitWidth = true
//        self.btnchangeTimeOfRequestShowOtlt.setAttributedTitle(strAttributedTime, for: .normal)
//        self.lblTotalLoads.text = self.dictBillDetails.value(forKey: "total_loads") as? String ?? ""
//        self.lblTotalTons.text = self.dictBillDetails.value(forKey: "total_tons") as? String ?? ""
//
        let total_loadsInt = Double(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "")
        let totalMiles = round(Double(distanceInMilesRound!))
        let distanceInMiles = String(format: "%.1f", totalMiles)
        let str = "\(round(totalMiles))\(" MILES")"
        
        let bill_Detail = self.dictConfirmation.value(forKey: "bill_details") as! NSDictionary
        let str_job_type = bill_Detail.value(forKey: "job_type") as? String ?? ""
        self.jobTypeStr = str_job_type.uppercased()
        
        // for popUp Location btn
        var strLocation = self.dictBillDetails.value(forKey: "drop_address") as? String ?? ""
        
        if(self.jobTypeStr == "HAULING") {
            strLocation = self.dictBillDetails.value(forKey: "drop_address") as? String ?? ""
//
//            let address = self.dictBillDetails.value(forKey: "pickup_address") as? String ?? ""
//            let city = self.dictBillDetails.value(forKey: "pickup_city") as? String ?? ""
//            let state = self.dictBillDetails.value(forKey: "pickup_state") as? String ?? ""
//            let zipcode = self.dictBillDetails.value(forKey: "pickup_zipcode") as? String ?? ""
//            strLocation = address + ", " + city + ", " + state + ", " + zipcode
        }
        else {
            //strLocation = pickup_address
            
            let address = self.dictBillDetails.value(forKey: "pickup_address") as? String ?? ""
            let city = self.dictBillDetails.value(forKey: "pickup_city") as? String ?? ""
            let state = self.dictBillDetails.value(forKey: "pickup_state") as? String ?? ""
            let zipcode = self.dictBillDetails.value(forKey: "pickup_zipcode") as? String ?? ""
            strLocation = address + ", " + city + ", " + state + ", " + zipcode
        }
        
        
        //Added By KRISHNA
        let attrs = NSAttributedString(string: strLocation, attributes: [NSAttributedStringKey.foregroundColor: UIColor(red:20.0/255.0, green:104.0/255.0, blue:215.0/255.0, alpha:1.0), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17.0), NSAttributedStringKey.underlineColor: UIColor(red:20.0/255.0, green:104.0/255.0, blue:215.0/255.0, alpha:1.0), NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        
        let strOrderID = "\(TYW_ID_SUFFIX)\( self.dictBillDetails.value(forKey: "bill_no") as? String ?? "")"
        
        self.lblShowLocationOtlt.attributedText = attrs
        let strPurchseOrderId = "Purchase Order : \(strOrderID)\n"
        let currentDescription = self.getCurrentLoadDetails(arr:self.arrConfirmation)
        //let strNeedObtains = "You need to obatain 16 Tons of Gravel #82.\n"
        let strTotalDistanceDesc = "Total distance from pickup location to \(self.jobTypeStr.capitalizingFirstLetter()) location : "
        
        let strConcinateing = strPurchseOrderId+currentDescription+strTotalDistanceDesc
        self.lblTotalDistanceWithDesc.attributedText = self.attributeDtailsBold(strNormal: strConcinateing, strBold: str)
        
        
    }
    
    func attributeDtailsBold(strBold: String, strNormal: String) -> NSMutableAttributedString
    {
        let normalString = NSMutableAttributedString(string:strNormal)
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)]
        let attributedString = NSMutableAttributedString(string:strBold, attributes:attrs)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:strBold.length))
        attributedString.append(normalString)
        return attributedString
    }
    
    func attributeDtailsBoldThird(strFirstNormal: String,strSecondBold: String, strthirdNormal: String) -> NSMutableAttributedString
    {
        
        let normalsThirdString = NSMutableAttributedString(string:strthirdNormal)
        
        let attrsFirst = [NSAttributedStringKey.font :  UIFont.systemFont(ofSize: 15)]
        let attributedStringFirst = NSMutableAttributedString(string:strFirstNormal, attributes:attrsFirst)
        
        let attrsss = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)]
        let attributedStringss = NSMutableAttributedString(string:strSecondBold, attributes:attrsss)
        
        
        let attrsThird = [NSAttributedStringKey.font :  UIFont.systemFont(ofSize: 15)]
        let attributedStringThird = NSMutableAttributedString(string:strthirdNormal, attributes:attrsThird)
        
        attributedStringFirst.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:strFirstNormal.length))
        
        attributedStringFirst.append(attributedStringss)
        attributedStringFirst.append(attributedStringThird)
        
        return attributedStringFirst
    }
    
    //#MARK:- make Attributed-String normal and Bold
    func attributeDtailsBold(strNormal: String, strBold: String) -> NSMutableAttributedString
    {
        let normalString = NSMutableAttributedString(string:strNormal)
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:strBold, attributes:attrs)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:strBold.length))
        normalString.append(attributedString)
        return normalString
    }
    
    func getCurrentLoadDetails(arr:NSMutableArray) -> String
    {
        var model: DriverAceeptJobModel!
        if Constant.MyVariables.appDelegate.acceptJobModel != nil {
            model = Constant.MyVariables.appDelegate.acceptJobModel!
        } else {
            Constant.MyVariables.appDelegate.acceptJobModel = DriverAceeptJobModel.init()
            model = Constant.MyVariables.appDelegate.acceptJobModel!
        }
        
        let materialArray = arr
        var materialDic = materialArray[model.currentMaterialIndex] as! NSDictionary
        let remainingTons = (Int(materialDic["tons"] as! String) ?? 0) - model.materialLoaded
        
        print(materialDic)
        print(model.currentMaterialIndex)
        print(model.materialLoaded)
        
        var needToObtain = 0
        if remainingTons > 0 {
            if remainingTons > 16 {
                //                model.materialLoaded = model.materialLoaded + 16
                needToObtain = 16
            } else {
                //                model.materialLoaded = model.materialLoaded + remainingTons
                needToObtain = remainingTons
            }
        } else {
            //            model.materialLoaded = 0
            //            model.currentMaterialIndex += 1
//            var index = materialArray.count - 1
//            if model.currentMaterialIndex > materialArray.count {
//                index = model.currentMaterialIndex + 1
//            }
//            guard let mDic = materialArray[index] as? NSDictionary else { return "" }
//            materialDic = mDic

            if materialArray.count > model.currentMaterialIndex+1 {
                materialDic = materialArray[model.currentMaterialIndex + 1] as! NSDictionary
            } else {
                materialDic = materialArray.lastObject as! NSDictionary
            }
            
            let remainingTons = (Int(materialDic["tons"] as! String) ?? 0)
            if remainingTons > 0 {
                if remainingTons > 16 {
                    //                    model.materialLoaded = model.materialLoaded + 16
                    needToObtain = 16
                } else {
                    //                    model.materialLoaded = model.materialLoaded + remainingTons
                    needToObtain = remainingTons
                }
            }
        }
        
        var strMsg = ""
        
        let category = materialDic["category"] as! String
        
        if (self.dictBillDetails["job_type"] as! String).uppercased() == "DELIVERY" {
            if category.uppercased() == "DIRT" {
                strMsg = "You need to obtain 1 Load of\n \(category.uppercased()) \(materialDic["name"] as! String).\n"
            } else {
                strMsg = "You need to obtain \(needToObtain) Tons of\n \(category.uppercased()) \(materialDic["name"] as! String).\n"
            }
        } else {
            strMsg = "You need to haul away 1 Load of\n \(category.uppercased()) \(materialDic["name"] as! String).\n"
        }
        
        return strMsg
        ///=====
        
        var totalTons: Int = 0
        var avaliableAcutalTons: Int = 0
        var lastRemainingTons: Int = 0
        var flagCount: Int = 1
        var strDesc: String = ""
        var nameOfPrduct: String = ""
        var pname = ""
        
        
        for item in self.arrConfirmation
        {
            let dict  = item as? NSDictionary
            let count = Int(dict?.value(forKey: "tons") as? String ?? "0") ?? 0
            totalTons = totalTons + count
            nameOfPrduct = dict?.value(forKey: "category") as? String ?? ""
            pname = dict?.value(forKey: "name") as? String ?? ""
            avaliableAcutalTons = (totalTons-((self.globalCurrentLoad-1)*16))
            if(avaliableAcutalTons >= 16)
            {
                avaliableAcutalTons = 16
                break
            }
            
            flagCount = flagCount + 1
            
        }
        
        let devideTime  = avaliableAcutalTons / 16
        var modules  = avaliableAcutalTons % 16
        if(modules > 0)
        {
            modules = modules + 1
        }
        let finalTotalLoads = (devideTime + modules)
        
        let bill_Detail = self.dictConfirmation.value(forKey: "bill_details") as! NSDictionary
        
        let str_job_type = bill_Detail.value(forKey: "job_type") as? String ?? ""
        
        
        if str_job_type.uppercased() == "HAULING" {
            strDesc = "You need to haul away \(finalTotalLoads) \(finalTotalLoads == 1 ? "Load" : "Loads" ) of \(nameOfPrduct) \(pname).\n"
        } else {
            strDesc = "You need to obtain \(avaliableAcutalTons) \(avaliableAcutalTons == 1 ? "Ton" : "Tons" ) of \(nameOfPrduct) \(pname).\n"
        }
        
        return strDesc
    }
    
    @objc func actionLocationShow(_ sender: Any)
    {
        let primaryContactFullAddress  = self.lblShowLocationOtlt.text ?? ""
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            let escapedString = primaryContactFullAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let directionsRequest = "\("comgooglemaps-x-callback://?daddr=")\(escapedString!)"
            
            let directionsURL = URL(string: directionsRequest)!
            UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
            print("Google map.")
            
        } else if UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!) {
            let escapedString = primaryContactFullAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
            let strUrl = "http://maps.apple.com/?address=" + (escapedString ?? "")
            let url = URL(string: strUrl)
            print(url ?? "")
            if url != nil {
                UIApplication.shared.open(url!)
            } else {
                self.showAlert("Location not found.")
            }
            print("Apple map.")
        } else {
            self.showAlert("No Application found.")
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func appIsGoingInBackground() {
        print("disappearing..")
       
        USER_DEFAULT.set(AppState.DriverInstructions.rawValue, forKey: APP_STATE_KEY)
    }

    @IBAction func actionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionNext(_ sender: Any)
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.viewPopUp.isHidden = false
            self.viewSubViewPopUp.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
//        if(self.jobTypeStr == "HAULING" && (self.globalCurrentLoad == self.globalTotalLoads))
//        {
//            let driver_Id =  String(self.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
//            let tracking_Id =  String(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)
//            let driver_Type = self.dictBillDetails.value(forKey: "driver_type") as? String ?? ""
//
//            let completeDelivery = CompleteDeliveryJobVc.init(nibName: "CompleteDeliveryJobVc", bundle: nil)
//            completeDelivery.driver_Id = driver_Id
//            completeDelivery.tracking_Id = tracking_Id
//            completeDelivery.driver_Type = driver_Type
//            completeDelivery.globalCurrentLoad = self.globalCurrentLoad
//            completeDelivery.globalTotalLoads = self.globalTotalLoads
//            completeDelivery.dictBillDetails = self.dictBillDetails
//            completeDelivery.jobTypeStr = self.jobTypeStr
//            self.navigationController?.pushViewController(completeDelivery, animated: true)
//        } else {
//            let vcComplete = LoadReceivedVC.init(nibName: "LoadReceivedVC", bundle: nil)
//            vcComplete.globalTotalLoads = self.globalTotalLoads
//            vcComplete.globalCurrentLoad = self.globalCurrentLoad
//            vcComplete.dictBillDetails = self.dictBillDetails.mutableCopy() as! NSMutableDictionary
//            vcComplete.jobTypeStr = self.jobTypeStr
////            vcComplete.delegateCurrentLoad = JobAcceptDriver()
//            vcComplete.dateAccepted = self.dateAccepted
//            self.navigationController?.pushViewController(vcComplete, animated: true)
//        }
    }
    
    @IBAction func actionNextFromPopUpScreen(_ sender: Any) {
        
        if(self.jobTypeStr == "HAULING" && (self.globalCurrentLoad == self.globalTotalLoads))
        {
            let driver_Id =  String(self.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
            let tracking_Id =  String(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)
            let driver_Type = self.dictBillDetails.value(forKey: "driver_type") as? String ?? ""
            
            let completeDelivery = CompleteDeliveryJobVc.init(nibName: "CompleteDeliveryJobVc", bundle: nil)
            completeDelivery.driver_Id = driver_Id
            completeDelivery.tracking_Id = tracking_Id
            completeDelivery.driver_Type = driver_Type
            completeDelivery.globalCurrentLoad = self.globalCurrentLoad
            completeDelivery.globalTotalLoads = self.globalTotalLoads
            completeDelivery.dictBillDetails = self.dictBillDetails
            completeDelivery.jobTypeStr = self.jobTypeStr
            self.navigationController?.pushViewController(completeDelivery, animated: true)
        } else {
            let vcComplete = LoadReceivedVC.init(nibName: "LoadReceivedVC", bundle: nil)
            vcComplete.globalTotalLoads = self.globalTotalLoads
            vcComplete.globalCurrentLoad = self.globalCurrentLoad
            vcComplete.dictBillDetails = self.dictBillDetails.mutableCopy() as! NSMutableDictionary
            vcComplete.jobTypeStr = self.jobTypeStr
            //vcComplete.delegateCurrentLoad = self
            vcComplete.dateAccepted = self.dateAccepted
            self.navigationController?.pushViewController(vcComplete, animated: true)
            
//            if self.jobTypeStr == "HAULING" {
//                self.apiCallForCompleteJob()
//            }
        }
          
    }
        
        
    func apiCallForCompleteJob() {
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else{
            return
        }
        let driver_Id =  String(self.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
        let tracking_Id =  String(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)
        
        let str_Load_No = "\(self.globalCurrentLoad)"
        let params = [
            "driver_id":driver_Id,
            "tracking_id":tracking_Id,
            "load_no":str_Load_No,
            "completion_image":"notProvided",
            "type":self.dictBillDetails.value(forKey: "driver_type") as? String ?? "",
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            "is_completion_image_uploaded": false
            ] as! NSDictionary
        
        self.startAnimating("")
        
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_COMPLETE_JOB_LOADS, .post, params as? [String : Any]) { (
            result, data, json, error, msg) in
            
            switch result
            {
            case .Failure:
                DispatchQueue.main.async(execute: {
                    self.stopAnimating()
                    self.showAlert(msg)
                })
                break
            case .Success:
                DispatchQueue.main.async(execute: {
                    self.stopAnimating()
                })
                break
            }
            
        }
    }
    
}
