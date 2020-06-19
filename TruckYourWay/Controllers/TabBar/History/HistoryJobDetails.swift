//
//  HistoryJobDetails.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 12/18/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import CoreLocation

class HistoryJobDetails: UIViewController {
    
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var btnchangePurchaseIdOtlt: UIButton!
    
    @IBOutlet weak var btnchangeTimeOfRequestShowOtlt: UIButton!
    
    @IBOutlet weak var btnJobSiteLocationOtlt: UIButton!
    
    @IBOutlet weak var lblTotalTons: UILabel!
    @IBOutlet weak var lblTotalLoads: UILabel!
    @IBOutlet weak var lblTotalMiles: UILabel!
    
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var superViewOfTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ConstraintviewHeightTotalCalculation: NSLayoutConstraint!
    
    
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
    
    //# Mark:- Button actions Inside Pop Up
    
    
    
    
    
    func CalculateHeightOfScreen()
    {
//        var viewHeightForTotal: Int = 0
        
        //            viewHeightForTotal = 90
        
        
        let totalNeedToIncreaseHeight = (self.arrConfirmation.count * 80)
        self.tblViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
//        self.ConstraintviewHeightTotalCalculation.constant = CGFloat(120)
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
        
//        let dropLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_latitude") as! String)!
//        let dropLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "drop_longitude") as! String)!
//        let pickLat = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_latitude") as! String)!
//        let pickLong = CLLocationDegrees(self.dictBillDetails.value(forKey: "pickup_longitude") as! String)!
//
        let drop_address = self.dictBillDetails.value(forKey: "drop_address") as? String ?? ""
//
//        let coordinate₀ = CLLocation(latitude: dropLat, longitude: dropLong)
//        let coordinate₁ = CLLocation(latitude: pickLat, longitude: pickLong)
//
//        let distanceInMilesInDouble = Double(((coordinate₀.distance(from: coordinate₁)/1000)*0.621371)) * (Double(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "") ?? 0)
////        let distanceInMilesRound = Double(round(1000*distanceInMilesInDouble)/100)
////        let distanceInMiles = String(distanceInMilesRound)
//
//        let distanceInMilesRound = String(format: "%.2f", distanceInMilesInDouble)
        
//        let distanceInMilesRound = Double(doubleStr)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

        let moment = self.dictBillDetails.value(forKey: "moment") as? String
        let ddd = moment as! String
        let fullDate =  Date(timeIntervalSince1970: TimeInterval(ddd)!)
        var time = dateFormatterPrint.string(from: fullDate)
        
        if (self.dictBillDetails.value(forKey: "type") as? String)?.uppercased() == "LATER" {
            let moment1 = self.dictBillDetails.value(forKey: "later_start") as? String
            let ddd1 = Double(moment1 as! String)
            let fullDate1 =  Date(timeIntervalSince1970:Double(ddd1!))
            time = dateFormatterPrint.string(from: fullDate1)
        }
        
        
         let strJob = (dictBillDetails.value(forKey: "job_type") as? String)?.uppercased() ?? "DELIVERY"
        
        let strType = "\(strJob) \((dictBillDetails.value(forKey: "type") as? String)?.uppercased() ?? "NOW")"
        let strTypeWithSpace = "\(strType.uppercased())\(", ")"
        let strAttributedTime = self.attributeDtailsBold(strBold: strTypeWithSpace, strNormal: time)
        self.btnchangeTimeOfRequestShowOtlt.setAttributedTitle(strAttributedTime, for: .normal)
        self.btnchangePurchaseIdOtlt.setTitle("\(TYW_ID_SUFFIX)\( self.dictBillDetails.value(forKey: "bill_no") as? String ?? "")", for: .normal)
        self.btnJobSiteLocationOtlt.setTitle(drop_address, for: .normal)
        
        self.lblTotalLoads.text = self.dictBillDetails.value(forKey: "total_loads") as? String ?? ""
        self.lblTotalTons.text = self.dictBillDetails.value(forKey: "total_tons") as? String ?? ""
        
        let milage = self.dictBillDetails.value(forKey: "mileage") as? String ?? ""
        self.lblTotalMiles.text = milage //distanceInMilesRound
        
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
}

extension HistoryJobDetails : UITableViewDelegate, UITableViewDataSource
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
        if(strCategory.uppercased() == "DIRT")
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
//            let totalTons = dict.value(forKey: "total_tons") as? String ?? "0"
            if(Int(tons)! > 1)
            {
                cell.lblMaterialQuantity.text = "\(tons)\(" tons")"
            }
            else
            {
                cell.lblMaterialQuantity.text = "\(tons)\(" ton")"
            }
        }
        
        let imgURL = imgStr  == nil ? "" : imgStr
        cell.imgView.loadImageAsync(with: BSE_URL_LoadMedia+imgURL!, defaultImage: "", size: cell.imgView.frame.size)
        
        cell.lblMaterialCategory.attributedText = self.attributeDtailsBold(strBold: "\(str_job_type.uppercased())\("\n")\(strCategory) ", strNormal: dict.value(forKey: "name") as? String ?? "")
        //            cell.lblMaterialQuantity.text = "\(tons as! String)\(" tons")"
        
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
        return cell
        
    }
    
}
