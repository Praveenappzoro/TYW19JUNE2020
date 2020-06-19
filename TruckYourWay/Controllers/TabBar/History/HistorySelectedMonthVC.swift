//
//  HistorySelectedMonthVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 11/16/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import CoreLocation
class HistorySelectedMonthVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var btnMonthName: UIButton!
    
    var selectedMonth : String = ""
    var arrJobs: NSMutableArray = []
    let dateFormatterPrint = DateFormatter()
    var loginUserData:LoggedInUser!
    var prevColor = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let strTitle = "\(self.selectedMonth) \("'s History")"
        let strTitle = "JOB HISTORY"
        self.btnMonthName.setTitle(strTitle, for: .normal)
        self.tblView.register(UINib(nibName: "ConsumerHistoryJobsDriverCell", bundle: nil), forCellReuseIdentifier: "ConsumerHistoryJobsDriverCell")
        
        self.tblView.register(UINib(nibName: "ConsumerCompletedJobsCell", bundle: nil), forCellReuseIdentifier: "ConsumerCompletedJobsCell")
        
        self.tblView.estimatedRowHeight = 200
        self.tblView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        self.getHistoryByMonth()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblView.reloadData()
        self.navigationController?.navigationBar.isHidden = true
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ActionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getHistoryByMonth()
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
        
        let parametersUser = [
            "user_id":self.loginUserData.user_id ?? "",
            "month":self.selectedMonth,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
        
        let parametersDriver = [
            "driver_id":self.loginUserData.user_id ?? "",
            "month":self.selectedMonth,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
        
        self.startAnimating("")
        let path = self.loginUserData.type == "service" ? BSE_URL_GET_DRIVER_MONTH_JOBS : BSE_URL_GET_CONSUMER_MONTH_JOBS
        
        APIManager.sharedInstance.getArrayDataFromAPI(path, .post, self.loginUserData.type == "service" ? parametersDriver : parametersUser, { (result, data, json, error, msg) in
            
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
                    
                    if(total>0)
                    {
                        let arr = jsonResponse
                        self.arrJobs = arr.mutableCopy() as! NSMutableArray
                        self.determineOrderColors()
                        self.tblView.reloadData()
                    }
                    
                })
            }
        })
    }
    
    func dateFromMilliseconds(selectedTimeStamp:Int) -> Date {
        let date : NSDate! = NSDate(timeIntervalSince1970:Double(selectedTimeStamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY  hh:mm:ss a"
        dateFormatter.timeZone = TimeZone.current
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
        let timeStamp = dateFormatter.string(from: date as Date)
        return dateFormatter.date( from: timeStamp )!
    }
    
    func getMaterialsName(currentIndex:Int) -> String
    {
        let strMutableCategory  : NSMutableString = ""
        
        guard let dict = self.arrJobs.object(at: currentIndex) as? NSDictionary else
        {
            return " "
        }
        guard let arrMaterial = dict.value(forKey: "materials") as? NSArray else {
            return " "
        }
        
        for item in arrMaterial
        {
            let dic = item as! NSDictionary
            guard let strCategory = dic.value(forKey: "category") else
            {
                return " "
            }
            guard let strName = dic.value(forKey: "name") else
            {
                return " "
            }
            if(arrMaterial.count <= 1)
            {
                let fullCategoryWithName = "\(strCategory)\(" ") \(strName)"
                strMutableCategory.append(fullCategoryWithName )
            }
            else
            {
                let fullCategoryWithName = "\(strCategory)\(" ") \(strName)\(", ")"
                strMutableCategory.append(fullCategoryWithName )
            }
        }
        
        var strCat = (strMutableCategory as String).trimmingCharacters(in: .whitespaces)
        if strCat.last == "," {
            strCat.removeLast()
        }
        
        return strCat
        //return strMutableCategory as String
    }
    
    func setJobTypeWithTime(dict:NSDictionary) -> NSAttributedString
    {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

        let moment = dict.value(forKey: "later_start") as? String
        let ddd = moment as! String
        let fullDate =  Date(timeIntervalSince1970: TimeInterval(ddd)!)
        let time = dateFormatterPrint.string(from: fullDate)
        let strFullDate = time
        
        let strJobType = (dict.value(forKey: "job_type") as? String)?.uppercased() ?? ""
        let strType = "\(strJobType)\(",") \((dict.value(forKey: "type") as? String)?.uppercased() ?? "NOW")"
        
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
            semiDetail = ""
            strTypeWithSpace = strType
        }
        
        let attr = self.attributeDtailsBold(strBold: strTypeWithSpace, strNormal: semiDetail)
        return attr
    }
}

extension HistorySelectedMonthVC: UITableViewDelegate, UITableViewDataSource
{
    //Mark:- TableView Delegate and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrJobs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.loginUserData.type != "service")
        {
         //   let cellDriver = tableView.dequeueReusableCell(withIdentifier: "ConsumerCompletedJobsCell", for: indexPath) as! ConsumerCompletedJobsCell
        //    dateFormatterPrint.dateFormat = "MMMM dd, YYYY"
            
            var cellDriver: ConsumerCompletedJobsCell! = tableView.dequeueReusableCell(withIdentifier: "ConsumerCompletedJobsCell") as? ConsumerCompletedJobsCell
            if cellDriver == nil {
                tableView.register(UINib(nibName: "ConsumerCompletedJobsCell", bundle: nil), forCellReuseIdentifier: "ConsumerCompletedJobsCell")
                cellDriver = tableView.dequeueReusableCell(withIdentifier: "ConsumerCompletedJobsCell") as? ConsumerCompletedJobsCell
            }
            
            
            let dict = self.arrJobs.object(at: indexPath.row) as! NSDictionary
            let dictDetails = dict.value(forKey: "bill_details") as! NSDictionary
            
            let moment = dictDetails.value(forKey: "moment") as? String//dictDetails.value(forKey: "moment") as? String
            let ddd = Double(moment as! String)
            let fullDate =  Date(timeIntervalSince1970:Double(ddd!))
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
            dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

            let time = dateFormatterPrint.string(from: fullDate)
            let strFullDate = time
            var strTypeWithSpace = ""
            let strJobType = (dictDetails.value(forKey: "type") as? String)?.uppercased() ?? "NOW"

            let strJob = (dictDetails.value(forKey: "job_type") as? String)?.uppercased() ?? "DELIVERY"
            
            let strType = "\(strJob) \((dictDetails.value(forKey: "type") as? String)?.uppercased() ?? "NOW")"
            let semiDetail = strType.uppercased() + ", " + strFullDate

            if strJobType == "LATER" {

                let strLater_S = dictDetails.value(forKey: "later_start") as? String ?? ""
                let strLater_E = dictDetails.value(forKey: "later_end") as? String ?? ""
                let strLater_Start = strLater_S as! String
                let strLater_End = strLater_E as! String
                
                let later_Start_Date =  self.dateFromMilliseconds(selectedTimeStamp: Int(strLater_Start)!)
                let later_End_Date =  self.dateFromMilliseconds(selectedTimeStamp: Int(strLater_End)!)
                
                //        dateFormatterPrint.dateFormat = "dd MMMM YYYY  hh:mm:ss a"
                dateFormatterPrint.dateFormat = "hh:mm a"
                dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
                let later_Start_Str = dateFormatterPrint.string(from: later_Start_Date)
                let later_End_str = dateFormatterPrint.string(from: later_End_Date)
                let later_Start = later_Start_Str as! String
                let later_End = later_End_str as! String
                
                let strBetweenDates = "\(later_Start) \(" - ")\(later_End)"
                
                cellDriver.stackViewBetween.isHidden = false

                cellDriver.lblBetweenValue.text = strBetweenDates
            } else {
                cellDriver.stackViewBetween.isHidden = true
            }
           
            let strOrderID = "\(TYW_ID_SUFFIX)\( dictDetails.value(forKey: "bill_no") as? String ?? "")"
            let strTotalTons = dictDetails.value(forKey: "total_tons") as? String ?? ""
            let strTotalLoads = dictDetails.value(forKey: "total_loads") as? String ?? ""
            let strMaterial =  self.getMaterialsName(currentIndex: indexPath.row)
//            let strAddress = dictDetails.value(forKey: "pickup_address") as? String ?? ""
            let strAddress = dictDetails.value(forKey: "drop_address") as? String ?? ""
            let strTotalAmount = dictDetails.value(forKey: "total_amount") as? String ?? ""
            
            let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
            let attributedString = NSMutableAttributedString(string:semiDetail, attributes:attrs)
            
            cellDriver.lblDeliveryTypeAndDate.attributedText = attributedString
            cellDriver.lblOrderID.text = strOrderID
            
                 let numberFormatter = NumberFormatter()
                 numberFormatter.numberStyle = .decimal
                 numberFormatter.usesGroupingSeparator = true
             
                 let strAmount = Double(strTotalAmount) ?? 0.0
                 let totalAmount1 = numberFormatter.string(from: NSNumber(value: strAmount)) ?? strTotalAmount
                    
                 var totalAmount = String(format: "%.2f", Double(totalAmount1) ?? 0)
            
                 if totalAmount1.contains(",") && totalAmount1.contains(".") {
                     totalAmount = totalAmount1
                 } else if totalAmount1.contains(",") && !totalAmount1.contains(".") {
                     totalAmount = String(format: "%@.00", totalAmount1)
                 }
             
                let strFinalAmount = "\(totalAmount)"
                if let count = strFinalAmount.components(separatedBy: ".").last?.count {
                    if count != 2 {
                        totalAmount = String(format: "%@0", totalAmount)
                    }
                }
                 cellDriver.lblAmountPaid.text = "$\(totalAmount)"
            
            
            
//            cellDriver.lblAmountPaid.text = "$\(Double(strTotalAmount)?.rounded(toPlaces: 2) ?? 0)"
            cellDriver.lblTotalTons.text = strTotalTons
            cellDriver.lblTotalLoads.text = strTotalLoads
            cellDriver.lblMaterials.text = strMaterial
            cellDriver.lblAddress.text = strAddress
            cellDriver.lblTruck.text = dictDetails.value(forKey: "truck_number") as? String ?? ""
            cellDriver.layoutIfNeeded()
            return cellDriver
        }
        else
        {
            var cellDriver: ConsumerHistoryJobsDriverCell! = tableView.dequeueReusableCell(withIdentifier: "ConsumerHistoryJobsDriverCell") as? ConsumerHistoryJobsDriverCell
            if cellDriver == nil {
                tableView.register(UINib(nibName: "ConsumerHistoryJobsDriverCell", bundle: nil), forCellReuseIdentifier: "ConsumerHistoryJobsDriverCell")
                cellDriver = tableView.dequeueReusableCell(withIdentifier: "ConsumerHistoryJobsDriverCell") as? ConsumerHistoryJobsDriverCell
            }
            
           // let cellDriver = tableView.dequeueReusableCell(withIdentifier: , for: indexPath) as! ConsumerHistoryJobsDriverCell
            dateFormatterPrint.dateFormat = "MMMM dd, YYYY"
            dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

            let dict = self.arrJobs.object(at: indexPath.row) as! NSDictionary
            let dictDetails = dict.value(forKey: "bill_details") as! NSDictionary
            
            let moment = dictDetails.value(forKey: "moment") as? String//dictDetails.value(forKey: "moment") as? String
            let ddd = Double(moment as! String)
            let fullDate =  Date(timeIntervalSince1970:Double(ddd!))
            let time = dateFormatterPrint.string(from: fullDate)
            
            let strJob = (dictDetails.value(forKey: "job_type") as? String)?.uppercased() ?? "DELIVERY"
            let strType = "\(strJob) \((dictDetails.value(forKey: "type") as? String)?.uppercased() ?? "NOW")"
            var semiDetail = strType.uppercased() + ", " + time
            let strJobType = (dictDetails.value(forKey: "type") as? String)?.uppercased() ?? "NOW"

            if strJobType == "LATER" {
                
                let moment1 = dictDetails.value(forKey: "later_start") as? String//dictDetails.value(forKey: "moment") as? String
                let ddd1 = Double(moment1 as! String)
                let fullDate1 =  Date(timeIntervalSince1970:Double(ddd1!))
                let time1 = dateFormatterPrint.string(from: fullDate1)

                semiDetail = strType.uppercased() + ", " + time1

                let strLater_S = dictDetails.value(forKey: "later_start") as? String ?? ""
                let strLater_E = dictDetails.value(forKey: "later_end") as? String ?? ""
                let strLater_Start = strLater_S as! String
                let strLater_End = strLater_E as! String
                
                let later_Start_Date =  self.dateFromMilliseconds(selectedTimeStamp: Int(strLater_Start)!)
                let later_End_Date =  self.dateFromMilliseconds(selectedTimeStamp: Int(strLater_End)!)
                
                //        dateFormatterPrint.dateFormat = "dd MMMM YYYY  hh:mm:ss a"
                dateFormatterPrint.dateFormat = "hh:mm a"
                dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
                let later_Start_Str = dateFormatterPrint.string(from: later_Start_Date)
                let later_End_str = dateFormatterPrint.string(from: later_End_Date)
                let later_Start = later_Start_Str as! String
                let later_End = later_End_str as! String
                
                let strBetweenDates = "\(later_Start) \(" - ")\(later_End)"
                
                cellDriver.stackViewBetween.isHidden = false
                cellDriver.lblBetweenValue.text = strBetweenDates
            } else {
                cellDriver.stackViewBetween.isHidden = true
            }
            
            
            let strOrderID = "\(TYW_ID_SUFFIX)\(dictDetails.value(forKey: "bill_no") as? String ?? "")"
            let strTotalTons = dictDetails.value(forKey: "total_tons") as? String ?? ""
            let strTotalLoads = dictDetails.value(forKey: "total_loads") as? String ?? ""
            let strMaterial =  self.getMaterialsName(currentIndex: indexPath.row)
//            let strAddress = dictDetails.value(forKey: "pickup_address") as? String ?? ""

            let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
            let attributedString = NSMutableAttributedString(string:semiDetail, attributes:attrs)
            
            cellDriver.lblDeliveryTypeAndDate.attributedText = attributedString
            cellDriver.lblOrderID.text = strOrderID
            cellDriver.lblTotalTons.text = strTotalTons
            cellDriver.lblTotalLoads.text = strTotalLoads
            cellDriver.lblMaterials.text = strMaterial
            
//            let pick_Lat = dictDetails.value(forKey: "pickup_latitude") as? String ?? "26.901690"
//            let pick_Long = dictDetails.value(forKey: "pickup_longitude") as? String ?? "75.779610"
//
//            let drop_Lat = dictDetails.value(forKey: "drop_latitude") as? String ?? "26.901690"
//            let drop_Long = dictDetails.value(forKey: "drop_longitude") as? String ?? "75.779610"
//
//            let coordinate₀ = CLLocation(latitude: Double(pick_Lat) ?? 26.901690, longitude: Double(pick_Long) ?? 75.779610)
//            let coordinate₁ = CLLocation(latitude: Double(drop_Lat) ?? 26.901690, longitude: Double(drop_Long) ?? 75.779610)
//
//            let distanceInMilesInDouble = Double(((coordinate₀.distance(from: coordinate₁)/1000)*0.621371)) * (Double(dictDetails.value(forKey: "total_loads") as? String ?? "") ?? 0) // result is in
//            let distanceInMilesRound = String(format: "%.2f", distanceInMilesInDouble)
            
            let milage = dictDetails.value(forKey: "mileage") as? String ?? ""
            cellDriver.lblTotalMiles.text = milage
            cellDriver.layoutIfNeeded()

            return cellDriver
        }

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let greenColor = #colorLiteral(red: 0.6709875464, green: 0.7787114978, blue: 0.2804822624, alpha: 1)
        let orangeColor = #colorLiteral(red: 1, green: 0.5335581899, blue: 0.1756182015, alpha: 1)
        
        if(self.loginUserData.type != "service") {
            let cellDriver = cell as! ConsumerCompletedJobsCell

            let dict = self.arrJobs.object(at: indexPath.row) as!  NSDictionary

            if (dict["color"] as! Int) == 0 {
                cellDriver.btnNextOtlt.backgroundColor = greenColor
            } else {
                cellDriver.btnNextOtlt.backgroundColor = orangeColor
            }
        } else {
            let cellDriver = cell as! ConsumerHistoryJobsDriverCell
            let dict = self.arrJobs.object(at: indexPath.row) as!  NSDictionary

            if (dict["color"] as! Int) == 0 {
                cellDriver.btnNextOtlt.backgroundColor = greenColor
            } else {
                cellDriver.btnNextOtlt.backgroundColor = orangeColor
            }
        }
        
        //KRISHNA
//        if indexPath.row == 0 {
//            prevColor = 0
//            cellDriver.btnNextOtlt.backgroundColor = #colorLiteral(red: 0.6709875464, green: 0.7787114978, blue: 0.2804822624, alpha: 1)
//        } else {
//
//            let greenColor = #colorLiteral(red: 0.6709875464, green: 0.7787114978, blue: 0.2804822624, alpha: 1)
//            let orangeColor = #colorLiteral(red: 1, green: 0.5335581899, blue: 0.1756182015, alpha: 1)
//
//            let dict = self.arrJobs.object(at: indexPath.row) as!  NSDictionary
//            let dictDetails = dict.value(forKey: "bill_details") as! NSDictionary
//
//            let dictPrev = self.arrJobs.object(at: indexPath.row - 1) as!  NSDictionary
//            let dictDetailsPrev = dictPrev.value(forKey: "bill_details") as! NSDictionary
//
//            if (dictDetails.value(forKey: "bill_no") as? String) == dictDetailsPrev.value(forKey: "bill_no") as? String {
//                if prevColor == 0 {
//                    prevColor = 0
//                    cellDriver.btnNextOtlt.backgroundColor = greenColor
//                } else {
//                    prevColor = 1
//                    cellDriver.btnNextOtlt.backgroundColor = orangeColor
//                }
//            } else {
//                if prevColor == 1 {
//                    prevColor = 0
//                    cellDriver.btnNextOtlt.backgroundColor = greenColor
//                } else {
//                    prevColor = 1
//                    cellDriver.btnNextOtlt.backgroundColor = orangeColor
//                }
//            }
//        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let dict = self.arrJobs.object(at: indexPath.row) as! NSDictionary
        
        guard let arr = dict.value(forKey: "materials") else {
            return
        }
        let arrMaterial = arr as! NSArray
        if(self.loginUserData.type == "service")
        {
            let historyJobDetail = HistoryJobDetails.init(nibName:"HistoryJobDetails" , bundle: nil)
            historyJobDetail.dictConfirmation = dict.mutableCopy() as! NSMutableDictionary
            historyJobDetail.arrConfirmation = arrMaterial.mutableCopy() as! NSMutableArray
            self.navigationController?.pushViewController(historyJobDetail, animated: true)
        }
        else
        {
            let historyJobDetail = HistoryDetailsForConsumerVC.init(nibName:"HistoryDetailsForConsumerVC" , bundle: nil)
            historyJobDetail.dictConfirmation = dict.mutableCopy() as! NSMutableDictionary
            historyJobDetail.arrConfirmation = arrMaterial.mutableCopy() as! NSMutableArray
            
            self.navigationController?.pushViewController(historyJobDetail, animated: true)
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
    
    func determineOrderColors() {

        for j in 0...self.arrJobs.count - 1 {
            let dictO = self.arrJobs.object(at: j) as!  NSDictionary
            let dict = dictO.mutableCopy() as! NSMutableDictionary

            let dictDetails = dict.value(forKey: "bill_details") as! NSDictionary
            let oIDLocal = dictDetails.value(forKey: "bill_no") as? String
            
            if j == 0 {
                dict["color"] = 0
            } else {
                let dictPO = self.arrJobs.object(at: j - 1) as!  NSDictionary

                let dictP = dictPO.mutableCopy() as!  NSMutableDictionary
                let dictDetailsP = dictP.value(forKey: "bill_details") as! NSDictionary
                let oIDP = dictDetailsP.value(forKey: "bill_no") as? String
                let colorP: Int = dictP["color"] as? Int ?? 0
                if oIDP == oIDLocal {
                    dict["color"] = colorP == 0 ? 0 : 1
                } else {
                    dict["color"] = colorP == 0 ? 1 : 0
                }
            }
            
            self.arrJobs.replaceObject(at: j, with: dict)
        }
        
        tblView.reloadData()
    }
    
}
