//
//  TermsAndConditionsVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/19/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController, UIScrollViewDelegate,UIWebViewDelegate {

    @IBOutlet weak var btnCheckToggleOtlt: UIButton!

    @IBOutlet weak var webViewOtlt: UIWebView!
    
    @IBOutlet weak var webViewBottomConstraint: NSLayoutConstraint!
    
    var bill_Id:String = ""
    var bill_amount:String = ""
    var promoAmount:String = ""
    var tax_amount:String = ""
    var total_amount:String = ""
    
    var delivery_type: String = ""
    var dictBillDetails : NSMutableDictionary = [:]
    var pickedCordinates : NSMutableDictionary = [:]

    var arrSelectedMaterials: NSArray = []
    
    var isViewable: Bool = false
    var isMultipleDriverForLater: Bool = false

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
    
        self.webViewOtlt.scrollView.delegate = self
        
        let url = URL (string: BSE_URL_Privcy_terms)
        let requestObj = URLRequest(url: url!)
        self.webViewOtlt.loadRequest(requestObj)
        self.startAnimating("Loading...")
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
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

        model.dictBillDetails = self.dictBillDetails
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        USER_DEFAULT.set(AppState.TruckTermsAndConditions.rawValue, forKey: APP_STATE_KEY)
    }
    

    @IBAction func actionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAgreeCheck(_ sender: Any)
    {
        if(self.btnCheckToggleOtlt.isSelected)
        {
            self.btnCheckToggleOtlt.isSelected = false
        }
        else
        {
            self.btnCheckToggleOtlt.isSelected = true
        }
    }
    
    @IBAction func actionProceed(_ sender: Any)
    {
        if(self.btnCheckToggleOtlt.isSelected)
        {
          //  let paymentVC  = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BillingAddressTableViewController") as! BillingAddressTableViewController
            
             let paymentVC = PaymentVC.init(nibName: "PaymentVC", bundle: nil)
            
                paymentVC.dictBillDetails = self.dictBillDetails.mutableCopy() as! NSMutableDictionary
                paymentVC.pickedCordinates = self.pickedCordinates.mutableCopy() as! NSMutableDictionary
                paymentVC.bill_Id = self.bill_Id
                paymentVC.promoAmount = self.promoAmount
                paymentVC.bill_amount = self.bill_amount
                paymentVC.tax_amount = self.tax_amount
                paymentVC.total_amount = self.total_amount
                paymentVC.delivery_type = self.delivery_type
                paymentVC.isMultipleDriverForLater = self.isMultipleDriverForLater
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
        else
        {
            showAlert("Please agree to Terms and Conditions.")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let y =  scrollView.contentSize.height - scrollView.bounds.origin.y
        let ss = (y - (self.webViewOtlt.frame.size.height))
        
        
        if(ss < 10 && self.isViewable == false)
        {
            self.isViewable = true
            self.webViewBottomConstraint.constant = 170
            //Do what you want.
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
//        self.startAnimating("Loading...")
    } // show indicator
    func webViewDidFinishLoad(_ webView: UIWebView){
        self.stopAnimating()
    } // hide indicator
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        self.stopAnimating()
    } // hide indicator

    
}

