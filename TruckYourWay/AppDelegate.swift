//
//  AppDelegate.swift
//  TruckYourWay
//
//  Created by Samradh Agarwal on 04/09/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown
import UserNotifications
import Firebase
import FirebaseMessaging
import GooglePlaces
import GoogleMaps


enum AppState: Int {
    case TruckScheduleTime = 1
    case TruckJobRequest = 2
    case TruckChooseDelivryServiceType  = 31
    case TruckChooseHaulingServiceType  = 32
    case TruckChooseServicesServiceType = 33
    
    case TruckServiceRequest = 41

    case TruckChooseDeliveryServiceMaterials = 51
    case TruckChooseHaulingServiceMaterials = 52

    case TruckSpecialInstruction = 60

    case TruckOrderConfirmation = 70

    case TruckTermsAndConditions = 80
    case TruckPayment = 90
    case TruckChooseDriver = 100
    
    //For Driver
    case DriverAcceptJob = 111
    case DriverLoadRecieve = 112
    case DriverInstructions = 113
    case DriverCompleteJob = 114

}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    var loginUserData:LoggedInUser!
    
    var truckCartModel: TruckCartModel?
    var acceptJobModel: DriverAceeptJobModel?
    
    var deviceToken:String = ""
    //    let reachabilityManager = NetworkReachabilityManager()
    let gcmMessageIDKey = "gcm.message_id"
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.registerForNotification(application)
        GMSPlacesClient.provideAPIKey(Google_Map_Key)
        GMSServices.provideAPIKey(Google_Map_Key)
        self.getInfo()
        self.getCurrentLocationFromGoogle()
        
        sleep(3)
        
        
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.init(red: 206/255, green: 114/255, blue: 54/255, alpha: 1)
           let view = (self.window?.rootViewController?.view)!
            view.addSubview(statusbarView)
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
           statusbarView.heightAnchor
               .constraint(equalToConstant: statusBarHeight).isActive = true
           statusbarView.widthAnchor
               .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
           statusbarView.topAnchor
               .constraint(equalTo: view.topAnchor).isActive = true
           statusbarView.centerXAnchor
               .constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.init(red: 206/255, green: 114/255, blue: 54/255, alpha: 1)
        }
        
        
//        if let statusbar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
//            statusbar.backgroundColor = UIColor.init(red: 206/255, green: 114/255, blue: 54/255, alpha: 1)
//        }
        DropDown.startListeningToKeyboard()
        IQKeyboardManager.shared.enable = true
        
        
        if let _ = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            self.isLogin(isLogin:true)
        }
        else
        {
            self.isLogin(isLogin:false)
        }
        
        // Override point for customization after application launch.
        return true
    }
    
    func getCurrentLocationFromGoogle()
    {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
       // locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = false
        } else {
            // Fallback on earlier versions
        }
        locationManager.distanceFilter = 5
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
    func getInfo()
    {
        let str =  USER_DEFAULT.value(forKey: "DeviceToken") as? String ?? ""
        self.deviceToken = str
        
        
        FirebaseApp.configure()
    }
    
    func isLogin(isLogin:Bool)
    {
        if(isLogin)
        {
            
            self.GetSuspensionAPI(){ (isSuspended) in

                if(!isSuspended)
                {
                     let vc = TabBar.init(nibName: "TabBar", bundle: nil)
                     vc.selectedIndex = 1
                    
                     self.navigationController = UINavigationController.init(rootViewController: vc)
                     
                     let nvc = NowVC.init(nibName: "NowVC", bundle: nil)
                    nvc.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
                    nvc.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "truck_cart_Tab"), tag: 1)
                    nvc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
                    nvc.navigationController?.navigationBar.isHidden = true
                    self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
                    self.navigationController?.navigationBar.isHidden = true
                    
                    (vc.selectedViewController as! UINavigationController).navigationBar.isHidden = true

                    if (self.loginUserData.type ?? "" == "service"){
                        
                        self.GetCurrentJobForProviderAPI { (status, json) in
                            
                            print("got response - > \(json)")
                            if status {
                                self.handleCurrentJobForProviderWith(json: json)
                            } else {
                                self.window?.rootViewController = self.navigationController
                            }
                        }
                        return
                    }
                    
                    if USER_DEFAULT.value(forKey: APP_STATE_KEY) != nil {
                        print("going to open schedule time->\(USER_DEFAULT.value(forKey: APP_STATE_KEY)!)")
                        
                        let appState: Int = USER_DEFAULT.value(forKey: APP_STATE_KEY)! as! Int


                        let stVC = SechudleTimeVC.init(nibName: "SechudleTimeVC", bundle: nil)
                        let jrVC = JobRequestVC.init(nibName: "JobRequestVC", bundle: nil)
                        
                        let servicesVC = ServicesVC.init(nibName: "ServicesVC", bundle: nil)
                        let haulingTypesVC = HaulingMaterialVC.init(nibName: "HaulingMaterialVC", bundle: nil)
                        let deliveryServicesVC = ChooseMaterialsVC.init(nibName: "ChooseMaterialsVC", bundle: nil)
                        
                        let serviceRequestVC = ServiceRequestVC.init(nibName: "ServiceRequestVC", bundle: nil)
                        
                        
                        let deliveryMaterialsVC = ChooseDeliveryMaterialVC.init(nibName: "ChooseDeliveryMaterialVC", bundle: nil)
                        
                        let haulingMaterialsVC = ChooseHaulingMaterialVC.init(nibName: "ChooseHaulingMaterialVC", bundle: nil)
                        
                        let instructionVC = SpecialDeliveryInstructionsVC.init(nibName: "SpecialDeliveryInstructionsVC", bundle: nil)
                        
                        let confirmationVC = OrderConfirmationVC.init(nibName: "OrderConfirmationVC", bundle: nil)
                        
                        let termsVC = TermsAndConditionsVC.init(nibName: "TermsAndConditionsVC", bundle: nil)
                        
                        let pymentVC = PaymentVC.init(nibName: "PaymentVC", bundle: nil)
                        
                        let cDriverVC = ChooseDriverVC.init(nibName: "ChooseDriverVC", bundle: nil)
                        
                        
                        self.truckCartModel = self.getTruckCartData()
                        self.acceptJobModel = self.getAcceptJobData()
                        
                        
                        let acceptingJob = AcceptingJobVC.init(nibName: "AcceptingJobVC", bundle: nil)
                        acceptingJob.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
                        acceptingJob.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "now_Tab"), tag: 1)
                        acceptingJob.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
                        acceptingJob.navigationController?.navigationBar.isHidden = true
                        
                        let jobaccept = JobAcceptDriver.init(nibName: "JobAcceptDriver", bundle: nil)
                        let loadRecieved = LoadReceivedVC.init(nibName: "LoadReceivedVC", bundle: nil)
                        let loadInstruction = SpecialInstructionsVC.init(nibName: "SpecialInstructionsVC", bundle: nil)
                        let completeJob = CompleteDeliveryJobVc.init(nibName: "CompleteDeliveryJobVc", bundle: nil)
                        
                        
                        switch appState {
                        case 1:
                            (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC]
                        case 2:
                            (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC]
                        case 31:
                            (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, deliveryServicesVC]
                        case 32:
                            (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, haulingTypesVC]
                        case 33:
                            (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, servicesVC]
                        case 41:
                            (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, servicesVC, serviceRequestVC]
                        case 51:
                            (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, deliveryServicesVC, deliveryMaterialsVC]
                        case 52:
                            (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, haulingTypesVC, haulingMaterialsVC]
                            
                        case 60:
                            if self.truckCartModel?.selectedServiceType == "DELIVERY" {
                                (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, deliveryServicesVC, deliveryMaterialsVC, instructionVC]
                                
                            } else if self.truckCartModel?.selectedServiceType == "HAULING" {
                                (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, haulingTypesVC, haulingMaterialsVC, instructionVC]
                            }
                            
                        case 70:
                            if self.truckCartModel?.selectedServiceType == "DELIVERY" {
                                (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, deliveryServicesVC, deliveryMaterialsVC, instructionVC, confirmationVC]
                                
                            } else if self.truckCartModel?.selectedServiceType == "HAULING" {
                                (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, haulingTypesVC, haulingMaterialsVC, instructionVC, confirmationVC]
                            }
                            
                        case 80:
                            if self.truckCartModel?.selectedServiceType == "DELIVERY" {
                                (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, deliveryServicesVC, deliveryMaterialsVC, instructionVC, confirmationVC, termsVC]
                                
                            } else if self.truckCartModel?.selectedServiceType == "HAULING" {
                                (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, haulingTypesVC, haulingMaterialsVC, instructionVC, confirmationVC, termsVC]
                            }
                            
                        case 90:
                            if self.truckCartModel?.selectedServiceType == "DELIVERY" {
                                (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, deliveryServicesVC, deliveryMaterialsVC, instructionVC, confirmationVC, termsVC, pymentVC]
                                
                            } else if self.truckCartModel?.selectedServiceType == "HAULING" {
                                (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, haulingTypesVC, haulingMaterialsVC, instructionVC, confirmationVC, termsVC, pymentVC]
                            }
                            
                        case 100:
                            if self.truckCartModel?.selectedServiceType == "DELIVERY" {
                                (vc.selectedViewController as! UINavigationController).viewControllers = [nvc, stVC, jrVC, deliveryServicesVC, deliveryMaterialsVC, instructionVC, confirmationVC, termsVC, pymentVC, cDriverVC]
                            }
                            
                            //For Driver side
                            
                        case 111:
                            vc.tabBar.isHidden = true
                            (vc.selectedViewController as! UINavigationController).viewControllers = [acceptingJob, jobaccept]
                            
                        case 112:
                            vc.tabBar.isHidden = true
                            (vc.selectedViewController as! UINavigationController).viewControllers = [acceptingJob, jobaccept, loadRecieved]
                            
                        case 113:
                            vc.tabBar.isHidden = true
                            (vc.selectedViewController as! UINavigationController).viewControllers = [acceptingJob, jobaccept, loadRecieved, loadInstruction]
                            
                        case 114:
                            vc.tabBar.isHidden = true
                            (vc.selectedViewController as! UINavigationController).viewControllers = [acceptingJob, jobaccept, loadRecieved, loadInstruction, completeJob]
                            
                            
                        default:
                            print("def")
                        }
                        
                        self.window?.rootViewController = self.navigationController
                        USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)
                    } else {
                        self.window?.rootViewController = self.navigationController
                    }
                }
                else {
                    let vc = LoginVC.init(nibName: "LoginVC", bundle: nil)
                    vc.isSuspended = isSuspended
                    self.navigationController = UINavigationController.init(rootViewController: vc)
                    self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
                    self.navigationController?.navigationBar.isHidden = true
                    self.window?.rootViewController = self.navigationController
                    
                }
            }
        }
        else {
            let vc = LoginVC.init(nibName: "LoginVC", bundle: nil)
            self.navigationController = UINavigationController.init(rootViewController: vc)
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
            self.navigationController?.navigationBar.isHidden = true
            self.window?.rootViewController = self.navigationController
        }
        self.window?.makeKeyAndVisible()
    }
    
    
    func handleCurrentJobForProviderWith(json: NSDictionary) {
        let billDetail = json["bill_details"] as! NSDictionary
        let arrConfirmation = json["materials"] as! NSArray
        
//        print(self.loginUserData.type)
                            
        let vc = TabBar.init(nibName: "TabBar", bundle: nil)
        vc.selectedIndex = 1
        
        self.navigationController = UINavigationController.init(rootViewController: vc)
        
        let nvc = NowVC.init(nibName: "NowVC", bundle: nil)
        
        nvc.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        nvc.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "truck_cart_Tab"), tag: 1)
        nvc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        nvc.navigationController?.navigationBar.isHidden = true
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        
        
        
        
        (vc.selectedViewController as! UINavigationController).navigationBar.isHidden = true

        if (billDetail["deleted"] as! String) == "true" {
            self.window?.rootViewController = self.navigationController
        } else if (billDetail["completed"] as! String) == "false" {
            
            var model: DriverAceeptJobModel!
            if let m = Constant.MyVariables.appDelegate.acceptJobModel {
                model = m
            } else {
                model = DriverAceeptJobModel.init()
            }

            model.isFromNotification = false
            model.arrConfirmation = arrConfirmation.mutableCopy() as! NSMutableArray
            model.dictConfirmation = json.mutableCopy() as! NSMutableDictionary
            model.dictBillDetails = billDetail.mutableCopy() as! NSMutableDictionary
            model.contact_name = billDetail.value(forKey: "contact_name") as? String ?? ""
            model.contact_no = billDetail.value(forKey: "contact_no") as? String ?? ""
            model.instruction = billDetail.value(forKey: "instruction") as? String ?? ""
            model.screenComeFrom = ""
            model.globalCurrentLoad = Int(billDetail.value(forKey: "completed_loads") as? String ?? "0")! + 1
            model.globalTotalLoads = Int(billDetail.value(forKey: "total_loads") as? String ?? "0")!
            model.jobTypeStr = (billDetail.value(forKey: "job_type") as? String ?? "").uppercased()
            model.isRepeatTimer = false
            model.isLaterJob = (billDetail.value(forKey: "type") as? String ?? "").uppercased() == "NOW" ? false : true
            model.jobStatus = 2
            //model.selectedServiceType = (arrConfirmation[model.globalCurrentLoad - 1] as! NSDictionary).value(forKey: "category") as? String ?? ""

//            model.loadAmount = Int(billDetail.value(forKey: "total_loads") as? String ?? "0")!
            if model.jobTypeStr == "HAULING" {
                model.loadUnit = "Loads"
            } else if model.selectedServiceType.uppercased() == "DIRT" {
                model.loadUnit = "Loads"
            } else {
                model.loadUnit = "Tons"
            }
            
            model.loadImage = UIImage()
            model.invoiceNumber = ""
            model.str_Invoice_Image = ""
            model.dateAccepted = Int(billDetail.value(forKey: "driver_accept_time") as? String ?? "0")!

            ///For Material index
//            let totalTons = model.arrConfirmation.reduce(0) { (result, dic) -> Int in
//                let d: NSDictionary = dic as! NSDictionary
//                let tons = Int("\(d["tons"] as? String ?? "0")") ?? 0
//                print("tons------- \(tons)")
//                return result + tons
//            }
            
            let completedLoads = Int(billDetail.value(forKey: "completed_loads") as? String ?? "0")!
            var load = 0
            var index = 0
            for dic in model.arrConfirmation {
                let d = dic as! NSDictionary
                let tons = Int("\(d["tons"] as? String ?? "0")") ?? 0
                var numberOfLoads = 0
                if tons > 16 {
                    let remainder = tons % 16
                    if remainder > 0 {
                        numberOfLoads = (tons / 16) + 1
                    } else {
                        numberOfLoads = (tons / 16)
                    }
                } else {
                    numberOfLoads = 1
                }
                load = load + numberOfLoads

                if load > completedLoads {
                    print("current load is -> \(load) and material is -> \(d["name"] as! String)")
                    if numberOfLoads == 1 {
                        model.currentMaterialIndex = index
                        model.materialLoaded = 0
                    } else {
                        let loadNo = load - completedLoads
                        if numberOfLoads == loadNo {
                            model.currentMaterialIndex = index
                            model.materialLoaded = 0
                        } else {
                            let compLoads = numberOfLoads - loadNo
                            model.materialLoaded = compLoads * 16
                        }
                    }
                    
                    break
                }
                index += 1
            }
            
            
            ///For Material index^^^^^^^^

//            model.currentMaterialIndex = Int(billDetail.value(forKey: "completed_loads") as? String ?? "0")!
//            model.materialLoaded = 0
                        
            
            Constant.MyVariables.appDelegate.acceptJobModel = model
            
            let acceptingJob = AcceptingJobVC.init(nibName: "AcceptingJobVC", bundle: nil)
            acceptingJob.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
            acceptingJob.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "now_Tab"), tag: 1)
            acceptingJob.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            acceptingJob.navigationController?.navigationBar.isHidden = true

            let jobaccept = JobAcceptDriver.init(nibName: "JobAcceptDriver", bundle: nil)
            let loadRecieved = LoadReceivedVC.init(nibName: "LoadReceivedVC", bundle: nil)
            let loadInstruction = SpecialInstructionsVC.init(nibName: "SpecialInstructionsVC", bundle: nil)
            let completeJob = CompleteDeliveryJobVc.init(nibName: "CompleteDeliveryJobVc", bundle: nil)

            vc.tabBar.isHidden = true
            
            
            jobaccept.isFromNotification = false
            jobaccept.arrConfirmation = arrConfirmation.mutableCopy() as! NSMutableArray
            jobaccept.dictConfirmation = json as! NSMutableDictionary
            jobaccept.dictBillDetails = billDetail.mutableCopy() as! NSMutableDictionary
            jobaccept.contact_name = billDetail.value(forKey: "contact_name") as? String ?? ""
            jobaccept.contact_no = billDetail.value(forKey: "contact_no") as? String ?? ""
            jobaccept.instruction = billDetail.value(forKey: "instruction") as? String ?? ""
            
            
//            jobaccept.selectedServiceType = "" //model.selectedServiceType
//            jobaccept.screenComeFrom = model.screenComeFrom
            jobaccept.globalCurrentLoad = Int(billDetail.value(forKey: "completed_loads") as? String ?? "0")! + 1
            jobaccept.globalTotalLoads = Int(billDetail.value(forKey: "total_loads") as? String ?? "0")!
            jobaccept.jobTypeStr = (billDetail.value(forKey: "job_type") as? String ?? "").uppercased()
            jobaccept.isRepeatTimer = false //model.isRepeatTimer
            jobaccept.jobStatus = 2 //model.jobStatus
            jobaccept.dateAccepted = Int(billDetail.value(forKey: "driver_accept_time") as? String ?? "0")!   //model.dateAccepted
            jobaccept.isLaterJob = (billDetail.value(forKey: "type") as? String ?? "").uppercased() == "NOW" ? false : true
            
            jobaccept.dictConfirmation = json as! NSMutableDictionary
            jobaccept.dictBillDetails = billDetail.mutableCopy() as! NSMutableDictionary
            jobaccept.globalTotalLoads = Int(billDetail.value(forKey: "total_loads") as? String ?? "0")!
            
//            let strLoads = "\("LOAD ")\(jobaccept.globalCurrentLoad)\(" of ")\(jobaccept.globalTotalLoads)"
//            jobaccept.lblLoadOfLoad.text = strLoads
            let str_job_type = billDetail.value(forKey: "job_type") as? String ?? ""
            jobaccept.jobTypeStr = str_job_type.uppercased()
            
            let jobType = (billDetail.value(forKey: "job_type") as? String ?? "").uppercased()
            
            var isCompletionImageUploaded = 0
            if let isImageUploaded = billDetail.value(forKey: "is_completion_image_uploaded") as? String {
                isCompletionImageUploaded = Int(isImageUploaded) ?? 0
            } else {
                isCompletionImageUploaded = Int(billDetail.value(forKey: "is_started_last_load") as? String ?? "0") ?? 0
            }
            
            let isStartedLastLoad = Int(billDetail.value(forKey: "is_started_last_load") as? String ?? "0") ?? 0

            
            
            if (billDetail["status"] as! String) == "pending" || (billDetail["status"] as! String).count == 0 {
                self.window?.rootViewController = self.navigationController
            } else if jobType == "HAULING" && isCompletionImageUploaded == 1 {

                let vcComplete = LoadReceivedVC.init(nibName: "LoadReceivedVC", bundle: nil)
                vcComplete.globalTotalLoads = jobaccept.globalTotalLoads
                vcComplete.globalCurrentLoad = jobaccept.globalCurrentLoad
                vcComplete.dictBillDetails = billDetail.mutableCopy() as! NSMutableDictionary
                vcComplete.jobTypeStr = jobType
                //vcComplete.delegateCurrentLoad = self
                vcComplete.dateAccepted = jobaccept.dateAccepted
                vcComplete.arrConfirmation = arrConfirmation.mutableCopy() as! NSMutableArray

                (vc.selectedViewController as! UINavigationController).viewControllers = [acceptingJob, jobaccept, loadRecieved]
            } else if jobType == "DELIVERY" && (isCompletionImageUploaded == 1 || isStartedLastLoad == 1) {
                let driver_Id =  String(billDetail.value(forKey: "driver_id") as? String ?? "0")
                let tracking_Id =  String(billDetail.value(forKey: "id") as? Int ?? 0)
                let driver_Type = billDetail.value(forKey: "driver_type") as? String ?? ""

                let completeDelivery = CompleteDeliveryJobVc.init(nibName: "CompleteDeliveryJobVc", bundle: nil)
                completeDelivery.driver_Id = driver_Id
                completeDelivery.tracking_Id = tracking_Id
                completeDelivery.driver_Type = driver_Type
                completeDelivery.globalCurrentLoad = jobaccept.globalCurrentLoad
                completeDelivery.globalTotalLoads = jobaccept.globalTotalLoads
                completeDelivery.dictBillDetails = jobaccept.dictBillDetails
                completeDelivery.jobTypeStr = jobType
                completeDelivery.arrConfirmation = arrConfirmation.mutableCopy() as! NSMutableArray
                (vc.selectedViewController as! UINavigationController).viewControllers = [acceptingJob, jobaccept, loadRecieved, completeJob]
            } else if(billDetail.value(forKey: "contact_name") as? String ?? "" == "") {
                if( jobType == "HAULING" && jobaccept.globalCurrentLoad == jobaccept.globalTotalLoads)
                {
                    let driver_Id =  String(billDetail.value(forKey: "driver_id") as? String ?? "0")
                    let tracking_Id =  String(billDetail.value(forKey: "id") as? Int ?? 0)
                    let driver_Type = billDetail.value(forKey: "driver_type") as? String ?? ""

                    let completeDelivery = CompleteDeliveryJobVc.init(nibName: "CompleteDeliveryJobVc", bundle: nil)
                    completeDelivery.driver_Id = driver_Id
                    completeDelivery.tracking_Id = tracking_Id
                    completeDelivery.driver_Type = driver_Type
                    completeDelivery.globalCurrentLoad = jobaccept.globalCurrentLoad
                    completeDelivery.globalTotalLoads = jobaccept.globalTotalLoads
                    completeDelivery.dictBillDetails = jobaccept.dictBillDetails
                    completeDelivery.jobTypeStr = jobType
                    completeDelivery.arrConfirmation = arrConfirmation.mutableCopy() as! NSMutableArray
                    (vc.selectedViewController as! UINavigationController).viewControllers = [acceptingJob, jobaccept, loadRecieved, completeJob]

                } else {
                    let vcComplete = LoadReceivedVC.init(nibName: "LoadReceivedVC", bundle: nil)
                    vcComplete.globalTotalLoads = jobaccept.globalTotalLoads
                    vcComplete.globalCurrentLoad = jobaccept.globalCurrentLoad
                    vcComplete.dictBillDetails = billDetail.mutableCopy() as! NSMutableDictionary
                    vcComplete.jobTypeStr = jobType
                    //vcComplete.delegateCurrentLoad = self
                    vcComplete.dateAccepted = jobaccept.dateAccepted
                    vcComplete.arrConfirmation = arrConfirmation.mutableCopy() as! NSMutableArray

                    (vc.selectedViewController as! UINavigationController).viewControllers = [acceptingJob, jobaccept, loadRecieved]
                }
            } else {

                    let specialInstructions = SpecialInstructionsVC.init(nibName: "SpecialInstructionsVC", bundle: nil)

                    let driver_Id =  String(billDetail.value(forKey: "driver_id") as? String ?? "0")
                    let tracking_Id =  String(billDetail.value(forKey: "id") as? Int ?? 0)
                    let driver_Type = billDetail.value(forKey: "driver_type") as? String ?? ""


                    specialInstructions.driver_Id = driver_Id
                    specialInstructions.tracking_Id = tracking_Id
                    specialInstructions.driver_Type = driver_Type
                    specialInstructions.consumer_Name = billDetail.value(forKey: "contact_name") as? String ?? ""
                    specialInstructions.consumer_contact_no = billDetail.value(forKey: "contact_no") as? String ?? ""
                    specialInstructions.consumer_instruction = billDetail.value(forKey: "instruction") as? String ?? ""
                    specialInstructions.globalCurrentLoad = jobaccept.globalCurrentLoad
                    specialInstructions.globalTotalLoads = jobaccept.globalTotalLoads
                    specialInstructions.jobTypeStr = jobaccept.jobTypeStr

                    specialInstructions.dictBillDetails = billDetail.mutableCopy() as! NSMutableDictionary
                    specialInstructions.dateAccepted = jobaccept.dateAccepted

                    (vc.selectedViewController as! UINavigationController).viewControllers = [acceptingJob, jobaccept, loadRecieved, loadInstruction]
            }
                //                                    if let completedLoad = json["completed_loads"] as? Int {
//                (vc.selectedViewController as! UINavigationController).viewControllers = [acceptingJob, jobaccept, loadRecieved]
                //                                    } else if  {
                //
                //                                    }
                self.window?.rootViewController = self.navigationController
                USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)
        } else {
            self.window?.rootViewController = self.navigationController
        }
    }
    
    
    //MARK:- Custom Methods
    func clearNotifications() {
        let notification = UNUserNotificationCenter.current()
        notification.removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    //MARK:- Check Suspension Status
    func GetSuspensionAPI( _ completion:@escaping (Bool)->())
    {
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {
            return
        }
        let parameters = [
            "user_id":self.loginUserData.user_id ?? "",
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
        DispatchQueue.main.async(execute: {
            APIManager.sharedInstance.getDataFromAPI(BSE_URL_CHECK_SUSPENSION, .post, parameters) { (result, data, json, error, msg) in
                
                switch result
                {
                case .Failure:
                    DispatchQueue.main.async(execute: {
                        completion(false)
                    })
                    break
                case .Success:
                    DispatchQueue.main.async(execute: {
                        guard let suspendedStatus = json?.value(forKey: "suspended") as? Bool else{
                            return completion(false)
                        }
                        if(suspendedStatus)
                        {
                            USER_DEFAULT.set(nil, forKey: "userData")
                        }
                        completion(suspendedStatus)
                    })
                    break
                }
                
            }
        })
    }
    
    //MARK:- Check Suspension Status
    func GetCurrentJobForProviderAPI( _ completion:@escaping (Bool, NSDictionary)->())
    {
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {
            return
        }
        let parameters = [
            "driver_id":self.loginUserData.user_id ?? "",
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
        DispatchQueue.main.async(execute: {
            APIManager.sharedInstance.getDataFromAPI(BSE_get_provider_current_job, .post, parameters) { (result, data, json, error, msg) in
                switch result
                {
                case .Failure:
                    DispatchQueue.main.async(execute: {
                        completion(false, json ?? [:])
                    })
                    break
                case .Success:
                    DispatchQueue.main.async(execute: {
                        completion(true, json!)
                    })
                    break
                }
                
            }
        })
    }
    
    //MARK:- register Notification
    func registerForNotification(_ application:UIApplication)
    {
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
            UNUserNotificationCenter.current().delegate = self
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
    }
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        USER_DEFAULT.set(deviceTokenString, forKey: "DeviceToken")
        self.deviceToken = deviceTokenString
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        if application.applicationIconBadgeNumber != 0
        {
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1
        } 
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        print("Push notification received: \(userInfo)")
        if application.applicationIconBadgeNumber != 0
        {
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.\
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let notification = UNUserNotificationCenter.current()
        notification.getDeliveredNotifications(completionHandler: { (notifications) in
            print(notifications.count)
            for noti in notifications {
                print(noti.request.content.userInfo)
                print(noti.request.content.userInfo["type"] as Any)
                let nType = noti.request.content.userInfo["type"] as? String ?? ""
                guard let notType = NotificationType(rawValue: nType) else {
                    print("Unable to get type of notification.")
                    return
                }
                if notType == .newJobRequest {
                    guard let dicts = noti.request.content.userInfo as? [String:Any] else {return}
                    let dictMain  = dicts as! NSDictionary
                    let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
                    let b_details = dictss.value(forKey: "bill_details") as! NSDictionary
                    let jobType = b_details.value(forKey: "job_type") as? String ?? ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        let alert = CustomAlert(title: "You have been selected for a new \(jobType.uppercased()) job!", image: UIImage(named: "logomain")!, typeAlert: "newJobRequest", ButtonTitle: "View")
                        alert.typeAlert = "newJobRequest"
                        alert.dictNotification = dictss.mutableCopy() as! NSMutableDictionary
                        alert.delegate = self
                        alert.show(animated: true)
                        notification.removeAllDeliveredNotifications()
                    }
                }
            }
        })
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func saveTrucCartData()  {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.truckCartModel as Any)
        userDefaults.set(encodedData, forKey: TRUCK_CART_KEY)
        userDefaults.synchronize()
    }
    
    func getTruckCartData() -> TruckCartModel? {
        let userDefaults = UserDefaults.standard
        if let decoded  = userDefaults.object(forKey: TRUCK_CART_KEY) as? Data {
            let decodedData = NSKeyedUnarchiver.unarchiveObject(with: decoded) as Any
            if decodedData is TruckCartModel {
                return decodedData as? TruckCartModel
            }
        }
        return nil
    }
    
    func saveAcceptJobData()  {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.acceptJobModel as Any)
        userDefaults.set(encodedData, forKey: ACCEPT_JOB_KEY)
        userDefaults.synchronize()        
    }
    
    func getAcceptJobData() -> DriverAceeptJobModel? {
        let userDefaults = UserDefaults.standard
        if let decoded  = userDefaults.object(forKey: ACCEPT_JOB_KEY) as? Data {
            let decodedData = NSKeyedUnarchiver.unarchiveObject(with: decoded) as Any
            if decodedData is DriverAceeptJobModel {
                return decodedData as? DriverAceeptJobModel
            }
        }
        
        return nil
    }
    
    
    func saveResponseDataStructToUserDefault(_ data: [DeliveryResponse], forKey key: String) {
        let defaults = UserDefaults.standard
        
        // Use PropertyListEncoder to convert Player into Data / NSData
        defaults.set(try? PropertyListEncoder().encode(data), forKey: key)
    }
    
    func getResponseDataStructFromUserDefault(forKey key: String) -> [DeliveryResponse]? {
        let defaults = UserDefaults.standard
        guard let data = defaults.object(forKey: key) as? Data else {
            return nil
        }
        
        // Use PropertyListDecoder to convert Data into Player
        guard let model = try? PropertyListDecoder().decode([DeliveryResponse].self, from: data) else {
            return nil
        }
        
        return model
    }
    
    
    enum NotificationType:String
    {
        case jobAccept = "Job Accepted!"
        case nowJobDeleted = "Now Job Deleted"
        case laterJobDeleted = "Later Job Deleted"
        case laterJobAccept = "Later Job Accepted"
        case jobDeclined = "Job Declined"
        case newJobRequest = "New Job Request"
        case loadEnroute = "Load Enroute"
        case loadCompleted = "Load Completed"
        case jobCompleted = "Job Completed"
        case accountSuspended = "Suspended"
        case accountDeleted = "Deleted"
        case deviceChanged = "Device Changed"
        case laterJobReminder = "Later Job Reminder"
        case laterJobStart = "Later Job Start"
        case laterJobStarted = "Later Job Started!"
        case Admin = "Admin"
    }
    
    func updateLocationOnServer(updatedLocation:CLLocation)
    {
        var loginUserData:LoggedInUser!
        
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            loginUserData = loginUpdate
        }
        else
        {
            return
        }
        
        let parameters = [
            "user_id":loginUserData.user_id!,
            "latitude":updatedLocation.coordinate.latitude,
            "longitude":updatedLocation.coordinate.longitude,
            "access_token":loginUserData.access_token!,
            "refresh_token":loginUserData.refresh_token!
            ] as NSDictionary
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_UPDATE_LOCATION, .post, parameters as? [String : Any]) { (result, data, json, error, msg) in
            
            switch result
            {
            case .Failure:
                DispatchQueue.main.async(execute: {
                })
                break
            case .Success:
                
                DispatchQueue.main.async(execute: {
                })
                break
            }
        }
    }
}

extension AppDelegate : CLLocationManagerDelegate
{
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        
        USER_DEFAULT.setValue(String(lat), forKey:LatitudePrefrence)
        USER_DEFAULT.setValue(String(long), forKey:LongitudePrefrence)
        
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {
            return
        }
        
        if(self.loginUserData.type == "service")
        {
            self.updateLocationOnServer(updatedLocation:location) // Stop Updating while tesing QA
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       // locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    
    // MARK: - State Restoration protocol adopted by UIApplication delegate
    //    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
    //        return true
    //    }
    //
    //    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
    //        return true
    //    }
    
}

