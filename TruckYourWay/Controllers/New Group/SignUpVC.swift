//
//  SignUpVC.swift
//  TruckYourWay
//
//  Created by Samradh Agarwal on 05/09/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import DropDown
import RSSelectionMenu

class SignUpVC: UIViewController,UITextFieldDelegate {

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
    
    @IBOutlet weak var heightConstraintForBecomeSPHeader: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblEINTitle: UILabel!
    @IBOutlet weak var lblCompanyNameTitle: UILabel!
    @IBOutlet weak var lblCompanyAddressTitle: UILabel!
    
    @IBOutlet weak var heightConstraintInfoView: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintLblAllFiledMandatory: NSLayoutConstraint!
    
    var strLatitude : String = ""
    var strLongitute : String = ""
    // Driver Specification Design Otlt
    
   
    
    @IBOutlet weak var viewBottomTruckOtlt: UIView!
    @IBOutlet weak var viewNumberOfTruck: UIView!
    @IBOutlet weak var viewRightNumerOfTrucks: UIView!
    
    @IBOutlet weak var btnSelectEquipmentOtlt: CustomButton!
    
    @IBOutlet weak var lblNumberOfTrucks: UILabel!
    
    @IBOutlet weak var textTruckNumber: CustomTxtField!
    
    @IBOutlet weak var viewDriverEqupmentHeightConstraint: NSLayoutConstraint!
    
    
    let simpleDataArray = ["Truck", "Bobcat", "Back Ho", "Excavator"]
    var simpleSelectedArray = [String]()
    
    // MARK: - Data Handlers
    var uploadedImageName: String = ""
    
    var isConsumer:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if(self.isConsumer)
        {
           self.heightConstraintLblAllFiledMandatory.constant = 0
                self.heightConstraintInfoView.constant = 210
            self.heightConstraintForBecomeSPHeader.constant = 0
        }
        else
        {
            self.heightConstraintLblAllFiledMandatory.constant = 40
            self.heightConstraintInfoView.constant = 250
            self.heightConstraintForBecomeSPHeader.constant = 44
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        if(self.isConsumer)
        {
            self.mainViewHeightConstraint.constant = 1260
            self.subViewHeightConstraint.constant = 1040
            self.viewDriverEqupmentHeightConstraint.constant = 0
            self.viewBottomTruckOtlt.alpha = 0
            
            self.lblEINTitle.text = OptionalsEINCompanyTitles.EINNumber.rawValue
            self.lblCompanyNameTitle.text = OptionalsEINCompanyTitles.CompanyName.rawValue
            self.lblCompanyAddressTitle.text = OptionalsEINCompanyTitles.CompanyAddress.rawValue
            
        }
        else
        {
            self.mainViewHeightConstraint.constant = 1520
            self.subViewHeightConstraint.constant = 1300
            self.viewDriverEqupmentHeightConstraint.constant = 220
            self.viewBottomTruckOtlt.alpha = 1
            
            self.viewRightNumerOfTrucks.layer.cornerRadius = 25
            self.viewRightNumerOfTrucks.layer.masksToBounds = true
            self.viewRightNumerOfTrucks.layer.borderWidth = 2
            self.viewRightNumerOfTrucks.layer.borderColor = UIColor.init(red: 206.0/255.0, green: 114.0/255.0, blue: 54.0/255.0, alpha: 1.0).cgColor
            
            
            self.lblNumberOfTrucks.layer.borderWidth = 2
            self.lblNumberOfTrucks.layer.borderColor = UIColor.init(red: 206.0/255.0, green: 114.0/255.0, blue: 54.0/255.0, alpha: 1.0).cgColor
            
            
            self.lblEINTitle.text = MandetoryEINCompanyTitles.EINNumber.rawValue
            self.lblCompanyNameTitle.text = MandetoryEINCompanyTitles.CompanyName.rawValue
            self.lblCompanyAddressTitle.text = MandetoryEINCompanyTitles.CompanyAddress.rawValue
        }
        
        guard let lat = USER_DEFAULT.value(forKey: LatitudePrefrence) else{ return }
        guard let long = USER_DEFAULT.value(forKey: LongitudePrefrence) else{ return }
        
        self.strLatitude = lat as! String
        self.strLongitute = long as! String
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
    
    @IBAction func actionChooseCompanyState(_ sender: Any)
    {
        self.addPlace(type:"Company")
    }
    @IBAction func ActionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func actionTruckSelectionEquipment(_ sender: Any)
    {
        self.btnSelectEquipmentOtlt.titleLabel?.text = ""
//        self.btnSelectEquipmentOtlt.setTitle("", for: .normal)
        
        let selectionMenu = RSSelectionMenu(selectionType: .Multiple, dataSource: simpleDataArray, cellType: .Basic) { (cell, object, indexPath) in
            
            // here you can set any text from object
            // let's set firstname in title and lastname as right detail
            let firstName = object
//            let firstName = object.components(separatedBy: " ").first
//            let lastName = object.components(separatedBy: " ").last
            
            cell.textLabel?.text = firstName
//            cell.detailTextLabel?.text = lastName
        }
        
        let strr = self.simpleSelectedArray.joined(separator: ",")
        
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { (text, selected, selectedItems) in
            self.simpleSelectedArray = selectedItems
            
            selectionMenu.onDismiss = { selectedItems in
                self.simpleSelectedArray = selectedItems
                
                    let strrss = self.simpleSelectedArray.joined(separator: ",")
                    self.btnSelectEquipmentOtlt.setTitle(strrss, for: .normal)
                }
                // perform any operation once you get selected items
        }
        
        // show as default
        selectionMenu.show(from: self)
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
       
//        if(textField == self.textFirstName || textField == self.textLastName)
//        {
//            if(string == " ")
//            {
//                return false
//            }
//        }
        
        if(textField == self.textCompanyZip || textField == self.textZip)
        {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 5 // Bool
        }
//        if(textField == self.textMobile)
//        {
//            guard let text = textField.text else { return true }
//            let newLength = text.characters.count + string.characters.count - range.length
//            return newLength <= 10 // Bool
//        }
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
//            return newLength <= 9 // Bool
        }
        
//        if(textField == self.textTruckNumber)
//        {
//            let allowedCharacters = CharacterSet(charactersIn:ConstantStringForTruckNumber)
//            let characterSet = CharacterSet(charactersIn: string)
//            return allowedCharacters.isSuperset(of: characterSet)
//            
//            guard let text = textField.text else { return true }
//            let newLength = text.characters.count + string.characters.count - range.length
//            return newLength <= 10 // Bool
//        }
        
        
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
        
         return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
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
    @IBAction func ActionNext(_ sender: Any)
    {
        if(self.isConsumer)
        {
           if(self.checkValidationBeforeMoveSubmitScreen())
           {
            
            let parameters = [
                "email":"",
                "firstname":self.textFirstName.text!,
                "lastname":self.textLastName.text!,
                "contact":self.textMobile.text!,
                "address":self.textAddress.text!,
                "city":self.textCity.text!,
                "state":self.btnStateOtlt.titleLabel?.text!,
                "zipcode":self.textZip.text!,
                "type":"customer",
                "profile_image":self.uploadedImageName,
                "password":"",
                "ein":self.textEINNumber.text,
                "company_name":self.textCompanyName.text,
                "company_address":self.textCompanyAddress.text,
                "company_city":self.textCompanyCity.text,
                "company_state": self.btnChooseCompanyStateOtlt.titleLabel?.text,
                "company_zipcode": self.textCompanyZip.text,
                "equipment":"",
                "equipment_no":"",
                "device_token":DeviceToken_Preference,
                "latitude":self.strLatitude,
                "longitude":self.strLongitute,
                "truck_image":"",
                "insurance_image1":"",
                "insurance_image2":"",
                "insurance_image3":"",
                "cdl_license_image":"",
                "license_plate_image":"",
                "total_trucks":""
                ] as NSDictionary
                let signUp = SignUpSubmitVC.init(nibName: "SignUpSubmitVC", bundle: nil)
                signUp.dictUserDetail = parameters.mutableCopy() as! NSMutableDictionary
                signUp.isConsumer = self.isConsumer
                self.navigationController?.pushViewController(signUp, animated: true)
           }
        }
        else
        {
            if(self.checkValidationBeforeMoveSubmitScreen())
            {
                
                let parameters = [
                    "email":"",
                    "firstname":self.textFirstName.text!,
                    "lastname":self.textLastName.text!,
                    "contact":self.textMobile.text!,
                    "address":self.textAddress.text!,
                    "city":self.textCity.text!,
                    "state":self.btnStateOtlt.titleLabel?.text!,
                    "zipcode":self.textZip.text!,
                    "type":"service",
                    "profile_image":self.uploadedImageName,
                    "password":"",
                    "ein":self.textEINNumber.text,
                    "company_name":self.textCompanyName.text,
                    "company_address":self.textCompanyAddress.text,
                    "company_city":self.textCompanyCity.text,
                    "company_state": self.btnChooseCompanyStateOtlt.titleLabel?.text,
                    "company_zipcode": self.textCompanyZip.text,
                    "equipment":self.btnSelectEquipmentOtlt.titleLabel?.text,
                    "equipment_no":self.textTruckNumber.text!,
                    "device_token":DeviceToken_Preference,
                    "latitude":self.strLatitude,
                    "longitude":self.strLongitute,
                    "truck_image":"",
                    "insurance_image1":"",
                    "insurance_image2":"",
                    "insurance_image3":"",
                    "cdl_license_image":"",
                    "license_plate_image":"",
                    "total_trucks":self.lblNumberOfTrucks.text!
                    ] as NSDictionary
                
                let addDoc = AddDocumentsVC.init(nibName: "AddDocumentsVC", bundle: nil)
                addDoc.isEditable = false
                addDoc.isConsumer = self.isConsumer
                addDoc.dictUserDetail = parameters.mutableCopy() as! NSMutableDictionary
                self.navigationController?.pushViewController(addDoc, animated: true)
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
            self.showAlert("Make sure zip must contain minimum 5 digits.")
            return false
        }
        
        let countEIN =   self.textEINNumber.text?.length ?? 0
        
        if (Int(countEIN) >= 1)
        {
        guard Validation.isLengthCorrect(testString: textEINNumber.text!, type: "ein") else
        {
            self.showAlert("Make sure EIN must contain minimum 9 digits.")
            return false
        }
            
        }
        
        if(!self.isConsumer)
        {
            
            guard Validation.isblank(testString: self.uploadedImageName) else
            {
                self.showAlert("Please upload your profile picture.")
                return false
            }
            
            guard Validation.isblank(testString: textEINNumber.text!) else
            {
                self.showAlert("EIN Number can't be blank.")
                return false
            }
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
            
            guard self.btnSelectEquipmentOtlt.titleLabel?.text ?? "" != "" else
            {
                self.showAlert("Equipment can't be blank.")
                return false
            }
            guard self.lblNumberOfTrucks.text! != "0" else
            {
                self.showAlert("Make sure choose minimum 1 Truck.")
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
    
    func APIGetUploadedImageName(_ pic:UIImage) {
        self.startAnimating("")
        
        APIManager.sharedInstance.uploadImage(pic, { (imageName) -> ()? in
            DispatchQueue.main.async(execute: {
                guard Validation.isblank(testString: imageName) else
                {
                    self.stopAnimating()
                    self.imgView.image = UIImage.init(named: "")
                    return
                }
                self.uploadedImageName = imageName as! String
                self.stopAnimating()
                
            })
        }) { (msg) -> ()? in
            
            DispatchQueue.main.async(execute: {
                self.stopAnimating()
                self.imgView.image = UIImage.init(named: "")
                //                self.showAlert(msg)
            })
        }
    }
    

}

extension SignUpVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
            self.imgView.contentMode = .scaleAspectFill
            self.imgView.image = chosenImage
        
        self.APIGetUploadedImageName(chosenImage)
        dismiss(animated: true, completion: nil)
    }
}
