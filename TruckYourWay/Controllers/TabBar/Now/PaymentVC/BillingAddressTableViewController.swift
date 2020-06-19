//
//  BillingAddressTableViewController.swift
//  TruckYourWay
//
//  Created by APPZORO on 11/12/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import UIKit
import DropDown

class BillingAddressTableViewController: UITableViewController {
    
     let dropDown = DropDown()
    
    @IBOutlet weak var txtFistName: CustomTxtField!
    @IBOutlet weak var txtLastName: CustomTxtField!
    @IBOutlet weak var txtCompanyName: CustomTxtField!
    @IBOutlet weak var txtBillingAddress: CustomTxtField!
    @IBOutlet weak var txtBillingAddress2: CustomTxtField!
    @IBOutlet weak var txtBillingCity: CustomTxtField!
    @IBOutlet weak var txtBillingZipCode: CustomTxtField!
    @IBOutlet weak var btnBllingState: CustomButton!
    @IBOutlet weak var txtBillingCountary: CustomTxtField!
    
    
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
    var loginUserData:LoggedInUser!
    var billingDetails: [String: Any]?
    var nonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
          self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedToPaymentButtonClick(_ sender: Any) {
        if  checkValidationBeforeMoveSubmitScreen() {
              billingDetails = ["firstName" : txtFistName.text ?? "",
                                  "lastName" : txtLastName.text ?? "",
                                  "company" : txtCompanyName.text ?? "",
                                  "address" : txtBillingAddress.text ?? "",
                                  "address2" : txtBillingAddress2.text ?? "",
                                  "city" : txtBillingCity.text ?? "",
                                 ]
            
            billingDetails?["zipcode"] =  txtBillingZipCode.text ?? ""
            billingDetails?["state"] =  btnBllingState.titleLabel?.text ?? ""
            billingDetails?["country"] = txtBillingCountary.text ?? ""
            
//            let paymentVC = PaymentVC.init(nibName: "PaymentVC", bundle: nil)
//            paymentVC.dictBillDetails = self.dictBillDetails.mutableCopy() as! NSMutableDictionary
//            paymentVC.pickedCordinates = self.pickedCordinates.mutableCopy() as! NSMutableDictionary
//            paymentVC.bill_Id = self.bill_Id
//            paymentVC.promoAmount = self.promoAmount
//            paymentVC.bill_amount = self.bill_amount
//            paymentVC.tax_amount = self.tax_amount
//            paymentVC.total_amount = self.total_amount
//            paymentVC.delivery_type = self.delivery_type
//            paymentVC.isMultipleDriverForLater = self.isMultipleDriverForLater
//            paymentVC.billingDetails = billingDetails
            
   //         self.navigationController?.pushViewController(paymentVC, animated: true)
            self.apiPayBill()
        }
    }
    
    
    //MARK:- api Pay Bill Calling
    
    func apiPayBill()
    {
        let parameters = [
            "nonce":nonce ?? "",
            "bill_no":self.bill_Id,
            "amount":self.total_amount,
            "user_id":self.loginUserData.user_id ?? "",
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            "type": self.isMultipleDriverForLater ? "multiple" : "single",
            "billingDetails": billingDetails ?? [:]
            ] as [String : Any]
        
        self.startAnimating("")
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_PAY_BILL, .post, parameters) { (result, data, json, error, msg) in
            
            switch result
            {
            case .Failure:
                DispatchQueue.main.async(execute: {
                    self.stopAnimating()
                    //self.showAlert(msg)
                    self.showAlert(with: {
                       self.navigationController?.popViewController(animated: true)
                    }, msg, false)
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
    
    @IBAction func billingStateButtonClick(_ sender: Any) {
        dropDown.anchorView = self.btnBllingState
        
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint (x: 0, y:self.btnBllingState.frame.size.height)
        dropDown.width = self.btnBllingState.frame.size.width
        dropDown.dataSource = arrayUsState as! [String]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btnBllingState.setTitle(item, for: .normal)
        }
         dropDown.show()
    }
    
    
    
    func checkValidationBeforeMoveSubmitScreen() -> Bool
    {
        guard Validation.isblank(testString: txtFistName.text!) else
        {
            self.showAlert("First name can't be blank.")
            return false
        }
        
        guard Validation.isblank(testString: txtLastName.text!) else
        {
            self.showAlert("Last name can't be blank.")
            return false
        }
        
//        guard Validation.isblank(testString: txtCompanyName.text!) else
//        {
//            self.showAlert("Company name can't be blank.")
//            return false
//        }
        
        guard Validation.isblank(testString: txtBillingAddress.text!) else
        {
            self.showAlert("Address can't be blank.")
            return false
        }
        
//        guard Validation.isblank(testString: txtBillingAddress2.text!) else
//        {
//            self.showAlert("Address 2 can't be blank.")
//            return false
//        }
        
        guard Validation.isblank(testString: txtBillingCity.text!) else
        {
            self.showAlert("City can't be blank.")
            return false
        }
        
        guard Validation.isblank(testString: txtBillingZipCode.text!) else
        {
            self.showAlert("Zip code can't be blank.")
            return false
        }
        
        guard btnBllingState.titleLabel?.text! != "State" else
        {
            self.showAlert("State can't be blank.")
            return false
        }
        
        guard  Validation.isblank(testString: txtBillingCountary.text!) else
        {
            self.showAlert("Country can't be blank.")
            return false
        }
        
        return true
        
        
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
