//
//  JobRequestVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/11/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit


class JobRequestVC: UIViewController {
   
    var selectedIndex : Int = -1
    @IBOutlet weak var collectionViewJobType: UICollectionView!
    
    var pickedCordinates : NSMutableDictionary = [:]

    var arrRequestType: NSMutableArray = ["DELIVERY","HAULING","SERVICES",""]

    var selected_Date: String = ""
    var delivery_type: String = ""
    var selectedServiceType: String = ""
    var later_start: Int = 0
    var later_end: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "JobRequestCell", bundle:nil)
        
        self.collectionViewJobType.register(nibName, forCellWithReuseIdentifier: "JobRequestCell")
        
        self.collectionViewJobType.register(UINib(nibName:"NextCell", bundle: Bundle.main),
                                                    forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                                    withReuseIdentifier:"NextCell")
        
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
        print("disappearing..")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc func appIsGoingInBackground() {
        print("disappearing..")
        
        guard let sModel = Constant.MyVariables.appDelegate.truckCartModel else {
            return
        }
        
        sModel.selectedServiceType = self.selectedServiceType
        sModel.selectedJobIndex = self.selectedIndex
        sModel.selected_Date = self.selected_Date

        Constant.MyVariables.appDelegate.saveTrucCartData()
        
        USER_DEFAULT.set(AppState.TruckJobRequest.rawValue, forKey: APP_STATE_KEY)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Constant.MyVariables.appDelegate.truckCartModel != nil {
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            self.selectedIndex = model.selectedJobIndex
            self.selectedServiceType = model.selectedServiceType
            self.selected_Date = model.selected_Date
            self.later_start = model.later_start
            self.later_end = model.later_end
            self.delivery_type = model.delivery_type
            self.pickedCordinates = model.pickedCordinates.mutableCopy() as! NSMutableDictionary
            
            switch self.selectedIndex {
            case 0:
                self.arrRequestType.replaceObject(at: 3, with: "Choose your type of material for delivery service.")
                
            case 1:
                self.arrRequestType.replaceObject(at:3, with: "Choose your type of material for hauling service.")

            case 2:
                self.arrRequestType.replaceObject(at: 3, with: "Choose your type of service needed.")

            case -1:
                self.arrRequestType.replaceObject(at: 3, with: "")

            default:
                self.arrRequestType.replaceObject(at: 3, with: "")
            }
            
            self.collectionViewJobType.reloadData()
        }
    }

    @IBAction func ActionBack(_ sender: Any)
    {
        let sModel = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
        sModel.selectedJobIndex = -1
        sModel.selectedServiceType = ""
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func OnTabNext(_ sender:UIButton)
    {
        if(self.selectedIndex >= 0)
        {
            if(self.arrRequestType.object(at: self.selectedIndex) as!String == "SERVICES")
            {
                 let serviceVC = ServicesVC.init(nibName: "ServicesVC", bundle: nil)
                self.navigationController?.pushViewController(serviceVC, animated: true)
            }
           else if(self.arrRequestType.object(at: self.selectedIndex) as!String == "HAULING")
            {
                let haulingVC = HaulingMaterialVC.init(nibName: "HaulingMaterialVC", bundle: nil)
                    haulingVC.selected_Date =  selected_Date
                    haulingVC.delivery_type = delivery_type
                    haulingVC.later_start = later_start
                    haulingVC.later_end = later_end
                    haulingVC.pickedCordinates = self.pickedCordinates
                    haulingVC.selectedServiceType = self.selectedServiceType
                
                let sModel = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
                sModel.selectedServiceType = self.selectedServiceType
                sModel.selectedJobIndex = self.selectedIndex
                Constant.MyVariables.appDelegate.saveTrucCartData()
                
                self.navigationController?.pushViewController(haulingVC, animated: true)
            }
            else
            {
                let chooseMaterial = ChooseMaterialsVC.init(nibName: "ChooseMaterialsVC", bundle: nil)
                    chooseMaterial.selected_Date =  selected_Date
                    chooseMaterial.delivery_type = delivery_type
                    chooseMaterial.later_start = later_start
                    chooseMaterial.later_end = later_end
                    chooseMaterial.pickedCordinates = self.pickedCordinates
                    chooseMaterial.selectedServiceType = self.selectedServiceType
                
                let sModel = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
                sModel.selectedServiceType = self.selectedServiceType
                sModel.selectedJobIndex = self.selectedIndex
                Constant.MyVariables.appDelegate.saveTrucCartData()
                
                self.navigationController?.pushViewController(chooseMaterial, animated: true)
            }
        }
        else
        {
         self.showAlert("Please choose request time.")
        }
    }
    
}
//MARK:- CollectionView Delegate and Data Source Methods

extension JobRequestVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.arrRoomsData.count
        return self.arrRequestType.count
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobRequestCell", for: indexPath) as! JobRequestCell
        
        
        cell.lblName.text = self.arrRequestType[indexPath.row] as? String
//        cell.imageView.image = UIImage.init(named: self.arrRequestType[indexPath.row] as! String)
        cell.imageView.image = UIImage.init(named: self.arrRequestType[1] as? String ?? "")// client shoud be want to be same image in both three images (HAULING)   08/01/2019
        
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
        
        if(indexPath.row == 3)
        {
            cell.lblName.alpha = 0
            cell.imageView.alpha = 0
            cell.lblDesc.text = self.arrRequestType[indexPath.row] as? String
            cell.lblDesc.alpha = 1
        }
        else
        {
            
            cell.lblName.alpha = 1
            cell.imageView.alpha = 1
            cell.lblDesc.alpha = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
        case 0:
            self.selectedIndex = indexPath.row
            self.arrRequestType.replaceObject(at: 3, with: "Choose your type of material for delivery service.")
            self.selectedServiceType = self.arrRequestType[indexPath.row] as? String ?? ""
            break;
        case 1:
//            self.view.makeToast("Under development", duration: 1.0, position: .center)
//            return
            self.selectedIndex = indexPath.row
            self.arrRequestType.replaceObject(at:3, with: "Choose your type of material for hauling service.")
            self.selectedServiceType = self.arrRequestType[indexPath.row] as? String ?? ""
            break;
        case 2:
            self.selectedIndex = indexPath.row
            self.arrRequestType.replaceObject(at: 3, with: "Choose your type of service needed.")
            self.selectedServiceType = self.arrRequestType[indexPath.row] as? String ?? ""
            break;
        case 3:
            break;
        default:
            self.arrRequestType.replaceObject(at: 3, with: "")
        }
        
        let sModel = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
        sModel.selectedServiceType = self.selectedServiceType
        sModel.selectedJobIndex = self.selectedIndex
        Constant.MyVariables.appDelegate.saveTrucCartData()

        
        self.collectionViewJobType.reloadData()
        
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return JobRequestCellHeight.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: JobRequestCellHeight.cellSpacing, left: JobRequestCellHeight.cellSpacing, bottom: 0, right: JobRequestCellHeight.cellSpacing)
    }
    
    
}

