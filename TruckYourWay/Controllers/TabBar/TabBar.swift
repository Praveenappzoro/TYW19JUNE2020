//
//  TabBar.swift
//  TruckYourWay
//
//  Created by Samradh Agarwal on 04/09/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class TabBar: UITabBarController,UITabBarControllerDelegate {

    let account = EditVC()
    let chooseLocationVC = NowVC()
    let later = LaterVC()
    let history = HistoryVC()
    let logout = LogoutVC()
    let acceptingJob = AcceptingJobVC()
    
    var loginUserData:LoggedInUser!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        if #available(iOS 13.0, *) {
//            self.tabBar.items?[2].imageInsets = .zero
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.initTabs()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        if(self.loginUserData.type == "service")
        {
            self.CheckStatusOfJobs(selectedTab: 2)
            
        } else {
            self.CheckStatusOfJobsCunsumerSide(selectedTab: 2)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController:  UIViewController) -> Bool {
       
        if(viewController.childViewControllers[0].nibName == "LogoutVC")
        {
            
            let alert = UIAlertController(title: title, message: "Are you sure you want to Logout?", preferredStyle: .actionSheet)
            
            let OKAction = UIAlertAction(title: "Yes", style: .default) { (action) in
               
                self.dismiss(animated: true, completion:nil)
                print("Logout successfully")
                if(self.loginUserData.type == "service")
                {
                   self.APIForUpdateJobAccepting()
                }
                else
                {
                    self.callApiLogout()
                }
//                USER_DEFAULT.set(nil, forKey: "userData")
//                AppDelegateVariable.appDelegate.isLogin(isLogin:false)
            }
            let CancelAction = UIAlertAction(title: "No", style: .default) { (action) in
               print("Cancel")
            }
            alert.addAction(OKAction)
            alert.addAction(CancelAction)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if(viewController.childViewControllers.count >= 1 && tabBarController.selectedIndex == 1)
        {
            if(viewController.childViewControllers.last?.nibName == "TrackDriverVC")
            {
                return true
            }
            if((viewController.childViewControllers.count) > 1 && viewController.childViewControllers[0].nibName == "NowVC" )
                {
                    return false
                }
        }
       
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if(self.loginUserData.type == "service")
        {
            self.CheckStatusOfJobs(selectedTab: 2)

        } else {
            self.CheckStatusOfJobsCunsumerSide(selectedTab: 2)

        }
    }
      func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool)
     {
        
     }
   
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
       
    }
    
    func initTabs()
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
    //        UITabBar.appearance().barTintColor = UIColor.orange
            UITabBar.appearance().tintColor = themeColorOrange
           
            
            
            if(self.loginUserData.type == "service")
            {
                account.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
                account.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "account_gray_Tab"), tag: 0)
                if SYSTEM_VERSION_LESS_THAN(version: "13") {
                account.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
                } else {
                  account.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
                }

                acceptingJob.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
                acceptingJob.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "now_Tab"), tag: 1)
                if SYSTEM_VERSION_LESS_THAN(version: "13") {
                acceptingJob.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
                }
                
                later.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
                later.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "later_Tab"), tag: 2)
    //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
    //                self.later.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "CheckDocuments")?.withRenderingMode(.alwaysOriginal), tag: 2)
    //
    //            }
                if SYSTEM_VERSION_LESS_THAN(version: "13") {
                later.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
                }
                
                history.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 3)
                history.title = "History"
                history.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "history_Tab"), tag: 3)
                if SYSTEM_VERSION_LESS_THAN(version: "13") {
                history.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
                }
                
                logout.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 4)
                logout.title = "Logout"
                logout.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "logout_Tab"), tag: 4)
                if SYSTEM_VERSION_LESS_THAN(version: "13") {
                 logout.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
                } else {
                    logout.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
                }
                
                let allVC = [account,acceptingJob,later,history,logout]
                self.viewControllers = allVC
                self.viewControllers = allVC.map { UINavigationController(rootViewController: $0)}
                
            }
            else
            {
    //            Order change to =>Truck Cart.
    //            #13 Current text change to=>Now/Later Jobs.
    //            #14 History change to=> Completed Jobs.
                
                account.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
                account.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "account_gray_Tab"), tag: 0)
                if SYSTEM_VERSION_LESS_THAN(version: "13") {
                    account.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
                } else {
                  account.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
                }
                
                account.navigationController?.navigationBar.isHidden = true
                
                chooseLocationVC.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
                chooseLocationVC.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "truck_cart_Tab"), tag: 1)
                if SYSTEM_VERSION_LESS_THAN(version: "13") {
                chooseLocationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
                }
                chooseLocationVC.navigationController?.navigationBar.isHidden = true

                later.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "now_later-jobs_Tab"), tag: 2)
               if SYSTEM_VERSION_LESS_THAN(version: "13") {
                later.tabBarItem.imageInsets = UIEdgeInsets(top:7, left: 0, bottom: -7, right: 0)
                }
                later.navigationController?.navigationBar.isHidden = true
                
                history.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 3)
                history.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "completed_jobs_Tab"), tag: 3)
                if SYSTEM_VERSION_LESS_THAN(version: "13") {
                history.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
                }
                history.navigationController?.navigationBar.isHidden = true
                
                logout.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 4)
                logout.title = "Logout"
                logout.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "logout_Tab"), tag: 4)
                if SYSTEM_VERSION_LESS_THAN(version: "13") {
                logout.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
                } else {
                    logout.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
                }
                logout.navigationController?.navigationBar.isHidden = true
                
                let allVC = [account,chooseLocationVC,later,history,logout]
                self.viewControllers = allVC
                self.viewControllers = allVC.map { UINavigationController(rootViewController: $0)}
            }
            
            
            
            
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
            leftSwipe.direction = .left
            rightSwipe.direction = .right
            
            view.addGestureRecognizer(leftSwipe)
            view.addGestureRecognizer(rightSwipe)
        
        }
    
    func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedSame
    }

    func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedDescending
    }

    func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedAscending
    }

    func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedAscending
    }

    func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedDescending
    }
    
    func APIForUpdateJobAccepting()
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
        
        self.startAnimating("")
        
        let parameters = [
            "user_id":self.loginUserData.user_id!,
            "status":"0",//isAccepting == true ? "1" : "0",
            "access_token":self.loginUserData.access_token!,
            "refresh_token": self.loginUserData.refresh_token!
            ] as! NSDictionary
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_ACCEPTING_JOBS, .post, parameters as? [String : Any]) { (result, data, json, error, msg) in
            
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
                    
                    self.callApiLogout()
                })
                break
            }
            
        }
    }
    
    func callApiLogout()
    {
        
        let parameters = [
            "user_id":self.loginUserData.user_id!,
            "access_token":self.loginUserData.access_token,
            "refresh_token":self.loginUserData.refresh_token,
            ] as! NSDictionary
        
        self.startAnimating("")
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_Logout, .post, parameters as? [String : Any]) { (result, data, json, error, msg) in
            
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
//                    USER_DEFAULT.set(nil, forKey: "userData")
                    
                    guard let prefEmail = USER_DEFAULT.value(forKey: rememberMe_Email) else { return  }
                    let email = prefEmail as? String ?? ""
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                    USER_DEFAULT.set(email, forKey: rememberMe_Email)
                    
                    
                    AppDelegateVariable.appDelegate.isLogin(isLogin:false)
                    Constant.MyVariables.appDelegate.truckCartModel = nil
                    
                })
                break
            }
            
        }
    }
    func CheckStatusOfJobs(selectedTab : Int)
    {
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        let parameters = [
            "device_token":self.loginUserData.device_token ?? "",
            "access_token":self.loginUserData.access_token,
            "refresh_token":self.loginUserData.refresh_token,
            "user_id": self.loginUserData.user_id ?? ""
            ] as! NSDictionary
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_get_later_jobs, .post, parameters as? [String : Any]) { (result, data, json, error, msg) in
            
            switch result
            {
            case .Failure:
                break
            case .Success:
                DispatchQueue.main.async(execute: {
                    let results = json?["results"] as! NSArray
                    if results.count > 0 {
                        var isGreenOn = false
                        for item in results {
                            if let dateLater = ((item as! NSDictionary)["bill_details"]as! NSDictionary)["later_start"] as? String  {
                                
                                let formator = DateFormatter()
                                formator.dateFormat = "dd MM yyyy"
                                formator.locale = Locale(identifier: "en_US_POSIX")
                                if let zone = TimeZone(abbreviation: "GMT-4") {
                                    formator.timeZone = zone
                                }

                                let dateis = formator.string(from: Date())
                                
                                let dateLaterIsDate = Date(timeIntervalSince1970: TimeInterval( Double(dateLater) ?? 0) )
                                let dateLateros = formator.string(from: dateLaterIsDate)
                                if dateis == dateLateros {
                                    isGreenOn = true
                                }
                                
                            }
                        }
                            if isGreenOn {
                                    //later_green
                                    self.later.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "later_green")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), tag: 2)
                                if self.SYSTEM_VERSION_LESS_THAN(version: "13") {
                                    self.later.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
                                }
                                    
                            } else {
                                self.later.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "later_Tab"), tag: 2)
                                if self.SYSTEM_VERSION_LESS_THAN(version: "13") {
                                self.later.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
                                }
                            }
                            
                    } else {
                        self.later.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "later_Tab"), tag: 2)
                        if self.SYSTEM_VERSION_LESS_THAN(version: "13") {
                        self.later.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
                        }
                    }
                })
                break
            }
            
        }
    }
    
    func CheckStatusOfJobsCunsumerSide(selectedTab : Int)
    {
        
        let parameters = [
            "type": "current",
            "user_id" : self.loginUserData.user_id ?? "",
            "device_token":self.loginUserData.device_token ?? "",
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            ] as NSDictionary
        
        APIManager.sharedInstance.getDataFromAPI(BSE_get_consumer_jobs, .post, parameters as? [String : Any]) { (result, data, json, error, msg) in
            
            switch result
            {
            case .Failure:
                break
            case .Success:
                DispatchQueue.main.async(execute: {
                    let results = json?["results"] as! NSArray
                    if results.count > 0 {
                        for item in results {
                            if ((item as! NSDictionary)["bill_details"]as! NSDictionary)["later_status"] as? String == "pending" {
                                let laterStart = ((item as! NSDictionary)["bill_details"]as! NSDictionary)["later_start"] as! String
                                let formator = DateFormatter()
                                formator.dateFormat = "dd MM yyyy"
//                                formator.locale = Locale(identifier: "en_US_POSIX")

                                let dateis = formator.string(from: Date())
                                let date = formator.date(from: dateis)
                                let dateAtMidnight = Date() //calendar.startOfDay(for: Date())
                                let diffrent = (Double(laterStart) ?? 0) - dateAtMidnight.timeIntervalSince1970
                                if diffrent > 0 && diffrent < 86400 {
                                        //later_green
                                            //now_later-jobs_Tab
                                            self.later.tabBarItem =  UITabBarItem(title: "", image: UIImage.init(named: "now_later-jobs_Tab-1")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), tag: 2)
                                            self.later.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
                                            break
                                } else {
                                        self.later.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "now_later-jobs_Tab"), tag: 2)
                                    if self.SYSTEM_VERSION_LESS_THAN(version: "13") {
                                        self.later.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
                                    }
                                    
                                }
                                
                            } else {
                                self.later.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "now_later-jobs_Tab"), tag: 2)
                                if self.SYSTEM_VERSION_LESS_THAN(version: "13") {
                                self.later.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
                                }
                            }
                        }
                    } else {
                        self.later.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "now_later-jobs_Tab"), tag: 2)
                        if self.SYSTEM_VERSION_LESS_THAN(version: "13") {
                        self.later.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
                        }
                    }
                })
                break
            }
            
        }
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
//        print(sender.direction);
//        if sender.direction == .left {
//            if (self.tabBarController?.selectedIndex)! < 2 { // set your total tabs here
//                self.tabBarController?.selectedIndex += 1
//            }
//        } else if sender.direction == .right {
//            if (self.tabBarController?.selectedIndex)! > 0 {
//                self.tabBarController?.selectedIndex -= 1
//            }
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
