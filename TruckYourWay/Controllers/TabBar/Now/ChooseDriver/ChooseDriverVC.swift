//
//  ChooseDriverVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/19/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

var isComeHome = false
class ChooseDriverVC: UIViewController {
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var viewPopUpAcceptRequest: UIView!
    
    
    
    @IBOutlet weak var viewPopUpForMultipleLoad: UIView!
    @IBOutlet weak var subViewPopUpForMultipleLoad: UIView!
    
    
    @IBOutlet weak var lblTitlePopUpForMultipleLoad: UILabel!
    
    @IBOutlet weak var viewPopUpChooseMultipleDriver: UIView!
    @IBOutlet weak var subViewPopUpChooseMultipleDriver: UIView!
    
    @IBOutlet weak var lblTitlePopUpForMultipleDriverSelection: UILabel!
    
    @IBOutlet weak var viewPopUpSelectANewDriver: UIView!
    @IBOutlet weak var subviewPopUpSelectANewDriver: UIView!
    
    @IBOutlet weak var viewHelpOtlt: UIView!
    
    @IBOutlet weak var subviewHelpOtlt: UIView!
    
    @IBOutlet weak var viewPopUpForCancellation: UIView!
    
    @IBOutlet weak var subViewPopUpForCancellation: UIView!
    
    
    
    var viewPopUp = UIView()
    var viewPopSub = UIView()
    var imgPopUp = UIImageView()
    var lblText = UILabel()
    var lblTimerUpdate = UILabel()
    
    @IBOutlet weak var lblAcceptMessage: UILabel!
    
    var bill_Id:String = ""
    var strDriverType:String = "single"
    var dictBillDetails : NSMutableDictionary = [:]
    var pickedCordinates : NSMutableDictionary = [:]
    var payloadDict : NSMutableDictionary = [:]
    
    var countdownTimer: Timer!
    var totalTime = 60
    
    var selectedIndex: Int = -1
    var totalDriverNeeded: Int = 1
    var currentlyWhichNoDriverRequest: Int = 1
    var allBillDrivers:NSMutableArray = []
    var arrSelectedMaterials: NSArray = []

    var loginUserData:LoggedInUser!
    
    var selectedDrivers: Int = 0
    var apiCall: Bool = false
    var arrayConfirmation: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Constant.MyVariables.appDelegate.truckCartModel != nil {
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            self.pickedCordinates = model.pickedCordinates
            self.dictBillDetails = model.dictBillDetails
            self.currentlyWhichNoDriverRequest = model.currentlyWhichNoDriverRequest
            self.totalDriverNeeded = model.totalDriverNeeded
            self.arrayConfirmation = model.arrConfirmation
            self.bill_Id = String(dictBillDetails.value(forKey: "id") as! Int)
        }
        
        //        self.touchableEventSetOnPhoneNumberAndUrl()
        
        if #available(iOS 10.0, *) {
            self.tblView.refreshControl = refreshControl
        } else {
            self.tblView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        self.tblView.register(UINib(nibName: "ChooseDriverCell", bundle: nil), forCellReuseIdentifier: "ChooseDriverCell")
        
        self.subviewHelpOtlt.layer.cornerRadius = 5
        self.subviewHelpOtlt.layer.masksToBounds = true
        
        self.subViewPopUpForCancellation.layer.cornerRadius = 5
        self.subViewPopUpForCancellation.layer.masksToBounds = true
        
        self.subViewPopUpChooseMultipleDriver.layer.cornerRadius = 5
        self.subViewPopUpChooseMultipleDriver.layer.masksToBounds = true
        
        self.subviewPopUpSelectANewDriver.layer.cornerRadius = 5
        self.subviewPopUpSelectANewDriver.layer.masksToBounds = true

        self.subViewPopUpForMultipleLoad.layer.cornerRadius = 5
        self.subViewPopUpForMultipleLoad.layer.masksToBounds = true
        
        
        self.get_Bill_Drivers()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getAcceptJobNotification), name: NSNotification.Name(rawValue: "AcceptJobByDriver"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getDeclineJobNotification), name: NSNotification.Name(rawValue: "DeclinedJobByDriver"), object: nil)
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appIsGoingInBackground)
            , name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    @objc func appIsGoingInBackground() {
        print("disappearing..")

        let model = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
        
        model.pickedCordinates = self.pickedCordinates
        model.dictBillDetails = self.dictBillDetails
        model.currentlyWhichNoDriverRequest = self.currentlyWhichNoDriverRequest
        model.totalDriverNeeded = self.totalDriverNeeded
        model.arrConfirmation = self.arrayConfirmation
        model.currentlyWhichNoDriverRequest = self.currentlyWhichNoDriverRequest
        model.totalDriverNeeded = self.totalDriverNeeded
        model.selectedServiceType = (self.dictBillDetails.value(forKey: "job_type") as? String)?.uppercased() ?? ""
        Constant.MyVariables.appDelegate.saveTrucCartData()
        USER_DEFAULT.set(AppState.TruckChooseDriver.rawValue, forKey: APP_STATE_KEY)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        self.ShowPopUp()
    }
    
    
    //MARK:- Manage state of application after payment state And before Complete choose service provider request
    func manageState()
    {
        
        let dict: NSDictionary = [:]
        dict.setValue(self.bill_Id, forKey: "bill_Id")
        dict.setValue(self.dictBillDetails, forKey: "bill_Details")
        dict.setValue(self.pickedCordinates, forKey: "pickedCordinates")
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            return
        }
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: data)
        let userDefaults = UserDefaults.standard
        userDefaults.set(encodedData, forKey: "Bill_Information")
        
        let ddaattaa = USER_DEFAULT.value(forKey: "Bill_Information") as? Data
        do
        {
            let json = try JSONSerialization.jsonObject(with: ddaattaa!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
            
            let dictReturn = json as NSDictionary?
            
            self.bill_Id = dictReturn?.value(forKey: "bill_Id") as? String ?? ""
            self.dictBillDetails = dictReturn?.value(forKey: "bill_Details") as! NSMutableDictionary
            self.pickedCordinates = dictReturn?.value(forKey: "pickedCordinates") as! NSMutableDictionary
            
        }
        catch{
            // print(error)
            OperationQueue.main.addOperation
                {
                    //
            }
        }
        
    }
    func CalculateTotalTons()
    {
        let arrayMaterial = self.arrayConfirmation
        var totalLoads = 0
        var isDirt = true
        for data in arrayMaterial {
            let dic = data as! NSDictionary
            print(dic)
            let category = dic["category"] as! String
            if category.uppercased() == "DIRT" {
                totalLoads += (Int(dic["total_tons"] as! String) ?? 0) / 16
            } else {
                isDirt = false
                let totalTons = Int(dic["total_tons"] as! String) ?? 0
                if totalTons > 16 {
                    if (totalTons % 16) == 0 {
                        totalLoads += (totalTons / 16)
                    } else {
                        totalLoads += ((totalTons / 16) + 1)
                    }
                } else {
                    totalLoads += 1
                }
            }
        }
        

//        print(self.dictBillDetails)
//        var loads = 1
//
//        if totalTons > 16 {
//            if (totalTons % 16 == 0) {
//                loads = (totalTons / 16)
//            }
//            else {
//                loads = (totalTons / 16);
//                loads += 1
//            }
//        }
        let totalTons = Int(self.dictBillDetails.value(forKey: "total_tons") as? String ?? "0")!

        if(totalLoads <= 5) {
            return
           // self.get_Bill_Drivers()
        }
        else {
            self.strDriverType = "multiple"
            let reminder  = Int(totalLoads % 5)
            let numberOfDrivers  = Int(totalLoads/5)
            
            self.totalDriverNeeded = reminder > 0 ? numberOfDrivers + 1 : numberOfDrivers
            
           // if self.apiCall == false {
                if self.selectedDrivers == self.totalDriverNeeded {
                    self.showCustomAlertWith(message: "You have selected all the Service Providers.", actions: ["OKAY": { 
               
                        isComeHome = true; self.navigationController?.popToRootViewController(animated: false)
                        Constant.MyVariables.appDelegate.truckCartModel = nil
                        Constant.MyVariables.appDelegate.saveTrucCartData()
                        USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)
                        
                         }], isSupportHiddedn: true, isCancleHide: true)
                } else  if self.selectedDrivers > 0 {
                   self.currentlyWhichNoDriverRequest = self.selectedDrivers + 1
                    self.viewPopUpSelectANewDriver.alpha = 1
                }
//                else {
//                    self.viewPopUpSelectANewDriver.alpha = 1
//                    self.currentlyWhichNoDriverRequest = self.selectedDrivers + 1
//                }
//                return
//
//
//                if self.selectedDrivers > 0 {
//                    if self.selectedDrivers == self.currentlyWhichNoDriverRequest {
//                        self.currentlyWhichNoDriverRequest = self.selectedDrivers + 1
//                    }
//                    if self.currentlyWhichNoDriverRequest > self.totalDriverNeeded {
//                        self.showCustomAlertWith(message: "You have selected all the Service Providers", actions: ["OK": { (
//                            self.navigationController?.popToRootViewController(animated: true)
//                            ) }], isSupportHiddedn: true)
//                    } else {
//                        self.viewPopUpSelectANewDriver.alpha = 1
//                    }
//                }
                else {
                    let jobType = (self.dictBillDetails.value(forKey: "job_type") as? String)?.uppercased() ?? ""
                    
                    var text = "You have ordered \(jobType == "HAULING" ? ("\(totalLoads) loads") : ("\(totalTons) tons")). Would you like to use \(self.totalDriverNeeded) service providers to complete YOUR order in 1 day?"
                    if isDirt {
                        text = "You have ordered \(jobType == "HAULING" ? ("\(totalLoads) loads") : ("\(Int(totalTons / 16)) loads")). Would you like to use \(self.totalDriverNeeded) service providers to complete YOUR order in 1 day?"
                    }
                    
                    self.lblTitlePopUpForMultipleLoad.text = text
                    self.lblTitlePopUpForMultipleDriverSelection.text = "\("Please select ")\(self.totalDriverNeeded)\(" service providers.")"
                    self.viewPopUpForMultipleLoad.alpha = 1
                }
              //  self.apiCall = true
           // }
        }
    }
    

    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        self.get_Bill_Drivers()
    }
    
    func ShowPopUp()
    {
        self.viewPopUp.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        self.viewPopSub.frame =  CGRect(x: (UIScreen.main.bounds.size.width-300)/2, y: (UIScreen.main.bounds.size.height-200)/2, width: 300, height: 200)
        self.lblTimerUpdate.frame = CGRect(x: (UIScreen.main.bounds.size.width-300)/2, y: (self.viewPopSub.frame.origin.y+self.viewPopSub.frame.size.height+20), width: 300, height: 30)
        self.imgPopUp.frame = CGRect(x: 0, y: 0, width: viewPopSub.frame.size.width, height: 170)
        self.lblText.frame = CGRect(x: 0, y: 170, width: viewPopSub.frame.size.width, height: 30)
        
        self.imgPopUp.contentMode = .scaleAspectFit
        self.lblText.textAlignment = .center
        self.lblTimerUpdate.textAlignment = .center
        
        self.imgPopUp.image = UIImage(named: "logomain")
        self.lblText.text = "Contacting service provider..."
        self.lblTimerUpdate.text = "60"
        
        self.lblText.textColor = UIColor.init(red: 255.0/255.0, green: 115.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        self.lblTimerUpdate.textColor = UIColor.init(red: 255.0/255.0, green: 115.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        
        self.lblText.font = UIFont.boldSystemFont(ofSize: 18)
        self.lblTimerUpdate.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.viewPopSub.addSubview(self.imgPopUp)
        self.viewPopSub.addSubview(self.lblText)
        self.viewPopUp.addSubview(self.lblTimerUpdate)
        self.viewPopUp.addSubview(self.viewPopSub)
        
        self.viewPopUp.backgroundColor = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.45)
        self.viewPopUp.alpha = 0
        UIApplication.shared.keyWindow!.addSubview(self.viewPopUp);
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func ActionBack(_ sender: Any)
    {
        self.viewPopUpForCancellation.isHidden = false
    }
    
    
    //#MARK:- Action for Please select N length Service providers .
    
    @IBAction func actionSelectMultipleDrivers(_ sender: Any)
    {
        self.viewPopUpChooseMultipleDriver.alpha = 0
        self.strDriverType = "multiple"
        //Example :- Please select 2 Drivers.
    }
    
    //#MARK:- Action for Multiple Drivers
    
    
    @IBAction func ActionNoMultipleDriver(_ sender: Any)
    {
        self.viewPopUpForMultipleLoad.alpha = 0
        self.strDriverType = "single"
        self.totalDriverNeeded = 1
       // self.get_Bill_Drivers()
    }
    
    @IBAction func ActionYesMultipleDrivers(_ sender: Any) {
        self.viewPopUpForMultipleLoad.alpha = 0
        self.viewPopUpChooseMultipleDriver.alpha = 1
    }
    
    @IBAction func ActionYesOnChooseMultipleDrivers(_ sender: Any) {
        self.viewPopUpChooseMultipleDriver.alpha = 0
        //self.get_Bill_Drivers()
    }
    
    @IBAction func ActionChooseAnotherDriver(_ sender: Any) {
        self.viewPopUpSelectANewDriver.alpha = 0
       // self.get_Bill_Drivers()
    }
    
    @IBAction func actionOkayOnAcceptPopUp(_ sender: Any)
    {
        
        _ = (self.dictBillDetails.value(forKey: "job_type") as? String)?.uppercased() ?? ""
        
//        if(jobType == "HAULING")
//        {
//            self.navigationController?.popToRootViewController(animated: true)
//        }
//        else
//        {
        Constant.MyVariables.appDelegate.truckCartModel = nil
        Constant.MyVariables.appDelegate.saveTrucCartData()
        USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)

//        if(jobType == "HAULING")
//        {
//            self.navigationController?.popToRootViewController(animated: true)
//        }
//        else
//        {
            let trackOrder = TrackDriverVC.init(nibName: "TrackDriverVC", bundle: nil)
            trackOrder.tracking_Id = self.payloadDict.value(forKey: "tracking_no") as? String ?? ""
            //trackOrder.isFromDriverList = true
            //self.navigationController?.pushViewController(trackOrder, animated: true)
            
            let vc = TabBar.init(nibName: "TabBar", bundle: nil)
            vc.selectedIndex = 2
            
            Constant.MyVariables.appDelegate.navigationController = UINavigationController.init(rootViewController: vc)
            let later = LaterVC.init(nibName: "LaterVC", bundle: nil)
            later.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "now_later-jobs_Tab"), tag: 2)
            later.tabBarItem.imageInsets = UIEdgeInsets(top:7, left: 0, bottom: -7, right: 0)
            later.navigationController?.navigationBar.isHidden = true
            
            (vc.selectedViewController as! UINavigationController).viewControllers = [later, trackOrder]

            Constant.MyVariables.appDelegate.window?.rootViewController = Constant.MyVariables.appDelegate.navigationController
            Constant.MyVariables.appDelegate.window?.makeKeyAndVisible()

//        }
    }
    
    
    @IBAction func ActionOkOnCancellationPopup(_ sender: Any)
    {
        self.viewPopUpForCancellation.isHidden = true
        //Remove saved data
//        Constant.MyVariables.appDelegate.truckCartModel = nil
//        Constant.MyVariables.appDelegate.saveTrucCartData()
//        USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)
//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func ActionCancelOnCancellationPopup(_ sender: Any)
    {
        self.viewPopUpForCancellation.isHidden = true
        
    }
    
    @IBAction func actionHelpPopup(_ sender: Any)
    {
        self.viewHelpOtlt.isHidden = false
    }
    
    @IBAction func actionCall(_ sender: Any)
    {
        if let url = NSURL(string: "tel://\(tywHelpPhoneNumber)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @IBAction func actionCancellationPolicy(_ sender: Any)
    {
        if let url =  NSURL(string: BSE_URL_Cancelation_Policy), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @IBAction func ActionHideHelpView(_ sender: Any)
    {
        self.viewHelpOtlt.isHidden = true
    }
    
    
    @objc func getAcceptJobNotification(_ userInfo: Notification) {
//        let totalTons = Int(self.dictBillDetails.value(forKey: "total_tons") as? String ?? "0")!
//
//        if totalTons <= 80 {
//            
//        }
        
        self.totalDriverNeeded = self.totalDriverNeeded - 1
        self.currentlyWhichNoDriverRequest  = self.currentlyWhichNoDriverRequest + 1
        if(self.totalDriverNeeded < 1)
        {
            let dicss = userInfo.userInfo as! [String: AnyObject]
            let dict = dicss as NSDictionary
            let dictPayload = dict.value(forKey: "payload") as! NSDictionary
            self.payloadDict = dictPayload.mutableCopy() as! NSMutableDictionary
            self.endTimer()
            self.viewPopUpAcceptRequest.alpha = 1
            let str = "\(" has accepted YOUR job.")\("\n") \("The courtesy 2-hour window will begin NOW.")"
            var fName: String = ""
            if(self.selectedIndex != -1)
            {
                fName =  "\("Truck ")\(dictPayload.value(forKey: "truck_no") as? String ?? "")"
            }
            else
            {
                fName = "Service Provider"
            }
            self.lblAcceptMessage.attributedText =  self.attributeDtailsBold(strBold: fName, strNormal: str)
            //            if userInfo != nil{
            //
            //            }
            
        }
        else
        {
            self.endTimer()
            self.viewPopUpSelectANewDriver.alpha = 1
        }
        
    }
    
    @objc func getDeclineJobNotification(_ userInfo: Notification){
        
        self.endTimer()
        
        if userInfo != nil{
            
        }
        
    }
    
    
    func get_Bill_Drivers()
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
            "bill_no":self.bill_Id,
            "driver_nos":"1",
            "dealer_name":self.loginUserData.fullName,
            "dealer_latitude": self.pickedCordinates.value(forKey: "lat")!,
            "dealer_longitude":self.pickedCordinates.value(forKey: "long")!,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? ""
            ] as [String : Any]
        
        self.startAnimating("")
        
        APIManager.sharedInstance.getArrayDataFromAPI(BSE_URL_GET_BILL_DRIVERS, .post, parameters, { (result, data, json, error, msg) in
            
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
                    
                    let jsonResponse = json?["results"] as! NSArray
                    let total = jsonResponse.count
                    let sDrivers = json?["selected_drivers"] as? Int ?? 0
                    self.selectedDrivers = sDrivers
                    
                    self.CalculateTotalTons()
                    if(total>0) {
                        let arr = jsonResponse
                        self.allBillDrivers = arr.mutableCopy() as! NSMutableArray
                        
                        self.tblView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                })
            }
        })
    }
    
    func callSubmitDriverApi(selectedDict: NSDictionary)
    {
        let parameters = [
            "bill_no":self.bill_Id,
            "type":self.strDriverType,
            "driver_id":selectedDict.value(forKey: "user_id") as! String,
            "driver_no":"\(self.currentlyWhichNoDriverRequest)",
            "user_id":self.loginUserData.user_id ?? "",
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? ""
            ] as [String : Any]
        
        self.startAnimating("")
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_SUBMIT_DRIVER, .post, parameters, { (result, data, json, error, msg) in
            
            switch result
            {
            case .Failure:
                DispatchQueue.main.async(execute: {
                    self.stopAnimating()
                    self.showAlert(msg)
                    self.get_Bill_Drivers()
                })
                break
            case .Success:
                
                DispatchQueue.main.async(execute: {
                    self.stopAnimating()
                    self.startTimer()
                    self.viewPopUp.alpha = 1
                })
            }
            
        })
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        if totalTime != 1 {
            totalTime -= 1
            self.lblTimerUpdate.text = "\(totalTime)\(" Sec")"
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        self.totalTime = 60
        self.lblTimerUpdate.text = "60"
        self.viewPopUp.alpha = 0
        if(self.countdownTimer != nil)
        {
            countdownTimer.invalidate()
        }
        
        get_Bill_Drivers()
    }
    
    
    func attributeDtailsBold(strNormal: String, strBold: String) -> NSMutableAttributedString
    {
        let normalString = NSMutableAttributedString(string:strNormal)
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:strBold, attributes:attrs)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:strBold.length))
        normalString.append(attributedString)
        return normalString
    }
    
    func attributeDtailsBold(strBold: String, strNormal: String) -> NSMutableAttributedString
    {
        let normalString = NSMutableAttributedString(string:strNormal)
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:strBold, attributes:attrs)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:strBold.length))
        attributedString.append(normalString)
        return attributedString
    }
}

extension ChooseDriverVC: UITableViewDelegate, UITableViewDataSource
{
    //Mark:- TableView Delegate and datasource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.allBillDrivers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 130
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseDriverCell", for: indexPath) as! ChooseDriverCell
        
        
        let dic = self.allBillDrivers.object(at: indexPath.row) as! NSDictionary
        let dict = dic.value(forKey: "details") as! NSDictionary
        
        let strDistance = dic.value(forKey: "distance") as! String
        let strPostPix = " MILES"
        
        let strDistanceCombined = "\(strDistance)\(strPostPix)"
        
        let strTruckNumber = dict.value(forKey: "truck_number") as! String
        let imgURL = dict.value(forKey: "truck_image") as! String ?? ""
        
        cell.lblTruckNumber.attributedText = self.attributeDtailsBold(strNormal: "Truck Number: ", strBold: strTruckNumber)
        cell.lblDistance.attributedText = self.attributeDtailsBold(strNormal: "Distance: ", strBold: strDistanceCombined)
        cell.viewRating.rating = Double(dict.value(forKey: "ratings") as! String) ?? 3.0
        cell.imgView.loadImageAsync(with: BSE_URL_LoadMedia+imgURL, defaultImage: "", size: cell.imgView.frame.size)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.selectedIndex = indexPath.row
        let dic = self.allBillDrivers.object(at: indexPath.row) as! NSDictionary
        let dict = dic.value(forKey: "details") as! NSDictionary
        self.callSubmitDriverApi(selectedDict:dict)
    }
}


