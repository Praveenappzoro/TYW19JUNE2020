import UIKit
import CoreLocation
import DropDown

protocol CurrentLoadUpdateDelegate {
    func didRecieveDataUpdate(currentLoad: Int)
}

class LoadReceivedVC: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- IB Outlets
    @IBOutlet weak var imageCornerView: UIView!
    
    @IBOutlet weak var imgViewInvoice: UIImageView!
    
    @IBOutlet weak var lblTimeDuration: UILabel!
    @IBOutlet weak var txtInvoiceNumber: CustomTxtField!
    
    @IBOutlet weak var btnLoadOfLoadTitle: UIButton!
    //Pop up design
    
    @IBOutlet weak var popupView: UIView!
    
     @IBOutlet weak var popupSubView: UIView!
    
    @IBOutlet weak var lblLoadOfLoad: UILabel!
    
    @IBOutlet weak var lblShowLocationOtlt: PaddingLabel!

    @IBOutlet weak var lblTotalDistance: UILabel!
    @IBOutlet weak var btnNext: UIButton!

    @IBOutlet weak var btnPicChoose: UIButton!
    @IBOutlet weak var btnQuantityOtlt: CustomButton!
    @IBOutlet weak var textAmount: CustomTxtField!
    
    @IBOutlet weak var btnLoadCompleteOtlt: CustomButton!
    @IBOutlet weak var lblLoadCompleteOtlt: UILabel!
    @IBOutlet weak var lblPurchaseOrder: UILabel!

    // Design for popUp Alert Confirmation
    @IBOutlet weak var lblTitleJobTypeLocation: UILabel!
    @IBOutlet weak var lblTitleJobDesc: UILabel!

    @IBOutlet weak var popUpLoadConfirmationComplete: UIView!
    
    @IBOutlet weak var subviewLoadConfirmationComplete: UIView!
    
    var dictBillDetails : NSMutableDictionary = [:]
    var arrConfirmation = NSMutableArray()
    let arrayLoadQuantityType: NSArray = ["Tons","Load"]
    
    var str_Invoice_Image:String = ""
    
    let dropDown = DropDown()
    
    var loginUserData:LoggedInUser!
    var jobTypeStr = ""
    
    // MARK: - UI Components
    var imagePicker: UIImagePickerController=UIImagePickerController()
    
    var globalCurrentLoad = 1
    var globalTotalLoads = 0
    var needToObtainTons = 0
    var indexAdded = 0

    var seconds = 7200
    var timer = Timer()
    
    var dateAccepted = 0
    
    var delegateCurrentLoad: CurrentLoadUpdateDelegate! = nil
    
    var oldMaterialLoaded = 0
    var oldCurrentMaterialIndex = 0

    var strdescription: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if Constant.MyVariables.appDelegate.acceptJobModel != nil {
            let model = Constant.MyVariables.appDelegate.acceptJobModel!
            
            self.dictBillDetails = model.dictBillDetails
            self.globalCurrentLoad = model.globalCurrentLoad
            self.globalTotalLoads = model.globalTotalLoads
            self.jobTypeStr = model.jobTypeStr
            self.arrConfirmation = model.arrConfirmation
            self.str_Invoice_Image = model.str_Invoice_Image
           
           // self.textAmount.text = model.loadAmount > 0 ? "\(model.loadAmount)" : ""
           // self.txtInvoiceNumber.text = model.invoiceNumber
           // self.imgViewInvoice.image = model.loadImage
            self.btnQuantityOtlt.setTitle(model.loadUnit, for: .normal)
            self.dateAccepted = model.dateAccepted
            
            
            let materialArray = model.dictConfirmation["materials"] as! NSArray
            guard let mDic = materialArray[model.currentMaterialIndex] as? NSDictionary else {
                return
            }
            
            var materialDic = mDic //materialArray[model.currentMaterialIndex] as! NSDictionary
            let remainingTons = (Int(materialDic["tons"] as! String) ?? 0) - model.materialLoaded
            
            print(materialDic)
            print(model.currentMaterialIndex)
            print(model.materialLoaded)
            oldCurrentMaterialIndex = model.currentMaterialIndex
            oldMaterialLoaded = model.materialLoaded
            
            var needToObtain = 0
            if remainingTons > 0 {
                if remainingTons > 16 {
                    model.materialLoaded = model.materialLoaded + 16
                    needToObtain = 16
                } else {
                    model.materialLoaded = model.materialLoaded + remainingTons
                    needToObtain = remainingTons
                }
            } else {
                model.materialLoaded = 0
                model.currentMaterialIndex += 1
                indexAdded = 1
                materialDic = materialArray[model.currentMaterialIndex] as! NSDictionary
                let remainingTons = (Int(materialDic["tons"] as! String) ?? 0) - model.materialLoaded
                if remainingTons > 0 {
                    if remainingTons > 16 {
                        model.materialLoaded = model.materialLoaded + 16
                        needToObtain = 16
                    } else {
                        model.materialLoaded = model.materialLoaded + remainingTons
                        needToObtain = remainingTons
                    }
                }
            }
            needToObtainTons = needToObtain
            //let materialDic = ((model.dictConfirmation["materials"] as! NSArray)[0]) as! NSDictionary
            
            let category = materialDic["category"] as! String
            
            if (self.dictBillDetails["job_type"] as! String).uppercased() == "DELIVERY" {
                btnNext.setTitle("NEXT", for: .normal)
                if category.uppercased() == "DIRT" {
                    btnQuantityOtlt.isUserInteractionEnabled = false
                    btnQuantityOtlt.setTitle("Load", for: .normal)
                    lblTitleJobDesc.text = "You need to obtain 1 Load of\n \(category.uppercased()) \(materialDic["name"] as! String).\nHow much material did you receive?"
                } else {
                    btnQuantityOtlt.isUserInteractionEnabled = true
                    btnQuantityOtlt.setTitle("Tons", for: .normal)
                    lblTitleJobDesc.text = "You need to obtain \(needToObtain) Tons of\n \(category.uppercased()) \(materialDic["name"] as! String).\nHow much material did you receive?"
                }
            } else {
                if category.uppercased() == "DIRT" {
                    btnQuantityOtlt.isUserInteractionEnabled = false
                } else {
                    btnQuantityOtlt.isUserInteractionEnabled = true
                }
                btnQuantityOtlt.setTitle("Load", for: .normal)
                btnNext.setTitle("LOAD HAULING COMPLETE", for: .normal)
                
                lblTitleJobDesc.text = "You need to haul away 1 Load of\n \(category.uppercased()) \(materialDic["name"] as! String).\nHow much material did you haul?"
            }
        } else {
            Constant.MyVariables.appDelegate.acceptJobModel = DriverAceeptJobModel.init()
        }
        
        
        self.globalTotalLoads = Int(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "0")!
        let strLoads = "\("LOAD ")\(self.globalCurrentLoad)\(" of ")\(self.globalTotalLoads)"
        
        if self.globalCurrentLoad > 1 {
            lblTimeDuration.backgroundColor = .white
            
        } else {
            let dateNow = Date().millisecondsSince1970
            let timeDifference = dateNow - dateAccepted
            seconds = seconds - timeDifference
            self.runTimer()
            lblTimeDuration.backgroundColor = .clear
        }
        self.btnLoadOfLoadTitle.setTitle(strLoads, for: .normal)
        self.lblLoadOfLoad.text = strLoads

        imagePicker.delegate = self
        
        self.lblShowLocationOtlt.layer.cornerRadius = 25
        //self.lblShowLocationOtlt.layer.masksToBounds = true
        self.lblShowLocationOtlt.layer.borderWidth = 5
        self.lblShowLocationOtlt.layer.borderColor = UIColor.init(red: 156.0/255.0, green: 190.0/255.0, blue: 56.0/255.0, alpha: 1.0).cgColor
        //let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(("labelActionShowLocation:")))
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelActionShowLocation))
        self.lblShowLocationOtlt.addGestureRecognizer(tap)
        tap.delegate = self as UIGestureRecognizerDelegate // Remember to extend your class with UIGestureRecognizerDelegate
        
        // Receive action
        
        self.imageCornerView.layer.borderWidth = 2
        self.imageCornerView.layer.borderColor = UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 35.0/255.0, alpha: 1.0).cgColor
        self.popupSubView.layer.cornerRadius = 10
        self.popupSubView.layer.masksToBounds = true
        
        self.subviewLoadConfirmationComplete.layer.cornerRadius = 10
        self.subviewLoadConfirmationComplete.layer.masksToBounds = true
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        self.InitData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.appIsGoingInBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
   
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let model = Constant.MyVariables.appDelegate.acceptJobModel!
        model.str_Invoice_Image = ""
        model.loadUnit = "Tons"
        model.loadAmount = 0
        model.loadImage = UIImage()
        model.invoiceNumber = ""
        model.arrConfirmation = self.arrConfirmation
        Constant.MyVariables.appDelegate.saveAcceptJobData()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func appIsGoingInBackground() {
        print("disappearing..")
        
        if Constant.MyVariables.appDelegate.acceptJobModel == nil {
            return
        }
        let model = Constant.MyVariables.appDelegate.acceptJobModel!   
        model.dictBillDetails = self.dictBillDetails
  
        model.globalCurrentLoad = self.globalCurrentLoad
        model.globalTotalLoads = self.globalTotalLoads
        model.jobTypeStr = self.jobTypeStr
        model.str_Invoice_Image = self.str_Invoice_Image
        model.loadUnit = self.btnQuantityOtlt.titleLabel?.text ?? "Tons"
        model.loadAmount = Int(self.textAmount.text ?? "0") ?? 0
        model.loadImage = self.imgViewInvoice.image ?? UIImage()
        model.invoiceNumber = self.txtInvoiceNumber.text ?? ""
        model.dateAccepted = self.dateAccepted
        model.materialLoaded = model.materialLoaded - needToObtainTons
        model.currentMaterialIndex = model.currentMaterialIndex - indexAdded
        Constant.MyVariables.appDelegate.saveAcceptJobData()

        USER_DEFAULT.set(AppState.DriverLoadRecieve.rawValue, forKey: APP_STATE_KEY)
    }    
    
    @objc func labelActionShowLocation(gr:UITapGestureRecognizer)
    {
        self.txtInvoiceNumber.resignFirstResponder()
        self.textAmount.resignFirstResponder()
        
        let primaryContactFullAddress  = self.lblShowLocationOtlt.text ?? ""
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            let escapedString = primaryContactFullAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let directionsRequest = "\("comgooglemaps-x-callback://?daddr=")\(escapedString!)"
            
            let directionsURL = URL(string: directionsRequest)!
            UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
            print("Google map.")
            
        } else if UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!) {
            let escapedString = primaryContactFullAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
            let strUrl = "http://maps.apple.com/?address=" + (escapedString ?? "")
            let url = URL(string: strUrl)
            print(url ?? "")
            if url != nil {
                UIApplication.shared.open(url!)
            } else {
                self.showAlert("Location not found.")
            }
            print("Apple map.")
        } else {
            self.showAlert("No Application found.")
        }
    }
  
    @IBAction func actionBack(_ sender: Any)
    {
        self.txtInvoiceNumber.resignFirstResponder()
        self.textAmount.resignFirstResponder()
        
        if(self.jobTypeStr == "HAULING" && (self.globalCurrentLoad == self.globalTotalLoads)) {
            UIView.animate(withDuration: 0.25, animations: {
                self.popupView.isHidden = false
                self.popupSubView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            });
            return
        }
        
        let model = Constant.MyVariables.appDelegate.acceptJobModel!
        
//        let materialArray = model.dictConfirmation["materials"] as! NSArray
//        guard let mDic = materialArray[oldCurrentMaterialIndex] as? NSDictionary else {
//            return
//        }
//        
//        var materialDic = mDic //materialArray[model.currentMaterialIndex] as! NSDictionary
//        let remainingTons = (Int(materialDic["tons"] as! String) ?? 0) - oldMaterialLoaded
//        
//        if remainingTons > 0 {
//            if remainingTons > 16 {
//                model.materialLoaded = model.materialLoaded - 16
//            } else {
//                model.materialLoaded = model.materialLoaded - remainingTons
//            }
//        } else {
//            model.materialLoaded = 0
//            model.currentMaterialIndex -= 1
//            materialDic = materialArray[oldCurrentMaterialIndex] as! NSDictionary
//            let remainingTons = (Int(materialDic["tons"] as! String) ?? 0) - oldMaterialLoaded
//            if remainingTons > 0 {
//                if remainingTons > 16 {
//                    model.materialLoaded = model.materialLoaded - 16
//                } else {
//                    model.materialLoaded = model.materialLoaded - remainingTons
//                }
//            }
//        }
        
        model.materialLoaded =  oldMaterialLoaded //model.materialLoaded - oldMaterialLoaded
        model.currentMaterialIndex = model.currentMaterialIndex - indexAdded
        Constant.MyVariables.appDelegate.saveAcceptJobData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionChooseInvoiceImg(_ sender: Any)
    {
        self.txtInvoiceNumber.resignFirstResponder()
        self.textAmount.resignFirstResponder()
        
        self.uploadPicture()
    }
    
    @IBAction func actionMaterialType(_ sender: Any)
    {
        dropDown.anchorView = self.btnQuantityOtlt
        
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint (x: 0, y:self.btnQuantityOtlt.frame.size.height)
        dropDown.width = self.btnQuantityOtlt.frame.size.width
        dropDown.dataSource = arrayLoadQuantityType as! [String]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btnQuantityOtlt.setTitle(item, for: .normal)
        }
        dropDown.show()
    }

    
    @IBAction func actionLocationShow(_ sender: Any)
    {
        self.txtInvoiceNumber.resignFirstResponder()
        self.textAmount.resignFirstResponder()
        
    
        let primaryContactFullAddress  = self.lblShowLocationOtlt.text ?? ""
        
        let testURL: NSURL = NSURL(string: "comgooglemaps-x-callback://")!
        if UIApplication.shared.canOpenURL(URL(string: "https://maps.google.com")!) {
            var escapedString = primaryContactFullAddress.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let directionsRequest = "\("comgooglemaps-x-callback://?daddr=")\(escapedString!)"
            
            let directionsURL = URL(string: directionsRequest)!
            UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
            print("Google map.")
            
        } else {
            let str =  "\("http://maps.apple.com/?saddr=")\(primaryContactFullAddress)"
            var escapedString = str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let directionsURL = URL(string: escapedString!)!
            UIApplication.shared.open(directionsURL, options: [:], completionHandler: nil)
            print("Apple map.")
        }
            
    }
    
    
    @IBAction func actionNext(_ sender: Any)
    {
        self.txtInvoiceNumber.resignFirstResponder()
        self.textAmount.resignFirstResponder()
        
        if(self.textAmount.text == "" || self.textAmount.text == "0")
        {
            self.showAlert("Amount can't be blank.")
            return
        }
        if(self.txtInvoiceNumber.text == "")
        {
            self.showAlert("Invoice Number can't be blank")
            return
        }
        if(self.str_Invoice_Image == "")
        {
            self.showAlert("Make sure Invoice receipt must be upload.")
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
        
        let driver_id =  String(self.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
        let tracking_id =  String(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)
        
        var getAccurateAmount : String = ""
        if(self.btnQuantityOtlt.titleLabel?.text == "Tons")
        {
            getAccurateAmount = self.textAmount.text!
        }
        else
        {
            let str = self.textAmount.text!
            let amountInDigit = Int(str as! String)! * 16
            getAccurateAmount = "\(amountInDigit)"
        }

//        let str_Load_No = "\(self.globalCurrentLoad)"
//        let params = [
//            "driver_id":driver_id,
//            "tracking_id":tracking_id,
//            "load_no":str_Load_No,
//            "completion_image":self.str_Invoice_Image,
//            "type":self.dictBillDetails.value(forKey: "driver_type") as? String ?? "",
//            "amount":self.textAmount.text!,
//            "tons":getAccurateAmount,
//            "bill_no":self.txtInvoiceNumber.text!,
//            "access_token":self.loginUserData.access_token ?? "",
//            "refresh_token":self.loginUserData.refresh_token ?? "",
//            "job_type":self.jobTypeStr.lowercased()
//            ] as! NSDictionary
        
//        if(self.jobTypeStr == "HAULING")
//        {
//
//            if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
//            {
//                guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
//                self.loginUserData = loginUpdate
//            }
//            else{
//                return
//            }
//
//            let str_Load_No = "\(self.globalCurrentLoad)"
//            let params = [
//                "driver_id":driver_id,
//                "tracking_id":tracking_id,
//                "load_no":str_Load_No,
//                "completion_image":self.str_Invoice_Image,
//                "type":self.dictBillDetails.value(forKey: "driver_type") as? String ?? "",
//                "access_token":self.loginUserData.access_token ?? "",
//                "refresh_token":self.loginUserData.refresh_token ?? ""
//                ] as! NSDictionary
//
//            self.startAnimating("")
//
//            APIManager.sharedInstance.getDataFromAPI(BSE_URL_COMPLETE_JOB_LOADS, .post, params as? [String : Any]) { (
//                result, data, json, error, msg) in
//
//                switch result
//                {
//                case .Failure:
//                    DispatchQueue.main.async(execute: {
//                        self.stopAnimating()
//                        self.showAlert(msg)
//                    })
//                    break
//                case .Success:
//                    DispatchQueue.main.async(execute: {
//                        self.stopAnimating()
//                        self.popUpLoadConfirmationComplete.isHidden = false
//                    })
//                    break
//                }
//            }
//        }
//        else
//        {
        var isLastLoad = false
        if(self.globalCurrentLoad == self.globalTotalLoads) {
            isLastLoad = true
        }
        
            let str_Load_No = "\(self.globalCurrentLoad)"
            let params = [
                "driver_id":driver_id,
                "tracking_id":tracking_id,
                "load_no":str_Load_No,
                "completion_image":self.str_Invoice_Image,
                "type":self.dictBillDetails.value(forKey: "driver_type") as? String ?? "",
                "amount":self.textAmount.text!,
                "tons":getAccurateAmount,
                "bill_no":self.txtInvoiceNumber.text!,
                "job_type":self.jobTypeStr.lowercased(),
                "access_token":self.loginUserData.access_token ?? "",
                "refresh_token":self.loginUserData.refresh_token ?? "",
                "is_started_last_load": isLastLoad
                ] as! NSDictionary
            
            self.startAnimating("")
            
            APIManager.sharedInstance.getDataFromAPI(BSE_URL_START_JOB_LOADS, .post, params as? [String : Any]) { (result, data, json, error, msg) in
                
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
                        UIView.animate(withDuration: 0.25, animations: {
                            if (self.jobTypeStr == "HAULING") {
                                self.popUpLoadConfirmationComplete.isHidden = false
                            } else {
                                self.popupView.isHidden = false
                                self.popupSubView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            }
                        });
                    })
                    break
                }
             }
//          }
        
    }
    
    @IBAction func actionNextOfPopUp(_ sender: Any)
    {
        self.popupView.isHidden = true
        if self.jobTypeStr != "HAULING" {
            self.popUpLoadConfirmationComplete.isHidden = false
        }
    }
    
    @IBAction func actionNoCompleteLoad(_ sender: Any)
    {
        self.popUpLoadConfirmationComplete.isHidden = true
    }
    
    @IBAction func actionYesCompleteLoad(_ sender: Any)
    {
        self.txtInvoiceNumber.resignFirstResponder()
        self.textAmount.resignFirstResponder()
        
        if(self.globalCurrentLoad == self.globalTotalLoads)
        {
            self.popupView.isHidden = true
            self.popUpLoadConfirmationComplete.isHidden = true
            let driver_Id =  String(self.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
            let tracking_Id =  String(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)
            let driver_Type = self.dictBillDetails.value(forKey: "driver_type") as? String ?? ""
            
            
            let model = Constant.MyVariables.appDelegate.acceptJobModel!
            
            model.dictBillDetails = self.dictBillDetails
            model.globalCurrentLoad = self.globalCurrentLoad
            model.globalTotalLoads = self.globalTotalLoads
            model.jobTypeStr = self.jobTypeStr
            model.str_Invoice_Image = self.str_Invoice_Image
            model.loadUnit = self.btnQuantityOtlt.titleLabel?.text ?? "Tons"
            model.loadAmount = Int(self.textAmount.text ?? "0") ?? 0
            model.loadImage = self.imgViewInvoice.image ?? UIImage()
            model.invoiceNumber = self.txtInvoiceNumber.text ?? ""
            model.dateAccepted = self.dateAccepted

            Constant.MyVariables.appDelegate.saveAcceptJobData()

            
//            if(self.dictBillDetails.value(forKey: "contact_name") as? String ?? "" == "")
//            {
                if(self.jobTypeStr == "HAULING") {
                    let vc = LastPageJobVC.init(nibName: "LastPageJobVC", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    let completeDelivery = CompleteDeliveryJobVc.init(nibName: "CompleteDeliveryJobVc", bundle: nil)
                    completeDelivery.driver_Id = driver_Id
                    completeDelivery.tracking_Id = tracking_Id
                    completeDelivery.driver_Type = driver_Type
                    completeDelivery.globalCurrentLoad = self.globalCurrentLoad
                    completeDelivery.globalTotalLoads = self.globalTotalLoads
                    completeDelivery.dictBillDetails = self.dictBillDetails
                    completeDelivery.jobTypeStr = self.jobTypeStr
                self.navigationController?.pushViewController(completeDelivery, animated: true)
                }

//            }
//            else
//            {
//                let specialInstructions = SpecialInstructionsVC.init(nibName: "SpecialInstructionsVC", bundle: nil)
//                specialInstructions.driver_Id = driver_Id
//                specialInstructions.tracking_Id = tracking_Id
//                specialInstructions.driver_Type = driver_Type
//                specialInstructions.consumer_Name = self.dictBillDetails.value(forKey: "contact_name") as? String ?? ""
//                specialInstructions.consumer_contact_no = self.dictBillDetails.value(forKey: "contact_no") as? String ?? ""
//                specialInstructions.consumer_instruction = self.dictBillDetails.value(forKey: "instruction") as? String ?? ""
//                specialInstructions.globalCurrentLoad = self.globalCurrentLoad
//                specialInstructions.globalTotalLoads = self.globalTotalLoads
//               specialInstructions.jobTypeStr = self.jobTypeStr
//                self.navigationController?.pushViewController(specialInstructions, animated: true)
//            }
        }
        else
        {
            
            if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
            {
                guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
                self.loginUserData = loginUpdate
            }
            else{
                return
            }
            
            let driver_id =  String(self.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
            let tracking_id =  String(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)
            let str_Load_No = "\(self.globalCurrentLoad)"
            
            if(self.jobTypeStr == "HAULING")
                     {
//                var getAccurateAmount : String = ""
//                if(self.btnQuantityOtlt.titleLabel?.text == "Tons")
//                {
//                    getAccurateAmount = self.textAmount.text!
//                }
//                else
//                {
//                    let str = self.textAmount.text!
//                    let amountInDigit = Int(str as! String)! * 16
//                    getAccurateAmount = "\(amountInDigit)"
//
//                }
//
//                let str_Load_No = "\(self.globalCurrentLoad)"
//                let params = [
//                    "driver_id":driver_id,
//                    "tracking_id":tracking_id,
//                    "load_no":str_Load_No,
//                    "completion_image":self.str_Invoice_Image,
//                    "type":self.dictBillDetails.value(forKey: "driver_type") as? String ?? "",
//                    "amount":self.textAmount.text!,
//                    "tons":getAccurateAmount,
//                    "bill_no":self.txtInvoiceNumber.text!,
//                    "job_type":self.jobTypeStr.lowercased(),
//                    "access_token":self.loginUserData.access_token ?? "",
//                    "refresh_token":self.loginUserData.refresh_token ?? ""
//                    ] as! NSDictionary
                
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
                    "is_completion_image_uploaded": false
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
                            self.globalCurrentLoad = self.globalCurrentLoad + 1
                            
                            let model = Constant.MyVariables.appDelegate.acceptJobModel!
                            model.globalCurrentLoad = self.globalCurrentLoad
                            Constant.MyVariables.appDelegate.saveAcceptJobData()
                            
                            
                        self.delegateCurrentLoad?.didRecieveDataUpdate(currentLoad: self.globalCurrentLoad)

                            
//                            if((self.globalCurrentLoad == self.globalTotalLoads) && (self.jobTypeStr == "HAULING"))
//                            {
//                                let driver_Id =  String(self.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
//                                let tracking_Id =  String(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)
//                                let driver_Type = self.dictBillDetails.value(forKey: "driver_type") as? String ?? ""
//
//                                let completeDelivery = CompleteDeliveryJobVc.init(nibName: "CompleteDeliveryJobVc", bundle: nil)
//                                completeDelivery.driver_Id = driver_Id
//                                completeDelivery.tracking_Id = tracking_Id
//                                completeDelivery.driver_Type = driver_Type
//                                completeDelivery.globalCurrentLoad = self.globalCurrentLoad
//                                completeDelivery.globalTotalLoads = self.globalTotalLoads
//                                completeDelivery.dictBillDetails = self.dictBillDetails
//                                completeDelivery.jobTypeStr = self.jobTypeStr
//                                self.navigationController?.pushViewController(completeDelivery, animated: true)
//                                return
//                            }
                            var checkFlag: Bool = false
                            if(self.dictBillDetails.value(forKey: "contact_name") as? String ?? "" == "") {
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: JobAcceptDriver.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        checkFlag = true
                                        break
                                    }
                                }
                            } else {
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: SpecialInstructionsVC.self) {
                                        
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        checkFlag = true
                                        break
                                    }
                                }
                            }
                            if(checkFlag == false)
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                            //                        self.tabBarController?.tabBar.isHidden = false
                            //                        self.navigationController?.popToRootViewController(animated: true)
                        })
                        break
                    }
                }
            } else {
               
                let params = [
                    "driver_id":driver_id,
                    "tracking_id":tracking_id,
                    "load_no":str_Load_No,
                    "completion_image":self.str_Invoice_Image,
                    "type":self.dictBillDetails.value(forKey: "driver_type") as? String ?? "",
                    "access_token":self.loginUserData.access_token ?? "",
                    "refresh_token":self.loginUserData.refresh_token ?? "",
                    "is_completion_image_uploaded": false

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
                            self.globalCurrentLoad = self.globalCurrentLoad + 1
                           
                            let model = Constant.MyVariables.appDelegate.acceptJobModel!
                            model.globalCurrentLoad = self.globalCurrentLoad
                            Constant.MyVariables.appDelegate.saveAcceptJobData()
                            
                            //self.delegateCurrentLoad?.didRecieveDataUpdate(currentLoad: self.globalCurrentLoad)
                            if((self.globalCurrentLoad == self.globalTotalLoads) && (self.jobTypeStr == "HAULING"))
                            {
                                let driver_Id =  String(self.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
                                let tracking_Id =  String(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)
                                let driver_Type = self.dictBillDetails.value(forKey: "driver_type") as? String ?? ""
                                
                                let completeDelivery = CompleteDeliveryJobVc.init(nibName: "CompleteDeliveryJobVc", bundle: nil)
                                completeDelivery.driver_Id = driver_Id
                                completeDelivery.tracking_Id = tracking_Id
                                completeDelivery.driver_Type = driver_Type
                                completeDelivery.globalCurrentLoad = self.globalCurrentLoad
                                completeDelivery.globalTotalLoads = self.globalTotalLoads
                                completeDelivery.dictBillDetails = self.dictBillDetails
                                completeDelivery.jobTypeStr = self.jobTypeStr
                                self.navigationController?.pushViewController(completeDelivery, animated: true)
                                return
                            }
                            var checkFlag: Bool = false
                            if(self.dictBillDetails.value(forKey: "contact_name") as? String ?? "" == "") {
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: JobAcceptDriver.self) {
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        checkFlag = true
                                        break
                                    }
                                }
                            } else {
                                for controller in self.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: SpecialInstructionsVC.self) {
                                        
                                        self.navigationController!.popToViewController(controller, animated: true)
                                        checkFlag = true
                                        break
                                    }
                                }
                            }
                            if(checkFlag == false)
                            {
                                self.navigationController?.popViewController(animated: true)
                            }
                            //                        self.tabBarController?.tabBar.isHidden = false
                            //                        self.navigationController?.popToRootViewController(animated: true)
                        })
                        break
                    }
                    
                }
            }
        }
    }
    
    func attributeDtailsBoldThird(strFirstNormal: String,strSecondBold: String, strthirdNormal: String) -> NSMutableAttributedString
    {
        
        let normalsThirdString = NSMutableAttributedString(string:strthirdNormal)
        
        let attrsFirst = [NSAttributedStringKey.font :  UIFont.systemFont(ofSize: 15)]
        let attributedStringFirst = NSMutableAttributedString(string:strFirstNormal, attributes:attrsFirst)
        
        let attrsss = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)]
        let attributedStringss = NSMutableAttributedString(string:strSecondBold, attributes:attrsss)
        
        
        let attrsThird = [NSAttributedStringKey.font :  UIFont.systemFont(ofSize: 15)]
        let attributedStringThird = NSMutableAttributedString(string:strthirdNormal, attributes:attrsThird)
        
        attributedStringFirst.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:strFirstNormal.length))
        
        attributedStringFirst.append(attributedStringss)
        attributedStringFirst.append(attributedStringThird)
        
        return attributedStringFirst
    }
    
    func InitData()
    {
        
        let strOrderID = "\(TYW_ID_SUFFIX)\( self.dictBillDetails.value(forKey: "bill_no") as? String ?? "")"
        lblPurchaseOrder.text = "Purchase Order : \(strOrderID)\n"
        var strLocation = ""
        if(self.jobTypeStr == "HAULING")
        {
            let dealer_Name = self.dictBillDetails.value(forKey: "dealer_name") as? String ?? ""
            
            let strAttributedTimeSecond = self.attributeDtailsBoldThird(strFirstNormal: "The \(self.jobTypeStr.capitalizingFirstLetter()) Location is:\n", strSecondBold: dealer_Name, strthirdNormal:"")
            
            self.lblTitleJobTypeLocation.attributedText = strAttributedTimeSecond
//            self.btnLoadCompleteOtlt.setTitle("LOAD HAULING COMPLETE", for: .normal)
            self.btnLoadCompleteOtlt.setTitle("NEXT", for: .normal)
            self.lblLoadCompleteOtlt.text = "LOAD HAULING IS COMPLETE?"
//            self.btnQuantityOtlt.setTitle("Loads", for: .normal)
            
            let address = self.dictBillDetails.value(forKey: "pickup_address") as? String ?? ""
            let city = self.dictBillDetails.value(forKey: "pickup_city") as? String ?? ""
            let state = self.dictBillDetails.value(forKey: "pickup_state") as? String ?? ""
            let zipcode = self.dictBillDetails.value(forKey: "pickup_zipcode") as? String ?? ""
            strLocation = address + ", " + city + ", " + state + ", " + zipcode
            UIView.animate(withDuration: 0.25, animations: {
                self.popupView.isHidden = false
                self.popupSubView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            });
        }
        else
        {
//            let materialArray = model.dictConfirmation["materials"] as! NSArray
//            var materialDic = materialArray[model.currentMaterialIndex] as! NSDictionary
//            let category = materialDic["category"] as! String
//
//            if category.uppercased() == "DIRT" {
//                self.btnQuantityOtlt.setTitle("Loads", for: .normal)
//            } else {
//                self.btnQuantityOtlt.setTitle("Tons", for: .normal)
//            }

            
            

            strLocation = self.dictBillDetails.value(forKey: "drop_address") as? String ?? ""

            self.btnLoadCompleteOtlt.setTitle("LOAD DELIVERY COMPLETE", for: .normal)
            self.lblLoadCompleteOtlt.text = "LOAD DELIVERY IS COMPLETE?"
        }
        
        let attrs = NSAttributedString(string: strLocation,
                                       attributes:
            [NSAttributedStringKey.foregroundColor: UIColor(red:20.0/255.0, green:104.0/255.0, blue:215.0/255.0, alpha:1.0),
             NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17.0),
             NSAttributedStringKey.underlineColor: UIColor(red:20.0/255.0, green:104.0/255.0, blue:215.0/255.0, alpha:1.0),
             NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        
        self.lblShowLocationOtlt.attributedText = attrs

        // Get Total distance between pickup and drop location
        let pick_Lat = self.dictBillDetails.value(forKey: "pickup_latitude") as? String ?? "26.901690"
        let pick_Long = self.dictBillDetails.value(forKey: "pickup_longitude") as? String ?? "75.779610"
        
        let drop_Lat = self.dictBillDetails.value(forKey: "drop_latitude") as? String ?? "26.901690"
        let drop_Long = self.dictBillDetails.value(forKey: "drop_longitude") as? String ?? "75.779610"
        
//        let coordinate₀ = CLLocation(latitude: Double(pick_Lat) ?? 26.901690, longitude: Double(pick_Long) ?? 75.779610)
//        let coordinate₁ = CLLocation(latitude: Double(drop_Lat) ?? 26.901690, longitude: Double(drop_Long) ?? 75.779610)
        
//        let distanceInMilesInDouble = Double(((coordinate₀.distance(from: coordinate₁)/1000)*0.621371)) // result is in miles
//        let distanceInMilesRound = Double(round(1000*distanceInMilesInDouble)/100)
//        let distanceInMiles = String(distanceInMilesRound)
        
//        let distanceInMilesRound = String(format: "%.1f", round(distanceInMilesInDouble))
        
//        let distanceInMilesRound = Double(doubleStr)
        
//        let str = "\(distanceInMilesRound)\(" MILES")"
//        let str = "\(distanceInMilesRound)\(" MILES")"
        let total_loadsInt = Double(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "") ?? 0
        let disMiles = Double("\(self.dictBillDetails.value(forKey: "mileage") as? String ?? "0")")! / total_loadsInt
        let totalMiles = round(disMiles)

//        let str = "\(distanceInMiles)\(" MILES")"
        let str = "\(totalMiles)\(" MILES")"


        self.lblTotalDistance.attributedText = self.attributeDtailsBold(strNormal: "Total distance from pickup location to \(self.jobTypeStr.capitalizingFirstLetter()) location : ", strBold: str)        
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
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
                    self.view.makeToast("Failed to upload Invoice Receipt Image. Try again.", duration: 3.0, position: .center)
                    self.str_Invoice_Image = ""
                    self.imgViewInvoice.image = UIImage(named: "")
                    return
                }
                self.str_Invoice_Image = imageName
                self.stopAnimating()
                self.view.makeToast("Invoice Receipt Image uploaded successfully.", duration: 3.0, position: .center)

            })
        }) { (msg) -> ()? in
            DispatchQueue.main.async(execute: {
                self.stopAnimating()
                self.view.makeToast("Failed to upload Invoice Receipt Image. Try again.", duration: 3.0, position: .center)
                self.str_Invoice_Image = ""
                self.imgViewInvoice.image = UIImage(named: "")
            })
        }
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
    
    func attributeDtailsBold(strNormal: String, strBold: String) -> NSMutableAttributedString
    {
        let normalString = NSMutableAttributedString(string:strNormal)
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:strBold, attributes:attrs)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:strBold.length))
        normalString.append(attributedString)
        return normalString
    }
    
    //#MARK:- implement timer functionality
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        //        isTimerRunning = true
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            self.dismiss(animated: true)
            //Send alert to indicate time's up.
        } else {
            seconds -= 1
            self.lblTimeDuration.text = timeString(time: TimeInterval(seconds))
        }
    }
    
}
extension LoadReceivedVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.imgViewInvoice.image = chosenImage
        self.btnPicChoose.setImage(UIImage.init(named: ""), for: .normal)
        self.APIGetUploadedImageName(chosenImage)
        dismiss(animated: true, completion: nil)
    }
}
