//
//  OrderConfirmationVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/17/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class OrderConfirmationVC: UIViewController {

    
    @IBOutlet weak var promoAmountConstraint: NSLayoutConstraint!
    @IBOutlet weak var newSubTotalConstraint: NSLayoutConstraint!
    @IBOutlet weak var alblNewSubTotal: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var btnEditTimeOfRequestOtlt: UIButton!
    @IBOutlet weak var btnOrderIdOtlt: UIButton!
    
     @IBOutlet weak var btnchangeTimeOfRequestShowOtlt: UIButton!
    
    @IBOutlet weak var btnPickedLocationOtlt: UIButton!
    @IBOutlet weak var btnApplyPromoCodeOtlt: UIButton!
    
    @IBOutlet weak var textPromoCodeOtlt: CustomTxtField!
    
    @IBOutlet weak var lblTonsTitle: UILabel!
    @IBOutlet weak var lblTons: UILabel!
    
    @IBOutlet weak var lblPromoCode: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var labelDeliveryPlaceholder: UILabel!

    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var superViewOfTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    
   
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    
    
    //Mark:- View Pop Up On CalcelTab Case
    
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var viewPopUpSubView: UIView!
    
    
    var pickedCordinates : NSMutableDictionary = [:]
    var selectedMaterialType : NSMutableDictionary = [:]
    
    var arrSelectedMaterials : NSMutableArray = []
    
    var arrConfirmation: NSMutableArray = []
    
    var dictConfirmation : NSMutableDictionary = [:]
    var dictBillDetails : NSMutableDictionary = [:]
    
    var selectedServiceType: String = ""
    
    var contact_name: String = ""
    var contact_no: String = ""
    var instruction: String = ""
    
    var selected_Date: String = ""
    var delivery_type: String = ""
    var later_start: Int = 0
    var later_end: Int = 0
    
    
    var loginUserData:LoggedInUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Constant.MyVariables.appDelegate.truckCartModel != nil {
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            self.selected_Date = model.selected_Date
            self.later_start = model.later_start
            self.later_end = model.later_end
            self.delivery_type = model.delivery_type
            self.pickedCordinates = model.pickedCordinates
            self.selectedMaterialType = model.selectedDeliveryMaterialType
            self.arrSelectedMaterials = model.arrSelectedDeliveryMaterial
            
            self.contact_name = model.contact_name
            self.contact_no = model.contact_no
            self.instruction = model.instruction
            
            self.arrConfirmation = model.arrConfirmation
            self.dictConfirmation = model.dictConfirmation
            self.dictBillDetails = model.dictBillDetails
        }
        
        promoAmountConstraint.constant = 0
        newSubTotalConstraint.constant = 0
        self.tblView.register(UINib(nibName: "ConfirmationHeaderCell", bundle: nil), forCellReuseIdentifier: "ConfirmationHeaderCell")
        self.tblView.register(UINib(nibName: "ConfirmationRowCell", bundle: nil), forCellReuseIdentifier: "ConfirmationRowCell")
        
        
        self.viewPopUpSubView.layer.cornerRadius = 10
        self.viewPopUpSubView.layer.masksToBounds = true
        
        self.btnPickedLocationOtlt.titleLabel!.numberOfLines = 3;
        self.btnPickedLocationOtlt.titleLabel!.adjustsFontSizeToFitWidth = true;
        self.btnPickedLocationOtlt.titleLabel!.lineBreakMode = .byWordWrapping;
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        self.callCalculateBill()
//        self.CalculateHeightOfScreen()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.appIsGoingInBackground)
            , name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func appIsGoingInBackground() {
        print("disappearing..")
        
        guard let model = Constant.MyVariables.appDelegate.truckCartModel else {
            return
        }
        model.selected_Date = self.selected_Date

        model.arrConfirmation = self.arrConfirmation
        model.dictConfirmation = self.dictConfirmation
        model.dictBillDetails = self.dictBillDetails
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        USER_DEFAULT.set(AppState.TruckOrderConfirmation.rawValue, forKey: APP_STATE_KEY)
    }
    
    //Mark:- Actions on PopUp No and Yes
    
    @IBAction func actionNoOnPopUp(_ sender: Any)
    {
       self.viewPopUp.isHidden = true
    }
    
    @IBAction func actionYesOnPopUp(_ sender: Any)
    {
            self.viewPopUp.isHidden = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func actionBack(_ sender: Any)
    {
        let model = Constant.MyVariables.appDelegate.truckCartModel!
        model.arrConfirmation = NSMutableArray()
        model.dictConfirmation = NSMutableDictionary()
        model.dictBillDetails = NSMutableDictionary()
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionEditRequestTime(_ sender: Any) {
    }
    
    @IBAction func actionChangeRequestTime(_ sender: Any)
    {
        
    }
    
    @IBAction func actionApplyPromoCode(_ sender: Any) {
        
        if self.textPromoCodeOtlt.isEnabled == false {
            return
        }
        
        if(self.textPromoCodeOtlt.text != "")
        {
            self.textPromoCodeOtlt.resignFirstResponder()
            self.getPromoCodeApi()
        }
        else{
            showAlert("Please enter promo code")
        }
        }
    
    @IBAction func actionCancelRequest(_ sender: Any)
    {
                
        UIView.animate(withDuration: 0.25, animations: {
            self.viewPopUp.isHidden = false
            self.viewPopUpSubView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
//        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionNext(_ sender: Any)
    {
        let strType = (self.dictBillDetails.value(forKey: "type") as? String ?? "now").uppercased()

        if strType == "LATER" {
            
            let total_bill_loads = Int(self.dictBillDetails.value(forKey: "bill_loads") as? String ?? "0") ?? 0
            let total_bill_tons = Int(self.dictBillDetails.value(forKey: "bill_tons") as? String ?? "0") ?? 0
            
            if(((total_bill_loads * 16) + total_bill_tons) > 80 )
            {
                let actionDic : [String: () -> Void] = [ "YES" : { (
                    self.goAhead(withMultipleDriver: true)
                    ) }, "NO" : { (
                        self.goAhead(withMultipleDriver: false)
                        ) }]
                self.showCustomAlertWith(message: "Would you like to use multiple Service Providers to complete YOUR  LATER job in 1 day?", actions: actionDic, isSupportHiddedn: true)
            }
            else
            {
                self.goAhead(withMultipleDriver: false)
            }
            
          
        } else {
            self.goAhead(withMultipleDriver: false)
        }
    }
    
    func goAhead(withMultipleDriver: Bool) {
        let termsVC = TermsAndConditionsVC.init(nibName: "TermsAndConditionsVC", bundle: nil)
             
               termsVC.dictBillDetails = dictBillDetails.mutableCopy() as! NSMutableDictionary
               termsVC.pickedCordinates = self.pickedCordinates.mutableCopy() as! NSMutableDictionary
               termsVC.bill_Id = String(dictBillDetails.value(forKey: "id") as! Int)
               termsVC.bill_amount = dictBillDetails.value(forKey: "bill_amount")! as! String
               termsVC.promoAmount = self.lblPromoCode.text ?? "N/A"
               termsVC.tax_amount = dictBillDetails.value(forKey: "tax_amount")! as! String
               termsVC.total_amount = dictBillDetails.value(forKey: "total_amount")! as! String
               termsVC.delivery_type = delivery_type
                termsVC.isMultipleDriverForLater = withMultipleDriver
               
               let model = Constant.MyVariables.appDelegate.truckCartModel!
               
               model.arrConfirmation = self.arrConfirmation
               model.dictConfirmation = self.dictConfirmation
               model.dictBillDetails = self.dictBillDetails
               
               Constant.MyVariables.appDelegate.saveTrucCartData()
               
               self.navigationController?.pushViewController(termsVC, animated: true)
    }
    
    func getPromoCodeApi()
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
        let purchase_order_Id = self.dictBillDetails.value(forKey: "id") as! Int ?? 0

        let parameters = [
            "user_id":self.loginUserData.user_id ?? "",
            "code":self.textPromoCodeOtlt.text ?? "",
            "bill_no":purchase_order_Id,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
        
        self.startAnimating("")
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_APPLY_PROMO_CODE, .post, parameters, { (result, data, json, error, msg) in
            
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
                    
                    let total = json?.count ?? 0
                    
                    
                    if(total>0)
                    {
                        let dict = json as! NSDictionary
                        self.dictConfirmation = dict.mutableCopy() as! NSMutableDictionary
                        guard let arr = self.dictConfirmation.value(forKey: "materials") else{
                            return
                        }
                        let arrMaterial = arr as! NSArray
                        self.arrConfirmation = arrMaterial.mutableCopy() as! NSMutableArray
                        
                        self.textPromoCodeOtlt.isEnabled = false
                        self.textPromoCodeOtlt.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.6032680458)
                        self.ShowDataOnSreen()
                        self.tblView.reloadData()
                    }
                })
            }
            
        })
    }
    
    func callCalculateBill()
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
            "material_data":self.arrSelectedMaterials,
            "date":self.selected_Date,
            "delivery_type":self.delivery_type,
            "pickup_location":self.pickedCordinates.value(forKey: "LocationName") as! String,
            "contact_name":self.contact_name,
            "contact_no":self.contact_no,
            "instruction":self.instruction,
            "job_type":self.selectedServiceType.lowercased() ==  "" ? "delivery" : self.selectedServiceType.lowercased(),
            "later_start":self.later_start,
            "later_end":self.later_end,
            "latitude":self.pickedCordinates.value(forKey: "lat")!,
            "longitude":self.pickedCordinates.value(forKey: "long")!,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
        
        print(parameters)
        self.startAnimating("")
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_CALCULATE_BILL, .post, parameters, { (result, data, json, error, msg) in
            
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
                    
                    let total = json?.count ?? 0
                    
                    
                    if(total>0)
                    {
                        let dict = json as! NSDictionary
                        self.dictConfirmation = dict.mutableCopy() as! NSMutableDictionary
                        print(dict)
                        
                        guard let arr = self.dictConfirmation.value(forKey: "materials") else{
                            return
                        }
                        let arrMaterial = arr as! NSArray
                        self.arrConfirmation = arrMaterial.mutableCopy() as! NSMutableArray
                        self.ShowDataOnSreen()
                        self.CalculateHeightOfScreen()
                        self.tblView.reloadData()
                    }
                })
            }
            
        })
    }
    
    func ShowDataOnSreen()
    {
        
        if(self.selectedServiceType.uppercased() == "HAULING")
        {
            labelDeliveryPlaceholder.text = "Hauling Location"
        }
        else
        {
            labelDeliveryPlaceholder.text = "Delivery Location"
        }
       let dictt = self.dictConfirmation.value(forKey: "bill_details") as! NSDictionary
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        dateFormatter.dateFormat = "dd MMMM yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        guard let date = dateFormatter.date(from: dictt.value(forKey: "bill_date") as? String ?? "") else {
            return
        }
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        var strBillDate = dateFormatter.string(from: date)
        self.dictBillDetails = dictt.mutableCopy() as! NSMutableDictionary
        
        let purchase_order_Id = self.dictBillDetails.value(forKey: "id") as! Int ?? 0
        let str_purchase_order_Id = "\(TYW_ID_SUFFIX)\(purchase_order_Id)"
        self.btnOrderIdOtlt.setTitle( str_purchase_order_Id, for: .normal)
        
       
        self.btnPickedLocationOtlt.setTitle(self.dictBillDetails.value(forKey: "pickup_location") as? String ?? "", for: .normal)
        
        let strLater_S = self.dictBillDetails.value(forKey: "later_start") as? String
        let strLater_E = self.dictBillDetails.value(forKey: "later_end") as? String
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

        let strType = (self.dictBillDetails.value(forKey: "type") as? String ?? "now").uppercased()

        if strType == "LATER" {
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
            let txtTime = "\("\n")\("Between ") \(later_Start) \(" - ")\(later_End)"
            strBillDate = strBillDate + txtTime
        }
        let strTypeWithSuffix = "\(strType)\(", ")"
        let attributeText = self.attributeDtailsBold(strBold: strTypeWithSuffix, strNormal: strBillDate)
        self.btnchangeTimeOfRequestShowOtlt.setAttributedTitle(attributeText, for: .normal)
        
//        let address = self.dictBillDetails.value(forKey: "pickup_address") as? String ?? ""
//        let city = self.dictBillDetails.value(forKey: "pickup_city") as? String ?? ""
//        let state = self.dictBillDetails.value(forKey: "pickup_state") as? String ?? ""
//        let zipcode = self.dictBillDetails.value(forKey: "pickup_zipcode") as? String ?? ""
//        let strLoc = address + ", " + city + ", " + state + ", " + zipcode
//        self.btnPickedLocationOtlt.setTitle(strLoc, for: .normal)
//
//       self.textPromoCodeOtlt.text =  self.dictBillDetails.value(forKey: "promo_code") as? String ?? ""
       
        let promoCode = self.dictBillDetails.value(forKey: "promo_amount") as? String ?? ""
        let str_total_tons = self.dictBillDetails.value(forKey: "bill_tons") as? String ?? ""
        let str_bill_amount = self.dictBillDetails.value(forKey: "bill_amount") as? String ?? ""
        let str_tax_amount = self.dictBillDetails.value(forKey: "tax_amount") as? String ?? ""
        let str_total_amount = self.dictBillDetails.value(forKey: "total_amount") as? String ?? ""
        
        let total_bill_loads = Int(self.dictBillDetails.value(forKey: "bill_loads") as? String ?? "0") ?? 0
        let total_bill_tons = Int(self.dictBillDetails.value(forKey: "bill_tons") as? String ?? "0") ?? 0
        
        if(total_bill_loads > 0 )
        {
            if(total_bill_tons > 0 )
            {
                let totalTon = Int(str_total_tons) ?? 0
                let totalLoad = Int(total_bill_loads) ?? 0
                
                self.lblTonsTitle.text = "TONS\nLOADS"
                self.lblTons.text =  "\(totalTon + (totalLoad * 16))\("\n")\(total_bill_loads + (totalTon / 16))"
            }
            else{
                self.lblTonsTitle.text = "LOADS"
                self.lblTons.text =  "\(total_bill_loads)"
            }
        }
        
        else
        {
            self.lblTonsTitle.text = "TONS"
            self.lblTons.text =  str_total_tons
        }
        let numberFormatter = NumberFormatter()
         numberFormatter.numberStyle = .decimal
         numberFormatter.usesGroupingSeparator = true
        
//        self.lblTons.text =  str_total_tons
        if(promoCode == "" || self.textPromoCodeOtlt.text == "")
        {
            self.lblPromoCode.text = "N/A"
            self.promoAmountConstraint.constant = 0
            self.newSubTotalConstraint.constant = 0
        }
        else
        {
            self.promoAmountConstraint.constant = 30
            self.newSubTotalConstraint.constant = 30
            
            let dPromo = Double(promoCode) ?? 0.0
            let promoAmount1 = numberFormatter.string(from: NSNumber(value: dPromo)) ?? promoCode
                   
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
            self.lblPromoCode.text = "\("$")\(promoAmount)"
            
            
//            self.lblPromoCode.text = "\("-$")\(Double(promoCode)?.rounded(toPlaces: 2) ?? 0)"
        }
        
      //self.bill_amount = "1000"
        let billAmount1 = numberFormatter.string(from: NSNumber(value: Double(str_bill_amount)!)) ?? str_bill_amount
        let taxAmount1 = numberFormatter.string(from: NSNumber(value: Double(str_tax_amount)!)) ?? str_tax_amount
        //self.total_amount = "1999.33"
        let totalAmount1 = numberFormatter.string(from: NSNumber(value: Double(str_total_amount)!)) ?? str_total_amount
        
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
        
//        if taxAmount1.contains(",") && taxAmount1.contains(".") {
//            taxAmount = taxAmount1
//        } else if taxAmount1.contains(",") && !taxAmount1.contains(".") {
//            taxAmount = String(format: "%@.00", taxAmount1)
//        }
//
//        if totalAmount1.contains(",") && totalAmount1.contains(".") {
//            totalAmount = totalAmount1
//        } else if totalAmount1.contains(",") && !totalAmount1.contains(".") {
//            totalAmount = String(format: "%@.00", totalAmount1)
//        }
        
        
        self.lblSubTotal.text = "\("$")\(billAmount)"
        self.lblTotal.text = "\("$")\(totalAmount)"
        self.lblTax.text = "\("$")\(taxAmount)"

//        self.lblSubTotal.text = "\("$")\(String(format: "%.2f", Float(str_bill_amount) ?? 0.00))"
//        self.lblTax.text = "\("$")\(String(format: "%.2f", Float(str_tax_amount) ?? 0.00))"
        let totalAmt = Double(str_total_amount)
        let tax = Double(str_tax_amount)
        let subTotal = (totalAmt ?? 0) - (tax ?? 0)
//        let roundedNewSubTotal = round(subTotal)
//        let str = String(format: "%.2f", roundedNewSubTotal)
        alblNewSubTotal.text = String(format: "$%.2f", subTotal)
//        self.lblTotal.text = "\("$")\(String(format: "%.2f", totalAmt!))"
    }
    
    func CalculateHeightOfScreen()
    {
        let totalNeedToIncreaseHeight = (self.arrConfirmation.count * 100)
        self.tblViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
        self.superViewOfTableViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
        self.secondViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
        self.mainViewHeightConstraint.constant += CGFloat(totalNeedToIncreaseHeight)
        self.tblView.reloadData()
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

extension OrderConfirmationVC: UITableViewDelegate, UITableViewDataSource
{
    //Mark:- TableView Delegate and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationHeaderCell") as! ConfirmationHeaderCell
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
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationRowCell", for: indexPath) as! ConfirmationRowCell
        
        let dict = self.arrConfirmation.object(at: indexPath.row) as! NSDictionary
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
        if(strPrefixCategory.uppercased() == "DIRT")
        {
            let strTotalTons = dict.value(forKey: "total_tons") as? String ?? "0"
            let totalTons = Int(strTotalTons) ?? 0
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
        }
        else
        {
            let tonsCheck = dict.value(forKey: "total_tons") as? String ?? "0"
            
            if(Int(tonsCheck) ?? 0 <= 1)
            {
                cell.lblMaterialQuantity.text = "\(dict.value(forKey: "total_tons") as? String ?? "")\(" Ton")"
            }
            else
            {
                cell.lblMaterialQuantity.text = "\(dict.value(forKey: "total_tons") as? String ?? "")\(" Tons")"
            }
            
            let tons = Int(tonsCheck) ?? 0
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
        
        if(self.selectedServiceType.uppercased() == "HAULING")
        {
           let totalLoad  =  ((Int(dict.value(forKey: "total_tons") as? String ?? "0") ?? 0)/16)
            if(totalLoad < 1)
            {
                cell.lblMaterialQuantity.text = "\(totalLoad) \(" Load")"
            }
            else
            {
                cell.lblMaterialQuantity.text = "\(totalLoad) \(" Loads")"
            }
        }
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true

        
        let billAmount1 = numberFormatter.string(from: NSNumber(value: Double(dict.value(forKey: "amount") as? String ?? "0")!)) ?? "0"

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

        cell.lblMaterialCost.text = "\("$")\(billAmount)"//"\("$")\(Double(dict.value(forKey: "amount") as? String ?? "0")?.rounded(toPlaces: 2) ?? 0)"
        
        return cell
    }
    
}
