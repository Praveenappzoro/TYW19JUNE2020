//
//  DriverLaterJobs.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 12/4/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import CoreLocation

class DriverLaterJobs: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var labelAceepted: UILabel!
    @IBOutlet weak var labelUserLocationPlaceholder: UILabel!

    @IBOutlet weak var lblTitleForJobTypeLocaton: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var viewTimerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnchangeTimeOfRequestShowOtlt: UIButton!
    @IBOutlet weak var btnPickLocationOtlt: UIButton!
    @IBOutlet weak var btnJobSiteLocationOtlt: UIButton!
    @IBOutlet weak var lblTotalTons: UILabel!
    @IBOutlet weak var lblInfoTotalTonsAndLoads: UILabel!
    @IBOutlet weak var lblTotalLoads: UILabel!
    @IBOutlet weak var lblTotalMiles: UILabel!
    @IBOutlet weak var btnAcceptOtlt: CustomButton!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var superViewOfTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var ConstraintviewHeightTotalCalculation: NSLayoutConstraint!
    
    var isFromNotification: Bool = false
    var arrConfirmation: NSMutableArray = []
    var dictConfirmation : NSMutableDictionary = [:]
    var dictBillDetails : NSMutableDictionary = [:]
    var selectedServiceType: String = ""
    var contact_name: String = ""
    var contact_no: String = ""
    var instruction: String = ""
    var screenComeFrom: String = ""
    var seconds = 60
    var timer = Timer()
    var loginUserData:LoggedInUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.register(UINib(nibName: "JobLaterCell", bundle: nil), forCellReuseIdentifier: "JobLaterCell")
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
        self.manageTimerScreen()
        self.CalculateHeightOfScreen()
        self.dateCompareFromTodayAfter12am()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
    }
    @IBAction func actionBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAcceptOrder(_ sender: Any)
    {
        let title = btnAcceptOtlt.titleLabel?.text ?? ""
        if title == "START" {
            
            let jobDetails = JobAcceptDriver.init(nibName: "JobAcceptDriver", bundle: nil)
            jobDetails.isFromNotification = true
            jobDetails.isLaterJob = true
            jobDetails.dictConfirmation = self.dictConfirmation //dictNoti.mutableCopy() as! NSMutableDictionary
            jobDetails.arrConfirmation = self.arrConfirmation//arr.mutableCopy() as! NSMutableArray
            self.navigationController?.pushViewController(jobDetails, animated: true)
        } else {
            self.acceptOrDeclineRequest(strStatusSendInApi:"true")
        }
    }
    
    func dateCompareFromTodayAfter12am()
    {
        let dateStart = self.callConvertTime(strTime:0)
        
        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = "dd MMMM YYYY  hh:mm:ss a"
        dateFormat.locale = Locale(identifier: "en_US_POSIX")

//        dateFormat.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let momentStart = self.dictBillDetails.value(forKey: "later_start") as? String
        
        ////By Krishna
        let momentStartTimeInterval = Int(momentStart ?? "0") ?? 0
        let dateStartMoment = Date(timeIntervalSince1970: TimeInterval(momentStartTimeInterval))
        
        let calendar = Calendar.current
        let currentDayOfMonth = calendar.component(.day, from: dateStart)
        
        let calendar1 = Calendar.current
        let dayOfJobStartDate = calendar1.component(.day, from: dateStartMoment)

        //////
        
        let today12AmTimeStamp: Int64 = Int64(dateStart.timeIntervalSince1970)
        let currentStamp: Int64 = Int64(Date().timeIntervalSince1970)
        let startLaterTimeStamp = Int64(momentStart ?? "0")

        let start = Int(self.dictBillDetails.value(forKey: "startButton") as? String ?? "0") ?? 0

        if start == 0 {
            if(dayOfJobStartDate == currentDayOfMonth && currentStamp < startLaterTimeStamp!){
                self.btnAcceptOtlt.isUserInteractionEnabled = true
                self.btnAcceptOtlt.layer.borderColor = themeColorGreenForLayer
                self.btnAcceptOtlt.setTitleColor(UIColor.gray, for: .normal)
            } else {
                self.btnAcceptOtlt.isUserInteractionEnabled = false
                self.btnAcceptOtlt.layer.borderColor = UIColor.gray.cgColor
                self.btnAcceptOtlt.setTitleColor(UIColor.gray, for: .normal)
            }
        } else {
            self.btnAcceptOtlt.isUserInteractionEnabled = true
            self.btnAcceptOtlt.layer.borderColor = themeColorGreenForLayer
            self.btnAcceptOtlt.setTitleColor(UIColor.gray, for: .normal)
        }

    }
    
    func callConvertTime(strTime:Int) -> Date
    {
        let calendar = NSCalendar.current
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: Date())
        dateComponents.month = calendar.component(.month, from: Date())
        dateComponents.day = calendar.component(.day, from: Date())
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let someDateTime = calendar.date(from: dateComponents)
        return someDateTime ?? Date()
    }
    
    func acceptOrDeclineRequest(strStatusSendInApi: String)
    {
        print("Accept Request")
        
        let params = [
            "user_id":self.dictBillDetails.value(forKey: "user_id") as! String,
            "driver_id":self.loginUserData.user_id ?? "",
            "tracking_id":String(self.dictBillDetails.value(forKey: "id") as! Int),
            "access_token":self.loginUserData.access_token!,
            "refresh_token":self.loginUserData.refresh_token!
        ]
        self.startAnimating("")
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_ACCEPT_LATER_JOB, .post, params) { (result, data, json, error, msg) in
            
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
                    if(strStatusSendInApi == "true")
                    {
                        UIView.animate(withDuration: 0.25, animations: {
                            self.navigationController?.popToRootViewController(animated: true)
                        });
                    }
                })
                break
            }
        }
    }
    
    func CalculateHeightOfScreen()
    {
        let totalNeedToIncreaseHeight = (self.arrConfirmation.count * 80)
        self.tblViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
        self.superViewOfTableViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
        self.secondViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
        self.mainViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
        self.tblView.reloadData()
        self.ShowDataOnSreen()
    }
    
    func ShowDataOnSreen()
    {
        let dictt = self.dictConfirmation.value(forKey: "bill_details") as! NSDictionary
        self.dictBillDetails = dictt.mutableCopy() as! NSMutableDictionary
        let total_loads = self.dictBillDetails.value(forKey: "total_loads") as? String ?? ""
        let total_tons = self.dictBillDetails.value(forKey: "tons") as? String ?? ""
        self.lblInfoTotalTonsAndLoads.text = "\("You will haul away \(total_loads) loads and \(total_tons) tons")"
        let dropLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_latitude") as? String ?? "0.0")!
        let dropLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_longitude") as? String ?? "0.0")!
        let pickLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_latitude") as? String ?? "0.0")!
        let pickLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_longitude") as? String ?? "0.0")!
        let coordinate₀ = CLLocation(latitude: dropLat, longitude: dropLong)
        let coordinate₁ = CLLocation(latitude: pickLat, longitude: pickLong)
        let distanceInMilesInDouble = Double(((coordinate₀.distance(from: coordinate₁)/1000)*0.621371))
        let distanceInMilesRound = String(format: "%.2f", distanceInMilesInDouble)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

//        let moment = self.dictBillDetails.value(forKey: "later_start") as? String
//        let ddd = moment as! String
//        let fullDate =  Date(timeIntervalSince1970: TimeInterval(ddd)!)
        
            var moment = dictBillDetails.value(forKey: "later_start") as? String
            if(moment?.characters.count == 13)
            {
                moment?.removeLast()
                moment?.removeLast()
                moment?.removeLast()
            }
            let ddd = moment as! String
            let fullDate =  Date(timeIntervalSince1970: TimeInterval(ddd)!)
            let time = dateFormatterPrint.string(from: fullDate)
            
        let strFullDate = (moment?.characters.count)! < 10 ? " " : time

        
//        let time = dateFormatterPrint.string(from: fullDate)
        let strLater_S = self.dictBillDetails.value(forKey: "later_start") as? String
        let strLater_E = self.dictBillDetails.value(forKey: "later_end") as? String
        //let pickup_address = self.dictBillDetails.value(forKey: "pickup_address") as? String ?? ""
        let address = self.dictBillDetails.value(forKey: "pickup_address") as? String ?? ""
        let city = self.dictBillDetails.value(forKey: "pickup_city") as? String ?? ""
        let state = self.dictBillDetails.value(forKey: "pickup_state") as? String ?? ""
        let zipcode = self.dictBillDetails.value(forKey: "pickup_zipcode") as? String ?? ""
        let pickup_address = address + ", " + city + ", " + state + ", " + zipcode
        
        
        let drop_address = self.dictBillDetails.value(forKey: "drop_address") as? String ?? ""
        let dealer_Name = self.dictBillDetails.value(forKey: "dealer_name") as? String ?? ""
        let jobType = (self.dictBillDetails.value(forKey: "job_type") as? String)?.uppercased() ?? ""
        self.lblTitleForJobTypeLocaton.text = "\(jobType)\(" LOCATION")"
        if(jobType == "DELIVERY"){
            let strAttributedLocationDelivery = self.attributeDtailsBold(strBold: "\(dealer_Name)\n", strNormal: pickup_address)
             self.btnPickLocationOtlt.setAttributedTitle(strAttributedLocationDelivery, for: .normal)
            self.btnJobSiteLocationOtlt.setTitle(drop_address, for: .normal)
            self.labelUserLocationPlaceholder.text = "PICKUP LOCATION"
        }
        else{
            let strAttributedLocationHauling = self.attributeDtailsBold(strBold: "\(dealer_Name)\n", strNormal: drop_address)
          
            self.btnPickLocationOtlt.setTitle(pickup_address, for: .normal)
             self.btnJobSiteLocationOtlt.setAttributedTitle(strAttributedLocationHauling, for: .normal)
            
            self.labelUserLocationPlaceholder.text = "DROP-OFF LOCATION"

        }
        self.btnPickLocationOtlt.titleLabel?.lineBreakMode = .byWordWrapping
        self.btnJobSiteLocationOtlt.titleLabel?.lineBreakMode = .byWordWrapping
        if(strLater_S != "OPTIONAL" || strLater_E != "OPTIONAL"){
        let strLater_Start = strLater_S as! String
        let strLater_End = strLater_E as! String
        let later_Start_Date =  self.dateFromMilliseconds(selectedTimeStamp: Int(strLater_Start)!)
        let later_End_Date =  self.dateFromMilliseconds(selectedTimeStamp: Int(strLater_End)!)
        dateFormatterPrint.dateFormat = "hh:mm a"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
        let later_Start_Str = dateFormatterPrint.string(from: later_Start_Date)
        let later_End_str = dateFormatterPrint.string(from: later_End_Date)
            let later_Start = later_Start_Str 
            let later_End = later_End_str 
            let txtTime = "\(strFullDate) \("\n")\(" Between ") \(later_Start) \(" - ")\(later_End)"
            var strAttributedFirstLine = self.attributeDtailsBold(strBold: " LATER, ", strNormal: txtTime)
            self.btnchangeTimeOfRequestShowOtlt.titleLabel!.lineBreakMode = .byWordWrapping
            self.btnchangeTimeOfRequestShowOtlt.setAttributedTitle(strAttributedFirstLine, for: .normal)
            self.lblTotalLoads.text = self.dictBillDetails.value(forKey: "total_loads") as? String ?? ""
            self.lblTotalTons.text = self.dictBillDetails.value(forKey: "total_tons") as? String ?? ""
            
            let miles = Double(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "0")! * Double(distanceInMilesRound)!
            self.lblTotalMiles.text =  String(round(miles)) //String(format: "%.2f", miles)//distanceInMilesRound
            
//            self.lblTotalMiles.text = "\(self.dictBillDetails.value(forKey: "mileage") as? String ?? "0")"
        }
        
        let status = self.dictBillDetails.value(forKey: "status") as? String ?? ""
        if status == "started" {
            btnAcceptOtlt.isHidden = true
            labelAceepted.isHidden = false
        } else {
            btnAcceptOtlt.isHidden = false
            labelAceepted.isHidden = true
        }
        
        let start = Int(self.dictBillDetails.value(forKey: "startButton") as? String ?? "0") ?? 0

        if start == 1 {
            btnAcceptOtlt.isHidden = false
            btnAcceptOtlt.setTitle("START", for: .normal)
        }

        
    }
    //#MARK:- implement timer functionality
    func manageTimerScreen(){
        print("Accept Request")
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            self.dismiss(animated: true)
        } else {
            seconds -= 1
            self.lblTimer.text = timeString(time: TimeInterval(seconds))
        }
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
    
    func dateFromMilliseconds(selectedTimeStamp:Int) -> Date {
        let date : NSDate! = NSDate(timeIntervalSince1970:Double(selectedTimeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY  hh:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date as Date)
        return dateFormatter.date( from: timeStamp )!
    }
}

extension DriverLaterJobs : UITableViewDelegate, UITableViewDataSource
{
    //Mark:- TableView Delegate and datasource
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobLaterCell") as! JobLaterCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.arrConfirmation.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobLaterCellMain", for: indexPath) as! JobLaterCellMain
        let dict = self.arrConfirmation.object(at: indexPath.row) as! NSDictionary
        let imgStr = dict.value(forKey: "material_image") as? String
        let tons = dict.value(forKey: "tons") as? String
        let imgURL = imgStr  == nil ? "" : imgStr
        cell.imgView.loadImageAsync(with: BSE_URL_LoadMedia+imgURL!, defaultImage: "", size: cell.imgView.frame.size)
        let fullStringForPostfix = "\(dict.value(forKey: "category") as? String ?? "")\(" ")\(dict.value(forKey: "name") as? String ?? "")"
        let strPrefixCategory = dict.value(forKey: "category") as? String ?? ""
        let strPostfixCategory = dict.value(forKey: "name") as? String ?? ""
        let strCategory = "\("\n")\(strPrefixCategory)\(" ")\(strPostfixCategory)"
        
        if((self.dictBillDetails.value(forKeyPath: "job_type") as? String ?? "").uppercased() == "HAULING"){
            cell.lblMaterialCategory.attributedText = self.attributeDtailsBold(strBold: "Hauling  ", strNormal:strCategory )
            let tons = ((Int(tons ?? "0") ?? 0))
            //let loads = ((Int(dict.value(forKey: "tons") as? String ?? "0") ?? 0))

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
            
            if(loads == 1)
            {
                cell.lblMaterialQuantity.text = "\(loads) \(" Load")"
            }
            else
            {
                cell.lblMaterialQuantity.text = "\(loads) \(" Loads")"
            }
        }
        else{
            cell.lblMaterialCategory.attributedText = self.attributeDtailsBold(strBold: "Delivery  ", strNormal:strCategory)
            let tons = (Int(tons ?? "0") ?? 0)

//            if((dict.value(forKey: "category") as? String ?? "").uppercased() == "DIRT") {
//                let tons = ((Int(tons ?? "0") ?? 0))
//                //let loads = ((Int(dict.value(forKey: "tons") as? String ?? "0") ?? 0))
//
//                var loads = 1
//
//                if tons > 16 {
//                    if (tons % 16 == 0) {
//                        loads = (tons / 16)
//                    }
//                    else {
//                        loads = (tons / 16);
//                        loads += 1
//                    }
//                }
//
//                if(loads == 1)
//                {
//                    cell.lblMaterialQuantity.text = "\(loads) \(" Load")"
//                }
//                else
//                {
//                    cell.lblMaterialQuantity.text = "\(loads) \(" Loads")"
//                }
//            } else{
//                cell.lblMaterialQuantity.text = "\(tons ?? "0") Tons"
//            }
            
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
        
//        cell.lblMaterialQuantity.text = "\(tons!)\(" tons")"
    
        
        
        
        return cell
    }
}
