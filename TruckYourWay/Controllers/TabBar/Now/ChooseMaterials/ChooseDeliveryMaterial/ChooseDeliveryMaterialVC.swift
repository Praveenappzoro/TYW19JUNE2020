//
//  ChooseDeliveryMaterialVC.swift
//  TruckYourWay
//
//  Created by Anil Choudhary on 25/02/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import UIKit

class ChooseDeliveryMaterialVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!

    var loginUserData:LoggedInUser!
    var arrSelectedDictMaterial: NSMutableArray = []
    
    var getMetarialDictonary : NSMutableDictionary = [:]
    //    var arrMaterials : NSMutableArray = []
    
    var selectedMaterialType : NSMutableDictionary = [:]
    var arrSelectedMaterial : NSMutableArray = []
    var arrSelectedMaterialTemp : [DeliveryData] = []
    var arrSelectedMaterialResponse : [DeliveryResponse] = []
    var pickedCordinates : NSMutableDictionary = [:]
    var selected_Date: String = ""
    var delivery_type: String = ""
    var selectedServiceType: String = ""
    var later_start: Int = 0
    var later_end: Int = 0
    var selectedIndex: Int = -1
    var selectedMaterialIndex: Int = 0
    var selectedMaterial: String = ""
    var arrayMaterialResponse: [DeliveryData] = []

    var isMeterialLoadedByLocation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Constant.MyVariables.appDelegate.truckCartModel != nil {
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            self.selectedIndex = model.selectedDeliveryIndex
            self.selected_Date = model.selected_Date
            self.later_start = model.later_start
            self.later_end = model.later_end
            self.delivery_type = model.delivery_type
            self.pickedCordinates = model.pickedCordinates
            self.selectedMaterialType = model.selectedDeliveryMaterialType
            self.arrSelectedDictMaterial = model.arrSelectedDeliveryMaterial
            self.isMeterialLoadedByLocation = model.isDeliveryMeterialLoadedByLocation
            self.selectedMaterial = model.selectedMaterialType
            
            self.tabBarController?.tabBar.items?[1].badgeValue = model.badgeNumber == 0 ? nil : "\(model.badgeNumber)"
            self.tabBarController?.tabBar.tintColor = model.badgeNumber  == 0 ? themeColorOrange : themeColorGreen

            if model.badgeNumber > 0 {
                self.isMeterialLoadedByLocation = true
            }


            if let arrayData = Constant.MyVariables.appDelegate.getResponseDataStructFromUserDefault(forKey: "arrMaterialLis tTemp") {
                self.arrSelectedMaterialResponse = arrayData

                guard let materialVC = (self.navigationController!.viewControllers[(self.navigationController!.viewControllers.count)-2]) as? ChooseMaterialsVC else { return }

                materialVC.arrMaterialListTemp = arrayData
            }

            
            //KRISHNA----6
           
            
            //=========
            
           // NOTE: 16 Tons = 1 load. 5 ton minimum

            //                Constant.MyVariables.appDelegate.saveResponseDataStructToUserDefault(self.arrMaterialListTemp, forKey: "arrMaterialListTemp")

            if !model.isDeliveryMeterialLoadedByLocation {
                CallApiCategoryData()
            }
        }
        
    self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        self.tblView.sectionHeaderHeight = UITableViewAutomaticDimension;
        self.tblView.estimatedSectionHeaderHeight = 25;
        
        self.tblView.register(UINib(nibName: "MaterialsHeaderCell", bundle: nil), forCellReuseIdentifier: "MaterialsHeaderCell")
        self.tblView.register(UINib(nibName: "MaterialChooseCell", bundle: nil), forCellReuseIdentifier: "MaterialChooseCell")
        //InfoHeaderTableViewCell
        self.tblView.register(UINib(nibName: "InfoHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoHeaderTableViewCell")

        var arrSelectedMaterialResponseTemp : [DeliveryResponse] = []
        
        if self.arrSelectedMaterialResponse.count > 0 {
            arrSelectedMaterialResponseTemp = [self.arrSelectedMaterialResponse[self.selectedIndex == -1 ? 0 : self.selectedIndex]]
        }
        
        for item in arrSelectedMaterialResponseTemp {
            let arr = item.object
            
            var modal: DeliveryData
            var i : Int = 0
            while(i < (arr.count))
            {
                let dict = arr[i]
                modal = DeliveryData(id:dict.id,
                                     quantity:dict.quantity,
                                     size:dict.size,
                                     category:dict.category,
                                     material_image:dict.material_image,
                                     version_no:dict.version_no,
                                     status:dict.status,
                                     dis: dict.distance,
                                     uid: dict.uuid
                                    )
                self.arrSelectedMaterialTemp.append(modal)
                i = i+1
            }
        }
        //self.tblView.reloadData()
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
        
        model.selected_Date = self.selected_Date
        
        model.selectedDeliveryMaterialType = self.selectedMaterialType
        model.arrSelectedDeliveryMaterial = self.arrSelectedDictMaterial
        model.isDeliveryMeterialLoadedByLocation = self.isMeterialLoadedByLocation
        Constant.MyVariables.appDelegate.saveTrucCartData()
        USER_DEFAULT.set(AppState.TruckChooseDelivryServiceType.rawValue, forKey: APP_STATE_KEY)
        
//        guard let materialVC = (self.navigationController!.viewControllers[(self.navigationController!.viewControllers.count)-2]) as? ChooseMaterialsVC else { return }
        
        model.isDeliveryMeterialLoadedByLocation = self.isMeterialLoadedByLocation
        Constant.MyVariables.appDelegate.saveTrucCartData()
        Constant.MyVariables.appDelegate.saveResponseDataStructToUserDefault(arrSelectedMaterialResponse, forKey: "arrMaterialListTemp")
        
        
    }
    
    
    @IBAction func actionBack(_ sender: Any)
    {
        let dddd : DeliveryResponse
        dddd = DeliveryResponse(object:self.arrSelectedMaterialTemp)
        
        guard let materialVC = (self.navigationController!.viewControllers[(self.navigationController!.viewControllers.count)-2]) as? ChooseMaterialsVC else {
            return
        }
        if materialVC.arrMaterialListTemp.count > 0 {
            materialVC.arrMaterialListTemp[self.selectedIndex] = dddd
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnSelectNextFooter(_ sender: UIButton)
    {
        
        self.arrSelectedDictMaterial = []
        
        self.syncCurrentData()
        
        
        let arr = self.filterArray()
        
        for item in arr {
            if(item.quantity > 0) {
                let dict: NSMutableDictionary = [:]
                if(item.category.uppercased() == "DIRT") {
                    dict.setValue(item.id, forKey: "id")
                    dict.setValue(item.category, forKey: "category")
                    dict.setValue(item.material_image, forKey: "material_image")
                    dict.setValue(item.size, forKey: "size")
                    dict.setValue(item.version_no, forKey: "version_no")
                    dict.setValue(item.quantity, forKey: "loads")
                    dict.setValue("active", forKey: "status")
                    self.arrSelectedDictMaterial.add(dict)
                } else {
                    
                    ////////////  ADDED BY KRISHNA  ////////////

                    if item.quantity < 5 {
                        let rAmount = 5 - item.quantity
                        self.showCustomAlertWith(message: "Please add \(rAmount) more tons of material for '\(item.category + item.size)' to satisfy the 5 ton minimum order. Thank You", actions: nil, isSupportHiddedn: true)
                        return
                    }
                    
                    if item.quantity > 16 {
                        let remainder = item.quantity % 16
                        //let shortRemainder = remainder % 5
                        if remainder > 0 && remainder < 5 {
                            let rAmount = 5 - remainder
                            let strMsg = "\("Please add \(rAmount) more tons of material for '\(item.category + item.size)' to satisfy the 5 ton minimum order. Thank You")"
                            self.showCustomAlertWith(message: strMsg, actions: nil, isSupportHiddedn: true)
                            return
                        }
                    }
                    ////////////  ADDED BY KRISHNA ENDS ////////////
                    
                    let reminder = item.quantity % 16
                    var remiderFinal: Int = 0
                    if(reminder > 0) {
                        remiderFinal = 1
                    }
                    let divide_no_Of_time = Int(item.quantity / 16)
                    
                    dict.setValue(item.id, forKey: "id")
                    dict.setValue(item.category, forKey: "category")
                    dict.setValue(item.material_image, forKey: "material_image")
                    dict.setValue(item.size, forKey: "size")
                    dict.setValue(item.version_no, forKey: "version_no")
                    dict.setValue(item.quantity, forKey: "tons")
                    dict.setValue("active", forKey: "status")
                    self.arrSelectedDictMaterial.add(dict)
                }
            }
        }
        
        let selectedTotalTons  = self.calculateRequirementsForNextProcess()
        if(selectedTotalTons < 1) {
            self.showCustomAlertWith(message: "Please add 5 tons of material to satisfy the 5 ton minimum order. Thank You", actions: nil, isSupportHiddedn: true)
            //self.showAlert("Please select choose material with quantity.")
            return
        }
        
        /*

        let remider =  selectedTotalTons % 16
        let needRemaining = 5 - remider

 

        if(selectedTotalTons < 5) {
            self.showAlert("Please add 5 tons minimum material for order delivery.")
            return
        }

        if(selectedTotalTons > 16 && remider > 0 && remider < 5) {
            if (needRemaining == 1) {
                let strMsg = "\("Please add \(needRemaining) more ton material in order to proceed.")"
                self.showAlert(strMsg)
            } else {
                let strMsg = "\("Please add \(needRemaining) more tons material in order to proceed.")"
                self.showAlert(strMsg)
            }
            return
        }
        */
        let specialDelivery = SpecialDeliveryInstructionsVC.init(nibName: "SpecialDeliveryInstructionsVC", bundle: nil)
        
        specialDelivery.selected_Date =  selected_Date
        specialDelivery.delivery_type = delivery_type
        specialDelivery.later_start = later_start
        specialDelivery.later_end = later_end
        specialDelivery.pickedCordinates = self.pickedCordinates.mutableCopy() as! NSMutableDictionary
        //        specialDelivery.selectedMaterialType = self.selectedMaterialType.mutableCopy() as! NSMutableDictionary
        specialDelivery.arrSelectedMaterial = self.arrSelectedDictMaterial.mutableCopy() as! NSMutableArray
        specialDelivery.selectedServiceType = self.selectedServiceType
        
        
        let model = Constant.MyVariables.appDelegate.truckCartModel!
        model.selectedDeliveryMaterialType = self.selectedMaterialType
        model.arrSelectedDeliveryMaterial = self.arrSelectedDictMaterial
        //model.arrSelectedMaterialResponse = self.arrMaterialListTemp
        model.isDeliveryMeterialLoadedByLocation = self.isMeterialLoadedByLocation
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        //        Constant.MyVariables.appDelegate.saveResponseDataStructToUserDefault(self.arrMaterialListTemp, forKey: "arrMaterialListTemp")
        
        
        self.navigationController?.pushViewController(specialDelivery, animated: true)
    }
    
    func validateItems() -> Bool {
        
        let selectedTotalTons  = self.calculateRequirementsForNextProcess()
        
        if(selectedTotalTons < 1) {
            return true
        }

        let remider =  selectedTotalTons % 16
        let shortRemainder = remider % 5
        
        if shortRemainder > 0 {
            let needRemaining = 5 - shortRemainder
            if (needRemaining == 1) {
                let strMsg = "\("Please add \(needRemaining) more ton material in order to proceed.")"
                self.showAlert(strMsg)
            } else {
                let strMsg = "\("Please add \(needRemaining) more tons material in order to proceed.")"
                self.showAlert(strMsg)
            }
            return false
        }
        
        return true
    }
    
    @IBAction func tapOnMinus(_ sender: MyButton)
    {
        let row = sender.row!
        var deliveryObj =  self.arrSelectedMaterialTemp[row]
        if !self.isMeterialLoadedByLocation {
            deliveryObj = self.arrayMaterialResponse[row]
        }
        
        if(deliveryObj.quantity == 0)
        {
            return
        }
        else
        {
            selectedTagofItem = row

            var updatedQuantity = deliveryObj.quantity
            updatedQuantity = updatedQuantity - 1
            self .selectedQuantity = updatedQuantity
            var deliveryObjTemp: DeliveryData
            deliveryObjTemp = DeliveryData(id: deliveryObj.id, quantity: updatedQuantity, size: deliveryObj.size, category:deliveryObj.category, material_image: deliveryObj.material_image, version_no: deliveryObj.version_no, status: "", dis: "", uid: "")
            
            let index = self.arrSelectedMaterialTemp.lastIndex { (model) -> Bool in
                return model.id == deliveryObj.id
            }
            
            self.arrSelectedMaterialTemp[index!] = deliveryObjTemp
            let cell = tblView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MaterialChooseCell
            cell.txtFieldTotalQuantity.text = "\(updatedQuantity)"
            
            
            self.syncCurrentData()
            let totalBadge = getBadgeNumber(totalMaterials: self.arrSelectedMaterialResponse)
            self.tabBarController?.tabBar.items?[1].badgeValue = totalBadge  == 0 ? nil : "\(totalBadge)"
            
            self.tabBarController?.tabBar.tintColor = totalBadge  == 0 ? themeColorOrange : themeColorGreen
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            model.badgeNumber = totalBadge
            Constant.MyVariables.appDelegate.saveTrucCartData()
        }
        
    }
    
    var selectedQuantity = 0
    var selectedTagofItem = 0
    
    @IBAction func tapOnPlus(_ sender: MyButton) {
        let row = sender.row!
        self.selectedMaterialIndex = row
        var deliveryObj =  self.arrSelectedMaterialTemp[row]
        if !self.isMeterialLoadedByLocation {
            deliveryObj = self.arrayMaterialResponse[row]
        }
        
        var updatedQuantity = deliveryObj.quantity
        updatedQuantity = updatedQuantity + 1
        self .selectedQuantity = updatedQuantity
        selectedTagofItem = row

        var deliveryObjTemp: DeliveryData
        
        deliveryObjTemp = DeliveryData(id: deliveryObj.id, quantity:updatedQuantity, size: deliveryObj.size, category:deliveryObj.category, material_image: deliveryObj.material_image, version_no: deliveryObj.version_no, status: "", dis: deliveryObj.distance, uid: deliveryObj.uuid)
        
        let index = self.arrSelectedMaterialTemp.lastIndex { (model) -> Bool in
            return model.id == deliveryObj.id
        }
        self.arrSelectedMaterialTemp[index ?? 0] = deliveryObjTemp
        
        let cell = tblView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MaterialChooseCell
        cell.txtFieldTotalQuantity.text = "\(updatedQuantity)"
        
        
        self.syncCurrentData()
        let totalBadge = getBadgeNumber(totalMaterials: self.arrSelectedMaterialResponse)
        self.tabBarController?.tabBar.items?[1].badgeValue = totalBadge  == 0 ? nil : "\(totalBadge)"
        self.tabBarController?.tabBar.tintColor = totalBadge  == 0 ? themeColorOrange : themeColorGreen
        let model = Constant.MyVariables.appDelegate.truckCartModel!
        model.badgeNumber = totalBadge
        Constant.MyVariables.appDelegate.saveTrucCartData()
        if(!self.isMeterialLoadedByLocation)
        {
            self.CallApi_load_material_by_location(section: self.selectedIndex, row: row)
        }
    }
    
    func syncCurrentData()
    {
        let dddd : DeliveryResponse
        dddd = DeliveryResponse(object:self.arrSelectedMaterialTemp)
        self.arrSelectedMaterialResponse[self.selectedIndex] = dddd
    }
    
    func calculateRequirementsForNextProcess() -> Int
    {
        var selectedTotalTons : Int = 0
        
        var arr : [DeliveryData] = []
        
        for item in self.arrSelectedMaterialResponse {
            let arr = item.object
            
            var modal: DeliveryData
            var j : Int = 0
            while(j < (arr.count))
            {
                let dict = arr[j]
                let val = dict.quantity
                if((dict.category).uppercased() == "DIRT")
                {
                    selectedTotalTons += (Int(val)*16)
                }
                else
                {
                    selectedTotalTons += Int(val)
                }
                modal = DeliveryData(id:dict.id,
                                     quantity:dict.quantity,
                                     size:dict.size,
                                     category:dict.category,
                                     material_image:dict.material_image,
                                     version_no:dict.version_no,
                                     status:dict.status,
                                     dis: dict.distance, uid: dict.uuid
                                    )
                j = j+1
            }
        }
        
        return selectedTotalTons
    }
    
    func filterArray() -> [DeliveryData]
    {
        var arrLocal : [DeliveryData] = []
        var arr : [DeliveryData] = []
        
        for item in self.arrSelectedMaterialResponse {
            let arr = item.object
            
            var modal: DeliveryData
            var j : Int = 0
            while(j < (arr.count))
            {
                let dict = arr[j]
                modal = DeliveryData(id:dict.id,
                                     quantity:dict.quantity,
                                     size:dict.size,
                                     category:dict.category,
                                     material_image:dict.material_image,
                                     version_no:dict.version_no,
                                     status:dict.status, dis: dict.distance, uid: dict.uuid)
                arrLocal.append(modal)
                j = j+1
            }
        }
        
        let ar =  arrLocal.filter({ (param) -> Bool in
            return param.quantity  > 0 ? true : false
        })
        arr = ar
        return arr
    }
    //Mark:- remove duplicate entries
    func getUniqueData(_ arrayOfDicts: [DeliveryData]) -> [DeliveryData] {
        var noDuplicates = [DeliveryData]()
        var usedNames = [String]()
        var flag: Int = 0
        for dict in arrayOfDicts {
            if !usedNames.contains(dict.category) {
                noDuplicates.append(dict)
                usedNames.append(dict.category)
            }
        }
        return noDuplicates
    }
    
    
    //#MARK:- load all Meterial by location on TYW
    func CallApi_load_material_by_location(section:Int,row:Int)
    {
        
        var arrSelectedMaterialResponseTemp = [self.arrSelectedMaterialResponse[self.selectedIndex]]
        
        
        let arr = self.arrSelectedMaterialResponse[self.selectedIndex].object
        var modal: DeliveryData
        modal = arr[row]
        
        if !self.isMeterialLoadedByLocation {
            modal = self.arrayMaterialResponse[row]
            
            let index = arr.lastIndex { (m) -> Bool in
                return m.id == modal.id
            }
            modal = arr[index!]
        }
        /*/ {
        "id": 1112,
        "size": "Crusher Run",
        "category": "GRAVEL",
        "material_image": "1564444873184053.jpg",
        "version_no": "21",
        "uuid": "SKU225",
        "status": "active",
        "distance": "1.00"
    }*/
        let material_data = [
            "id" : modal.id,
            "version_no" : modal.version_no,
            "distance" : modal.distance,
            "category":modal.category,
            "uuid" : modal.uuid,
            "status" : modal.status,
            "material_image":modal.material_image,
            "size":modal.size
        ] as [String : Any]
        
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
            "material_data":material_data,
            "type":(self.selectedServiceType).lowercased(),
            "latitude": self.pickedCordinates.value(forKey: "lat")!,
            "longitude":self.pickedCordinates.value(forKey: "long")!,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            "position" : row
            ] as [String : Any]
        
        self.startAnimating("")
        print("load material by location ==== \(parameters)")
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_LOAD_MATERIAL_BY_LOCATION, .post, parameters, { (result, data, json, error, msg) in
            
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
                    
                    let jsonDic = json?["results"] as! NSDictionary
                    let total = jsonDic.count

                    if(total>0)
                    {
                        self.getMetarialDictonary = jsonDic.mutableCopy() as! NSMutableDictionary
                        //                        var arr : NSMutableArray = []
                        //                        arr  = self.arrMaterials.mutableCopy() as! NSMutableArray
                        //                        self.arrMaterials.removeAllObjects()
                        var dictNew: NSMutableDictionary = [:]
                        var arrMaterialListTempOnPriority: [DeliveryResponse] = []
                        var flag : Int = 0
                        for (keys, values) in jsonDic
                        {
                            print("The path to '\(keys)' is '\(values)'.")
                            let str = keys as! String
                            let dict = [str:values] as NSDictionary
                            dictNew = dict.mutableCopy() as! NSMutableDictionary
                            dictNew.setValue(false, forKey: "isExpendable")
                            let updatedDict =  self.AddImportData(dict:dictNew,keyName:keys as! String)
                            //                            self.arrMaterials.add(updatedDict)
                            let arrr = self.appendData(arr: updatedDict.value(forKey: str) as! NSArray)
                            let dddd : DeliveryResponse
                            dddd = DeliveryResponse(object:arrr)
                            
                            arrMaterialListTempOnPriority.append(dddd)
                            self.updateDataAfterGetMaterialByLocation(arrDeliveryMaterial:arrMaterialListTempOnPriority,selectedItemIndex:row,flag:flag)
                            flag = flag+1
                        }
                        
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
                                    status:dict.value(forKey: "status") as? String ?? "",
                                    dis:dict.value(forKey: "distance") as? String ?? "",
                                    uid:dict.value(forKey: "uuid") as? String ?? "")

            deliveryArr.append(delivery)
        }
        
        return deliveryArr
    }
    
    func updateDataAfterGetMaterialByLocation(arrDeliveryMaterial:[DeliveryResponse],selectedItemIndex:Int,flag:Int)
    {
        var arrOld : [DeliveryData] = []
        var arrNew : [DeliveryData] = []
        
        var mainArray : [DeliveryResponse] = []
        var flagIncrease: Int = 0
        
        
        
        arrOld = self.arrSelectedMaterialResponse[flag].object
        arrNew = arrDeliveryMaterial[flag].object
        
        for item in self.arrSelectedMaterialResponse {
            mainArray.append(item)
            flagIncrease = flagIncrease + 1
        }
        var i: Int = 0
        
        for item in arrNew {
            if(i != selectedItemIndex) {
                arrOld[i] = item
            } else {
                arrOld[i].status = item.status //To retain the mterial count
                //arrOld[i] = item //To change the mterial count to 0
            }
            i = i+1
        }
        
        
        let dddd : DeliveryResponse
        dddd = DeliveryResponse(object:arrNew)
        
        mainArray[flag] = dddd
        self.arrSelectedMaterialResponse[flag] = dddd
        
        self.arrSelectedMaterialTemp = self.arrSelectedMaterialResponse[self.selectedIndex].object
        let deliveryObj =  self.arrSelectedMaterialTemp[selectedTagofItem]
        var updatedQuantity = deliveryObj.quantity
        updatedQuantity = self .selectedQuantity
        
        var deliveryObjTemp: DeliveryData
        
        deliveryObjTemp = DeliveryData(id: deliveryObj.id, quantity:updatedQuantity, size: deliveryObj.size, category:deliveryObj.category, material_image: deliveryObj.material_image, version_no: deliveryObj.version_no, status: "", dis: deliveryObj.distance, uid: deliveryObj.uuid)
        
        let index = self.arrSelectedMaterialTemp.lastIndex { (model) -> Bool in
            return model.id == deliveryObj.id
        }
        self.arrSelectedMaterialTemp[index ?? 0] = deliveryObjTemp
        self.syncCurrentData()
        let totalBadge = getBadgeNumber(totalMaterials: self.arrSelectedMaterialResponse)
        self.tabBarController?.tabBar.items?[1].badgeValue = totalBadge  == 0 ? nil : "\(totalBadge)"
        self.tabBarController?.tabBar.tintColor = totalBadge  == 0 ? themeColorOrange : themeColorGreen
        let model = Constant.MyVariables.appDelegate.truckCartModel!
        model.badgeNumber = totalBadge
        Constant.MyVariables.appDelegate.saveTrucCartData()
        
        self.tblView.reloadData()
        
        
        guard let materialVC = (self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count ?? 0)-2]) as? ChooseMaterialsVC else
        {
            return
        }
        // materialVC.arrMaterialListTemp[self.selectedIndex] = dddd
        materialVC.arrMaterialListTemp = mainArray
        materialVC.isMeterialLoadedByLocation = true
        self.isMeterialLoadedByLocation = true
        
    }
}


//Mark:- extension for TableView Delegate and datasource

extension ChooseDeliveryMaterialVC: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialsHeaderCell") as! MaterialsHeaderCell
        cell.viewForFooter.alpha = 1
        cell.btnFooterNext.addTarget(self, action: #selector(self.OnSelectNextFooter(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.arrSelectedMaterialTemp.count >= 1 {
            return 50
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.isMeterialLoadedByLocation {
            return  self.arrayMaterialResponse.count
        }
        return  self.arrSelectedMaterialTemp.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 150
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoHeaderTableViewCell") as? InfoHeaderTableViewCell
        let model = Constant.MyVariables.appDelegate.truckCartModel!
        if model.selectedDeliveryIndex == 1 {
            cell?.lblDisc.text = "NOTE: 16 tons = 1 load.\n1 load minimum\n(All loads are whole numbers)"
        } else {
            cell?.lblDisc.text = "NOTE: 16 tons = 1 load.\n5 ton minimum\n(All loads are whole numbers)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialChooseCell", for: indexPath) as! MaterialChooseCell
        
        var data: DeliveryData = self.arrSelectedMaterialTemp[indexPath.row]
        
        if !self.isMeterialLoadedByLocation {
            data = self.arrayMaterialResponse[indexPath.row]
            cell.labelDistance.text = "Distance: \(data.distance) Miles"
        } else {
            cell.labelDistance.text = ""
        }
        
        cell.lblInstructionCategoryHeightConstraint.constant = 0
        cell.materialName.text = "\(data.category)\(" ")\(data.size)"
        
        cell.txtFieldTotalQuantity.delegate = self
        
        cell.btnMinusOtlt.tag = indexPath.row
        cell.btnPlusOtlt.tag = indexPath.row
        
        cell.lblLoads.text = (data.category).uppercased() == "DIRT" ? "LOADS" : "TONS"
        cell.txtFieldTotalQuantity.text = "\(data.quantity)"
        cell.txtFieldTotalQuantity.tag = indexPath.row
        cell.imgViewMaterial.loadImageAsync(with: BSE_URL_LoadMedia+data.material_image, defaultImage: "", size: cell.imgViewMaterial.frame.size)
        
        cell.txtFieldTotalQuantity.section = indexPath.section
        cell.txtFieldTotalQuantity.row = indexPath.row
        
        cell.btnMinusOtlt.section = indexPath.section
        cell.btnMinusOtlt.row = indexPath.row
        
        cell.btnPlusOtlt.section = indexPath.section
        cell.btnPlusOtlt.row = indexPath.row
        
        cell.btnMaterialImageZoomOtlt.section = indexPath.section
        cell.btnMaterialImageZoomOtlt.row = indexPath.row
        cell.btnMaterialImageZoomOtlt.tag = indexPath.row
        cell.btnMaterialImageZoomOtlt.material_image = BSE_URL_LoadMedia+data.material_image
        cell.btnMaterialImageZoomOtlt.addTarget(self, action: #selector(self.addImageViewWithImage(_:)), for: .touchUpInside)
        cell.btnMinusOtlt.addTarget(self, action: #selector(self.tapOnMinus(_:)), for: .touchUpInside)
        
        
        cell.btnPlusOtlt.addTarget(self, action: #selector(self.tapOnPlus(_:)), for: .touchUpInside)
        let strStatus = data.status
        if(strStatus == "inactive")
        {
            cell.btnShowPopUpForAvaliableMaterialOtlt.alpha = 1
            cell.btnShowPopUpForAvaliableMaterialOtlt.addTarget(self, action: #selector(self.actionCheckMaterialAvaliable(_:)), for: .touchUpInside)
            cell.viewBackground.backgroundColor = UIColor.init(red: 105.0/255.0, green: 105.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        }
        else
        {
            cell.btnShowPopUpForAvaliableMaterialOtlt.alpha = 0
            cell.viewBackground.backgroundColor = UIColor.white
        }
        cell.labelUUID.text = data.uuid
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        //        let previous  = self.selectedIndex
        //        self.selectedIndex = indexPath.section
        //
        //        tableView.reloadSections([previous,indexPath.section], with: .fade)
        
    }
    
    
    //Mark:- Zoom In Image tap on Photo any item
    
    @IBAction func actionCheckMaterialAvaliable(_ sender: UIButton)
    {
        
        let alert = CustomAlert(title: "This location does not offer this material. you must place a new order.\n(Please go back to empty truck cart in order to refresh material orders.)", image: UIImage(named: "logomain")!, typeAlert: "", ButtonTitle: "Next")
        alert.show(animated: true)
    }
    
    @IBAction func addImageViewWithImage(_ sender: MyButton){
        
        //let dict  = self.arrSelectedMaterialTemp[sender.row!]
        let imgURL = sender.material_image
        
        let viewZoomImage = UIView(frame: self.view.frame)
        viewZoomImage.isUserInteractionEnabled = true
        viewZoomImage.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        viewZoomImage.tag = 100
        viewZoomImage.alpha = 0
        let imageView = UIImageView(frame: self.view.frame)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.clear
        imageView.loadImageAsync(with: imgURL, defaultImage: "", size: imageView.frame.size)
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.removeImage))
        dismissTap.numberOfTapsRequired = 1
        viewZoomImage.addGestureRecognizer(dismissTap)
        viewZoomImage.addSubview(imageView)
        self.view.addSubview(viewZoomImage)
        
        viewZoomImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        viewZoomImage.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 4.0, options: .curveEaseOut, animations:
            {
                viewZoomImage.transform = CGAffineTransform.identity
        }, completion: nil)
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
}

//Mark:- extension for UITextField Delegate

extension ChooseDeliveryMaterialVC: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if(textField.text == " ")
        {
            return false
        }
        if textField.text == "0" {
            textField.text = ""
        }
        let stt =  "\(textField.text as! String)\(string )"
        if(textField.text != "")
        {
            let total = Int(stt) ?? 0
            
            if(total > 9999)
            {
                return false
            }
            
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let txtFiled = textField as? CustomTxtField
        self.tblView.isScrollEnabled = true
        
        let row = txtFiled!.row ?? 0
        
        var deliveryObj =  self.arrSelectedMaterialTemp[row]
        if !self.isMeterialLoadedByLocation {
            deliveryObj = self.arrayMaterialResponse[row]
        }
        //            return
        //        }
        var strr = textField.text ?? ""
        if(strr == "")
        {
            strr = "0"
            return
        }
        let checkValue = Int(strr )
        
        if(checkValue! <= 0)
        {
            strr = "0"
            return
        }
        selectedQuantity = checkValue ?? 0
        selectedTagofItem = row
        
        let strQuantity = strr as! String
        let updatedQuantity = Int(strQuantity) ?? 1
        var deliveryObjTemp: DeliveryData
        deliveryObjTemp = DeliveryData(id: deliveryObj.id, quantity: updatedQuantity, size: deliveryObj.size, category:deliveryObj.category, material_image: deliveryObj.material_image, version_no: deliveryObj.version_no, status: "", dis: deliveryObj.distance, uid: deliveryObj.uuid)
        
        let index = self.arrSelectedMaterialTemp.lastIndex { (model) -> Bool in
            return model.id == deliveryObj.id
        }
        self.arrSelectedMaterialTemp[index!] = deliveryObjTemp
        self.tblView.reloadData()
        
        
        self.syncCurrentData()
        let totalBadge = getBadgeNumber(totalMaterials: self.arrSelectedMaterialResponse)
        self.tabBarController?.tabBar.items?[1].badgeValue = totalBadge  == 0 ? nil : "\(totalBadge)"
        
        self.tabBarController?.tabBar.tintColor = totalBadge  == 0 ? themeColorOrange : themeColorGreen
        
        if(!self.isMeterialLoadedByLocation)
        {
            self.CallApi_load_material_by_location(section: self.selectedIndex, row: row)
        }
    }
    
    
    func CallApiCategoryData() {
        
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
            "category": self.selectedMaterial,
            "type":(self.selectedServiceType).lowercased(),
            "latitude": self.pickedCordinates.value(forKey: "lat")!,
            "longitude":self.pickedCordinates.value(forKey: "long")!,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
        
        self.startAnimating("")
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_load_specific_category_distance, .post, parameters, { (result, data, json, error, msg) in
            
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
                    let jsonDic = (json?["results"] as! NSDictionary)[self.selectedMaterial] as! NSArray
                    let total = jsonDic.count
                    if(total>0) {
                        let array = jsonDic.mutableCopy() as! NSArray
                        let arrr = self.appendData(arr: array)
                        //let dddd : DeliveryResponse
                        self.arrayMaterialResponse = arrr
                    }
                    self.tblView.reloadData()
                })
            }
            
        })
        
    }
}

