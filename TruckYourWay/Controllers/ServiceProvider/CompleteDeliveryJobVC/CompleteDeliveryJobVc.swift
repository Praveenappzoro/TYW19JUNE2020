

import UIKit

class CompleteDeliveryJobVc: UIViewController, CurrentLoadUpdateDelegate {
    //MARK:- IB Outlets
    @IBOutlet weak var imageCornerView: UIView!
    
    @IBOutlet weak var imgViewDelivered: UIImageView!
    @IBOutlet weak var btnPicChoose: UIButton!
    @IBOutlet weak var btnLoadOfLoadOtlt: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    // MARK: - UI Components
    var imagePicker: UIImagePickerController=UIImagePickerController()
    
    
    // Design for popUp Alert Confirmation
    
    @IBOutlet weak var popUpLoadConfirmationComplete: UIView!
    
    @IBOutlet weak var subviewLoadConfirmationComplete: UIView!
    
    var driver_Id : String = ""
    var tracking_Id : String = ""
    var driver_Type : String = ""
    var dictBillDetails : NSMutableDictionary = [:]

    var str_Complete_Image: String = ""
    
    var jobTypeStr = ""
    
    var globalCurrentLoad = 1
    var globalTotalLoads = 0
    var arrConfirmation = NSMutableArray()

     var loginUserData:LoggedInUser!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if Constant.MyVariables.appDelegate.acceptJobModel != nil {
            let model = Constant.MyVariables.appDelegate.acceptJobModel!
            
            
            let driver_Id =  String(model.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
            let tracking_Id =  String(model.dictBillDetails.value(forKey: "id") as? Int ?? 0)
            let driver_Type = model.dictBillDetails.value(forKey: "driver_type") as? String ?? ""
            
            self.driver_Id = driver_Id
            self.tracking_Id = tracking_Id
            self.driver_Type = driver_Type
            self.arrConfirmation = model.arrConfirmation
            self.globalCurrentLoad = model.globalCurrentLoad
            self.globalTotalLoads = model.globalTotalLoads
            self.jobTypeStr = model.jobTypeStr

            
        } else {
            Constant.MyVariables.appDelegate.acceptJobModel = DriverAceeptJobModel.init()
        }
        
        
        
        imagePicker.delegate = self
        
        
        if(self.jobTypeStr == "HAULING")
        {
            self.lblHeader.text = "Please take a photo of the JOB SITE showing that the total Hauling job has been completed."
        }
        else
        {
            self.lblHeader.text = "Please take a photo of the JOB SITE showing that the total Delivery job has been completed."
        }
        
        let strLoads = "\("LOAD ")\(self.globalCurrentLoad)\(" of ")\(self.globalTotalLoads)"
        
        self.btnLoadOfLoadOtlt.setTitle(strLoads, for: .normal) 
        self.imageCornerView.layer.borderWidth = 2
        self.imageCornerView.layer.borderColor = UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 35.0/255.0, alpha: 1.0).cgColor
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        self.subviewLoadConfirmationComplete.layer.cornerRadius = 10
        self.subviewLoadConfirmationComplete.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.appIsGoingInBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func appIsGoingInBackground() {
        print("disappearing..")
        
        USER_DEFAULT.set(AppState.DriverCompleteJob.rawValue, forKey: APP_STATE_KEY)
    }
    


    @IBAction func actionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionChooseCompleteImg(_ sender: Any)
    {
        self.uploadPicture()
    }

    @IBAction func actionComplete(_ sender: Any)
    {
        self.popUpLoadConfirmationComplete.isHidden = false
    }
    
    
    @IBAction func actionNoCompleteLoad(_ sender: Any)
    {
        self.popUpLoadConfirmationComplete.isHidden = true
    }
    
    @IBAction func actionYesCompleteLoad(_ sender: Any)
    {
        
        if(self.str_Complete_Image == "")
        {
            self.showAlert("ALERT! Please upload job completion photo in order to proceed.")
            return
        }
        
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
            "driver_id":self.driver_Id,
            "tracking_id":self.tracking_Id,
            "load_no":"\(self.globalTotalLoads)",
            "completion_image":self.str_Complete_Image,
            "type":self.driver_Type,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            "is_completion_image_uploaded": true
            ] as! NSDictionary
        
        self.startAnimating("")
        
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_COMPLETE_JOB_LOADS, .post, params as? [String : Any]) { (result, data, json, error, msg) in
            
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
                    self.tabBarController?.tabBar.isHidden = false
                    if(self.jobTypeStr == "HAULING")
                    {
                        let vcComplete = LoadReceivedVC.init(nibName: "LoadReceivedVC", bundle: nil)
                        vcComplete.globalTotalLoads = self.globalTotalLoads
                        vcComplete.globalCurrentLoad = self.globalCurrentLoad
                        vcComplete.dictBillDetails = self.dictBillDetails.mutableCopy() as! NSMutableDictionary
                        vcComplete.jobTypeStr = self.jobTypeStr
                        self.navigationController?.pushViewController(vcComplete, animated: true)
                        //self.globalCurrentLoad = self.globalCurrentLoad + 1
                        if self.jobTypeStr == "HAULING" {
                            if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
                            {
                                guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
                                self.loginUserData = loginUpdate
                            }
                            else{
                                return
                            }
                            let driver_Id =  String(self.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
                            let tracking_Id =  String(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)
                            
                            let str_Load_No = "\(self.globalCurrentLoad)"
                            let params = [
                                "driver_id":driver_Id,
                                "tracking_id":tracking_Id,
                                "load_no":str_Load_No,
                                "completion_image":"notProvided",
                                "type":self.dictBillDetails.value(forKey: "driver_type") as? String ?? "",
                                "access_token":self.loginUserData.access_token ?? "",
                                "refresh_token":self.loginUserData.refresh_token ?? "",
                                "is_completion_image_uploaded": true
                                ] as! NSDictionary
                            
                            self.startAnimating("")
                            
                            
                            APIManager.sharedInstance.getDataFromAPI(BSE_URL_COMPLETE_JOB_LOADS, .post, params as? [String : Any]) { (
                                result, data, json, error, msg) in
                                
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
                                    })
                                    break
                                }
                                
                            }
                        }
                    }
                    else
                    {
                        let vc = LastPageJobVC.init(nibName: "LastPageJobVC", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                        Constant.MyVariables.appDelegate.acceptJobModel = nil
                        Constant.MyVariables.appDelegate.saveAcceptJobData()
                        USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)
                    }
                  
                })
                break
            }
            
        }
        
    }
    //#MARK:- Take picture for upload Invoice
    
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
                self.str_Complete_Image = imageName
                self.stopAnimating()
                self.view.makeToast("Complete \(self.jobTypeStr.capitalizingFirstLetter()) image uploaded successfully.", duration: 1.0, position: .center)
//                self.showAlert("Complete delivery image uploaded successfully.")
            })
        }) { (msg) -> ()? in
            
            DispatchQueue.main.async(execute: {
                self.stopAnimating()
            })
        }
    }
    
    //#MARK:- get Value On PopTo CurrentViewController

    func didRecieveDataUpdate(currentLoad:Int)
    {
        self.globalCurrentLoad = currentLoad
        
        self.globalTotalLoads = Int(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "0")!
        
        let strLoads = "\("LOAD ")\(self.globalCurrentLoad)\(" of ")\(self.globalTotalLoads)"
        
//        let strLoads = "\("LOAD ")\(self.globalCurrentLoad)\(" of ")\(self.globalTotalLoads)"
    }
    
}

extension CompleteDeliveryJobVc:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.imgViewDelivered.image = chosenImage
        self.btnPicChoose.setImage(UIImage.init(named: ""), for: .normal)
        self.APIGetUploadedImageName(chosenImage)
        dismiss(animated: true, completion: nil)
    }
}
