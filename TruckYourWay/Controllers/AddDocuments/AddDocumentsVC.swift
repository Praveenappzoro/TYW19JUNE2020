//
//  AddDocumentsVC.swift
//  TruckYourWay
//
//  Created by Samradh Agarwal on 13/09/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import Toast_Swift

class AddDocumentsVC: UIViewController {

    
    @IBOutlet weak var btnGeneralLiabilityOtlt: CustomButton!
    
    @IBOutlet weak var btnWorkerCompensationOtlt: CustomButton!
    
    @IBOutlet weak var btnVehicleLiabilityOtlt: CustomButton!
    
    @IBOutlet weak var btnCDLLicenseOtlt: CustomButton!
    
    @IBOutlet weak var btnLicensePlateOtlt: CustomButton!
    
    @IBOutlet weak var btnFrontOfTruckOtlt: CustomButton!
    
    @IBOutlet weak var btnUpdateOrNextOtlt: CustomButton!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lblBecomeSP: UILabel!

    // MARK :- Dark View
    @IBOutlet weak var darkViewOtlt: UIView!
    @IBOutlet weak var subView: UIView!
    
    
    
    // MARK: - UI Components
    var imagePicker: UIImagePickerController=UIImagePickerController()
    
    // MARK: - Data Handlers
    var dictUserDetail: NSMutableDictionary = [:]
    
    
    var selectedButton: Int = 0
    
    var loginUserData:LoggedInUser!
    var truck_image:String = ""
    var insurance_image1:String = ""
    var insurance_image2:String = ""
    var insurance_image3:String = ""
    var cdl_license_image:String = ""
    var license_plate_image:String = ""
    
    var isConsumer:Bool = false
    var isEditable:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
         self.initDataInUI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        if(self.isEditable)
        {
            self.btnUpdateOrNextOtlt.setTitle("UPDATE", for: .normal)
            self.lblBecomeSP.isHidden = true
        }
        else
        {
            self.btnUpdateOrNextOtlt.setTitle("NEXT", for: .normal)
            self.lblBecomeSP.isHidden = false
        }
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ActionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func ActionGeneralLiability(_ sender: Any)
    {
        self.selectedButton = Int((sender as AnyObject).tag)
        self.uploadPicture()
        
    }
    
    @IBAction func ActionWorkerCompensation(_ sender: Any)
    {
        self.selectedButton = Int((sender as AnyObject).tag)
        self.uploadPicture()
    }
    
    @IBAction func ActionVehicleLiability(_ sender: Any)
    {
        self.selectedButton = Int((sender as AnyObject).tag)
        self.uploadPicture()
    }
    
    @IBAction func ActionCDLLicense(_ sender: Any)
    {
        self.selectedButton = Int((sender as AnyObject).tag)
        self.uploadPicture()
    }
    
    @IBAction func ActionLicensePlate(_ sender: Any)
    {
        self.selectedButton = Int((sender as AnyObject).tag)
        self.uploadPicture()
    }
    
    @IBAction func ActionFrontOfTruck(_ sender: Any)
    {
        self.selectedButton = Int((sender as AnyObject).tag)
        self.uploadPicture()
    }
    
    @IBAction func ActionUpdate(_ sender: Any)
    {
            if(self.isValidateFirstTimeUser())
            {
                if(self.isEditable)
                  {
                    let parameters = [
                        "user_id":self.loginUserData.user_id!,
                        "firstname":self.loginUserData.firstname!,
                        "lastname":self.loginUserData.lastname!,
                        "contact":self.loginUserData.contact!,
                        "address":self.loginUserData.address!,
                        "city":self.loginUserData.city!,
                        "state":self.loginUserData.state!,
                        "zipcode":self.loginUserData.zipcode!,
                        "type":"service",
                        "profile_image":self.loginUserData.profile_image ?? "",
                        "ein":self.loginUserData.ein!,
                        "company_name":self.loginUserData.company!,
                        "company_address":self.loginUserData.company_address!,
                        "company_city":self.loginUserData.company_city!,
                        "company_state":self.loginUserData.company_state!,
                        "company_zipcode":self.loginUserData.zipcode!,
                        "equipment":self.loginUserData.equipment ?? "",
                        "equipment_no":self.loginUserData.truck_number ?? "",
                        "device_token":DeviceToken_Preference,
                        "longitude":"",
                        "latitude":"",
                        "truck_image":self.truck_image,
                        "insurance_image1":self.insurance_image1,
                        "insurance_image2":self.insurance_image2,
                        "insurance_image3":self.insurance_image3,
                        "cdl_license_image":self.cdl_license_image,
                        "license_plate_image":self.license_plate_image,
                        "total_trucks":self.loginUserData.total_trucks ?? "0"
                ] as! NSDictionary
                
                    self.APIForUpdateExistingUserDetails(params:parameters)
                }
                else
                {
                        self.dictUserDetail.setValue(self.insurance_image1, forKey: "insurance_image1")
                        self.dictUserDetail.setValue(self.insurance_image2, forKey: "insurance_image2")
                        self.dictUserDetail.setValue(self.insurance_image3, forKey: "insurance_image3")
                        self.dictUserDetail.setValue(self.cdl_license_image, forKey: "cdl_license_image")
                        self.dictUserDetail.setValue(self.license_plate_image, forKey: "license_plate_image")
                        self.dictUserDetail.setValue(self.truck_image, forKey: "truck_image")
                    
                        let signUpSubmit = SignUpSubmitVC.init(nibName: "SignUpSubmitVC", bundle: nil)
                        signUpSubmit.dictUserDetail = self.dictUserDetail.mutableCopy() as! NSMutableDictionary
                        signUpSubmit.isConsumer = self.isConsumer
                        self.navigationController?.pushViewController(signUpSubmit, animated: true)
                }
            }
    }
    
    
    @IBAction func actionOkay(_ sender: Any)
    {
        self.darkViewOtlt.isHidden = true
    }
    
    func isValidateFirstTimeUser() -> Bool
    {
        if(insurance_image1 == "" || insurance_image2 == "" || insurance_image3 == "")
        {
            self.darkViewOtlt.isHidden = false
            return false
        }
        
        
        else if(cdl_license_image  == "")
        {
            self.showAlert("Please Upload CDL License Image")
            return false
        }
        else if(license_plate_image  == "")
        {
            self.showAlert("Please Upload License Plate Image")
            return false
        }
        else if(truck_image  == "")
        {
            self.showAlert("Please Upload Front of Truck Image")
            return false
        }
        else
        {
            return true
        }
        
    }
    func uploadPicture()
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
                        self.showAlert("Profile updated successfully.")
                        self.initDataInUI()
                        
                    })
                    break
                }
                
            }
    }
    
    func initDataInUI()
    {
        
        self.subView.layer.cornerRadius = 10
        self.lbl1.layer.cornerRadius = 15
        self.lbl2.layer.cornerRadius = 15
        self.lbl3.layer.cornerRadius = 15
        
        self.subView.layer.masksToBounds = true
        self.lbl1.layer.masksToBounds = true
        self.lbl2.layer.masksToBounds = true
        self.lbl3.layer.masksToBounds = true
        
        
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {
            return
        }
        self.truck_image = self.loginUserData.truck_image ?? ""
        self.insurance_image1 = self.loginUserData.insurance_image1 ?? ""
        self.insurance_image2 = self.loginUserData.insurance_image2 ?? ""
        self.insurance_image3 = self.loginUserData.insurance_image3 ?? ""
        self.cdl_license_image = self.loginUserData.cdl_license ?? ""
        self.license_plate_image = self.loginUserData.license_plate ?? ""
        
        if(self.insurance_image1 != "")
        {
            
            self.btnGeneralLiabilityOtlt.isSelected = true
        }
        if(self.insurance_image2 != "")
        {
            self.btnWorkerCompensationOtlt.isSelected = true
        }
        if(self.insurance_image3 != "")
        {
            self.btnVehicleLiabilityOtlt.isSelected = true
        }
        if(self.cdl_license_image != "")
        {
            self.btnCDLLicenseOtlt.isSelected = true
        }
        if(self.license_plate_image != "")
        {
            self.btnLicensePlateOtlt.isSelected = true
        }
        if(self.truck_image != "")
        {
            self.btnFrontOfTruckOtlt.isSelected = true
        }
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
                
                if(self.selectedButton == 1)
                {
                    self.insurance_image1 = imageName
                    self.btnGeneralLiabilityOtlt.isSelected = true
                }
                else if(self.selectedButton == 2)
                {
                    self.insurance_image2 = imageName
                    self.btnWorkerCompensationOtlt.isSelected = true
                }
                else if(self.selectedButton == 3)
                {
                    self.insurance_image3 = imageName
                    self.btnVehicleLiabilityOtlt.isSelected = true
                }
                else if(self.selectedButton == 4)
                {
                    self.cdl_license_image = imageName
                    self.btnCDLLicenseOtlt.isSelected = true
                }
                else if(self.selectedButton == 5)
                {
                    self.license_plate_image = imageName
                    self.btnLicensePlateOtlt.isSelected = true
                }
                else
                {
                    self.truck_image = imageName
                    self.btnFrontOfTruckOtlt.isSelected = true
                }
               
                self.stopAnimating()
                self.showToast()
//                self.showAlert("Photo updated successfully.")
                
                
            })
        }) { (msg) -> ()? in
            
            DispatchQueue.main.async(execute: {
                self.stopAnimating()
                self.view.makeToast(msg, duration: 1.0, position: .center)
                //                self.showAlert(msg)
            })
        }
    }
    
    //#Mark:- show Taost on image upload
    func showToast()
    {
        
        self.view.makeToast("Photo updated successfully.", duration: 1.0, position: .center)
    }
}

extension AddDocumentsVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.APIGetUploadedImageName(chosenImage)
        dismiss(animated: true, completion: nil)
    }
}
