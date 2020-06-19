//
//  HistoryVC.swift
//  TruckYourWay
//
//  Created by Samradh Agarwal on 04/09/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var noHistory: UILabel!
    @IBOutlet weak var lblHistoryVCTitle: UILabel!
    
    var arrHistoryJobs: NSMutableArray = []
    let dateFormatterPrint = DateFormatter()
    var loginUserData:LoggedInUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initData()
        self.tblView.register(UINib(nibName: "CurrentJobsCell", bundle: nil), forCellReuseIdentifier: "CurrentJobsCell")
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initData()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false

        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")

        self.getHistory()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ActionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func initData()
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
        
        if(self.loginUserData.type == "service")
        {
            self.lblHistoryVCTitle.text = "    JOB HISTORY"
            self.noHistory.text = "No Records Found"
        }
        else
        {
            self.lblHistoryVCTitle.text = "    COMPLETED JOB(S)"
            self.noHistory.text = "No Records Found"
        }
    }
    
    func getHistory()
    {
        
        
        let parametersUser = [
            "user_id":self.loginUserData.user_id ?? "",
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
       
        let parametersDriver = [
            "driver_id":self.loginUserData.user_id ?? "",
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
        
        self.startAnimating("")
        let path = self.loginUserData.type == "service" ? BSE_URL_GET_DRIVER_HISTORY_MONTHS : BSE_URL_GET_CONSUMER_HISTORY_MONTHS
        APIManager.sharedInstance.getArrayDataFromAPI(path, .post, self.loginUserData.type == "service" ? parametersDriver : parametersUser, { (result, data, json, error, msg) in
            
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
                    
                    let jsonResponse = json?["results"] as! NSArray
                    let total = jsonResponse.count
                    
                    if(total>0)
                    {
                        self.noHistory.alpha = 0
                        let arr = jsonResponse
                        let arrMutable = arr.mutableCopy() as! NSMutableArray
                        
                       let ar = arrMutable.filter({ (param) -> Bool in
                            let dict = param as! NSDictionary
                            return dict.value(forKey: "jobs") as! Int  > 0 ? true : false
                       }) as! NSArray
                        
                        let mutableArr = ar.mutableCopy() as! NSMutableArray
                        self.arrHistoryJobs = mutableArr.mutableCopy() as! NSMutableArray
                        
                        if(self.arrHistoryJobs.count > 0)
                        {
                            self.noHistory.alpha = 0
                        }
                        else
                        {
                          self.noHistory.alpha = 1
                        }
                        
                        self.tblView.reloadData()
                    }
                    else
                    {
                        self.noHistory.alpha = 1
                    }
                })
            }
            
        })
        
    }
    
    
    
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource
{
    //Mark:- TableView Delegate and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrHistoryJobs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentJobsCell", for: indexPath) as! CurrentJobsCell
        
        let dict = self.arrHistoryJobs.object(at: indexPath.row) as! NSDictionary
//        let dictDetails = dict.value(forKey: "month") as! NSDictionary
        

        let strType = dict.value(forKey: "jobs") as? Int
        
        var strTypeWithSpace : String = ""
        
        if(strType! > 1 )
        {
            strTypeWithSpace = "\(strType ?? 0)\(" job(s)")"
        }
        else
        {
           strTypeWithSpace = "\(strType ?? 0)\(" job")"
        }
        cell.lblTime.text = dict.value(forKey: "month") as? String
        cell.lbl_BillId.attributedText = self.attributeDtailsBold(strBold: strTypeWithSpace, strNormal: "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let dict = self.arrHistoryJobs.object(at: indexPath.row) as! NSDictionary
        
        guard let strMonth = dict.value(forKey: "month") as? String else{
            return
        }
        guard let numberOfJobs = dict.value(forKey: "jobs") as? Int else{
            return
        }
        
        let totalJobs = numberOfJobs as! Int
        
        if(totalJobs < 1)
        {
            return
        }
        let historySelected = HistorySelectedMonthVC.init(nibName:"HistorySelectedMonthVC" , bundle: nil)
        
        historySelected.selectedMonth = strMonth
        
        self.navigationController?.pushViewController(historySelected, animated: true)
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
}
