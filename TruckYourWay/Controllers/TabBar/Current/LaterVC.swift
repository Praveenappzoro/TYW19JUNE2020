//
//  LaterVC.swift
//  TruckYourWay
//
//  Created by Samradh Agarwal on 04/09/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class LaterVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!

    @IBOutlet weak var lblHintForDriver: UILabel!
    @IBOutlet weak var noJobAvailable: UILabel!
    @IBOutlet weak var lblTitleNowLaterScreen: UILabel!
    
    var arrJobs: NSMutableArray = []
    let dateFormatterPrint = DateFormatter()
    var loginUserData:LoggedInUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.tblView.register(UINib(nibName: "CurrentJobsCell", bundle: nil), forCellReuseIdentifier: "CurrentJobsCell")
        self.tblView.register(UINib(nibName: "DriverLaterJobCell", bundle: nil), forCellReuseIdentifier: "DriverLaterJobCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.initData()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false

         dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
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
    
    
    // MARK:- all manual funcations
    
    func initData()
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
        
        if(self.loginUserData.type == "service")
        {
          self.lblTitleNowLaterScreen.text = "    JOBS FOR LATER"
            
          self.getLaterJobsDriverSide()
        }
        else
        {
            self.lblHintForDriver.text = ""
          self.lblTitleNowLaterScreen.text = "    NOW/LATER JOB(S)"
          self.getJobs()
        }
    }
    
    
    func getLaterJobsDriverSide()
    {
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        let parameters = [
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            "user_id": self.loginUserData.user_id ?? ""
            ] as [String : Any]
        
        self.startAnimating("")
        
        APIManager.sharedInstance.getArrayDataFromAPI(BSE_URL_GET_LATER_JOBS, .post, parameters, { (result, data, json, error, msg) in
            
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
                        self.noJobAvailable.alpha = 0
                        let arr = jsonResponse
                        self.arrJobs = arr.mutableCopy() as! NSMutableArray
                        self.determineOrderColors()
                        self.tblView.reloadData()
                    }
                    else
                    {
                        self.noJobAvailable.alpha = 1
                    }
                })
            }
            
        })
        
    }
    
    func getJobs()
    {
       
        let parameters = [
            "user_id":self.loginUserData.user_id ?? "",
            "type":self.loginUserData.type == "current",
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
        
        self.startAnimating("")
        
        APIManager.sharedInstance.getArrayDataFromAPI(BSE_URL_GET_CONSUMER_JOBS, .post, parameters, { (result, data, json, error, msg) in
            
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
                        self.noJobAvailable.alpha = 0
                        let arr = jsonResponse
                        self.arrJobs = arr.mutableCopy() as! NSMutableArray
                        self.determineOrderColors()
                        self.tblView.reloadData()
                    }
                    else
                    {
                     self.noJobAvailable.alpha = 1
                    }
                })
            }
            
        })
        
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
            let fullCategoryWithName = "\(strCategory)\(" ") \(strName)\(", ")"
            strMutableCategory.append(fullCategoryWithName )
        }
        
       // return strMutableCategory as String
        
        var strCat = (strMutableCategory as String).trimmingCharacters(in: .whitespaces)
        if strCat.last == "," {
            strCat.removeLast()
        }
        
        return strCat
    }
    
    func currentTimeInMiliseconds(selectedDate: Date) -> Int! {
        let currentDate = selectedDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY  hh:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        //        dateFormatter.dateFormat = format
//        if let zone = TimeZone(abbreviation: "GMT-4") {
//            dateFormatter.timeZone = zone
//        }

        let date = dateFormatter.date(from: dateFormatter.string(from: currentDate as Date))
        let nowDouble = date!.timeIntervalSince1970
        return Int(nowDouble)
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

extension LaterVC: UITableViewDelegate, UITableViewDataSource
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let greenColor = #colorLiteral(red: 0.6709875464, green: 0.7787114978, blue: 0.2804822624, alpha: 1)
        let orangeColor = #colorLiteral(red: 1, green: 0.5335581899, blue: 0.1756182015, alpha: 1)
        
            let cellDriver = cell as! DriverLaterJobCell
            
            let dict = self.arrJobs.object(at: indexPath.row) as!  NSDictionary
            
            if (dict["color"] as? Int) == 0 {
                cellDriver.btnNextOtlt.backgroundColor = greenColor
            } else {
                cellDriver.btnNextOtlt.backgroundColor = orangeColor
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if(self.loginUserData.type == "service")
//        {
            let cellDriver = tableView.dequeueReusableCell(withIdentifier: "DriverLaterJobCell", for: indexPath) as! DriverLaterJobCell
        dateFormatterPrint.dateFormat = "MMMM, dd, YYYY"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
        let dict = self.arrJobs.object(at: indexPath.row) as! NSDictionary
        let dictDetails = dict.value(forKey: "bill_details") as! NSDictionary
        
        let truckStart = dictDetails.value(forKey: "truck_number") as? String ?? ""
        
        if(self.loginUserData.type == "service") {
            cellDriver.stackViewTotalPaid.isHidden = true
             cellDriver.lblTruckNo.text = ""
             cellDriver.lblTruckNumberText.text = ""
            // cellDriver.topTruckNumberContraint.constant = 0
             cellDriver.lblTruckNo.isHidden = true
        } else {
            cellDriver.stackViewTotalPaid.isHidden = false
            cellDriver.lblTruckNo.text = "Truck No:"
              cellDriver.lblTruckNumberText.text = truckStart
              cellDriver.lblTruckNo.isHidden = false
            //  cellDriver.topTruckNumberContraint.constant = 10
        }

        let strJob_type = (dictDetails.value(forKey: "job_type") as? String)?.uppercased() ?? ""
            
            var moment = dictDetails.value(forKey: "later_start") as? String
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
            
       
        let strType = "\(strJob_type), \((dictDetails.value(forKey: "type") as? String)?.uppercased() ?? "NOW")"
        
            
        let strLater_S = dictDetails.value(forKey: "later_start") as? String ?? ""
        let strLater_E = dictDetails.value(forKey: "later_end") as? String ?? ""
        
            if((strLater_S == "OPTIONAL" || strLater_E == "OPTIONAL") && strLater_S == "" || strLater_E == "")
            {
                cellDriver.layoutIfNeeded()
                return cellDriver
            }
        
        let strLater_Start = strLater_S
        let strLater_End = strLater_E
        
        let later_Start_Date =  self.dateFromMilliseconds(selectedTimeStamp: Int(strLater_Start)!)
        let later_End_Date =  self.dateFromMilliseconds(selectedTimeStamp: Int(strLater_End)!)
            
        dateFormatterPrint.dateFormat = "hh:mm a"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

        dateFormatterPrint.amSymbol = "AM"
        dateFormatterPrint.pmSymbol = "PM"
        let later_Start_Str = dateFormatterPrint.string(from: later_Start_Date)
        let later_End_str = dateFormatterPrint.string(from: later_End_Date)
        let later_Start = later_Start_Str
        let later_End = later_End_str
        
            
            let strBetweenDates = "\n\("Between") \(later_Start) \(" - ")\(later_End)"
            let strOrderID = "\(TYW_ID_SUFFIX)\( dictDetails.value(forKey: "bill_no") as? String ?? "")"
            let strTotalTons = dictDetails.value(forKey: "total_tons") as? String ?? ""
            let strTotalLoads = dictDetails.value(forKey: "total_loads") as? String ?? ""
            let strMaterial =  self.getMaterialsName(currentIndex: indexPath.row)
            let strAddress = dictDetails.value(forKey: "drop_address") as? String ?? ""
        
        
//            let address = dictDetails.value(forKey: "pickup_address") as? String ?? ""
//            let city = dictDetails.value(forKey: "pickup_city") as? String ?? ""
//            let state = dictDetails.value(forKey: "pickup_state") as? String ?? ""
//            let zipcode = dictDetails.value(forKey: "pickup_zipcode") as? String ?? ""
//            let strAddress = address + ", " + city + ", " + state + ", " + zipcode
    
        
            var semiDetail = "\(strFullDate)\(strBetweenDates)"
            var strTypeWithSpace = "\(strType)\(" ")"
            
            if((dictDetails.value(forKey: "type") as? String)?.uppercased() == "NOW")
            {
                let dateFormatterPrint1 = DateFormatter()
                dateFormatterPrint1.dateFormat = "MMMM dd, yyyy"
                dateFormatterPrint1.locale = Locale(identifier: "en_US_POSIX")

                semiDetail = ", \(dateFormatterPrint1.string(from: Date()))"
                strTypeWithSpace = strType
            }
            let strTotalAmount = dictDetails.value(forKey: "total_amount") as? String ?? ""
        
        
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
        
        let strFinalAmount2 = "\(totalAmount)"
        if let count = strFinalAmount2.components(separatedBy: ".").last?.count {
            if count != 2 {
                totalAmount = String(format: "%@0", totalAmount)
            }
        }
        
            cellDriver.lblTotalPaid.text = "$\(totalAmount)"

        print("dnt --->%@", strTypeWithSpace + semiDetail)
            cellDriver.lblDeliveryTypeAndDate.text = strTypeWithSpace + semiDetail
            //cellDriver.lblDeliveryTypeAndDate.attributedText = self.attributeDtailsBold(strBold: strTypeWithSpace, strNormal: semiDetail)
            cellDriver.lblOrderID.text = strOrderID
            cellDriver.lblTotalTons.text = strTotalTons
            cellDriver.lblTotalLoads.text = strTotalLoads
            cellDriver.lblMaterials.text = strMaterial
            cellDriver.lblAddress.text = strAddress
            cellDriver.layoutIfNeeded()
            cellDriver.layoutIfNeeded()
            return cellDriver
//        }
//
//        else
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentJobsCell", for: indexPath) as! CurrentJobsCell
//            dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
//
//            let dict = self.arrJobs.object(at: indexPath.row) as! NSDictionary
//            let dictDetails = dict.value(forKey: "bill_details") as! NSDictionary
//
//            let strType = (dictDetails.value(forKey: "type") as? String)?.uppercased() as! String
//            let strTypeWithSpace = "\(strType)\(", ")"
//
//            if((dictDetails.value(forKey: "type") as? String)?.uppercased() ?? "" == "NOW")
//            {
//                let moment = dictDetails.value(forKey: "moment") as? String
//                let ddd = moment as! String
//                let ddaaattt =  Date(timeIntervalSince1970: TimeInterval(ddd)!)
//                let time = dateFormatterPrint.string(from: ddaaattt)
//                cell.lblTime.attributedText = self.attributeDtailsBold(strBold: strTypeWithSpace, strNormal: time)
//            }
//            else
//            {
//                let moment = dictDetails.value(forKey: "later_start") as? String
//                let ddd = moment as! String
//                let ddaaattt =  Date(timeIntervalSince1970: TimeInterval(ddd)!)
//                let time = dateFormatterPrint.string(from: ddaaattt)
//                cell.lblTime.attributedText = self.attributeDtailsBold(strBold: strTypeWithSpace, strNormal: time)
//            }
//            cell.lbl_BillId.text = "\("TYW_00")\(dictDetails.value(forKey: "bill_no") as? String ?? "")"
//            return cell
//        }
        
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
    
             let dict = self.arrJobs.object(at: indexPath.row) as! NSDictionary
            
           
            guard let arr = dict.value(forKey: "materials") else{
                return
            }
            let arrMaterial = arr as! NSArray
            
            if(self.loginUserData.type == "service")
            {
                
                let driverLaterJobs = DriverLaterJobs.init(nibName:"DriverLaterJobs" , bundle: nil)
                
                driverLaterJobs.dictConfirmation = dict.mutableCopy() as! NSMutableDictionary
                driverLaterJobs.arrConfirmation = arrMaterial.mutableCopy() as! NSMutableArray
                
                self.navigationController?.pushViewController(driverLaterJobs, animated: true)
            }
            else
            {
                let currentJobDetail = CurrentJobDetailsVC.init(nibName:"CurrentJobDetailsVC" , bundle: nil)
            
                currentJobDetail.dictConfirmation = dict.mutableCopy() as! NSMutableDictionary
                currentJobDetail.arrConfirmation = arrMaterial.mutableCopy() as! NSMutableArray
            
            self.navigationController?.pushViewController(currentJobDetail, animated: true)
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
