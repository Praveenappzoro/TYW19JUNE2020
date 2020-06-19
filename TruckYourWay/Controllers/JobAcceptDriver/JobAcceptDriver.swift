//
//  JobAcceptDriver.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 12/17/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import CoreLocation




class JobAcceptDriver: UIViewController, CurrentLoadUpdateDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var lblTitleForJobTypeLocaton: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var viewTimerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnchangeTimeOfRequestShowOtlt: UIButton!
    
    @IBOutlet weak var greenLblbView: UIView!
    @IBOutlet weak var btnPickLocationOtlt: UIButton!
    
    @IBOutlet weak var btnJobSiteLocationOtlt: UIButton!
    @IBOutlet weak var buttonDecline: UIButton!
    @IBOutlet weak var buttonAccept: UIButton!

    @IBOutlet weak var viewTotalCalculations: UIView!
    
     @IBOutlet weak var lblTotalTons: UILabel!
     @IBOutlet weak var lblTotalLoads: UILabel!
     @IBOutlet weak var lblTotalMiles: UILabel!
//    @IBOutlet weak var lblSubTotal: UILabel!
//    @IBOutlet weak var lblTax: UILabel!
//    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblShowLocationOtlt: PaddingLabel!
    
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var superViewOfTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ConstraintviewHeightTotalCalculation: NSLayoutConstraint!
    
    
    
    // Design for popUp view1
    
    @IBOutlet weak var viewForInstruction: UIView!
    @IBOutlet weak var subViewForInstruction: UIView!
    
    
    @IBOutlet weak var viewForDeliveryInstruction: UIView!
    @IBOutlet weak var viewForHaulingInstruction: UIView!
    
    
    @IBOutlet weak var viewSand: UIView!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var viewLocation: UIView!
    
    @IBOutlet weak var viewSandHauling: UIView!
    @IBOutlet weak var viewCameraHauling: UIView!
    @IBOutlet weak var viewLocationHauling: UIView!
    
    @IBOutlet weak var imgSand: UIImageView!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var imgCameraHaul: UIImageView!
    @IBOutlet weak var imgLocation: UIImageView!
    
    @IBOutlet weak var labelUserLocationPlaceholder: UILabel!

    // Design for popUp view2
    
    @IBOutlet weak var lblMaterialPickupTitle: UILabel!
    
    @IBOutlet weak var viewPopUp: UIView!
    
    @IBOutlet weak var viewSubViewPopUp: UIView!
    
    @IBOutlet weak var lblLoadOfLoad: UILabel!
    
    @IBOutlet weak var lblTotalDistanceWithDesc: UILabel!

   
    
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
    
    var seconds = 60
    var timer = Timer()
    var isRepeatTimer: Bool = true
    var jobStatus: Int = 0
    var dateAccepted = 0

    var isLaterJob: Bool = false
    
    var loginUserData:LoggedInUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(arrConfirmation)
        print(dictConfirmation)
        print(dictBillDetails)
        if isLaterJob {
//            lblTimer.text = ""
//            greenLblbView.backgroundColor = .white
        } else {
            self.manageTimerScreen()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if Constant.MyVariables.appDelegate.acceptJobModel != nil {
            let model = Constant.MyVariables.appDelegate.acceptJobModel!
            
            self.isFromNotification = model.isFromNotification
            self.arrConfirmation = model.arrConfirmation
            self.dictConfirmation = model.dictConfirmation
            self.dictBillDetails = model.dictBillDetails
            self.contact_name = model.contact_name
            self.contact_no = model.contact_no
            self.instruction = model.instruction
            self.selectedServiceType = model.selectedServiceType
            self.screenComeFrom = model.screenComeFrom
            self.globalCurrentLoad = model.globalCurrentLoad
            self.globalTotalLoads = model.globalTotalLoads
            self.jobTypeStr = model.jobTypeStr
            self.isRepeatTimer = model.isRepeatTimer
            self.jobStatus = model.jobStatus
            self.dateAccepted = model.dateAccepted
            self.isLaterJob = model.isLaterJob
            
            if model.jobStatus == 1 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.viewForInstruction.isHidden = false
                    self.subViewForInstruction.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.timer.invalidate()
                    self.isRepeatTimer = false
                });
            } else if jobStatus == 2 {
                self.viewForInstruction.isHidden = true
                UIView.animate(withDuration: 0.25, animations: {
                    self.viewPopUp.isHidden = false
                    self.viewSubViewPopUp.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                });
            }
            
        } else {
            Constant.MyVariables.appDelegate.acceptJobModel = DriverAceeptJobModel.init()
        }
        
        ////////
        if isLaterJob {
            buttonDecline.isHidden = true
            buttonAccept.setTitle("START", for: .normal)
        } else {
            buttonDecline.isHidden = false
            buttonAccept.setTitle("ACCEPT", for: .normal)
        }
        self.lblShowLocationOtlt.layer.cornerRadius = 25
        self.lblShowLocationOtlt.layer.masksToBounds = true
        self.lblShowLocationOtlt.layer.borderWidth = 5
        self.lblShowLocationOtlt.layer.borderColor = UIColor.init(red: 156.0/255.0, green: 190.0/255.0, blue: 56.0/255.0, alpha: 1.0).cgColor
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionLocationShow))
        self.lblShowLocationOtlt.addGestureRecognizer(tap)
        tap.delegate = self as UIGestureRecognizerDelegate // Remember to extend your class with UIGestureRecognizerDelegate
        
        
        self.viewSubViewPopUp.layer.cornerRadius = 10
        self.viewSubViewPopUp.layer.masksToBounds = true
        
        self.subViewForInstruction.layer.cornerRadius = 10
        self.subViewForInstruction.layer.masksToBounds = true
        
        
        self.viewSand.layer.cornerRadius = 25
        self.viewCamera.layer.cornerRadius = 25
        self.viewLocation.layer.cornerRadius = 25
        
        self.viewSand.layer.masksToBounds = true
        self.viewCamera.layer.masksToBounds = true
        self.viewLocation.layer.masksToBounds = true
        
        self.viewSandHauling.layer.cornerRadius = 25
        self.viewCameraHauling.layer.cornerRadius = 25
        self.viewLocationHauling.layer.cornerRadius = 25
        
        self.viewSandHauling.layer.masksToBounds = true
        self.viewCameraHauling.layer.masksToBounds = true
        self.viewLocationHauling.layer.masksToBounds = true
        
        
        if let myImage = UIImage(named: "camera") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            self.imgCamera.image = tintableImage
            self.imgCameraHaul.image = tintableImage
            
        }
        self.imgCamera.tintColor = UIColor.black
        self.imgCameraHaul.tintColor = UIColor.black
        
        
        self.tblView.register(UINib(nibName: "ConfirmationHeaderCell", bundle: nil), forCellReuseIdentifier: "ConfirmationHeaderCell")
        self.tblView.register(UINib(nibName: "JobLaterCell", bundle: nil), forCellReuseIdentifier: "JobLaterCell")
        self.tblView.register(UINib(nibName: "ConfirmationRowCell", bundle: nil), forCellReuseIdentifier: "ConfirmationRowCell")
        self.tblView.register(UINib(nibName: "JobLaterCellMain", bundle: nil), forCellReuseIdentifier: "JobLaterCellMain")
        
        
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {
            return
        }
        
        
        if isLaterJob {
            lblTimer.text = ""
            greenLblbView.backgroundColor = .white
        } else {
            //self.manageTimerScreen()
        }
        
        self.CalculateHeightOfScreen()
        
        //////////
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.ShowDataOnSreen()
        NotificationCenter.default.addObserver(self, selector: #selector(self.appIsGoingInBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appIsGoingInBackground()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func appIsGoingInBackground() {
        print("disappearing..")
        
        if Constant.MyVariables.appDelegate.acceptJobModel == nil {
            return
        }
        
        let model = Constant.MyVariables.appDelegate.acceptJobModel!
        
        model.isFromNotification = self.isFromNotification
        model.arrConfirmation = self.arrConfirmation
        model.dictConfirmation = self.dictConfirmation
        model.dictBillDetails = self.dictBillDetails
        model.contact_name = self.contact_name
        model.contact_no = self.contact_no
        model.instruction = self.instruction
        model.selectedServiceType = self.selectedServiceType
        model.screenComeFrom = self.screenComeFrom
        model.globalCurrentLoad = self.globalCurrentLoad
        model.globalTotalLoads = self.globalTotalLoads
        model.jobTypeStr = self.jobTypeStr
        model.isRepeatTimer = self.isRepeatTimer
        model.jobStatus = self.jobStatus
        model.dateAccepted = self.dateAccepted
        model.isLaterJob = self.isLaterJob
        
        Constant.MyVariables.appDelegate.saveAcceptJobData()
        
        USER_DEFAULT.set(AppState.DriverAcceptJob.rawValue, forKey: APP_STATE_KEY)
    }
    
    
    @IBAction func actionBack(_ sender: Any)
    {
//        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func actionAcceptOrder(_ sender: Any)
    {
        self.acceptOrDeclineRequest(strStatusSendInApi:"true")
        Constant.MyVariables.appDelegate.clearNotifications()
    }
    
    @IBAction func actionDeclineJob(_ sender: Any)
    {
        
            let alertMessage = UIAlertController(title:"Alert", message: "Are you sure you want to decline this job? ", preferredStyle: UIAlertControllerStyle.alert)
            alertMessage.addAction(UIAlertAction(title:"No", style: UIAlertActionStyle.default, handler: nil))
            
            let buttonYes = UIAlertAction(title: "Yes" , style: .default) { (_ action) in
                self.acceptOrDeclineRequest(strStatusSendInApi:"false")
                Constant.MyVariables.appDelegate.clearNotifications()
            }
            buttonYes.setValue(UIColor.red, forKey: "titleTextColor")
            alertMessage.addAction(buttonYes)
            
            let delegate=UIApplication.shared.delegate as! AppDelegate
            self.present(alertMessage, animated: true, completion: nil)
       
        
    }
    

    //# Mark:- Button actions Inside Pop Up
    
    
    
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
    
    @IBAction func actionNextInstructionPopUp(_ sender: Any) {
        
        self.jobStatus = 2
        
        self.viewForInstruction.isHidden = true
        
        if(self.dictBillDetails.value(forKey: "contact_name") as? String ?? "" == "") {
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.viewPopUp.isHidden = false
                
                self.viewSubViewPopUp.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
            });
            
        } else {
            
            let model = Constant.MyVariables.appDelegate.acceptJobModel!
            model.isFromNotification = self.isFromNotification
            model.arrConfirmation = self.arrConfirmation
            model.dictConfirmation = self.dictConfirmation
            model.dictBillDetails = self.dictBillDetails
            model.contact_name = self.contact_name
            model.contact_no = self.contact_no
            model.instruction = self.instruction
            model.selectedServiceType = self.selectedServiceType
            model.screenComeFrom = self.screenComeFrom
            model.globalCurrentLoad = self.globalCurrentLoad
            model.globalTotalLoads = self.globalTotalLoads
            model.jobTypeStr = self.jobTypeStr
            model.isRepeatTimer = self.isRepeatTimer
            model.jobStatus = self.jobStatus
            model.dateAccepted = self.dateAccepted
            Constant.MyVariables.appDelegate.saveAcceptJobData()
            
            let specialInstructions = SpecialInstructionsVC.init(nibName: "SpecialInstructionsVC", bundle: nil)
            
            let driver_Id =  String(self.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
            
            let tracking_Id =  String(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)
            
            let driver_Type = self.dictBillDetails.value(forKey: "driver_type") as? String ?? ""
                        
            specialInstructions.driver_Id = driver_Id
            
            specialInstructions.tracking_Id = tracking_Id
            
            specialInstructions.driver_Type = driver_Type
            
            specialInstructions.consumer_Name = self.dictBillDetails.value(forKey: "contact_name") as? String ?? ""
            
            specialInstructions.consumer_contact_no = self.dictBillDetails.value(forKey: "contact_no") as? String ?? ""
            
            specialInstructions.consumer_instruction = self.dictBillDetails.value(forKey: "instruction") as? String ?? ""
            specialInstructions.globalCurrentLoad = self.globalCurrentLoad
            specialInstructions.globalTotalLoads = self.globalTotalLoads
            specialInstructions.jobTypeStr = self.jobTypeStr
            specialInstructions.dictBillDetails = self.dictBillDetails.mutableCopy() as! NSMutableDictionary
            specialInstructions.dateAccepted = self.dateAccepted
            specialInstructions.arrConfirmation = self.arrConfirmation
            specialInstructions.dictConfirmation = self.dictConfirmation
            
            self.navigationController?.pushViewController(specialInstructions, animated: true)
            
        }
        
    }
    
    @IBAction func actionNextFromPopUpScreen(_ sender: Any)
    {
       
        self.viewForInstruction.isHidden = false
        self.viewForInstruction.isHidden = true

	    let model = Constant.MyVariables.appDelegate.acceptJobModel!
        
        model.isFromNotification = self.isFromNotification
        model.arrConfirmation = self.arrConfirmation
        model.dictConfirmation = self.dictConfirmation
        model.dictBillDetails = self.dictBillDetails
        model.contact_name = self.contact_name
        model.contact_no = self.contact_no
        model.instruction = self.instruction
        model.selectedServiceType = self.selectedServiceType
        model.screenComeFrom = self.screenComeFrom
        model.globalCurrentLoad = self.globalCurrentLoad
        model.globalTotalLoads = self.globalTotalLoads
        model.jobTypeStr = self.jobTypeStr
        model.isRepeatTimer = self.isRepeatTimer
        model.jobStatus = self.jobStatus
        model.dateAccepted = self.dateAccepted
        Constant.MyVariables.appDelegate.saveAcceptJobData()


            if(self.dictBillDetails.value(forKey: "contact_name") as? String ?? "" == "") {
                
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
                    completeDelivery.arrConfirmation = self.arrConfirmation

                    self.navigationController?.pushViewController(completeDelivery, animated: true)
                } else {
                    let vcComplete = LoadReceivedVC.init(nibName: "LoadReceivedVC", bundle: nil)
                    vcComplete.globalTotalLoads = self.globalTotalLoads
                    vcComplete.globalCurrentLoad = self.globalCurrentLoad
                    vcComplete.dictBillDetails = self.dictBillDetails.mutableCopy() as! NSMutableDictionary
                    vcComplete.jobTypeStr = self.jobTypeStr
                    //vcComplete.delegateCurrentLoad = self
                    vcComplete.dateAccepted = self.dateAccepted
                    vcComplete.arrConfirmation = self.arrConfirmation
                    self.navigationController?.pushViewController(vcComplete, animated: true)
                    
                //    if self.jobTypeStr == "HAULING" {
                //        self.apiCallForCompleteJob()
                //    }
                }
            } else {
                
//                let vcComplete = LoadReceivedVC.init(nibName: "LoadReceivedVC", bundle: nil)
//                vcComplete.delegateCurrentLoad = self
                
                let specialInstructions = SpecialInstructionsVC.init(nibName: "SpecialInstructionsVC", bundle: nil)
                
                
                let driver_Id =  String(self.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
                let tracking_Id =  String(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)
                let driver_Type = self.dictBillDetails.value(forKey: "driver_type") as? String ?? ""
                
                
                specialInstructions.driver_Id = driver_Id
                specialInstructions.tracking_Id = tracking_Id
                specialInstructions.driver_Type = driver_Type
                specialInstructions.consumer_Name = self.dictBillDetails.value(forKey: "contact_name") as? String ?? ""
                specialInstructions.consumer_contact_no = self.dictBillDetails.value(forKey: "contact_no") as? String ?? ""
                specialInstructions.consumer_instruction = self.dictBillDetails.value(forKey: "instruction") as? String ?? ""
                specialInstructions.globalCurrentLoad = self.globalCurrentLoad
                specialInstructions.globalTotalLoads = self.globalTotalLoads
                specialInstructions.jobTypeStr = self.jobTypeStr
   
                specialInstructions.dictBillDetails = self.dictBillDetails.mutableCopy() as! NSMutableDictionary
                specialInstructions.dateAccepted = self.dateAccepted
                self.navigationController?.pushViewController(specialInstructions, animated: true)
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
    
    func acceptOrDeclineRequest(strStatusSendInApi: String)
    {
        print("Accept Request")
        let dropLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_latitude") as! String) ?? 0.0
        let dropLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_longitude") as! String) ?? 0.0
        let pickLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_latitude") as! String) ?? 0.0
        let pickLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_longitude") as! String) ?? 0.0
        let coordinate₀ = CLLocation(latitude: dropLat, longitude: dropLong)
        let coordinate₁ = CLLocation(latitude: pickLat, longitude: pickLong)
        let distanceInMilesInDouble = Double(((coordinate₀.distance(from: coordinate₁)/1000)*0.621371)) // result is in miles
        let doubleStr = String(format: "%.2f", distanceInMilesInDouble)
        let params = [
            "user_id":self.dictBillDetails.value(forKey: "user_id") as! String,
            "driver_id":self.dictBillDetails.value(forKey: "driver_id") as! String,//self.loginUserData.user_id!,
            "acceptance":strStatusSendInApi,
            "tracking_id":String(self.dictBillDetails.value(forKey: "id") as! Int),
            "access_token":self.loginUserData.access_token!,
            "refresh_token":self.loginUserData.refresh_token!,
            "mileage": doubleStr
            ] as? [String : Any]
        self.startAnimating("")
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_ACCEPT_JOB, .post, params) { (result, data, json, error, msg) in
            
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
                    if(strStatusSendInApi == "true") {
                        self.dateAccepted = Date().millisecondsSince1970
                        UIView.animate(withDuration: 0.25, animations: {
                            self.viewForInstruction.isHidden = false
                            self.subViewForInstruction.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            self.timer.invalidate()
                            self.isRepeatTimer = false
                            self.jobStatus = 1
                        });
                    }
                    else {
                        Constant.MyVariables.appDelegate.acceptJobModel = nil
                        Constant.MyVariables.appDelegate.saveAcceptJobData()
                        USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
                break
            }
        }
    }
    
    func CalculateHeightOfScreen()
    {
        var viewHeightForTotal: Int = 10
        
//            viewHeightForTotal = 90


        let totalNeedToIncreaseHeight = (self.arrConfirmation.count * 80)
        self.tblViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
//        self.ConstraintviewHeightTotalCalculation.constant = CGFloat(viewHeightForTotal)
        self.superViewOfTableViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight+viewHeightForTotal)
        self.secondViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight+viewHeightForTotal)
        self.mainViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight+viewHeightForTotal)
        self.tblView.reloadData()
        self.ShowDataOnSreen()
    }
    
    func ShowDataOnSreen()
    {
        guard let dictt = self.dictConfirmation.value(forKey: "bill_details") as? NSDictionary else {return}
        self.dictBillDetails = dictt.mutableCopy() as! NSMutableDictionary
        print(Int(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "0")!)
        self.globalTotalLoads = Int(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "0")!
        
        let strLoads = "\("LOAD ")\(self.globalCurrentLoad)\(" of ")\(self.globalTotalLoads)"
        
        self.lblLoadOfLoad.text = strLoads
        
//        let dropLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_latitude") as! String) ?? 0.0
//        let dropLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_longitude") as! String) ?? 0.0
//        let pickLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_latitude") as! String) ?? 0.0
//        let pickLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_longitude") as! String) ?? 0.0
        
//        let pickup_address = self.dictBillDetails.value(forKey: "pickup_address") as? String ?? ""
        
        let address = self.dictBillDetails.value(forKey: "pickup_address") as? String ?? ""
        let city = self.dictBillDetails.value(forKey: "pickup_city") as? String ?? ""
        let state = self.dictBillDetails.value(forKey: "pickup_state") as? String ?? ""
        let zipcode = self.dictBillDetails.value(forKey: "pickup_zipcode") as? String ?? ""
        let pickup_address = address + ", " + city + ", " + state + ", " + zipcode
        
        let drop_address = self.dictBillDetails.value(forKey: "drop_address") as? String ?? ""
        
//        let coordinate₀ = CLLocation(latitude: dropLat, longitude: dropLong)
//        let coordinate₁ = CLLocation(latitude: pickLat, longitude: pickLong)
        
//        let distanceInMilesInDouble = Double(((coordinate₀.distance(from: coordinate₁)/1000)*0.621371)) // result is in miles
////        let distanceInMilesRound = Double(round(1000*distanceInMilesInDouble)/100)
//        let doubleStr = String(format: "%.2f", distanceInMilesInDouble)
//
//        let distanceInMilesRound = Double(doubleStr)
        
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
        } else {
            strAttributedTimeSecond = self.attributeDtailsBoldThird(strFirstNormal: "The material pickup address is:\n", strSecondBold: "", strthirdNormal: "")
        }
        self.lblMaterialPickupTitle.attributedText = strAttributedTimeSecond
        
        if(jobType == "DELIVERY")
        {
            let strAttributedLocationDelivery = self.attributeDtailsBold(strBold: "\(dealer_Name)\n", strNormal: pickup_address)
            self.btnPickLocationOtlt.setAttributedTitle(strAttributedLocationDelivery, for: .normal)
            self.btnJobSiteLocationOtlt.setTitle(drop_address, for: .normal)
            self.labelUserLocationPlaceholder.text = "PICKUP LOCATION"
            self.lblTitleForJobTypeLocaton.text = "\(jobType)\(" LOCATION")"

        }
        else
        {
            let strAttributedLocationHauling = self.attributeDtailsBold(strBold: "\(dealer_Name)\n", strNormal: pickup_address)
            self.btnPickLocationOtlt.setTitle(drop_address, for: .normal)
        self.btnJobSiteLocationOtlt.setAttributedTitle(strAttributedLocationHauling, for: .normal)
            self.labelUserLocationPlaceholder.text = "HAULING LOCATION"
            self.lblTitleForJobTypeLocaton.text = "DROP-OFF LOCATION"

        }
        
        self.btnPickLocationOtlt.titleLabel!.numberOfLines = 3
        self.btnPickLocationOtlt.titleLabel!.lineBreakMode = .byWordWrapping
        self.btnPickLocationOtlt.titleLabel!.adjustsFontSizeToFitWidth = true
        self.btnJobSiteLocationOtlt.titleLabel!.numberOfLines = 3
        self.btnJobSiteLocationOtlt.titleLabel!.lineBreakMode = .byWordWrapping
        self.btnJobSiteLocationOtlt.titleLabel!.adjustsFontSizeToFitWidth = true
        self.btnchangeTimeOfRequestShowOtlt.setAttributedTitle(strAttributedTime, for: .normal)
        self.lblTotalLoads.text = self.dictBillDetails.value(forKey: "total_loads") as? String ?? ""
        self.lblTotalTons.text = self.dictBillDetails.value(forKey: "total_tons") as? String ?? ""
        
        let total_loadsInt = Double(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "") ?? 0
//        let totalMiles = round(Double(distanceInMilesRound!) * total_loadsInt)
//        let distanceInMiles = String(format: "%.1f", totalMiles)
        self.lblTotalMiles.text = "\(self.dictBillDetails.value(forKey: "mileage") as? String ?? "0")"
        //self.lblTotalMiles.text = distanceInMiles
        let disMiles = Double("\(self.dictBillDetails.value(forKey: "mileage") as? String ?? "0")")! / total_loadsInt
        let totalMiles = round(disMiles)

//        let str = "\(distanceInMiles)\(" MILES")"
        let str = "\(totalMiles)\(" MILES")"

        let bill_Detail = self.dictConfirmation.value(forKey: "bill_details") as! NSDictionary
        let str_job_type = bill_Detail.value(forKey: "job_type") as? String ?? ""
        self.jobTypeStr = str_job_type.uppercased()
        
        // for popUp Location btn
        var strLocation = self.dictBillDetails.value(forKey: "drop_address") as? String ?? ""
        
        if(self.jobTypeStr == "HAULING")
        {
            self.viewForDeliveryInstruction.isHidden = true
            self.viewForHaulingInstruction.isHidden = false
            
            let address = self.dictBillDetails.value(forKey: "pickup_address") as? String ?? ""
            let city = self.dictBillDetails.value(forKey: "pickup_city") as? String ?? ""
            let state = self.dictBillDetails.value(forKey: "pickup_state") as? String ?? ""
            let zipcode = self.dictBillDetails.value(forKey: "pickup_zipcode") as? String ?? ""
            strLocation = address + ", " + city + ", " + state + ", " + zipcode
            
            //strLocation = self.dictBillDetails.value(forKey: "drop_address") as? String ?? ""
        }
        else
        {
            self.viewForDeliveryInstruction.isHidden = false
            self.viewForHaulingInstruction.isHidden = true
            strLocation = pickup_address
        }
        
        //Added By KRISHNA
        let attrs = NSAttributedString(string: strLocation, attributes: [NSAttributedStringKey.foregroundColor: UIColor(red:20.0/255.0, green:104.0/255.0, blue:215.0/255.0, alpha:1.0), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17.0), NSAttributedStringKey.underlineColor: UIColor(red:20.0/255.0, green:104.0/255.0, blue:215.0/255.0, alpha:1.0), NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        
        //        btn.setAttributedTitle(attrs, for: .normal)
       
        let strOrderID = "\(TYW_ID_SUFFIX)\( self.dictBillDetails.value(forKey: "bill_no") as? String ?? "")"
      
        self.lblShowLocationOtlt.attributedText = attrs
        let strPurchseOrderId = "Purchase Order: \(strOrderID)\n"
        let currentDescription = self.getCurrentLoadDetails(arr:self.arrConfirmation)
        //let strNeedObtains = "You need to obatain 16 Tons of Gravel #82.\n"
        let strTotalDistanceDesc = "Total distance from pickup location to \(self.jobTypeStr.capitalizingFirstLetter()) location: "
        
        let strConcinateing = strPurchseOrderId+currentDescription+strTotalDistanceDesc
        self.lblTotalDistanceWithDesc.attributedText = self.attributeDtailsBold(strNormal: strConcinateing, strBold: str)
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
    
    //#MARK:- get Value On PopTo CurrentViewController
    
    func didRecieveDataUpdate(currentLoad:Int)
    {
        self.globalCurrentLoad = currentLoad
        self.globalTotalLoads = Int(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "0")!
        
        let strLoads = "\("LOAD ")\(self.globalCurrentLoad)\(" of ")\(self.globalTotalLoads)"
        self.lblLoadOfLoad.text = strLoads
    }
    
    //#MARK:- implement timer functionality
    
    func manageTimerScreen() {
        print("Accept Request--------")
        if self.arrConfirmation.count > 0 {
            let timestamp = (self.arrConfirmation[0] as! NSDictionary)["creation_time"] as? String
            let dateStarted = Int("\(timestamp ?? "0")")!
            let dateNow = Date().millisecondsSince1970
            let timeDifference = dateNow - dateStarted
            seconds = seconds - timeDifference
            print(timeDifference)
            self.runTimer()
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if(self.isRepeatTimer)
        {
            if seconds < 1 {
                self.timer.invalidate()
                self.isRepeatTimer = false
//                self.view.makeToastActivity(.center) 
                self.view.makeToast("Time is Over For Job Response", duration: 1.0, position: .center)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
                    // Put your code which should be executed with a delay here
                    self.navigationController?.popToRootViewController(animated: true)
                })
            } else {
                seconds -= 1
                self.lblTimer.text = timeString(time: TimeInterval(seconds))
            }
        }
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
}

extension JobAcceptDriver : UITableViewDelegate, UITableViewDataSource
{
    //Mark:- TableView Delegate and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobLaterCell") as! JobLaterCell
            return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrConfirmation.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobLaterCellMain", for: indexPath) as! JobLaterCellMain
        
            let bill_Detail = self.dictConfirmation.value(forKey: "bill_details") as! NSDictionary
            let str_job_type = bill_Detail.value(forKey: "job_type") as? String ?? ""
        
            let dict = self.arrConfirmation.object(at: indexPath.row) as! NSDictionary
            let strCategory = dict.value(forKey: "category") as? String ?? ""
            let imgStr = dict.value(forKey: "material_image") as? String
        
            let tons = dict.value(forKey: "tons") as? String ?? "0"
            let totalTons = Int(tons) ?? 0
            let devideTime  = totalTons / 16
            var modules  = totalTons % 16
            if(modules > 0)
            {
                modules = modules + 1
            }
            let finalTotalLoads = (devideTime + modules)
        
        
        
            if (strCategory.uppercased() == "DIRT" || str_job_type.uppercased() == "HAULING")
            {
                if(finalTotalLoads > 1)
                {
                    cell.lblMaterialQuantity.text = "\(finalTotalLoads as Int) \(" Loads")"
                }
                else
                {
                    cell.lblMaterialQuantity.text = "\(finalTotalLoads as Int) \(" Load")"
                }
            }
            else
            {
//                if(Int(tons)! > 1)
//                {
//                 cell.lblMaterialQuantity.text = "\(tons)\(" tons")"
//                }
//                else
//                {
//                 cell.lblMaterialQuantity.text = "\(tons)\(" ton")"
//                }
                
                let tons = (totalTons)
                if((dict.value(forKey: "category") as? String ?? "").uppercased() == "DIRT") {
    //                let strTotalTons = dict.value(forKey: "total_tons") as? String ?? "0"
                    let totalTons = tons
                    let devideTime  = totalTons / 16
                    var modules  = totalTons % 16
                    if(modules > 0)
                    {
                        modules = modules + 1
                    }
                    let finalTotalLoads = (devideTime + modules)
                    if(finalTotalLoads <= 1)
                    {
                        cell.lblMaterialQuantity.text = "\(finalTotalLoads as Int) \(" Load")"
                    }
                    else
                    {
                        cell.lblMaterialQuantity.text = "\(finalTotalLoads as Int) \(" Loads")"
                    }
                } else {
                    if(tons <= 1)
                    {
                        cell.lblMaterialQuantity.text = "\(tons)\(" Ton")"
                    }
                    else
                    {
                        cell.lblMaterialQuantity.text = "\(tons)\(" Tons")"
                    }
                    
                    var loads = 1
                    
                    if tons > 16 {
                        if (tons % 16 == 0) {
                            loads = (tons / 16)
                        }
                        else {
                            loads = (tons / 16);
                            loads += 1
                        }
                    }
                    cell.lblMaterialQuantity.numberOfLines = 2
                    var strLoads = "(\(loads) Loads)"
                    if loads == 1 {
                        strLoads = "(\(loads) Load)"
                    }
                    
                    cell.lblMaterialQuantity.text = cell.lblMaterialQuantity.text! + "\n" + strLoads
                }

            }
        
            let imgURL = imgStr  == nil ? "" : imgStr
            cell.imgView.loadImageAsync(with: BSE_URL_LoadMedia+imgURL!, defaultImage: "", size: cell.imgView.frame.size)
            
            cell.lblMaterialCategory.attributedText = self.attributeDtailsBold(strBold: "\(str_job_type.uppercased())\("\n")\(strCategory) ", strNormal: dict.value(forKey: "name") as? String ?? "")
//            cell.lblMaterialQuantity.text = "\(tons as! String)\(" tons")"
            return cell
        
    }
    
}
