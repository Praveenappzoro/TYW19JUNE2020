//
//  EditVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/9/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//


import UIKit
import DropDown
import Cosmos
import RSSelectionMenu

class EditVC: UIViewController,UITextFieldDelegate {
    
    
    // MARK: - UI Components
    var imagePicker: UIImagePickerController=UIImagePickerController()
    
    let dropDown = DropDown()
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textFirstName: CustomTxtField!
    @IBOutlet weak var textLastName: CustomTxtField!
    @IBOutlet weak var textMobile: CustomTxtField!
    @IBOutlet weak var textAddress: CustomTxtField!
    @IBOutlet weak var textCity: CustomTxtField!
    @IBOutlet weak var textZip: CustomTxtField!
    @IBOutlet weak var textEINNumber: CustomTxtField!
    @IBOutlet weak var textCompanyName: CustomTxtField!
    @IBOutlet weak var textCompanyAddress: CustomTxtField!
    
    @IBOutlet weak var textCompanyCity: CustomTxtField!
    @IBOutlet weak var textCompanyZip:CustomTxtField!
    
    @IBOutlet weak var btnChooseCompanyStateOtlt: CustomButton!
    
    @IBOutlet weak var btnStateOtlt: CustomButton!
    
    @IBOutlet weak var btnchooseProfilePictureOtlt: CustomButton!
    @IBOutlet weak var viewConsumerBottomOtlt: UIView!
    
    @IBOutlet weak var textTruckNumber: CustomTxtField!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ConsumerBottomViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var heigthConstraintBecomeServiceProvider: NSLayoutConstraint!
    
    // service provider Specification Design Otlt
    
    @IBOutlet weak var viewTopRatingAndJobAcceptingDetails: UIView!
    
    @IBOutlet weak var viewTopDriverInfoHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewRightNumerOfTrucks: UIView!
    @IBOutlet weak var lbldriverName: UILabel!
    
    @IBOutlet weak var viewRating: CosmosView!
    
    @IBOutlet weak var switchStatusJobAcceptingOtlt: UISwitch!
    
    @IBOutlet weak var viewDriverSpecificBottomOptions: UIView!
    
    @IBOutlet weak var viewDriverSpecificBottomHeightConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var lblEINTitle: UILabel!
    @IBOutlet weak var lblCompanyNameTitle: UILabel!
    @IBOutlet weak var lblCompanyAddressTitle: UILabel!
    
    @IBOutlet weak var btnSelectEquipmentOtlt: CustomButton!
    @IBOutlet weak var lblNumberOfTrucks: UILabel!
    
    let simpleDataArray = ["Truck", "Bobcat", "Back Ho", "Excavator"]
    var simpleSelectedArray = [String]()
    // MARK: - Data Handlers
    var uploadedImageName: String = ""
    var loginUserData:LoggedInUser!
    
    var isImagePickerDismiss: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
            self.initDataInUI()
       
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
//        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
    }
    
    
    
   
    @IBAction func switchAction(_ sender: Any)
    {
        let switchh = sender as! UISwitch
        
        self.APIForUpdateJobAccepting(isAccepting: switchh.isOn)
    }
    
    @IBAction func actionChooseState(_ sender: Any)
    {
        self.addPlace(type:"User")
    }
    
    @IBAction func actionChoosePicture(_ sender: Any)
    {
        let alert = UIAlertController(title: title, message: "options", preferredStyle: .actionSheet)
        let actionCamera = UIAlertAction(title: "Take Picture", style: .default) { (alt) in
            self.openCamera()
        }
        let actionGallery = UIAlertAction(title: "Camera Roll", style: .default) { (alt) in
            self.openGallary()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (alt) in
            
        }
        alert.addAction(actionCamera)
        alert.addAction(actionGallery)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false

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
            let str = USER_DEFAULT.value(forKey: JobAcceptingPrefrence) ?? "0"
            let strJobAccepting = str as! String
            
            self.switchStatusJobAcceptingOtlt.isOn = strJobAccepting == "1" ? true : false
        }
        
        if(!self.isImagePickerDismiss)
        {
            self.getUserDetails()
        }
        else
        {
            self.isImagePickerDismiss = false
        }
    }
    @IBAction func actionChooseCompanyState(_ sender: Any)
    {
        self.addPlace(type:"Company")
    }
    @IBAction func ActionChangePasswordScreen(_ sender: Any)
    {
        let changePassword = ChangePasswordVC.init(nibName: "ChangePasswordVC", bundle: nil)
        self.navigationController?.pushViewController(changePassword, animated: true)
    }
    
    
    @IBAction func actionTruckSelectionEquipment(_ sender: Any)
    {
         self.btnSelectEquipmentOtlt.titleLabel?.text  = ""
        
        let selectionMenu = RSSelectionMenu(selectionType: .Multiple, dataSource: simpleDataArray, cellType: .Basic) { (cell, object, indexPath) in
            
            // here you can set any text from object
            // let's set firstname in title and lastname as right detail
            
            let firstName = object
           // let firstName = object.components(separatedBy: " ").first
            //let lastName = object.components(separatedBy: " ").last
            
            cell.textLabel?.text = firstName
            //cell.detailTextLabel?.text = lastName
        }
        
        let strr = self.simpleSelectedArray.joined(separator: ",")
        
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { (text, selected, selectedItems) in
            self.simpleSelectedArray = selectedItems
       
            selectionMenu.onDismiss = { selectedItems in
                self.simpleSelectedArray = selectedItems
                let strrss = self.simpleSelectedArray.joined(separator: ",")
                self.btnSelectEquipmentOtlt.setTitle(strrss, for: .normal)
                // perform any operation once you get selected items
            }
        }
        
        // show as default
        selectionMenu.show(from: self)
    }
    
    @IBAction func actionDocuments(_ sender: Any)
    {
        let document = AddDocumentsVC.init(nibName: "AddDocumentsVC", bundle: nil)
            document.isEditable = true
            self.navigationController?.pushViewController(document, animated: true)
    }
    
    @IBAction func actionUpdateDriver(_ sender: Any)
    {
        self.EditProfileConsumerOrDriver()
    }
    
    @IBAction func actionAddNumberOfTruck(_ sender: Any)
    {
        
        let total = self.lblNumberOfTrucks.text
        var tt = Int(total as! String)
        tt = tt! + 1
        
        self.lblNumberOfTrucks.text = "\(tt as! Int)"
       
        
    }
    
    @IBAction func actionRemoveNumberOfTruck(_ sender: Any)
    {
        if(self.lblNumberOfTrucks.text != "0")
        {
            let total = self.lblNumberOfTrucks.text
            var tt = Int(total as! String)
            tt = tt! - 1
            
            self.lblNumberOfTrucks.text = "\(tt as! Int)"
        }
    }
    
    
    @IBAction func ActionSave(_ sender: Any)
    {
        self.EditProfileConsumerOrDriver()
    }
    
    func EditProfileConsumerOrDriver()
    {
        if(self.loginUserData.type != "service")
        {
            if(self.checkValidationBeforeMoveSubmitScreen())
            {
                
                let parameters = [
                    "user_id":self.loginUserData.user_id!,
                    "firstname":self.textFirstName.text!,
                    "lastname":self.textLastName.text!,
                    "contact":self.textMobile.text!,
                    "address":self.textAddress.text!,
                    "city":self.textCity.text!,
                    "state":self.btnStateOtlt.titleLabel?.text ?? "",
                    "zipcode":self.textZip.text!,
                    "type":self.loginUserData.type!,
                    "profile_image":self.uploadedImageName,
                    "ein":self.textEINNumber.text!,
                    "company_name":self.textCompanyName.text!,
                    "company_address":self.textCompanyAddress.text!,
                    "company_city":self.textCompanyCity.text!,
                    "company_state":self.btnChooseCompanyStateOtlt.titleLabel?.text ?? "",
                    "company_zipcode":self.textCompanyZip.text!,
                    "equipment": "",
                    "equipment_no":"",
                    "device_token":DeviceToken_Preference,
                    "longitude":"",
                    "latitude":"",
                    "truck_image":"",
                    "insurance_image1":"",
                    "insurance_image2":"",
                    "insurance_image3":"",
                    "cdl_license_image":"",
                    "license_plate_image":"",
                    "total_trucks":""
                    ] as! NSDictionary
                
                self.APIForUpdateExistingUserDetails(params:parameters)
            }
        }
        else
        {
            if(self.checkValidationBeforeMoveSubmitScreen())
            {
                
                let parameters = [
                    "user_id":self.loginUserData.user_id!,
                    "firstname":self.textFirstName.text!,
                    "lastname":self.textLastName.text!,
                    "contact":self.textMobile.text!,
                    "address":self.textAddress.text!,
                    "city":self.textCity.text!,
                    "state":self.btnStateOtlt.titleLabel?.text ?? "",
                    "zipcode":self.textZip.text!,
                    "type":self.loginUserData.type!,
                    "profile_image":self.uploadedImageName,
                    "ein":self.textEINNumber.text!,
                    "company_name":self.textCompanyName.text!,
                    "company_address":self.textCompanyAddress.text!,
                    "company_city":self.textCompanyCity.text!,
                    "company_state":self.btnChooseCompanyStateOtlt.titleLabel?.text ?? "",
                    "company_zipcode":self.textCompanyZip.text!,
                    "equipment": self.btnSelectEquipmentOtlt.titleLabel?.text,
                    "equipment_no":self.textTruckNumber.text!,
                    "device_token":DeviceToken_Preference,
                    "longitude":"",
                    "latitude":"",
                    "truck_image":self.loginUserData.truck_image ?? "",
                    "insurance_image1":self.loginUserData.insurance_image1 ?? "",
                    "insurance_image2":self.loginUserData.insurance_image2 ?? "",
                    "insurance_image3":self.loginUserData.insurance_image3 ?? "",
                    "cdl_license_image":self.loginUserData.cdl_license ?? "",
                    "license_plate_image":self.loginUserData.license_plate ?? "",
                    "total_trucks":self.lblNumberOfTrucks.text!
                    ] as! NSDictionary
                
                self.APIForUpdateExistingUserDetails(params:parameters)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func initDataInUI()
    {
        
        let onColor  = UIColor.green
        let offColor = UIColor.red
        
        /*For on state*/
        self.switchStatusJobAcceptingOtlt.onTintColor = onColor
        
        /*For off state*/
        self.switchStatusJobAcceptingOtlt.tintColor = offColor
        self.switchStatusJobAcceptingOtlt.layer.cornerRadius = self.switchStatusJobAcceptingOtlt.frame.height / 2
        self.switchStatusJobAcceptingOtlt.backgroundColor = offColor
        
//        self.switchStatusJobAcceptingOtlt.tintColor = .red // the "off" color
//        self.switchStatusJobAcceptingOtlt.onTintColor = .green // the "on" color
        
        self.viewRightNumerOfTrucks.layer.cornerRadius = 25
        self.viewRightNumerOfTrucks.layer.masksToBounds = true
        self.viewRightNumerOfTrucks.layer.borderWidth = 2
        self.viewRightNumerOfTrucks.layer.borderColor = UIColor.init(red: 206.0/255.0, green: 114.0/255.0, blue: 54.0/255.0, alpha: 1.0).cgColor
        
        
        self.lblNumberOfTrucks.layer.borderWidth = 2
        self.lblNumberOfTrucks.layer.borderColor = UIColor.init(red: 206.0/255.0, green: 114.0/255.0, blue: 54.0/255.0, alpha: 1.0).cgColor
        
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
            
            self.mainViewHeightConstraint.constant = 1650
            self.subViewHeightConstraint.constant = 1505
            self.viewTopRatingAndJobAcceptingDetails.alpha = 1
            self.viewDriverSpecificBottomHeightConstraint.constant = 385
            self.ConsumerBottomViewHeightConstraint.constant = 0
            self.viewConsumerBottomOtlt.alpha = 0
            self.viewTopDriverInfoHeightConstraint.constant = 100
            self.viewDriverSpecificBottomOptions.alpha = 1
            
            self.lblEINTitle.text = MandetoryEINCompanyTitles.EINNumber.rawValue
            self.lblCompanyNameTitle.text = MandetoryEINCompanyTitles.CompanyName.rawValue
            self.lblCompanyAddressTitle.text = MandetoryEINCompanyTitles.CompanyAddress.rawValue
        }
        else
        {
            self.mainViewHeightConstraint.constant = 1320
            self.subViewHeightConstraint.constant = 1150
            self.viewTopRatingAndJobAcceptingDetails.alpha = 0
            self.viewDriverSpecificBottomHeightConstraint.constant = 0
            self.ConsumerBottomViewHeightConstraint.constant = 120
            self.viewConsumerBottomOtlt.alpha = 1
            self.viewTopDriverInfoHeightConstraint.constant = 0
            self.viewDriverSpecificBottomOptions.alpha = 0
            
            self.lblEINTitle.text = OptionalsEINCompanyTitles.EINNumber.rawValue
            self.lblCompanyNameTitle.text = OptionalsEINCompanyTitles.CompanyName.rawValue
            self.lblCompanyAddressTitle.text = OptionalsEINCompanyTitles.CompanyAddress.rawValue

        }
        
        self.uploadedImageName = self.loginUserData.profile_image ?? ""
        self.imgView.loadImageAsync(with: BSE_URL_LoadMedia+self.uploadedImageName, defaultImage: "", size: self.imgView.frame.size)
        self.textFirstName.text = self.loginUserData.firstname
        self.textLastName.text = self.loginUserData.lastname
        self.textMobile.text = self.loginUserData.contact
        self.textAddress.text = self.loginUserData.address
        self.textCity.text = self.loginUserData.city
        self.textEINNumber.text = self.loginUserData.ein
        self.btnStateOtlt.setTitle(self.loginUserData.state, for: .normal)
        self.textZip.text = self.loginUserData.zipcode ?? ""
        self.textCompanyName.text = self.loginUserData.company ?? ""
        self.textCompanyCity.text = self.loginUserData.company_city ?? ""
        self.textCompanyZip.text = self.loginUserData.company_zipcode ?? ""
        self.textCompanyAddress.text = self.loginUserData.company_address ?? ""
        self.btnChooseCompanyStateOtlt.setTitle(self.loginUserData.company_state ?? "", for: .normal)
       
        self.lblNumberOfTrucks.text = self.loginUserData.total_trucks ?? "0"
        self.textTruckNumber.text = self.loginUserData.truck_number ?? ""
        
        let str = self.loginUserData.ratings ?? "0"
        
        self.viewRating.rating = Double(str) ?? 0
        
        if(self.lblNumberOfTrucks.text == "")
        {
            self.lblNumberOfTrucks.text = "0"
        }
        self.btnSelectEquipmentOtlt.setTitle(self.loginUserData.equipment ?? "", for: .normal)
        
    }
    
    func getUserDetails()
    {
        
        let parameters = [
            "user_id":self.loginUserData.user_id!,
            "access_token":self.loginUserData.access_token,
            "refresh_token":self.loginUserData.refresh_token,
            ] as! NSDictionary
        
                self.startAnimating("")
                
                APIManager.sharedInstance.getDataFromAPI(BSE_URL_GET_USER_DETAILS, .post, parameters as? [String : Any]) { (result, data, json, error, msg) in
                    
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
                            guard let loginUser = try? JSONDecoder().decode(LoggedInUser.self, from: data!) else {return}
                            USER_DEFAULT.set(data!, forKey: "userData")
                            
                            self.initDataInUI()
                            
                        })
                        break
                    }
                    
                }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            showAlert("This device has no Camera")
        }
    }
    
    //MARK:- Textfield Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.textFirstName:
            self.textLastName.becomeFirstResponder()
            break
        case self.textLastName:
            self.textMobile.becomeFirstResponder()
            break
        case self.textMobile:
            self.textAddress.becomeFirstResponder()
            break
        case self.textAddress:
            self.textCity.becomeFirstResponder()
            break
        case self.textCity:
            self.textZip.becomeFirstResponder()
            break
        case self.textZip:
            self.textEINNumber.becomeFirstResponder()
            break
        case self.textEINNumber:
            self.textCompanyName.becomeFirstResponder()
            break
        case self.textCompanyName:
            self.textCompanyAddress.becomeFirstResponder()
            break
        case self.textCompanyAddress:
            self.textCompanyCity.becomeFirstResponder()
            break
        case self.textCompanyCity:
            self.textCompanyZip.becomeFirstResponder()
            break
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if(textField == self.textFirstName || textField == self.textLastName)
        {
            if(string == " ")
            {
                return false
            }
        }
        
        if(textField == self.textCompanyZip || textField == self.textZip)
        {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 5 // Bool
        }
        
        if(textField == self.textEINNumber)
        {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            var fullString = textField.text ?? ""
            fullString.append(string)
            if range.length == 1 {
                textField.text = Utility.sharedInstance.EINNumberformat(einNumber: fullString, shouldRemoveLastDigit: true)
            } else {
                textField.text = Utility.sharedInstance.EINNumberformat(einNumber: fullString)
            }
            return false
        }
        
        if(textField == self.textMobile)
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
        
        if(textField == self.textTruckNumber)
        {
            let allowedCharacters = CharacterSet(charactersIn:ConstantStringForTruckNumber)
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 10 // Bool
        }
        
        return true
    }
    
   
    
    func addPlace(type:String)
    {
        if (type == "User")
        {
            dropDown.anchorView = self.btnStateOtlt
            
            dropDown.direction = .bottom
            dropDown.bottomOffset = CGPoint (x: 0, y:self.btnStateOtlt.frame.size.height)
            dropDown.width = self.btnStateOtlt.frame.size.width
            dropDown.dataSource = arrayUsState as! [String]
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.btnStateOtlt.setTitle(item, for: .normal)
            }
        }
        else
        {
            dropDown.anchorView = self.btnChooseCompanyStateOtlt
            
            dropDown.direction = .bottom
            dropDown.bottomOffset = CGPoint (x: 0, y:self.btnChooseCompanyStateOtlt.frame.size.height)
            dropDown.width = self.btnChooseCompanyStateOtlt.frame.size.width
            dropDown.dataSource = arrayUsState as! [String]
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.btnChooseCompanyStateOtlt.setTitle(item, for: .normal)
            }
        }
        dropDown.show()
    }
    
    
    //MARK:- Create Edit user info Api Calling
    func APIForUpdateExistingUserDetails(params:NSDictionary)
    {
        self.startAnimating("")
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_EDIT_PROFILE, .post, params as? [String : Any]) { (result, data, json, error, msg) in
            
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
                    guard let loginUser = try? JSONDecoder().decode(LoggedInUser.self, from: data!) else {return}
                    USER_DEFAULT.set(data!, forKey: "userData")
                    self.showAlert(with: {
                        self.tabBarController?.selectedIndex = 1
//                       AppDelegateVariable.appDelegate.isLogin(isLogin:true)
//                        self.navigationController?.popToRootViewController(animated: true)
                        
                    }, "Profile updated successfully.", false)
                    self.initDataInUI()
                    
                })
                break
            }
            
        }
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func checkValidationBeforeMoveSubmitScreen() -> Bool
    {
        guard Validation.isblank(testString: textFirstName.text!) else
        {
            self.showAlert("First name can't be blank.")
            return false
        }
        
        guard Validation.isblank(testString: textLastName.text!) else
        {
            self.showAlert("Last name can't be blank.")
            return false
        }
        
        guard Validation.isblank(testString: textMobile.text!) else
        {
            self.showAlert("Mobile Number can't be blank.")
            return false
        }
        
        guard Validation.isblank(testString: textAddress.text!) else
        {
            self.showAlert("Address can't be blank.")
            return false
        }
        
        guard btnStateOtlt.titleLabel?.text! != "State" else
        {
            self.showAlert("State can't be blank.")
            return false
        }
        
        guard Validation.isblank(testString: textCity.text!) else
        {
            self.showAlert("City can't be blank.")
            return false
        }
        
        guard Validation.isblank(testString: textZip.text!) else
        {
            self.showAlert("Zip code can't be blank.")
            return false
        }
        
        
        guard Validation.isLengthCorrect(testString: textMobile.text!, type: "mobile") else
        {
            self.showAlert("Make sure mobile must contain 10 digits.")
            return false
        }
        
        guard Validation.isLengthCorrect(testString: textZip.text!, type: "zip") else
        {
            self.showAlert("Make sure zip must contain 5 digits.")
            return false
        }
        
        let countEIN =   self.textEINNumber.text?.length ?? 0
        if (Int(countEIN) >= 1)
        {
        guard Validation.isLengthCorrect(testString: textEINNumber.text!, type: "ein") else
        {
            self.showAlert("Make sure EIN contain must contain 9 digits.")
            return false
        }
        }
        
        if(self.loginUserData.type == "service")
        {
       
            guard Validation.isblank(testString: textCompanyName.text!) else
            {
                self.showAlert("Company name can't be blank.")
                return false
            }
            
            guard btnChooseCompanyStateOtlt.titleLabel?.text! != "State" else
            {
                self.showAlert("Company State can't be blank.")
                return false
            }
            guard Validation.isblank(testString: textCompanyAddress.text!) else
            {
                self.showAlert("Company address can't be blank.")
                return false
            }
            
            guard Validation.isblank(testString: textCompanyCity.text!) else
            {
                self.showAlert("Company city can't be blank.")
                return false
            }
            
            guard Validation.isblank(testString: textCompanyZip.text!) else
            {
                self.showAlert("Company ZIP code can't be blank.")
                return false
            }
            
            guard Validation.isLengthCorrect(testString: textCompanyZip.text!, type: "zip") else
            {
                self.showAlert("Make sure Company ZIP must contain minimum 5 digits.")
                return false
            }
            
            guard self.btnSelectEquipmentOtlt.titleLabel?.text! != "" else
            {
                self.showAlert("Equipment can't be blank.")
                return false
            }
            guard self.lblNumberOfTrucks.text! != "0" else
            {
                self.showAlert("Make sure choose minimum 1 Truck.")
                return false
            }
            guard Validation.isblank(testString: textEINNumber.text!) else
            {
                self.showAlert("EIN Number can't be blank.")
                return false
            }
            
            
            
            guard Validation.isLengthCorrect(testString: textTruckNumber.text!, type: "truckNumber") else
            {
                self.showAlert("Make sure truck Number must contain 1 digits.")
                return false
            }
            
            guard Validation.isLengthCorrect(testString: textCompanyZip.text!, type: "zip") else
            {
                
                self.showAlert("Make sure Company ZIP contain must contain 5 digits.")
                return false
            }
        }
        return true
        
        
    }
    
    func APIGetUploadedImageName(_ pic:UIImage)
    {
        self.startAnimating("")
        
        APIManager.sharedInstance.uploadImage(pic, { (imageName) -> ()? in
            DispatchQueue.main.async(execute: {
                guard Validation.isblank(testString: imageName) else
                {
                    self.stopAnimating()
                    return
                }
                self.uploadedImageName = imageName as! String
                self.stopAnimating()
                
            })
        }) { (msg) -> ()? in
            
            DispatchQueue.main.async(execute: {
                self.stopAnimating()
                //                self.showAlert(msg)
            })
        }
    }
    
    //MARK:- Call Accept Job Api Calling
    func APIForUpdateJobAccepting(isAccepting:Bool)
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
        
        self.startAnimating("")
        
        let parameters = [
            "user_id":self.loginUserData.user_id!,
            "status":isAccepting == true ? "1" : "0",
            "access_token":self.loginUserData.access_token!,
            "refresh_token": self.loginUserData.refresh_token!
            ] as! NSDictionary
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_ACCEPTING_JOBS, .post, parameters as? [String : Any]) { (result, data, json, error, msg) in
            
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
//                    let dict = json
                    let str = self.switchStatusJobAcceptingOtlt.isOn == true ? "1" : "0"
                    USER_DEFAULT.set(str , forKey: JobAcceptingPrefrence)
                    self.switchStatusJobAcceptingOtlt.isOn = str == "1" ? true : false

                    
                })
                break
            }
            
        }
    }
    
    
}

extension EditVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        self.isImagePickerDismiss = true
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        self.isImagePickerDismiss = true
//        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//
//        self.imgView.contentMode = .scaleAspectFill
//        self.imgView.image = chosenImage
//
//        self.APIGetUploadedImageName(chosenImage)
//        dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.isImagePickerDismiss = true
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.imgView.contentMode = .scaleAspectFill
        self.imgView.image = chosenImage
        
        let pickedImage = fixOrientation(img: chosenImage)
        self.APIGetUploadedImageName(pickedImage)
        dismiss(animated: true, completion: nil)
    }
    
    func fixOrientation(img:UIImage) -> UIImage {

        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }

        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)

        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;

    }
}
