//
//  ServiceRequestVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 11/15/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import DropDown

class ServiceRequestVC: UIViewController {

    
    //MARK:- outlets addded
    
    @IBOutlet weak var txtCompanyName: CustomTxtField!
    @IBOutlet weak var txtContactName: CustomTxtField!
    @IBOutlet weak var txtAddressJob: CustomTxtField!
    
    @IBOutlet weak var txtEmail: CustomTxtField!
    @IBOutlet weak var txtMobileNumber: CustomTxtField!
    @IBOutlet weak var btnStateNameOtlt: CustomButton!
    @IBOutlet weak var btnchooseJobTypeOtlt: CustomButton!
    
    @IBOutlet weak var txtCity: CustomTxtField!
    @IBOutlet weak var txtZipCode: CustomTxtField!
    
    @IBOutlet weak var txtViewDescriptionJob: UITextView!
    
    @IBOutlet weak var txtSquareFootage: CustomTxtField!
    
    @IBOutlet weak var btnSelectedServiceOtlt: CustomButton!
    
    @IBOutlet weak var switchIsBobcatNeeded: UISwitch!
    
    
    //#MARK :- Pop Up Design
    
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var subViewPopup: UIView!
    
    @IBOutlet weak var btnCheckToggleOtlt: UIButton!
    
    var isBobcatNeeded: Bool = false
    var selectedServiceType: String = ""
    var arrSelectedServiceList: NSMutableArray = []
    let dropDown = DropDown()
    
    var loginUserData:LoggedInUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedServiceType)
        if Constant.MyVariables.appDelegate.truckCartModel != nil {
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            self.selectedServiceType = model.selectedServicesServiceType
            self.isBobcatNeeded = model.isBobcatNeeded
            self.arrSelectedServiceList = model.arrSelectedServiceList
        }
        
        self.subViewPopup.layer.cornerRadius = 10
        self.subViewPopup.layer.masksToBounds = true
        
        let strTitle = "\(selectedServiceType) \(" REQUEST ")"
        self.btnSelectedServiceOtlt.setTitle(strTitle, for: .normal)
        
        self.btnSelectedServiceOtlt.titleLabel?.minimumScaleFactor = 0.5
        self.btnSelectedServiceOtlt.titleLabel?.numberOfLines = 0   //<-- Or to desired number of lines
        self.btnSelectedServiceOtlt.titleLabel?.adjustsFontSizeToFitWidth = true
        self.switchIsBobcatNeeded.isOn = self.isBobcatNeeded
        
         if let URL = Bundle.main.url(forResource: "ServicesList", withExtension: "plist") {
            let services = NSDictionary(contentsOf: URL) as! NSDictionary
            let dict = services.value(forKey: "Services") as! NSDictionary
            let arr = dict.value(forKey: self.selectedServiceType) as! NSArray
            self.arrSelectedServiceList = arr.mutableCopy() as! NSMutableArray
            //            arrServicesList
        }
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        self.designTextDescription()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appIsGoingInBackground)
            , name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("disappearing..")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func appIsGoingInBackground() {
        print("disappearing..")
        
        guard let sModel = Constant.MyVariables.appDelegate.truckCartModel else {
            return
        }
        sModel.isBobcatNeeded = self.isBobcatNeeded
        sModel.arrSelectedServiceList = self.arrSelectedServiceList
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        USER_DEFAULT.set(AppState.TruckServiceRequest.rawValue, forKey: APP_STATE_KEY)
        
    }
    
    
    
    //MARK:- All IBActions
    
    @IBAction func actionBack(_ sender: Any)
    {
        self.resignAllKeyboard()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionChooseJobType(_ sender: Any)
    {
        self.resignAllKeyboard()
        self.addPlace(type: "JobType")
    }
    
    @IBAction func actionChooseState(_ sender: Any)
    {
        self.resignAllKeyboard()
        self.addPlace(type: "State")
    }
    
    @IBAction func actionSubmit(_ sender: Any)
    {
        
        
            self.resignAllKeyboard()
            if(self.checkValidationForRequestSubmit())
            {
                if(self.btnCheckToggleOtlt.isSelected)
                {
                self.apiForRegisterService()
    //            self.viewPopup.alpha = 1
                }
                else{
                    self.showAlert("Please agree to Terms and Conditions.")
                }
               
            }
            else
            {
                
            }
        
    }
    
    
    
    @IBAction func actionOkayFromPopUp(_ sender: Any)
    {
        self.resignAllKeyboard()
         self.viewPopup.alpha = 0
        self.navigationController?.popToRootViewController(animated: true)
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
    
    @IBAction func switchBobcatValueChange(_ sender: Any)
    {
        self.resignAllKeyboard()
         let switchBobcat = sender as! UISwitch
        self.isBobcatNeeded = switchBobcat.isOn
//        self.switchIsBobcatNeeded.isOn = self.isBobcatNeeded
    }
    
    func resignAllKeyboard()
    {
        self.txtCity.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
        self.txtZipCode.resignFirstResponder()
        self.txtAddressJob.resignFirstResponder()
        self.txtCompanyName.resignFirstResponder()
        self.txtContactName.resignFirstResponder()
        self.txtMobileNumber.resignFirstResponder()
        self.txtSquareFootage.resignFirstResponder()
        self.txtViewDescriptionJob.resignFirstResponder()
        
    }
    
    
    func designTextDescription()
    {
        self.txtViewDescriptionJob.layer.cornerRadius = 20
        self.txtViewDescriptionJob.layer.masksToBounds = true
        self.txtViewDescriptionJob.layer.borderWidth = 2
        self.txtViewDescriptionJob.layer.borderColor = UIColor.init(red: 206.0/255.0, green: 114.0/255.0, blue: 54.0/255.0, alpha: 1.0).cgColor
        self.txtViewDescriptionJob.textContainerInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        //        self.txtViewDescriptionJob.textContainer.lineFragmentPadding = 20
    }
    
    //MARK:- Get State local manage
    func addPlace(type:String)
    {
        if (type == "State")
        {
            dropDown.anchorView = self.btnStateNameOtlt
            
            dropDown.direction = .bottom
            dropDown.bottomOffset = CGPoint (x: 0, y:self.btnStateNameOtlt.frame.size.height)
            dropDown.width = self.btnStateNameOtlt.frame.size.width
            dropDown.dataSource = arrayUsState as! [String]
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.btnStateNameOtlt.setTitle(item, for: .normal)
            }
        }
        else
        {
            dropDown.anchorView = self.btnchooseJobTypeOtlt
            
            dropDown.direction = .bottom
            dropDown.bottomOffset = CGPoint (x: 0, y:self.btnchooseJobTypeOtlt.frame.size.height)
            dropDown.width = self.btnchooseJobTypeOtlt.frame.size.width
            dropDown.dataSource = self.arrSelectedServiceList as! [String]
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.btnchooseJobTypeOtlt.setTitle(item, for: .normal)
            }
        }
        dropDown.show()
    }
    
    //MARK:- Create Edit user info Api Calling
    func apiForRegisterService()
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
        
        let params = [
            "user_id":self.loginUserData.user_id!,
            "company_name":self.txtCompanyName.text!,
            "contact":self.txtContactName.text!,
            "address":self.txtAddressJob.text!,
            "city":self.txtCity.text!,
            "state":self.btnStateNameOtlt.titleLabel?.text ?? "",
            "zipcode":self.txtZipCode.text!,
            "mobile":self.txtMobileNumber.text!,
            "email":self.txtEmail.text!,
            "is_bobcat":self.isBobcatNeeded,
            "type":self.btnchooseJobTypeOtlt.titleLabel?.text ?? "",
            "description":self.txtViewDescriptionJob.text!,
            "square_footage":self.txtSquareFootage.text!,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            "service": selectedServiceType
            ] as! NSDictionary
        
        self.startAnimating("")
        
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_REGISTER_SERVICE, .post, params as? [String : Any]) { (result, data, json, error, msg) in
            
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
                    self.viewPopup.alpha = 1
                    
                })
                break
            }
            
        }
    }
    
    //MARK:- validation Method
    
    func checkValidationForRequestSubmit() -> Bool
    {
//        guard Validation.isblank(testString: self.txtCompanyName.text!) else
//        {
//            self.showAlert("Company name can't be blank.")
//            return false
//        }
        
        guard Validation.isblank(testString: self.txtContactName.text!) else
        {
            self.showAlert("Contact name can't be blank.")
            return false
        }
        
        guard Validation.isblank(testString: txtAddressJob.text!) else
        {
            self.showAlert("Address of Job can't be blank.")
            return false
        }
        
        guard btnStateNameOtlt.titleLabel?.text! != "State" else
        {
            self.showAlert(" Please select State.")
            return false
        }
        
        guard Validation.isblank(testString: txtCity.text!) else
        {
            self.showAlert("City can't be blank.")
            return false
        }
        
        guard Validation.isblank(testString: txtZipCode.text!) else
        {
            self.showAlert("Zip code can't be blank.")
            return false
        }
        
        guard Validation.isLengthCorrect(testString: txtZipCode.text!, type: "zip") else
        {
            self.showAlert("Make sure zip code must contain 5 digits.")
            return false
        }
        
        guard Validation.isblank(testString: txtMobileNumber.text!) else
        {
            self.showAlert("Mobile Number can't be blank.")
            return false
        }
        
        guard Validation.isLengthCorrect(testString: txtMobileNumber.text!, type: "mobile") else
        {
            self.showAlert("Make sure mobile number must contain 10 digits.")
            return false
        }
        
        
        guard Validation.isblank(testString: txtEmail.text!) else
        {
            self.showAlert("Email can't be blank.")
            return false
        }
        
        guard Validation.isValidEmail(emailString: txtEmail.text!) else
        {
            self.showAlert("Email not valid.")
            return false
        }
        
        guard btnchooseJobTypeOtlt.titleLabel?.text! != "Choose" else
        {
            self.showAlert("Please select Type of Job.")
            return false
        }
        
        guard Validation.isblank(testString: txtViewDescriptionJob.text!) else
        {
            self.showAlert("Please Enter Job Description.")
            return false
        }
        
        guard Validation.isblank(testString: txtSquareFootage.text!) else
        {
            self.showAlert("Please Enter Square Footage of Job.")
            return false
        }
       
        
        
        
       
        
        
        
        
        return true
        
        
    }
    
}

extension ServiceRequestVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if(textField == self.txtEmail || textField == self.txtZipCode || textField == self.txtSquareFootage)
        {
            guard let text = textField.text else { return true }
            
            if(string == " ")
            {
                return false
            }
            
            if(textField == self.txtZipCode)
            {
                guard let text = textField.text else { return true }
                let newLength = text.characters.count + string.characters.count - range.length
                return newLength <= 5 // Bool
            }
           
            
            return true // Bool
        }
        
        if(textField == self.txtMobileNumber)
        {
            var fullString = textField.text ?? ""
            fullString.append(string)
            if range.length == 1 {
                textField.text = Utility.sharedInstance.USPhoneNumberformat(phoneNumber: fullString, shouldRemoveLastDigit: true)
            } else {
                textField.text = Utility.sharedInstance.USPhoneNumberformat(phoneNumber: fullString)
            }
            return false
        }
        
        return true
    }
}
