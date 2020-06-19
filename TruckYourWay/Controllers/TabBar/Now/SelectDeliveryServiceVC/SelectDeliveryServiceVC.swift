//
//  SelectDeliveryServiceVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/12/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class SelectDeliveryServiceVC: UIViewController {

    var selectedIndex: Int = -1
    
    
    @IBOutlet weak var collectionViewDeliveryService: UICollectionView!
    var pickedCordinates : NSMutableDictionary = [:]
    
    var dictLoadMatrials : NSMutableDictionary = [:]
//    var arrLoadMatrials: NSMutableArray = []
    var selectedServiceType: String = ""
    var loginUserData:LoggedInUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var nibName = UINib(nibName: "SelectDeliveryServiceCell", bundle:nil)
        
        self.collectionViewDeliveryService.register(nibName, forCellWithReuseIdentifier: "SelectDeliveryServiceCell")
        
        self.collectionViewDeliveryService.register(UINib(nibName:"NextCell", bundle: Bundle.main),
                                      forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                                      withReuseIdentifier:"NextCell")
        
        
        self.apiLoadMaterials()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
    }
    @IBAction func ActionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
     @objc func OnTabNext(_ sender:UIButton)
    {
        
//        let dictSelectedMaterial = self.arrLoadMatrials.object(at: self.selectedIndex) as! NSDictionary
//
//        let chooseMaterial = ChooseMaterialsVC.init(nibName: "ChooseMaterialsVC", bundle: nil)
//            chooseMaterial.pickedCordinates = self.pickedCordinates
//            chooseMaterial.selectedMaterialType = dictSelectedMaterial.mutableCopy() as! NSMutableDictionary
//            chooseMaterial.selectedServiceType = self.selectedServiceType
//        self.navigationController?.pushViewController(chooseMaterial, animated: true)
    }
    
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
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_LOAD_MATERIALS, .post, parameters, { (result, data, json, error, msg) in
            
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
                    
                    let total = json?.count ?? 0
                    if(total > 0)
                    {
                        let dict = json as! NSDictionary
                        self.dictLoadMatrials = dict.mutableCopy() as! NSMutableDictionary
                        self.collectionViewDeliveryService.reloadData()
                    }
                })
            }
            
        })
 }
    
}
//MARK:- CollectionView Delegate and Data Source Methods

extension SelectDeliveryServiceVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.dictLoadMatrials.count
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
        
        let keyName = (self.dictLoadMatrials.allValues)[indexPath.section]
        let arr = (self.dictLoadMatrials.allValues)[indexPath.section] as! NSArray
        let dict = arr.object(at: indexPath.row) as! NSDictionary
        
        let imgURL = dict.value(forKey: "material_image") as! String
        cell.lblTitle.text = (dict.value(forKey: "category") as? String)?.uppercased()
        
        cell.imgView.loadImageAsync(with: BSE_URL_LoadMedia+imgURL, defaultImage: "", size: cell.imgView.frame.size)
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
        
        
        switch indexPath.row {
        case 0:
            self.selectedIndex = indexPath.row
            break;
        case 1:
            self.selectedIndex = indexPath.row
            break;
        case 2:
            self.selectedIndex = indexPath.row
            break;
        case 3:
            break;
        default: break
        }
        
        self.collectionViewDeliveryService.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (((self.view.frame.size.width - 20)/2)-40), height: (((self.view.frame.size.width - 20)/2)-20))//JobRequestCellHeight.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
}

}
