//
//  OrderConfirmationVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/17/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentJobDetailsVC: UIViewController {
    
    
    @IBOutlet weak var lblPurchaseHistory: UILabel!
    
    @IBOutlet weak var lblWhen: UILabel!
    
    @IBOutlet weak var lblPickupLocation: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var btnOrderIdOtlt: UIButton!
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var viewTimerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnTrackOrderOtlt: CustomButton!
    
    @IBOutlet weak var btnCancelRequestOtlt: CustomButton!
    
    @IBOutlet weak var btnJobTitle: CustomButton!
    @IBOutlet weak var btnchangeTimeOfRequestShowOtlt: UIButton!
    
    @IBOutlet weak var greenLblbView: UIView!
    @IBOutlet weak var btnPickLocationOtlt: UIButton!
    
    @IBOutlet weak var viewTotalCalculations: UIView!
    
    @IBOutlet weak var lblTotalTons: UILabel!
    
    @IBOutlet weak var lblTotalLoads: UILabel!
    
    @IBOutlet weak var viewPopUpForCancellation: UIView!
    @IBOutlet weak var subViewPopUpForCancellation: UIView!

    
//    @IBOutlet weak var lblTotalMiles: UILabel!
@IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var stackViewBottomOtlt: UIStackView!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var superViewOfTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ConstraintviewHeightTotalCalculation: NSLayoutConstraint!
    
    
    @IBOutlet weak var constraintBottomStackTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomStackLeading: NSLayoutConstraint!
    
    // Design for popUp view1
    
    @IBOutlet weak var viewForInstruction: UIView!
    @IBOutlet weak var subViewForInstruction: UIView!
    
    @IBOutlet weak var imgSand: UIImageView!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var imgLocation: UIImageView!
    
    
    // Design for popUp view2
    
    
    @IBOutlet weak var viewPopUp: UIView!
    
    @IBOutlet weak var viewSubViewPopUp: UIView!
    
    @IBOutlet weak var lblLoadOfLoad: UILabel!
    
    @IBOutlet weak var btnLocationShowOtlt: UIButton!
    
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
    var isRepeatTimer: Bool = true
    
    
    var loginUserData:LoggedInUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewSubViewPopUp.layer.cornerRadius = 10
        self.viewSubViewPopUp.layer.masksToBounds = true
        
        self.subViewForInstruction.layer.cornerRadius = 10
        self.subViewForInstruction.layer.masksToBounds = true
        
        self.imgSand.layer.cornerRadius = 25
        self.imgCamera.layer.cornerRadius = 25
        self.imgLocation.layer.cornerRadius = 25
        
        self.imgSand.layer.masksToBounds = true
        self.imgCamera.layer.masksToBounds = true
        self.imgLocation.layer.masksToBounds = true
        
        if let myImage = UIImage(named: "camera") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            self.imgCamera.image = tintableImage
        
        }
        self.imgCamera.tintColor = UIColor.black
        
        self.tblView.register(UINib(nibName: "ConfirmationHeaderCell", bundle: nil), forCellReuseIdentifier: "ConfirmationHeaderCell")
        self.tblView.register(UINib(nibName: "JobLaterCell", bundle: nil), forCellReuseIdentifier: "JobLaterCell")
        self.tblView.register(UINib(nibName: "ConfirmationRowCell", bundle: nil), forCellReuseIdentifier: "ConfirmationRowCell")
        self.tblView.register(UINib(nibName: "JobLaterCellMain", bundle: nil), forCellReuseIdentifier: "JobLaterCellMain")
        
        self.subViewPopUpForCancellation.layer.cornerRadius = 5
        self.subViewPopUpForCancellation.layer.masksToBounds = true
        
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {
            return
        }
        
        if(!self.isFromNotification)
        {
        self.CheckAndDesignScreen()
        }
        if(self.isFromNotification)
        {
           self.manageTimerScreen()
        }
        
        
        self.CalculateHeightOfScreen()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
    }
    @IBAction func actionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
   
    
    @IBAction func actionAcceptOrder(_ sender: Any)
    {
        if(self.isFromNotification)
        {
                self.acceptOrDeclineRequest(strStatusSendInApi:"true")
        }
        else
        {
            print("Cancel Order")
            self.viewPopUpForCancellation.isHidden = false
        }
    }
    
    @IBAction func actionTrackOrder(_ sender: Any)
    {
        if(self.isFromNotification)
        {
            let alertMessage = UIAlertController(title:"Alert", message: "Are you sure you want to decline job? ", preferredStyle: UIAlertControllerStyle.alert)
            alertMessage.addAction(UIAlertAction(title:"No", style: UIAlertActionStyle.default, handler: nil))
            
            let buttonYes = UIAlertAction(title: "Yes" , style: .default) { (_ action) in
                self.acceptOrDeclineRequest(strStatusSendInApi:"false")
                
            }
            buttonYes.setValue(UIColor.red, forKey: "titleTextColor")
            alertMessage.addAction(buttonYes)
            
            let delegate=UIApplication.shared.delegate as! AppDelegate
            self.present(alertMessage, animated: true, completion: nil)
            
        }
        else
        {
            
            let trackOrder = TrackDriverVC.init(nibName: "TrackDriverVC", bundle: nil)
                trackOrder.tracking_Id = "\(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)"//dictBillDetails.mutableCopy() as! NSMutableDictionary
                self.navigationController?.pushViewController(trackOrder, animated: true)
                print("Track JOB")
            
        }
    }
    
    @IBAction func actionApplyPromoCode(_ sender: Any)
    {
        
    }
    
   
    @IBAction func actionNext(_ sender: Any)
    {
        
    }
    
    //# Mark:- Button actions Inside Pop Up
    
    
    
    @IBAction func actionLocationShow(_ sender: Any)
    {
        let primaryContactFullAddress  = self.btnLocationShowOtlt.titleLabel?.text ?? ""
        
        let testURL: NSURL = NSURL(string: "comgooglemaps-x-callback://")!
        if UIApplication.shared.canOpenURL(URL(string: "https://maps.google.com")!) {
            var escapedString = primaryContactFullAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let directionsRequest = "\("comgooglemaps-x-callback://?daddr=")\(escapedString!)"
            
            let directionsURL = URL(string: directionsRequest)!
            UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
            print("Google map.")
        
        } else {
           let str =  "\("http://maps.apple.com/?saddr=")\(primaryContactFullAddress)"
            var escapedString = str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let directionsURL = URL(string: escapedString!)!
            UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
            print("Apple map.")
        }
    }
    
    @IBAction func actionNextInstructionPopUp(_ sender: Any)
    {
        self.viewForInstruction.isHidden = true
        UIView.animate(withDuration: 0.25, animations: {
            self.viewPopUp.isHidden = false
            self.viewSubViewPopUp.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
       
    }
    
    @IBAction func actionNextFromPopUpScreen(_ sender: Any)
    {
        self.viewForInstruction.isHidden = false
         self.viewForInstruction.isHidden = true
        let vcComplete = LoadReceivedVC.init(nibName: "LoadReceivedVC", bundle: nil)
        vcComplete.dictBillDetails = self.dictBillDetails.mutableCopy() as! NSMutableDictionary
        self.navigationController?.pushViewController(vcComplete, animated: true)
    }
    
    
    @IBAction func ActionOkOnCancellationPopup(_ sender: Any)
    {
        self.viewPopUpForCancellation.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionCancelOnCancellationPopup(_ sender: Any)
    {
        self.viewPopUpForCancellation.isHidden = true
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
    
    
    func CheckAndDesignScreen()
    {
       self.lblPurchaseHistory.text = "PURCHASE ORDER"
        self.lblPickupLocation.text = "JOBSITE LOCATION"
    }
    func acceptOrDeclineRequest(strStatusSendInApi: String)
    {
        print("Accept Request")
       
        let params = [
            "user_id":self.dictBillDetails.value(forKey: "user_id") as! String,
            "driver_id":self.dictBillDetails.value(forKey: "driver_id") as! String,//self.loginUserData.user_id!,
            "acceptance":strStatusSendInApi,
            "tracking_id":String(self.dictBillDetails.value(forKey: "id") as! Int),
            "access_token":self.loginUserData.access_token!,
            "refresh_token":self.loginUserData.refresh_token!
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
                    if(strStatusSendInApi == "true")
                    {
                        UIView.animate(withDuration: 0.25, animations: {
                            self.viewForInstruction.isHidden = false
                            self.subViewForInstruction.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            self.timer.invalidate()
                            self.isRepeatTimer = false
                            
                            
                        });
                    }
                    else
                    {
                    self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                })
                break
            }
            
        }
        
    }
    
    func CalculateHeightOfScreen()
    {

            self.viewTimerHeightConstraint.constant = 0
                        self.greenLblbView.alpha = 0
            let strJobType =  ((self.dictConfirmation.value(forKey: "bill_details") as? NSDictionary)?.value(forKey: "job_type") as? String)?.uppercased()
        
        let totalNeedToIncreaseHeight = (self.arrConfirmation.count * 80)
        self.tblViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
//        self.ConstraintviewHeightTotalCalculation.constant = CGFloat(viewHeightForTotal)
        self.superViewOfTableViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
        self.secondViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
        self.mainViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
        self.tblView.reloadData()
        self.ShowDataOnSreen()
    }
    
    func setJobTypeWithTime(dict:NSDictionary) -> NSAttributedString
    {
        let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

        let moment = dict.value(forKey: "later_start") as? String
        let ddd = moment!
        let fullDate =  Date(timeIntervalSince1970: TimeInterval(ddd)!)
        let time = dateFormatterPrint.string(from: fullDate)
        let strFullDate = time
        
        let strJobType = (dict.value(forKey: "job_type") as? String)?.uppercased() ?? ""
        let strType = "\(strJobType), \((dict.value(forKey: "type") as? String)?.uppercased() ?? "NOW")"
        
        let strLater_Start = dict.value(forKey: "later_start") as? String ?? "0"
        let strLater_End = dict.value(forKey: "later_end") as? String ?? "0"

        let later_Start_Date =  self.dateFromMilliseconds(selectedTimeStamp: Int(strLater_Start)!)
        let later_End_Date =  self.dateFromMilliseconds(selectedTimeStamp: Int(strLater_End)!)
        dateFormatterPrint.dateFormat = "hh:mm a"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

        let later_Start_Str = dateFormatterPrint.string(from: later_Start_Date)
        let later_End_str = dateFormatterPrint.string(from: later_End_Date)
        let later_Start = later_Start_Str
        let later_End = later_End_str
        let strBetweenDates = "\n\("Between ") \(later_Start) \(" - ")\(later_End)"
        
        var semiDetail = "\(strFullDate)\(strBetweenDates)"
        var strTypeWithSpace = "\(strType)\(", ")"
        
        if((dict.value(forKey: "type") as? String)?.uppercased() == "NOW")
        {
            let dateFormatterPrint1 = DateFormatter()
            dateFormatterPrint1.dateFormat = "MMMM dd, yyyy"
            dateFormatterPrint1.locale = Locale(identifier: "en_US_POSIX")

            semiDetail = ", \(dateFormatterPrint1.string(from: Date()))"
            strTypeWithSpace = strType
        }
        
        let attr = self.attributeDtailsBold(strBold: strTypeWithSpace, strNormal: semiDetail)
        return attr
    }
    
    func ShowDataOnSreen()
    {
        let dictt = self.dictConfirmation.value(forKey: "bill_details") as! NSDictionary
        self.dictBillDetails = dictt.mutableCopy() as! NSMutableDictionary
     
        let dropLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_latitude") as! String)!
        let dropLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_longitude") as! String)!
        let pickLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_latitude") as! String)!
        let pickLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_longitude") as! String)!
        
        let coordinate₀ = CLLocation(latitude: dropLat, longitude: dropLong)
        let coordinate₁ = CLLocation(latitude: pickLat, longitude: pickLong)
        
        let distanceInMilesInDouble = Double(((coordinate₀.distance(from: coordinate₁)/1000)*0.621371)) // result is in miles
//        let distanceInMilesRound = Double(round(1000*distanceInMilesInDouble)/100)
//        let distanceInMiles = String(distanceInMilesRound)

        let doubleStr = String(format: "%.2f", distanceInMilesInDouble)
        
        let distanceInMilesRound = Double(doubleStr)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

        let moment = self.dictBillDetails.value(forKey: "moment") as? String
        let ddd = moment as! String
        let fullDate =  Date(timeIntervalSince1970: TimeInterval(ddd)!)
        let time = dateFormatterPrint.string(from: fullDate)
    self.btnchangeTimeOfRequestShowOtlt.setAttributedTitle(self.setJobTypeWithTime(dict:dictt), for: .normal)
        self.btnchangeTimeOfRequestShowOtlt.titleLabel?.lineBreakMode = .byWordWrapping
        self.btnchangeTimeOfRequestShowOtlt.titleLabel?.lineBreakMode = .byWordWrapping

        let bill_Id = "\(TYW_ID_SUFFIX)\(String(self.dictBillDetails.value(forKey: "bill_no") as? String ?? ""))"
        self.btnOrderIdOtlt.setTitle( bill_Id, for: .normal)
        
        self.lblTotalLoads.text = self.dictBillDetails.value(forKey: "total_loads") as? String ?? ""
        self.lblTotalTons.text = self.dictBillDetails.value(forKey: "total_tons") as? String ?? ""
//        self.lblTotalMiles.text = distanceInMiles
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        
        let bAmount = self.dictBillDetails.value(forKey: "bill_amount") as? String ?? "0"
        let txAmount = self.dictBillDetails.value(forKey: "tax_amount") as? String ?? "0"
        let totlAmount = self.dictBillDetails.value(forKey: "total_amount") as? String ?? "0"

        let billAmount1 = numberFormatter.string(from: NSNumber(value: Double(bAmount)!)) ?? bAmount
        let taxAmount1 = numberFormatter.string(from: NSNumber(value: Double(txAmount)!)) ?? txAmount
        //self.total_amount = "1999.33"
        let totalAmount1 = numberFormatter.string(from: NSNumber(value: Double(totlAmount)!)) ?? totlAmount

        var billAmount = String(format: "%.2f", Double(billAmount1) ?? 0)
        var taxAmount = String(format: "%.2f", Double(taxAmount1) ?? 0)
        var totalAmount = String(format: "%.2f", Double(totalAmount1) ?? 0)


        if billAmount1.contains(",") && billAmount1.contains(".") {
         billAmount = billAmount1
        } else if billAmount1.contains(",") && !billAmount1.contains(".") {
         billAmount = String(format: "%@.00", billAmount1)
        }
        
        let strFinalAmount = "\(billAmount)"
        if let count = strFinalAmount.components(separatedBy: ".").last?.count {
            if count != 2 {
                billAmount = String(format: "%@0", billAmount)
            }
        }

        if taxAmount1.contains(",") && taxAmount1.contains(".") {
         taxAmount = taxAmount1
        } else if taxAmount1.contains(",") && !taxAmount1.contains(".") {
         taxAmount = String(format: "%@.00", taxAmount1)
        }
        
        let strFinalAmount1 = "\(taxAmount)"
        if let count = strFinalAmount1.components(separatedBy: ".").last?.count {
            if count != 2 {
                taxAmount = String(format: "%@0", taxAmount)
            }
        }

        if totalAmount1.contains(",") && totalAmount1.contains(".") {
         totalAmount = totalAmount1
        } else if totalAmount1.contains(",") && !totalAmount1.contains(".") {
         totalAmount = String(format: "%@.00", totalAmount1)
        }
        
        let strFinalAmount2 = "\(totalAmount)"
        if let count = strFinalAmount2.components(separatedBy: ".").last?.count {
            if count != 2 {
                totalAmount = String(format: "%@0", totalAmount)
            }
        }

        self.lblSubTotal.text = "\("$")\(billAmount)"
        self.lblTax.text = "\("$")\(taxAmount)"
        self.lblTotal.text = "\("$")\(totalAmount)"
        
        
//        self.lblSubTotal.text = "\("$")\(self.dictBillDetails.value(forKey: "bill_amount") as? String ?? "")"
//        self.lblTax.text = "\("$")\(self.dictBillDetails.value(forKey: "tax_amount") as? String ?? "")"
        let str_total_amount = self.dictBillDetails.value(forKey: "total_amount") as? String ?? ""
        let totalAmt = Double(str_total_amount)
//        self.lblTotal.text = "\("$")\(String(format: "%.2f", totalAmt!))"
        
        self.btnPickLocationOtlt.titleLabel!.lineBreakMode = .byWordWrapping
        self.btnPickLocationOtlt.setTitle(self.dictBillDetails.value(forKey: "drop_address") as? String ?? "", for: .normal)
        
    // for popUp Location btn
        
        let strLocation = self.dictBillDetails.value(forKey: "drop_address") as? String ?? ""
        
        let attrs = NSAttributedString(string: strLocation,
                                       attributes:
            [NSAttributedStringKey.foregroundColor: UIColor(red:20.0/255.0, green:104.0/255.0, blue:215.0/255.0, alpha:1.0),
             NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0),
             NSAttributedStringKey.underlineColor: UIColor(red:20.0/255.0, green:104.0/255.0, blue:215.0/255.0, alpha:1.0),
             NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        
        self.btnLocationShowOtlt.titleLabel!.lineBreakMode = .byWordWrapping
        self.btnLocationShowOtlt.setAttributedTitle(attrs, for: .normal)
        
        
        if (self.dictBillDetails.value(forKey: "type") as! String) == "now"{
            return
        }
        
        let laterDate = self.dictBillDetails.value(forKey: "later_start") as? String
        let laterDateDD = laterDate as! String
        let laterJobTime =  Date(timeIntervalSince1970: TimeInterval(laterDateDD)!)
        let laterJobDDMMYY = dateFormatterPrint.string(from: laterJobTime)
        let todayDate =  Date()
        let todayDDMMYY = dateFormatterPrint.string(from: todayDate)
        
//        if(laterJobDDMMYY > todayDDMMYY)
//        {
//            
//            //            self.stackViewBottomOtlt.alignment = .center
//            self.constraintBottomStackLeading.constant = (UIScreen.main.bounds.size.width-160)/2
//            self.constraintBottomStackTrailing.constant = (UIScreen.main.bounds.size.width-160)/2
//            self.btnTrackOrderOtlt.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
//            //self.btnTrackOrderOtlt.alpha = 0
//            self.btnTrackOrderOtlt.isHidden = false
//        }
        
      let later_track_job_button = self.dictBillDetails.value(forKey: "later_track_job_button") as? Int ?? 10
        
        if later_track_job_button == 0 {
         self.btnTrackOrderOtlt.isEnabled = false
            self.btnTrackOrderOtlt.borderColor = UIColor.gray
        } else {
            self.btnTrackOrderOtlt.isEnabled = true
            self.btnTrackOrderOtlt.borderColor = UIColor.init(red: 156.0/255.0, green: 190.0/255.0, blue: 56.0/255.0, alpha: 1)
        }
        
    }
    
    
    //#MARK:- implement timer functionality
    
    func manageTimerScreen()
    {
        print("Accept Request")
        
            self.runTimer()
        
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func runTimer() {
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        //        isTimerRunning = true
    }
    
    @objc func updateTimer() {
        
        if(self.isRepeatTimer)
        {
            if seconds < 1 {
                self.timer.invalidate()
                self.isRepeatTimer = false
                self.view.makeToast("Time is Over For Job Response", duration: 1.0, position: .center)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
                    // Put your code which should be executed with a delay here
                     self.navigationController?.popToRootViewController(animated: true)
                })
               
    //            self.dismiss(animated: true)
                
                //Send alert to indicate time's up.
            } else {
                seconds -= 1
                self.lblTimer.text = timeString(time: TimeInterval(seconds))
            }
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

extension CurrentJobDetailsVC : UITableViewDelegate, UITableViewDataSource
{
    //Mark:- TableView Delegate and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(self.loginUserData.type == "service" && !self.isFromNotification)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobLaterCell") as! JobLaterCell
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationHeaderCell") as! ConfirmationHeaderCell
            return cell
        }
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
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationRowCell", for: indexPath) as! ConfirmationRowCell
        
            let dict = self.arrConfirmation.object(at: indexPath.row) as! NSDictionary
            let imgStr = dict.value(forKey: "material_image") as? String
        
            let imgURL = imgStr  == nil ? "" : imgStr
            cell.imgView.loadImageAsync(with: BSE_URL_LoadMedia+imgURL!, defaultImage: "", size: cell.imgView.frame.size)
        
        let category  = dict.value(forKey: "category") as? String ?? ""
        let name  = dict.value(forKey: "name") as? String ?? ""
        let categoryPrefixwithName = "\(category)\(" ")\(name)"
        
        let strJobType =  ((self.dictConfirmation.value(forKey: "bill_details") as? NSDictionary)?.value(forKey: "job_type") as? String)?.uppercased()
        
            if(strJobType == "HAULING")
            {
                cell.lblMaterialCategory.attributedText = self.attributeDtailsBold(strBold: "Hauling ", strNormal: categoryPrefixwithName)
            }
            else
            {
                cell.lblMaterialCategory.attributedText = self.attributeDtailsBold(strBold: "Delivery ", strNormal: categoryPrefixwithName)

            }
//        if((dict.value(forKey: "category") as? String ?? "").uppercased() == "DIRT")
//        {
//            let tons = ((Int(dict.value(forKey: "tons") as? String ?? "0") ?? 0))
//            //let loads = ((Int(dict.value(forKey: "tons") as? String ?? "0") ?? 0))
//
//            var loads = 1
//
//            if tons > 16 {
//                if (tons % 16 == 0) {
//                    loads = (tons / 16)
//                }
//                else {
//                    loads = (tons / 16);
//                    loads += 1
//                }
//            }
//
//            if(loads == 1)
//            {
//                cell.lblMaterialQuantity.text = "\(loads) \(" Load")"
//            }
//            else
//            {
//                cell.lblMaterialQuantity.text = "\(loads) \(" Loads")"
//            }
////            let loadsInt = Double(loads)
//            guard let pricePerLoad = dict.value(forKey: "price_loads") as? String else{
//                cell.lblMaterialCost.text = "$"
//                return cell
//            }
//            let trimmedString = pricePerLoad.trimmingCharacters(in: CharacterSet.whitespaces)
//
//            let perLoadInDouble = Double(trimmedString)!
//            let totalLoad = Double(loads) * perLoadInDouble
//          //  cell.lblMaterialCost.text = "\("$") \(String(format: "%.2f", totalLoad))"
////            cell.lblMaterialCost.text = dict.value(forKey: "amount") as? String
//           cell.lblMaterialCost.text = "\(Double(dict.value(forKey: "material_amount") as? String ?? "")?.rounded(toPlaces: 2) ?? 0)"
//            return cell
//        }
        guard let pricePerTon = dict.value(forKey: "price_tons") as? String else{
            cell.lblMaterialCost.text = "$"
            return cell
        }
        let tons = dict.value(forKey: "tons") as? String ?? ""
        
        if(Int(tons) ?? 0 > 1)
        {
        cell.lblMaterialQuantity.text = "\(tons) \(" tons")"
        }
        else
        {
            cell.lblMaterialQuantity.text = "\(tons) \(" ton")"
        }
        let trimmedStingTon = pricePerTon.trimmingCharacters(in: CharacterSet.whitespaces)
        let perTonInDouble = Double(trimmedStingTon) ?? 0.0
        let totalTon = Double(tons)! * perTonInDouble
        
       // cell.lblMaterialCost.text = "\("$") \(totalTon)"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true

        
        let billAmount1 = numberFormatter.string(from: NSNumber(value: Double(dict.value(forKey: "material_amount") as? String ?? "")!)) ?? "0"

        var billAmount = String(format: "%.2f", Double(billAmount1) ?? 0)

        if billAmount1.contains(",") && billAmount1.contains(".") {
           billAmount = billAmount1
        } else if billAmount1.contains(",") && !billAmount1.contains(".") {
           billAmount = String(format: "%@.00", billAmount1)
        }
        
        let strFinalAmount2 = "\(billAmount)"
        if let count = strFinalAmount2.components(separatedBy: ".").last?.count {
            if count != 2 {
                billAmount = String(format: "%@0", billAmount)
            }
        }
        
        
         cell.lblMaterialCost.text =  "$\(billAmount)"
        
        let totalTons = Int(tons) ?? 0

        if((self.dictBillDetails.value(forKeyPath: "job_type") as? String ?? "").uppercased() == "HAULING"){
            let tons = (totalTons)
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
        } else{
            
//            if((dict.value(forKey: "category") as? String ?? "").uppercased() == "DIRT") {
//                let tons = (totalTons)
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
//            }
            
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
        
         //cell.lblMaterialCost.text = "\(Double(dict.value(forKey: "material_amount") as? String ?? "")?.rounded(toPlaces: 2) ?? 0)"
        return cell
        
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    //    {
    //
    //
    //
    //    }
    
   
}
