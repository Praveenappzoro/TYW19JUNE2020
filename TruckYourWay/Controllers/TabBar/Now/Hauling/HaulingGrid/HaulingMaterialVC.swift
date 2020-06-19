//
//  HaulingMaterialVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 12/19/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class HaulingMaterialVC: UIViewController {

    
    @IBOutlet weak var collectionViewJobType: UICollectionView!
    
    @IBOutlet weak var viewPopUp: UIView!
    
    @IBOutlet weak var subViewPopUp: UIView!
    
    
    let constInstructionForDirt = "NOTE: 16 tons = 1 load (All loads are whole numbers) (5 ton minimum on all loads)"
    
    let constInstructionForNotDirt = "NOTE: 16 tons = 1 load (All loads are whole numbers) (5 ton minimum on all loads)"
    
    var selectedIndex: Int = -1
    var selectedTotalTons: Int = 0
    
    var selectedServiceType: String = ""
    
    
    var pickedCordinates : NSMutableDictionary = [:]
    var selectedMaterialType : NSMutableDictionary = [:]
    
    var getMetarialDictonary : NSMutableDictionary = [:]
    var arrMaterials : NSMutableArray = []
    var arrMaterialsForNextProcess : NSMutableArray = []
    var arrSelectedDictMaterial : NSMutableArray = []
    var arrMaterialListTemp: [DeliveryResponse] = []
    var loginUserData:LoggedInUser!
    
    
    var selected_Date: String = ""
    var delivery_type: String = ""
    var later_start: Int = 0
    var later_end: Int = 0
    var isMeterialLoadedByLocation: Bool = false
    var selectedMaterial: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Constant.MyVariables.appDelegate.truckCartModel != nil {
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            self.selectedIndex = model.selectedHaulingIndex
            self.selected_Date = model.selected_Date
            self.later_start = model.later_start
            self.later_end = model.later_end
            self.delivery_type = model.delivery_type
            self.pickedCordinates = model.pickedCordinates
            
//            self.later_end = model.later_end
//            self.delivery_type = model.delivery_type
//            self.pickedCordinates = model.pickedCordinates
            self.collectionViewJobType.reloadData()
        }
        
        var nibName = UINib(nibName: "JobRequestCell", bundle:nil)
        
        self.collectionViewJobType.register(nibName, forCellWithReuseIdentifier: "JobRequestCell")
        
        self.collectionViewJobType.register(UINib(nibName:"NextCell", bundle: Bundle.main),
                                            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                            withReuseIdentifier:"NextCell")
        
        self.subViewPopUp.layer.cornerRadius = 5
        self.subViewPopUp.layer.masksToBounds = true
        
        self.apiLoadMaterials()
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
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
        
        model.selectedHaulingIndex = self.selectedIndex
        model.selected_Date = self.selected_Date

        model.selectedDeliveryMaterialType = self.selectedMaterialType
        model.arrSelectedDeliveryMaterial = self.arrSelectedDictMaterial
        //model.arrSelectedMaterialResponse = self.arrMaterialListTemp
        model.isDeliveryMeterialLoadedByLocation = self.isMeterialLoadedByLocation

    Constant.MyVariables.appDelegate.saveResponseDataStructToUserDefault(self.arrMaterialListTemp, forKey: "arrMaterialListTemp")
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        USER_DEFAULT.set(AppState.TruckChooseHaulingServiceType.rawValue, forKey: APP_STATE_KEY)
        
    }
    
    @IBAction func actionBack(_ sender: Any)
    {
        
        
        if(self.tabBarController?.tabBar.items?[1].badgeValue != nil)
        {
            self.viewPopUp.isHidden = false
            
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            
            model.selectedHaulingIndex = -1
            model.selectedDeliveryMaterialType = NSMutableDictionary()
            model.arrSelectedDeliveryMaterial = NSMutableArray()
            model.badgeNumber = 0
        Constant.MyVariables.appDelegate.saveResponseDataStructToUserDefault([DeliveryResponse](), forKey: "arrMaterialListTemp")
            
            Constant.MyVariables.appDelegate.saveTrucCartData()
        }
        else
        {
           
            self.navigationController?.popViewController(animated: true)
            
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            
            model.selectedHaulingIndex = -1
            model.selectedDeliveryMaterialType = NSMutableDictionary()
            model.arrSelectedDeliveryMaterial = NSMutableArray()
            Constant.MyVariables.appDelegate.saveResponseDataStructToUserDefault([DeliveryResponse](), forKey: "arrMaterialListTemp")
            
            Constant.MyVariables.appDelegate.saveTrucCartData()
        }
    }
    
    @IBAction func actionNo(_ sender: Any)
    {
        self.viewPopUp.isHidden = true
    }
    
    @IBAction func actionYes(_ sender: Any)
    {
        self.viewPopUp.isHidden = true
        self.tabBarController?.tabBar.items?[1].badgeValue = nil
        self.tabBarController?.tabBar.tintColor = themeColorOrange
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnSelectSectionType(_ sender: UIButton)
    {
        self.selectedIndex = sender.tag
        let dict = self.arrMaterials.object(at: self.selectedIndex) as! NSDictionary
        let dictMutable = dict.mutableCopy() as! NSMutableDictionary
        
        if(dictMutable.value(forKey: "isExpendable") as! Bool == true)
        {
            dictMutable.setValue(false, forKey: "isExpendable")
        }
        else
        {
            dictMutable.setValue(true, forKey: "isExpendable")
        }
        self.arrMaterials.replaceObject(at: self.selectedIndex, with: dictMutable)
    }
    
    @IBAction func tapOnMinus(_ sender: MyButton)
    {
        
        let section = sender.section!
        let row = sender.row!
        let firstKey = Array(getMetarialDictonary.allKeys)
        let dictSec = self.arrMaterials.object(at: section) as! NSDictionary
        var dictSecMutable = dictSec.mutableCopy() as! NSMutableDictionary
        
        let arr = dictSec.value(forKey:firstKey[section] as! String) as! NSArray
        var arrMutable = arr.mutableCopy() as! NSMutableArray
        
        let dict =  arrMutable.object(at: row) as! NSDictionary
        var dictNew = dict.mutableCopy() as! NSMutableDictionary
        
        var strQuantity =  dictNew.value(forKey: "quantity") as! String
        if(strQuantity == "0" || dictNew.value(forKey: "status") as! String == "inactive")
        {
            return
        }
        else
        {
            var intQuantity = Int(strQuantity)!
            intQuantity = intQuantity-1
            strQuantity = "\(intQuantity)"
        }
        
        dictNew.setValue(strQuantity, forKey: "quantity")
        arrMutable.replaceObject(at: row, with: dictNew)
        dictSecMutable.setValue(arrMutable, forKey: firstKey[section] as! String)
        
        self.arrMaterials.replaceObject(at: section, with: dictSecMutable)
        
        self.calculateRequirementsForNextProcess()
        
    }
    
    @IBAction func tapOnPlus(_ sender: MyButton)
    {
        let section = sender.section!
        let row = sender.row!
        
        
        let firstKey = Array(getMetarialDictonary.allKeys)
        let dictSec = self.arrMaterials.object(at: section) as! NSDictionary
        var dictSecMutable = dictSec.mutableCopy() as! NSMutableDictionary
        
        let arr = dictSec.value(forKey:firstKey[section] as! String) as! NSArray
        var arrMutable = arr.mutableCopy() as! NSMutableArray
        
        let dict =  arrMutable.object(at: row) as! NSDictionary
        var dictNew = dict.mutableCopy() as! NSMutableDictionary
        
        var strQuantity =  dictNew.value(forKey: "quantity") as! String
        
        if(dictNew.value(forKey: "status") as! String == "inactive")
        {
            return
        }
        else
        {
            var intQuantity = Int(strQuantity)!
            intQuantity = intQuantity+1
            strQuantity = "\(intQuantity)"
        }
        
        dictNew.setValue(strQuantity, forKey: "quantity")
        arrMutable.replaceObject(at: row, with: dictNew)
        dictSecMutable.setValue(arrMutable, forKey: firstKey[section] as! String)
        
        self.arrMaterials.replaceObject(at: section, with: dictSecMutable)
        
        self.calculateRequirementsForNextProcess()
        
        
    }
    
    @IBAction func actionCheckMaterialAvaliable(_ sender: UIButton)
    {
        
        let alert = CustomAlert(title: "This location does not offer this material. you must place a new order.\n(Please go back to empty truck cart in order to refresh material orders.)", image: UIImage(named: "logomain")!, typeAlert: "", ButtonTitle: "Next")
        alert.show(animated: true)
    }
    
    @IBAction func OnSelectNextFooter(_ sender: UIButton)
    {
        
        
        if(self.selectedIndex <= -1 )
        {
            
            self.showAlert("Please select Material type.")
            return
        }
        
        self.arrSelectedDictMaterial = []
        self.arrSelectedDictMaterial.add(self.arrMaterials.object(at: self.selectedIndex))
        
        let chooseHaulingyM = ChooseHaulingMaterialVC.init(nibName: "ChooseHaulingMaterialVC", bundle: nil)
        
        chooseHaulingyM.selected_Date =  selected_Date
        chooseHaulingyM.delivery_type = delivery_type
        chooseHaulingyM.later_start = later_start
        chooseHaulingyM.later_end = later_end
        chooseHaulingyM.pickedCordinates = self.pickedCordinates.mutableCopy() as! NSMutableDictionary
        chooseHaulingyM.selectedMaterialType = self.selectedMaterialType.mutableCopy() as! NSMutableDictionary
        chooseHaulingyM.arrSelectedMaterial = self.arrSelectedDictMaterial.mutableCopy() as! NSMutableArray
        chooseHaulingyM.arrSelectedMaterialResponse = self.arrMaterialListTemp
        chooseHaulingyM.selectedIndex = self.selectedIndex
        chooseHaulingyM.selectedServiceType = self.selectedServiceType
        chooseHaulingyM.isMeterialLoadedByLocation = self.isMeterialLoadedByLocation
        chooseHaulingyM.selectedMaterial = selectedMaterial
        
        let model = Constant.MyVariables.appDelegate.truckCartModel!
        model.selectedHaulingIndex = self.selectedIndex
        
        model.selectedDeliveryMaterialType = self.selectedMaterialType
        model.arrSelectedDeliveryMaterial = self.arrSelectedDictMaterial
        //model.arrSelectedMaterialResponse = self.arrMaterialListTemp
        //
        model.isDeliveryMeterialLoadedByLocation = self.isMeterialLoadedByLocation

    Constant.MyVariables.appDelegate.saveResponseDataStructToUserDefault(self.arrMaterialListTemp, forKey: "arrMaterialListTemp")
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        
        
        self.navigationController?.pushViewController(chooseHaulingyM, animated: true)
    }
    
    //#MARK:- load all Meterial avaliable on TYW
    func apiLoadMaterials()
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
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_LOAD_HAULING_MATERIAL, .post, parameters, { (result, data, json, error, msg) in
            
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
                    
                    let jsonResponse = json?["results"] as! NSDictionary

                    let total = jsonResponse.count
                    if(total>0)
                    {
                        self.getMetarialDictonary = jsonResponse.mutableCopy() as! NSMutableDictionary
                        self.arrMaterials.removeAllObjects()
                        var dictNew: NSMutableDictionary = [:]
                        for (keys, values) in jsonResponse
                        {
                            print("The path to '\(keys)' is '\(values)'.")
                            let str = keys as! String
                            let dict = [str:values] as NSDictionary
                            dictNew = dict.mutableCopy() as! NSMutableDictionary
                            dictNew.setValue(false, forKey: "isExpendable")
                            let updatedDict =  self.AddImportData(dict:dictNew,keyName:keys as! String)
                            self.arrMaterials.add(updatedDict)
                            let arrr = self.appendData(arr: updatedDict.value(forKey: str) as! NSArray)
                            
                            let dddd : DeliveryResponse
                            dddd = DeliveryResponse(object:arrr)
                            self.arrMaterialListTemp.append(dddd)
                        }
                        self.collectionViewJobType.reloadData()
                    }
                })
            }
            
        })
    }
    func appendData(arr: NSArray) -> [DeliveryData]
    {
        var deliveryArr: [DeliveryData] = []
        for item in arr
        {
            let dict = item as! NSDictionary
            var delivery: DeliveryData
            delivery = DeliveryData(id:dict.value(forKey: "id") as? Int ?? 0,
                                    quantity:Int(dict.value(forKey: "quantity") as? String ?? "0") ?? 0 ,
                                    size:dict.value(forKey: "size") as? String ?? "",
                                    category:dict.value(forKey: "category") as? String ?? "",
                                    material_image:dict.value(forKey: "material_image") as? String ?? "",
                                    version_no:dict.value(forKey: "version_no") as? String ?? "",
                                    status:dict.value(forKey: "status") as? String ?? "", dis: "", uid: "")
            deliveryArr.append(delivery)
        }
        
        return deliveryArr
    }
    
    
    func AddImportData(dict: NSDictionary,keyName: String) -> NSDictionary
    {
        var dictMutable: NSMutableDictionary = [:]
        var dictSec: NSMutableDictionary = [:]
        dictSec = dict.mutableCopy() as! NSMutableDictionary
        
        let arr = dict.value(forKey:keyName) as! NSArray
        var arrMutable = arr.mutableCopy() as! NSMutableArray
        var i: NSInteger = 0;
        for item in arr
        {
            let dictA = item as! NSDictionary
            dictMutable = dictA.mutableCopy() as! NSMutableDictionary
            dictMutable.setValue("0", forKey: "quantity")
            arrMutable.replaceObject(at: i, with:dictMutable)
            i += 1 ;
        }
        
        dictSec.setValue(arrMutable, forKey: keyName)
        return dictSec
    }
    
    func calculateRequirementsForNextProcess()
    {
        self.selectedTotalTons = 0
        var i: Int = 0
        let firstKey = Array(getMetarialDictonary.allKeys)
        for item in self.arrMaterials
        {
            
            var j: Int = 0
            let dict = item as! NSDictionary
            let arrSubItem = dict.value(forKey: firstKey[i] as! String) as! NSArray
            
            for dictSubItem in arrSubItem
            {
                let dictSub = dictSubItem as! NSDictionary
                let val = dictSub.value(forKey: "quantity") as! String
                //                let quantityConvertInt = Int(val)!
                // In case of Hauling all materials will be consder as a load
                if((dictSub.value(forKey: "category") as! String).uppercased() == "DIRT")
                {
                    self.selectedTotalTons += Int(val) ?? 0
                }
                else
                {
                    self.selectedTotalTons += Int(val) ?? 0
                }
                
            }
            
            i += 1
        }
    }
    
    func getSelectedMaterial()
    {
        self.arrSelectedDictMaterial = []
        var i: Int = 0
        let firstKey = Array(getMetarialDictonary.allKeys)
        var arrMutable: NSMutableArray = []
        
        for item in self.arrMaterials
        {
            var dictMutable: NSMutableDictionary = [:]
            var dictSec: NSMutableDictionary = [:]
            let dict = item as! NSDictionary
            dictSec = dict.mutableCopy() as! NSMutableDictionary
            let keyName = firstKey[i] as! String
            let arr = dict.value(forKey:keyName) as! NSArray
            var arrMutable = arr.mutableCopy() as! NSMutableArray
            var j: NSInteger = 0;
            
            for item in arr
            {
                let dictA = item as! NSDictionary
                dictMutable = dictA.mutableCopy() as! NSMutableDictionary
                if(dictMutable.value(forKey: "quantity") as! String == "0")
                {
                    arrMutable.removeObject(at: j)
                }
                else
                {
                    // In case of Hauling all materials will be consder as a load
                    if((dictMutable.value(forKey: "category") as! String).uppercased() == "DIRT")
                    {
                        let dict = [
                            "id": dictMutable.value(forKey: "id"),
                            "size":dictMutable.value(forKey: "size"),
                            "category": dictMutable.value(forKey: "category"),
                            "material_image": dictMutable.value(forKey: "material_image"),
                            "version_no": dictMutable.value(forKey: "version_no"),
                            "status": dictMutable.value(forKey: "status"),
                            "loads": dictMutable.value(forKey: "quantity") as! String
                            ] as [String:AnyObject]
                        let ddiicctt = dict as NSDictionary
                        dictMutable = ddiicctt.mutableCopy() as! NSMutableDictionary
                    }
                    else
                    {
                        let dict = [
                            "id": dictMutable.value(forKey: "id"),
                            "size":dictMutable.value(forKey: "size"),
                            "category": dictMutable.value(forKey: "category"),
                            "material_image": dictMutable.value(forKey: "material_image"),
                            "version_no": dictMutable.value(forKey: "version_no"),
                            "status": dictMutable.value(forKey: "status"),
                            "loads": dictMutable.value(forKey: "quantity") as! String
                            ] as [String:AnyObject]
                        let ddiicctt = dict as NSDictionary
                        dictMutable = ddiicctt.mutableCopy() as! NSMutableDictionary
                    }
                    
                    self.arrSelectedDictMaterial.add(dictMutable)
                    
                    arrMutable.replaceObject(at: j, with: dictMutable)
                    
                    j += 1 ;
                }
            }
            if(arrMutable.count>0)
            {
                dictSec.setValue(arrMutable, forKey: keyName)
                self.arrMaterialsForNextProcess.add(dictSec)
            }
            
            i += 1 ;
            
        }
    }
    
    @objc func removeImage() {
        
        let vieww = (self.view.viewWithTag(100)! as! UIView)
        
        vieww.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 4.0, options: .curveEaseOut, animations:
            {
                vieww.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                vieww.removeFromSuperview()
        }, completion: { (void) in
            //            vieww.removeFromSuperview()
        })
        
    }
    
}

extension HaulingMaterialVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.arrRoomsData.count
        return self.getMetarialDictonary.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if(self.selectedIndex != -1)
        {
            return CGSize(width:collectionView.frame.size.width, height:100.0)
        }
        else
        {
            return CGSize(width:collectionView.frame.size.width, height:0.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NextCell", for: indexPath as IndexPath) as! NextCell
            
            
            footerView.backgroundColor = UIColor.green
            return footerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NextCell", for: indexPath as IndexPath) as! NextCell
            
            footerView.btnNextOtlt.addTarget(self, action: #selector(self.OnSelectNextFooter(_:)), for: .touchUpInside)
            
            
            footerView.backgroundColor = UIColor.green
            return footerView
            
        default:
            return UICollectionReusableView()
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobRequestCell", for: indexPath) as! JobRequestCell
        
        
        let dict  = self.arrMaterials.object(at: indexPath.row) as? NSDictionary
        let firstKey = Array(getMetarialDictonary.allKeys)
        cell.lblName.text = firstKey[indexPath.row] as? String ?? ""
        cell.imageView.image = UIImage.init(named: "HAULING")
        
        if(self.selectedIndex == indexPath.row)
        {
            cell.viewCellMain.backgroundColor = UIColor.init(red: 156.0/255.0, green: 190.0/255.0, blue: 56.0/255.0, alpha: 1.0)
            cell.lblName.textColor = .white
        }
        else
        {
            cell.viewCellMain.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            cell.lblName.textColor = .darkGray
        }
        
        cell.lblDesc.alpha = 0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let firstKey = Array(getMetarialDictonary.allKeys)
        self.selectedMaterial = firstKey[indexPath.row] as? String ?? ""
        self.selectedIndex = indexPath.row
        self.collectionViewJobType.reloadData()
//
//
//        self.selectedIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return JobRequestCellHeight.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: JobRequestCellHeight.cellSpacing, left: JobRequestCellHeight.cellSpacing, bottom: 0, right: JobRequestCellHeight.cellSpacing)
    }
    
    
}
