//
//  PaymentVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/19/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree

class PaymentVC: UIViewController {

    @IBOutlet weak var lblSubTotal: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblPromoCode: UILabel!
    
    var dictBillDetails : NSMutableDictionary = [:]
    var pickedCordinates : NSMutableDictionary = [:]

    var loginUserData:LoggedInUser!

    var bill_Id:String = ""
    var promoAmount:String = ""
    var bill_amount:String = ""
    var tax_amount:String = ""
    var total_amount:String = ""
    var promo_code:String = ""
    
    var delivery_type: String = ""
    
    var tokenforBrainTree: String = ""
    var arrSelectedMaterials: NSArray = []
    var isMultipleDriverForLater: Bool = false
   // var billingDetails: [String: Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Constant.MyVariables.appDelegate.truckCartModel != nil {
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            
            self.delivery_type = model.delivery_type
            self.pickedCordinates = model.pickedCordinates
            self.dictBillDetails = model.dictBillDetails
            
            self.bill_Id = String(dictBillDetails.value(forKey: "id") as! Int)
            self.bill_amount = dictBillDetails.value(forKey: "bill_amount")! as! String
            self.tax_amount = dictBillDetails.value(forKey: "tax_amount")! as! String
            self.total_amount = dictBillDetails.value(forKey: "total_amount")! as! String
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        
       
        
        if(self.promoAmount == "")
        {
            self.lblPromoCode.text = "N/A"
        }
        else
        {
            var amount = "0"
            if self.promoAmount.contains(" ") {
                amount = self.promoAmount.components(separatedBy: " ")[1]
            }

            let dPromo = Double(amount) ?? 0.0
            let promoAmount1 = numberFormatter.string(from: NSNumber(value: dPromo)) ?? self.promoAmount
                   
                   var promoAmount = String(format: "%.2f", Double(promoAmount1) ?? 0)
                   
                    if promoAmount1.contains(",") && promoAmount1.contains(".") {
                           promoAmount = promoAmount1
                       } else if promoAmount1.contains(",") && !promoAmount1.contains(".") {
                       promoAmount = String(format: "%@.00", promoAmount1)
                   }
            let strFinalAmount2 = "\(promoAmount)"
            if let count = strFinalAmount2.components(separatedBy: ".").last?.count {
                if count != 2 {
                    promoAmount = String(format: "%@0", promoAmount)
                }
            }
            self.lblPromoCode.text = self.promoAmount
        }

        //self.bill_amount = "1000"
        let billAmount1 = numberFormatter.string(from: NSNumber(value: Double(self.bill_amount)!)) ?? self.bill_amount
        let taxAmount1 = numberFormatter.string(from: NSNumber(value: Double(self.tax_amount)!)) ?? self.tax_amount
        //self.total_amount = "1999.33"
        let totalAmount1 = numberFormatter.string(from: NSNumber(value: Double(self.total_amount)!)) ?? self.total_amount
        
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
        
        //        self.lblTons.text =  str_total_tons
       
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
         self.apiForGenerateToken()
        
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
        model.dictBillDetails = self.dictBillDetails
        model.billId = self.bill_Id
        Constant.MyVariables.appDelegate.saveTrucCartData()
        USER_DEFAULT.set(AppState.TruckPayment.rawValue, forKey: APP_STATE_KEY)
    }
    

    @IBAction func actionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionPayment(_ sender: Any)
    {
        if self.tokenforBrainTree == "" {
           self.showAlert("Please try again later")
            return
        }
       self.showDropIn(clientTokenOrTokenizationKey: self.tokenforBrainTree)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        let actionDic : [String: () -> Void] = [ "YES" : { (
            self.cancelServiceAction()
        ) }, "NO" : { (
            print("tapped NO")
        ) }]
        self.showCustomAlertWith(message: "Are you sure you want to cancel YOUR Service?", actions: actionDic, isSupportHiddedn: true)
    }
    
    func cancelServiceAction() {
        //Remove saved data
        Constant.MyVariables.appDelegate.truckCartModel = nil
        Constant.MyVariables.appDelegate.saveTrucCartData()
        USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK:- apiForGenerateToken Calling

    func apiForGenerateToken()
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
                "access_token":self.loginUserData.access_token ?? "",
                "refresh_token":self.loginUserData.refresh_token ?? "",
                ] as [String : Any]
            
            self.startAnimating("")
            
            APIManager.sharedInstance.getDataFromAPI(BSE_URL_GENERATE_TOKEN, .post, parameters) { (result, data, json, error, msg) in
                
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
                       self.tokenforBrainTree =  json?.value(forKey: "token") as! String
                    })
                    break
                }
                
            }
        }
    
    //MARK:- api Pay Bill Calling
    
    func apiPayBill(nonce: String)
    {
        
          let paymentVC  = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BillingAddressTableViewController") as! BillingAddressTableViewController
        
       // let paymentVC = PaymentVC.init(nibName: "PaymentVC", bundle: nil)
        
        paymentVC.dictBillDetails = self.dictBillDetails.mutableCopy() as! NSMutableDictionary
        paymentVC.pickedCordinates = self.pickedCordinates.mutableCopy() as! NSMutableDictionary
        paymentVC.bill_Id = self.bill_Id
        paymentVC.promoAmount = self.promoAmount
        paymentVC.bill_amount = self.bill_amount
        paymentVC.tax_amount = self.tax_amount
        paymentVC.total_amount = self.total_amount
        paymentVC.delivery_type = self.delivery_type
        paymentVC.isMultipleDriverForLater = self.isMultipleDriverForLater
        paymentVC.loginUserData = loginUserData
        paymentVC.nonce = nonce
        self.navigationController?.pushViewController(paymentVC, animated: true)
        
        return
        
        let parameters = [
            "nonce":nonce,
            "bill_no":self.bill_Id,
            "amount":self.total_amount,
            "user_id":self.loginUserData.user_id ?? "",
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            "type": self.isMultipleDriverForLater ? "multiple" : "single"
          //  "billingDetails": billingDetails ?? [:]
        ] as [String : Any]
        
        self.startAnimating("")
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_PAY_BILL, .post, parameters) { (result, data, json, error, msg) in
            
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
                    
                    self.tabBarController?.tabBar.items?[1].badgeValue = nil
                    self.tabBarController?.tabBar.tintColor = themeColorOrange
                    
                    if(self.delivery_type == "now")
                    {
                        
                        let chooseDriver = ChooseDriverVC.init(nibName: "ChooseDriverVC", bundle: nil)
                        chooseDriver.dictBillDetails = self.dictBillDetails.mutableCopy() as! NSMutableDictionary
                        chooseDriver.bill_Id  = self.bill_Id
                        chooseDriver.pickedCordinates = self.pickedCordinates.mutableCopy() as! NSMutableDictionary
                        
                        
                        self.navigationController?.pushViewController(chooseDriver, animated: true)
                    }
                    else
                    {
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MoveToNowLater"), object: nil)
                    Constant.MyVariables.appDelegate.truckCartModel = nil
                        Constant.MyVariables.appDelegate.saveTrucCartData()
                        USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)

                        let thanksVC = LastPageJobVC.init(nibName: "LastPageJobVC", bundle: nil)
                        thanksVC.isFromLaterJob = true
                    self.navigationController?.pushViewController(thanksVC, animated: true)
                    }
                })
                break
            }
            
        }
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
                self.showAlert("Payment error occured. Please try again after some time")

            } else if (result?.isCancelled == true) {
                print("CANCELLED")
                self.showAlert("Payment Process cancelled. Please try again after some time")
                
            } else if let result = result {
                
                let out = result.paymentMethod!

                
                self.apiPayBill(nonce:out.nonce)
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }

}
