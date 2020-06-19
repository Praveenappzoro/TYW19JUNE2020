//
//  HistoryDetailsForConsumerVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 1/9/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import UIKit
import CoreLocation

class HistoryDetailsForConsumerVC: UIViewController {
    @IBOutlet weak var lblNewSubTotal: UILabel!
    
    @IBOutlet weak var newSubTotalCanstraint: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnchangePurchaseIdOtlt: UIButton!
    @IBOutlet weak var btnchangeTimeOfRequestShowOtlt: UIButton!
    @IBOutlet weak var btnJobSiteLocationOtlt: UIButton!
    @IBOutlet weak var lblTotalTons: UILabel!
    @IBOutlet weak var lblTotalLoads: UILabel!
    @IBOutlet weak var lblPromoCode: UILabel!

    @IBOutlet weak var lblDiscount: UILabel!
    //    @IBOutlet weak var lblTotalMiles: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var superViewOfTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var discountHeightConstraint: NSLayoutConstraint!
    
    var arrConfirmation: NSMutableArray = []
    
    var dictConfirmation : NSMutableDictionary = [:]
    var dictBillDetails : NSMutableDictionary = [:]
    var selectedServiceType: String = ""
    var loginUserData:LoggedInUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnJobSiteLocationOtlt.titleLabel!.numberOfLines = 3
        self.btnJobSiteLocationOtlt.titleLabel!.adjustsFontSizeToFitWidth = true
        self.btnJobSiteLocationOtlt.titleLabel!.lineBreakMode = .byWordWrapping
        self.tblView.register(UINib(nibName: "ConfirmationHeaderCell", bundle: nil), forCellReuseIdentifier: "ConfirmationHeaderCell")
        self.tblView.register(UINib(nibName: "ConfirmationRowCell", bundle: nil), forCellReuseIdentifier: "ConfirmationRowCell")
        
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {return}
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
        print(self.dictConfirmation.value(forKey: "bill_details") as! NSDictionary)
        let dictt = self.dictConfirmation.value(forKey: "bill_details") as! NSDictionary
        self.selectedServiceType = (self.dictConfirmation.value(forKey: "bill_details") as! NSDictionary)["job_type"] as! String
        
        self.dictBillDetails = dictt.mutableCopy() as! NSMutableDictionary
        let dropLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_latitude") as! String)!
        let dropLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_longitude") as! String)!
        let pickLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_latitude") as! String)!
        let pickLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_longitude") as! String)!
        let drop_address = self.dictBillDetails.value(forKey: "drop_address") as? String ?? ""
        let coordinate₀ = CLLocation(latitude: dropLat, longitude: dropLong)
        let coordinate₁ = CLLocation(latitude: pickLat, longitude: pickLong)
        let distanceInMilesInDouble = Double(((coordinate₀.distance(from: coordinate₁)/1000)*0.621371))

        let doubleStr = String(format: "%.2f", distanceInMilesInDouble)
        let distanceInMilesRound = Double(doubleStr)
       
    self.btnchangeTimeOfRequestShowOtlt.setAttributedTitle(self.setJobTypeWithTime(dict:dictt), for: .normal)
        self.btnchangeTimeOfRequestShowOtlt.titleLabel?.lineBreakMode = .byWordWrapping
        self.btnchangeTimeOfRequestShowOtlt.titleLabel?.lineBreakMode = .byWordWrapping
        self.btnchangePurchaseIdOtlt.setTitle("\(TYW_ID_SUFFIX)\( self.dictBillDetails.value(forKey: "bill_no") as? String ?? "")", for: .normal)
        self.btnJobSiteLocationOtlt.setTitle(drop_address, for: .normal)
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
//        
//        let str_total_amount = self.dictBillDetails.value(forKey: "total_amount") as? String ?? ""
        
        if let taxAmount = Double(self.dictBillDetails.value(forKey: "tax_amount") as? String ?? ""), let totalAmount = Double(self.dictBillDetails.value(forKey: "total_amount") as? String ?? ""), let billAmount = Double(self.dictBillDetails.value(forKey: "bill_amount") as? String ?? ""){
            let netAmnt = billAmount - (totalAmount - taxAmount)
            discountHeightConstraint.constant = netAmnt > 0 ? 20 : 0
            let subTotal = billAmount - netAmnt
            lblNewSubTotal.text = "$\(subTotal.rounded(toPlaces: 2))"
            newSubTotalCanstraint.constant = netAmnt > 0 ? 20 : 0
            
            let promoAmount1 = numberFormatter.string(from: NSNumber(value: Double(netAmnt))) ?? "0"

            var promoAmount = String(format: "%.2f", Double(promoAmount1) ?? 0)

            if promoAmount1.contains(",") && promoAmount1.contains(".") {
                promoAmount = promoAmount1
            } else if promoAmount1.contains(",") && !promoAmount1.contains(".") {
                promoAmount = String(format: "%@.00", promoAmount1)
            }
            let strFinalAmount = "\(promoAmount)"
            if let count = strFinalAmount.components(separatedBy: ".").last?.count {
                if count != 2 {
                    promoAmount = String(format: "%@0", promoAmount)
                }
            }
                    
            lblDiscount.text = "(-) $\(promoAmount)"
        }
        
//        let totalAmt = Double(str_total_amount)
//        self.lblTotal.text = "\("$")\(String(format: "%.2f", totalAmt!))"
        
        self.lblPromoCode.text = dictt["promo_code"] as? String ?? "N/A"
        

        
        
            //"promo_code" = "<null>";

    }
    
    func setJobTypeWithTime(dict:NSDictionary) -> NSAttributedString
    {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

        let moment = dict.value(forKey: "moment") as? String
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
            semiDetail = "\(strFullDate)"
            strTypeWithSpace = strType + ", "
        }
        let attr = self.attributeDtailsBold(strBold: strTypeWithSpace, strNormal: semiDetail)
        return attr
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

extension HistoryDetailsForConsumerVC : UITableViewDelegate, UITableViewDataSource
{
    //Mark:- TableView Delegate and datasource
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationHeaderCell") as! ConfirmationHeaderCell
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationRowCell", for: indexPath) as! ConfirmationRowCell
        let dict = self.arrConfirmation.object(at: indexPath.row) as! NSDictionary

        //(Material price * number of loads / Tons) + (Delivery / Hauling changes + number of loads) + (Mileage charge * mileage * number of loads)
        var materialPrice: Double!
        let priceTon = (dict["price_tons"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        let priceLoad = (dict["price_loads"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)

        if(self.selectedServiceType.uppercased() == "HAULING") {
            materialPrice = Double(priceLoad ?? "0")!
        } else {
            materialPrice = Double(priceTon ?? "0")!
        }

        let tons = dict.value(forKey: "tons") as? String ?? "0"
        let totalTons = Int(tons) ?? 0

        let deliveryCharge = Double((dict.value(forKey: "delivery_charge") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0")!
        let loads = Double(dict.value(forKey: "load_no") as? String ?? "0")!
        let mileageCharge = Double((dict.value(forKey: "milage_charge") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0")!
        let milageStr = self.dictBillDetails["mileage"] as? String ?? "0"
        let mileage = Double(milageStr)! / Double(self.arrConfirmation.count)
        
//        let totalTons = self.selectedServiceType.uppercased() == "HAULING" ? loads : Double(tons)!
        
        
       // print("Material price: \(materialPrice) \n Total Loads: \(totalTons) \n Delivery Charge: \(deliveryCharge) Loads: \(loads) Milage Charge: \(mileageCharge) Milage: \(mileage)")
        
//        let mPrice = materialPrice * totalTons
//        let dPrice = deliveryCharge * loads
//        let milePrice = mileageCharge * mileage * loads
//
//        let finalPrice = mPrice + dPrice + milePrice
        //cell.lblMaterialCost.text = String(format: "$%.2f", finalPrice)
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true

        
        let billAmount1 = numberFormatter.string(from: NSNumber(value: Double(dict.value(forKey: "material_amount") as? String ?? "0")!)) ?? "0"

        var billAmount = String(format: "%.2f", Double(billAmount1) ?? 0)

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
         cell.lblMaterialCost.text =  "$\(billAmount)"//"\(Double(dict.value(forKey: "material_amount") as? String ?? "")?.rounded(toPlaces: 2) ?? 0)"
        
        let imgStr = dict.value(forKey: "material_image") as? String
        let imgURL = imgStr  == nil ? "" : imgStr
        cell.imgView.loadImageAsync(with: BSE_URL_LoadMedia+imgURL!, defaultImage: "", size: cell.imgView.frame.size)

        let strPrefixCategory = dict.value(forKey: "category") as? String ?? ""
        let strPostfixCategory = dict.value(forKey: "name") as? String ?? ""
        let strCategory = "\("\n")\(strPrefixCategory)\(" ")\(strPostfixCategory)"
        
        if(self.selectedServiceType.uppercased() == "HAULING")
        {
            cell.lblMaterialCategory.attributedText = self.attributeDtailsBold(strBold: "Hauling  ", strNormal:strCategory )
        }
        else
        {
            cell.lblMaterialCategory.attributedText = self.attributeDtailsBold(strBold: "Delivery  ", strNormal:strCategory )
        }
        if((dict.value(forKey: "category") as? String ?? "").uppercased() == "DIRT")
        {
            let loads = dict.value(forKey: "load_no") as? String ?? "0"
            if(Int(loads) ?? 0 > 1)
            {
                cell.lblMaterialQuantity.text = "\(loads) \(" Loads")"
            }
            else
            {
                cell.lblMaterialQuantity.text = "\(loads) \(" Loads")"
            }
//            guard let pricePerLoad = dict.value(forKey: "price_loads") as? String else{
//                cell.lblMaterialCost.text = "$"
//                return cell
//            }
            //let trimmedString = pricePerLoad.trimmingCharacters(in: CharacterSet.whitespaces)
            //let perLoadInDouble = Double(trimmedString)!
            //let totalLoad = Double(loads)! * perLoadInDouble
          //  cell.lblMaterialCost.text = "\("$") \(totalLoad)"
            //cell.lblMaterialCost.text = "\(Double(dict.value(forKey: "material_amount") as? String ?? "")?.rounded(toPlaces: 2) ?? 0)"
//            return cell
        }

        if(Int(tons) ?? 0 > 1)
        {
            cell.lblMaterialQuantity.text = "\(tons) \(" tons")"
        }
        else
        {
            cell.lblMaterialQuantity.text = "\(tons) \(" ton")"
        }
        
        
//        if(self.selectedServiceType.uppercased() == "HAULING")
//        {
//            let tons  =  ((Int(dict.value(forKey: "total_tons") as? String ?? "0") ?? 0))
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
//        }
        
        
        
        if((self.dictBillDetails.value(forKeyPath: "job_type") as? String ?? "").uppercased() == "HAULING"){
            cell.lblMaterialCategory.attributedText = self.attributeDtailsBold(strBold: "Hauling  ", strNormal:strCategory )
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
        }
        else{
            cell.lblMaterialCategory.attributedText = self.attributeDtailsBold(strBold: "Delivery  ", strNormal:strCategory)
            
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
        
//        let trimmedStingTon = pricePerTon.trimmingCharacters(in: CharacterSet.whitespaces)
//        let perTonInDouble = Double(trimmedStingTon)!
//        let totalTon = Double(tons)! * perTonInDouble
//        cell.lblMaterialCost.text = "\("$") \(totalTon.rounded(toPlaces: 2))"
        return cell
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
