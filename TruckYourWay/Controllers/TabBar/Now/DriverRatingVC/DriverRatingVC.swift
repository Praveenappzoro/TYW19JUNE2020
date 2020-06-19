//
//  DriverRatingVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/20/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import Cosmos

class DriverRatingVC: UIViewController {

    @IBOutlet weak var collectionViewRating: UICollectionView!
    
    @IBOutlet weak var pageControlOtlt: UIPageControl!
    
    var view1Cos = CosmosView()
    var view2Cos = CosmosView()
    var textFeedBack = UITextView()
    
    var payloadDict: NSMutableDictionary = [:]
//    var dictBillDetails: NSMutableDictionary = [:]
    var loginUserData:LoggedInUser!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var nibName = UINib(nibName: "RatingCell1", bundle:nil)
        
        self.collectionViewRating.register(nibName, forCellWithReuseIdentifier: "RatingCell1")
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        // Do any additional setup after loading the view.
    }

    @objc func OnTabNext(_ sender:UIButton)
    {
        let indexPath = IndexPath(row: sender.tag+1, section: 0)
        self.collectionViewRating.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.pageControlOtlt.currentPage = sender.tag+1
        
    }
    
    @objc func OnTabSkip(_ sender:UIButton)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func OnTabSend(_ sender:UIButton)
    {
        self.giveRateDriverApi()
    }
    
    
    //MARK:- get Info for bill
    
    func giveRateDriverApi()
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
        let rating = String(self.view2Cos.rating as? Double ?? 0)
        let driver_Id = self.payloadDict.value(forKey: "driver_id") as? String ?? ""
        let bill_No = self.payloadDict.value(forKey: "bill_no") as? String ?? ""
        let trackingId = self.payloadDict.value(forKey: "tracking_id") as? String ?? ""

        let params = [
            "bill_no":bill_No,
            "driver_id":driver_Id,
            "ratings":rating,
            "feedback":self.textFeedBack.text ?? "",
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            "tracking_id": trackingId
            ] as [String : Any]
        
        self.startAnimating("")
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_RATE_DRIVER, .post, params) { (result, data, json, error, msg) in
            
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
                    Constant.MyVariables.appDelegate.clearNotifications()
                    var isOnTracking: Bool = false
                    for controller in self.navigationController!.viewControllers {
                        if controller is TrackDriverVC {
                            isOnTracking = true
                            break
                        }
                    }
                    if isOnTracking { self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                break
            }
            
        }
    }

}
//MARK:- CollectionView Delegate and Data Source Methods

extension DriverRatingVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 3
        }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingCell1", for: indexPath) as! RatingCell1
        
       
        if(indexPath.row == 0)
        {
            cell.viewPage1.alpha = 1
            cell.viewPage2.alpha = 0
            cell.viewPage3.alpha = 0
            cell.btnNextPage1.tag = indexPath.row
            cell.ratingViewPage1.rating = 0
            
            self.view1Cos = cell.ratingViewPage1
            self.view1Cos.rating = cell.ratingViewPage1.rating
            
            cell.btnNextPage1.addTarget(self, action: #selector(self.OnTabNext(_:)), for: .touchUpInside)
        }
        else if(indexPath.row == 1)
        {
            cell.viewPage1.alpha = 0
            cell.viewPage2.alpha = 1
            cell.viewPage3.alpha = 0
            cell.btnNextPage2.tag = indexPath.row
            cell.ratingViewPage2.rating = 0
            self.view2Cos = cell.ratingViewPage2
            self.view2Cos.rating = cell.ratingViewPage2.rating
            
            cell.btnNextPage2.addTarget(self, action: #selector(self.OnTabNext(_:)), for: .touchUpInside)
        }
        else
        {
            cell.viewPage1.alpha = 0
            cell.viewPage2.alpha = 0
            cell.viewPage3.alpha = 1
            self.textFeedBack = cell.textView
            self.textFeedBack.text = cell.textView.text
            cell.btnBackPage3.addTarget(self, action: #selector(self.OnTabSkip(_:)), for: .touchUpInside)
            cell.btnNextPage3.addTarget(self, action: #selector(self.OnTabSend(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
       
        }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row == 0)
        {
            return CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-50)
        }
        else if(indexPath.row == 1)
        {
            return CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height < 500 ? 550 : UIScreen.main.bounds.size.height-50)
        }
        else
        {
            return CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height < 550 ? 600 : UIScreen.main.bounds.size.height-50)
        }
            
    }
    
    
}
