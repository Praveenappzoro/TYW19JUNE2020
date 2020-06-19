//
//  ServicesVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 11/15/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class ServicesVC: UIViewController {
    
    var selectedIndex: Int = -1
    var serviceType: String = ""

    
    @IBOutlet weak var collectionViewDeliveryService: UICollectionView!
    
    var arrServicesList: NSMutableArray = ["DEMOLITION","EXCAVATION","GRADING","CONCRETE","HARDSCAPE"]
    var loginUserData:LoggedInUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Constant.MyVariables.appDelegate.truckCartModel != nil {
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            self.selectedIndex = model.selectedServiceIndex
            self.serviceType = model.selectedServicesServiceType
          
            self.collectionViewDeliveryService.reloadData()
        }
        
        var nibName = UINib(nibName: "SelectDeliveryServiceCell", bundle:nil)
        
        self.collectionViewDeliveryService.register(nibName, forCellWithReuseIdentifier: "SelectDeliveryServiceCell")
        
        self.collectionViewDeliveryService.register(UINib(nibName:"NextCell", bundle: Bundle.main),
                                                    forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                                    withReuseIdentifier:"NextCell")
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
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
        sModel.selectedServiceIndex = self.selectedIndex
        sModel.selectedServicesServiceType = self.arrServicesList.object(at: self.selectedIndex) as! String
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        USER_DEFAULT.set(AppState.TruckChooseServicesServiceType.rawValue, forKey: APP_STATE_KEY)
        
    }
    
    
    @IBAction func actionBack(_ sender: Any)
    {
        let sModel = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
        
        sModel.selectedServiceIndex = -1
        sModel.selectedServicesServiceType = ""
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func OnTabNext(_ sender:UIButton)
    {
        
        if(self.selectedIndex >= 0)
        {
            let serviceRequestVC = ServiceRequestVC.init(nibName: "ServiceRequestVC", bundle: nil)
                serviceRequestVC.selectedServiceType = self.arrServicesList.object(at: self.selectedIndex) as! String
            
            let sModel = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
            sModel.selectedServiceIndex = self.selectedIndex
            sModel.selectedServicesServiceType = self.arrServicesList.object(at: self.selectedIndex) as! String
            
            Constant.MyVariables.appDelegate.saveTrucCartData()
            self.navigationController!.pushViewController(serviceRequestVC, animated: true)
        }
    }
    
}
//MARK:- CollectionView Delegate and Data Source Methods

extension ServicesVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.arrRoomsData.count
        return self.arrServicesList.count
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
            
            assert(false, "Unexpected element kind")
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NextCell", for: indexPath as IndexPath) as! NextCell
            
            footerView.btnNextOtlt.addTarget(self, action: #selector(self.OnTabNext(_:)), for: .touchUpInside)
            
            footerView.backgroundColor = UIColor.green
            return footerView
            
        default:
            return UICollectionReusableView()

            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectDeliveryServiceCell", for: indexPath) as! SelectDeliveryServiceCell
        
        
        cell.lblTitle.text = self.arrServicesList.object(at: indexPath.row) as? String
        
        cell.imgView.image = UIImage(named: (self.arrServicesList.object(at: indexPath.row) as? String)!)
        
        if(self.selectedIndex == indexPath.row)
        {
            cell.lblTitle.textColor = UIColor.white
            cell.viewMainCell.backgroundColor = UIColor.init(red: 156.0/255.0, green: 190.0/255.0, blue: 56.0/255.0, alpha: 1.0)
        }
        else
        {
            cell.lblTitle.textColor = UIColor.black
            cell.viewMainCell.backgroundColor = .clear
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.collectionViewDeliveryService.reloadData()
        
        let sModel = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
        sModel.selectedServiceIndex = self.selectedIndex
        Constant.MyVariables.appDelegate.saveTrucCartData()
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize.init(width: (((self.view.frame.size.width - 20)/2)-40), height: (((self.view.frame.size.width - 20)/2)-20))//JobRequestCellHeight.cellSize
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return JobRequestCellHeight.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: JobRequestCellHeight.cellSpacing, left: JobRequestCellHeight.cellSpacing, bottom: 0, right: JobRequestCellHeight.cellSpacing)
    }
}
