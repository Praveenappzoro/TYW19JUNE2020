//
//  SpecialDeliveryInstructionsVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/16/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class SpecialDeliveryInstructionsVC: UIViewController {

    @IBOutlet weak var textContactName: CustomTxtField!
    
    @IBOutlet weak var textContactNumber: CustomTxtField!
    
    @IBOutlet weak var labelInstruction: UILabel!
    @IBOutlet weak var labelSpecialInstruction: UILabel!

    @IBOutlet weak var textSpecialDeliveryInstructions: CustomTextView!

    var selectedServiceType: String = ""
    
    var pickedCordinates : NSMutableDictionary = [:]
    var selectedMaterialType : NSMutableDictionary = [:]
    var arrSelectedMaterial : NSMutableArray = []
    
    var selected_Date: String = ""
    var delivery_type: String = ""
    var later_start: Int = 0
    var later_end: Int = 0
    
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
            self.arrSelectedMaterial = model.arrSelectedDeliveryMaterial
            self.selectedServiceType = model.selectedServiceType
            self.textContactName.text = model.contact_name
            self.textContactNumber.text = model.contact_no
            self.textSpecialDeliveryInstructions.text = model.instruction
        }
        
        self.textSpecialDeliveryInstructions.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.appIsGoingInBackground)
            , name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        if self.selectedServiceType == "DELIVERY" {
            labelInstruction.text = "Please give YOUR Service Provider(s) Special Instructions about YOUR Delivery order."
            labelSpecialInstruction.text = "Special Delivery Instructions"
        } else {
            labelInstruction.text = "Please give YOUR Service Provider(s) Special Instructions about YOUR Hauling order."
            labelSpecialInstruction.text = "Special Hauling Instructions"
        }
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

        model.contact_name = self.textContactName.text ?? ""
        model.contact_no = self.textContactNumber.text ?? ""
        model.instruction = self.textSpecialDeliveryInstructions.text ?? ""
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        USER_DEFAULT.set(AppState.TruckSpecialInstruction.rawValue, forKey: APP_STATE_KEY)
    }
    
    @IBAction func ActionBack(_ sender: Any)
    {
//        let model = Constant.MyVariables.appDelegate.truckCartModel!
//        
//        model.contact_name = ""
//        model.contact_no = ""
//        model.instruction = ""
//        
//        Constant.MyVariables.appDelegate.saveTrucCartData()
//        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionSkip(_ sender: Any)
    {
        let orderConfirmation = OrderConfirmationVC.init(nibName: "OrderConfirmationVC", bundle: nil)
            orderConfirmation.pickedCordinates = self.pickedCordinates.mutableCopy() as! NSMutableDictionary
            orderConfirmation.selectedMaterialType = self.selectedMaterialType.mutableCopy() as! NSMutableDictionary
            orderConfirmation.arrSelectedMaterials = self.arrSelectedMaterial.mutableCopy() as! NSMutableArray
            orderConfirmation.selectedServiceType = self.selectedServiceType
            orderConfirmation.contact_name = ""
            orderConfirmation.contact_no = ""
            orderConfirmation.instruction = ""
            orderConfirmation.selected_Date =  selected_Date
            orderConfirmation.delivery_type = delivery_type
            orderConfirmation.later_start = later_start
            orderConfirmation.later_end = later_end
        
        let model = Constant.MyVariables.appDelegate.truckCartModel!
        
        
        model.contact_name =  ""
        model.contact_no =  ""
        model.instruction = ""
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        USER_DEFAULT.set(AppState.TruckChooseDeliveryServiceMaterials.rawValue, forKey: APP_STATE_KEY)
        
        
        self.navigationController?.pushViewController(orderConfirmation, animated: true)
    }
    
    @IBAction func ActionNext(_ sender: Any)
    {
        
        if(self.checkValidationForSpecialInstruction())
        {
            let orderConfirmation = OrderConfirmationVC.init(nibName: "OrderConfirmationVC", bundle: nil)
                orderConfirmation.pickedCordinates = self.pickedCordinates.mutableCopy() as! NSMutableDictionary
                orderConfirmation.selectedMaterialType = self.selectedMaterialType.mutableCopy() as! NSMutableDictionary
                orderConfirmation.arrSelectedMaterials = self.arrSelectedMaterial.mutableCopy() as! NSMutableArray
                orderConfirmation.selectedServiceType = self.selectedServiceType
                orderConfirmation.contact_name = self.textContactName.text ?? ""
                orderConfirmation.contact_no = self.textContactNumber.text ?? ""
                orderConfirmation.instruction = self.textSpecialDeliveryInstructions.text ?? ""
                orderConfirmation.selected_Date =  selected_Date
                orderConfirmation.delivery_type = delivery_type
                orderConfirmation.later_start = later_start
                orderConfirmation.later_end = later_end
            
            
            
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            
            
            model.contact_name = self.textContactName.text ?? ""
            model.contact_no = self.textContactNumber.text ?? ""
            model.instruction = self.textSpecialDeliveryInstructions.text ?? ""
            
            Constant.MyVariables.appDelegate.saveTrucCartData()
            USER_DEFAULT.set(AppState.TruckChooseDeliveryServiceMaterials.rawValue, forKey: APP_STATE_KEY)
            
            
            self.navigationController?.pushViewController(orderConfirmation, animated: true)
        }
    }
    
    
    func checkValidationForSpecialInstruction() -> Bool
    {
        guard Validation.isblank(testString: self.textContactName.text!) else
        {
            self.showAlert("Contact Name can't be blank.")
            return false
        }
        
        guard Validation.isblank(testString: self.textContactNumber.text!) else
        {
            self.showAlert("Contact Number can't be blank.")
            return false
        }
        
        guard Validation.isLengthCorrect(testString: self.textContactNumber.text!, type: "mobile") else
        {
            self.showAlert("Make sure Contact Number must contain 10 digits.")
            return false
        }
        
        guard Validation.isblank(testString: self.textSpecialDeliveryInstructions.text!) else
        {
            self.showAlert("Special Delivery Instructions field can't be blank.")
            return false
        }
        
        return true
    }
    
}

extension SpecialDeliveryInstructionsVC : UITextFieldDelegate
{
    //#MARK:- textField delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.textContactName:
            self.textContactNumber.becomeFirstResponder()
            break
        case self.textContactNumber:
            self.textSpecialDeliveryInstructions.becomeFirstResponder()
            break
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField == self.textContactNumber)
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
