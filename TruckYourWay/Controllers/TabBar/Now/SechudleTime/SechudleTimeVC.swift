//
//  SechudleTimeVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/10/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import DropDown

class SechudleTimeVC: UIViewController {

    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    // Later Ride choose design
    @IBOutlet weak var viewRideLater: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var scrollViewMain: UIScrollView!

    @IBOutlet weak var calenderView: CKCalendarView!
    
    @IBOutlet weak var viewTimeButtonsShow: UIView!

    @IBOutlet weak var btnSelectedDateOtlt: CustomButton!
    
    @IBOutlet weak var btnStartTimeOtlt: CustomButton!
    
    
    let dropDown = DropDown()
    
    var selectedButtonIndex : Int = 0
    
    var selected_Date: String = ""
    var selected_Date_From_Calender: Date = Date()
    var delivery_type: String = ""
    var later_start: Int = 0
    var later_end: Int = 0
    
    var pickedCordinates : NSMutableDictionary = [:]

    var arrayTimeAvaliable: NSMutableArray = ["8 AM-10 AM", "10 AM-12 PM", "12 PM-2 PM" , "2 PM-4 PM"]
    var dateFormatter = DateFormatter()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

       
        self.navigationController?.navigationBar.isHidden = true
       
        self.calenderView.delegate = self
        self.btnStartTimeOtlt.setTitle((self.arrayTimeAvaliable.object(at: 0) as! String), for: .normal)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
        self.btnSelectedDateOtlt.setTitle(dateFormatterPrint.string(from: Date()) , for: .normal)
        
        dateFormatter.dateFormat = "H:mm a"
        
        self.viewTimeButtonsShow.layer.cornerRadius = 25
        self.viewTimeButtonsShow.layer.borderColor = UIColor.init(red: 206.0/255.0, green: 114.0/255.0, blue: 54.0/255.0, alpha: 1.0).cgColor
        self.viewTimeButtonsShow.layer.borderWidth = 2
        self.viewTimeButtonsShow.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeUIOnPopToRoot), name: NSNotification.Name(rawValue: "MoveToNowLater"), object: nil)
        // Do any additional setup after loading the view.
        
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.viewRideLater.alpha = 0
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        self.checkAndChangeUI()
        
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
        
        sModel.selected_Date = selected_Date
        sModel.later_start = self.later_start
        sModel.later_end = self.later_end
        sModel.pickedCordinates = self.pickedCordinates
        
        USER_DEFAULT.set(AppState.TruckScheduleTime.rawValue, forKey: APP_STATE_KEY)
        Constant.MyVariables.appDelegate.saveTrucCartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.translatesAutoresizingMaskIntoConstraints = true
        if Constant.MyVariables.appDelegate.truckCartModel != nil {
            let model = Constant.MyVariables.appDelegate.truckCartModel!
            self.selected_Date = model.selected_Date
            self.later_start = model.later_start
            self.later_end = model.later_end
            self.pickedCordinates = model.pickedCordinates
            
            if model.delivery_type == "later" {
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd MMMM yyyy"
                let date = dateFormatterPrint.date(from: model.selected_Date)
                self.calenderView.select(date, makeVisible: true)
                
                dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
                let strDate = dateFormatterPrint.string(from: date ?? Date())
                self.btnSelectedDateOtlt.setTitle(strDate, for: .normal)
                UIView.transition(with: self.viewRideLater, duration: 0.5, options: .allowUserInteraction, animations: {
                    self.viewRideLater.alpha = 1
                }, completion: nil)
                self.checkAndChangeUI()
            }
           
        }
    }

    @objc func changeUIOnPopToRoot()
    {
        UIView.transition(with: self.viewRideLater, duration:  0.5, options: .allowUserInteraction, animations: {
            self.viewRideLater.alpha = 0
        }, completion: nil)
        self.checkAndChangeUI()
    }
    
    @IBAction func actionMoveToNow(_ sender: Any)
    {
        UIView.transition(with: self.viewRideLater, duration:  0.5, options: .allowUserInteraction, animations: {
            self.viewRideLater.alpha = 0
        }, completion: { (status) in
            self.checkAndChangeUI()
        })
    }
    
    @IBAction func ActionOnNow(_ sender: Any)
    {
//        let sechudleVC = NowVC.init(nibName: "NowVC", bundle: nil)
//        let dateFormat = DateFormatter.init()
//            dateFormat.dateFormat = "dd MMMM YYYY"
//        let strCurrent = dateFormat.string(from: Date())
//            sechudleVC.selected_Date =  strCurrent
//            sechudleVC.delivery_type = "now"
//            sechudleVC.later_start = 0
//            sechudleVC.later_end = 0
//            sechudleVC.pickedCordinates = self.dictLoc.mutableCopy() as! NSMutableDictionary
//        self.navigationController?.pushViewController(sechudleVC, animated: true)
        
        let sechudleVC = JobRequestVC.init(nibName: "JobRequestVC", bundle: nil)
            let dateFormat = DateFormatter.init()
                dateFormat.dateFormat = "dd MMMM YYYY"
//        if let zone = TimeZone(abbreviation: "GMT-4") {
//            dateFormat.timeZone = zone
//        }
            let strCurrent = dateFormat.string(from: Date())
                sechudleVC.selected_Date =  strCurrent
                sechudleVC.delivery_type = "now"
                sechudleVC.later_start = 0
                sechudleVC.later_end = 0
            sechudleVC.pickedCordinates = self.pickedCordinates
        
        
        let sModel = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
        
        sModel.selected_Date = strCurrent
        sModel.later_start = self.later_start
        sModel.later_end = self.later_end
        sModel.pickedCordinates = self.pickedCordinates
        sModel.delivery_type = "now"
        Constant.MyVariables.appDelegate.saveTrucCartData()

        self.navigationController?.pushViewController(sechudleVC, animated: true)
    }
    
    
    @IBAction func ActionOnLater(_ sender: Any)
    {
      
      self.showCustomAlertWith(message: "LATER Service Coming Soon!", actions: nil, isSupportHiddedn: true)
      
      return
      
      
        let Start = self.callConvertTime(strTime:8)
        let end = self.callConvertTime(strTime: 10)

        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "dd MMMM YYYY  hh:mm:ss a"
//        if let zone = TimeZone(abbreviation: "GMT-4") {
//            dateFormatter.timeZone = zone
//        }
        self.later_start = self.currentTimeInMiliseconds(selectedDate:Start)
        self.later_end = self.currentTimeInMiliseconds(selectedDate:end)

        UIView.transition(with: self.viewRideLater, duration: 0.5, options: [], animations: {
            self.calenderView.select(Date(), makeVisible: true)
            self.viewRideLater.alpha = 1
        }, completion: { (status) in
            self.checkAndChangeUI()
        })
        
    }
    
    // #MARK:- add Action for Back Screen
    
    @IBAction func actionBack(_ sender: Any)
    {
        
        let sModel = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
        
        sModel.later_start = 0
        sModel.later_end = 0
        sModel.selected_Date = ""
        
        Constant.MyVariables.appDelegate.saveTrucCartData()
        
        self.navigationController?.popViewController(animated: true)
    }
    // #MARK:- add Action for Later
    
    @IBAction func actionChooseStartTime(_ sender: Any)
    {
        dropDown.anchorView = self.btnStartTimeOtlt
        
        dropDown.direction = .top
        dropDown.bottomOffset = CGPoint (x: 0, y:self.btnStartTimeOtlt.frame.size.height)
        dropDown.width = self.btnStartTimeOtlt.frame.size.width
        dropDown.dataSource = self.arrayTimeAvaliable as! [String]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.convertDateFromTime(selectedString:item)
            self.btnStartTimeOtlt.setTitle(item, for: .normal)
        }
        dropDown.show()
        
    }
    
    @IBAction func actionNextOnLater(_ sender: Any)
    {
        
        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = "dd MMMM YYYY"
//        if let zone = TimeZone(abbreviation: "GMT-4") {
//            dateFormat.timeZone = zone
//        }
        let strCurrent = dateFormat.string(from: self.selected_Date_From_Calender)
        let strToday = dateFormat.string(from:  Date())
        
        if(strCurrent == strToday)
        {
            showAlert("You can not post Later job for current date.")
            return
        }
        
        let sechudleVC = JobRequestVC.init(nibName: "JobRequestVC", bundle: nil)
       
        sechudleVC.selected_Date =  strCurrent
        sechudleVC.delivery_type = "later"
        sechudleVC.later_start = self.later_start
        sechudleVC.later_end = self.later_end
        sechudleVC.pickedCordinates = self.pickedCordinates

        let sModel = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
        
        sModel.selected_Date = strCurrent
        sModel.later_start = self.later_start
        sModel.later_end = self.later_end
        sModel.pickedCordinates = self.pickedCordinates
        sModel.delivery_type = "later"
        Constant.MyVariables.appDelegate.saveTrucCartData()

        self.navigationController?.pushViewController(sechudleVC, animated: true)
    }
    
    func currentTimeInMiliseconds(selectedDate: Date) -> Int! {
        let nowDouble = selectedDate.timeIntervalSince1970
        return Int(nowDouble)
    }
    
    func dateFromMilliseconds(selectedTimeStamp:Int) -> Date {
        let date : NSDate! = NSDate(timeIntervalSince1970:Double(selectedTimeStamp))
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "dd MMMM YYYY  hh:mm:ss a"
//        dateFormatter.timeZone = TimeZone.current
//        if let zone = TimeZone(abbreviation: "GMT-4") {
//            dateFormatter.timeZone = zone
//        }
        let timeStamp = dateFormatter.string(from: date as Date)
        return dateFormatter.date( from: timeStamp )!
    }
    func convertDateFromTime(selectedString:String)
    {
        switch selectedString {
        case "8 AM-10 AM":
            
           let Start = self.callConvertTime(strTime:8)
           let end = self.callConvertTime(strTime: 10)
          
           let dateFormatter = DateFormatter.init()
           dateFormatter.dateFormat = "dd MMMM YYYY  hh:mm:ss a"
           
           self.later_start = self.currentTimeInMiliseconds(selectedDate:Start)
           self.later_end = self.currentTimeInMiliseconds(selectedDate:end)
           
            break
        case "10 AM-12 PM":
            let Start = self.callConvertTime(strTime:10)
            let end = self.callConvertTime(strTime: 12)
            
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "dd MMMM YYYY  hh:mm:ss a"
            
            self.later_start = self.currentTimeInMiliseconds(selectedDate:Start)
            self.later_end = self.currentTimeInMiliseconds(selectedDate:end)
            break
        case "12 PM-2 PM":
            let Start = self.callConvertTime(strTime:12)
            let end = self.callConvertTime(strTime: 14)
            
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "dd MMMM YYYY  hh:mm:ss a"
            
            self.later_start = self.currentTimeInMiliseconds(selectedDate:Start)
            self.later_end = self.currentTimeInMiliseconds(selectedDate:end)
            break
        case "2 PM-4 PM":
            
            let Start = self.callConvertTime(strTime:14)
            let end = self.callConvertTime(strTime: 16)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM YYYY  hh:mm:ss a"
            
            self.later_start = self.currentTimeInMiliseconds(selectedDate:Start)
            self.later_end = self.currentTimeInMiliseconds(selectedDate:end)
            break
        default:
            print("default")
        }
    }
    
    func callConvertTime(strTime:Int) -> Date
    {
        var calendar = NSCalendar.current
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: self.selected_Date_From_Calender)
        dateComponents.month = calendar.component(.month, from: self.selected_Date_From_Calender)
        dateComponents.day = calendar.component(.day, from: self.selected_Date_From_Calender)
        dateComponents.hour = strTime
        dateComponents.minute = 0
        dateComponents.second = 0
//        calendar.timeZone = NSTimeZone(abbreviation: "GMT-4")! as TimeZone //OR NSTimeZone.localTimeZone()

        let userCalendar = Calendar.current // user calendar
        let someDateTime = calendar.date(from: dateComponents)

        return someDateTime!//strCurrent
    }
    
    func checkAndChangeUI()
    {
        
        var frame = self.viewContainer.frame

        if(self.viewRideLater.alpha == 0) {
            //self.viewHeightConstraint.constant = 160+350+20 // 20 is extra space
            frame.size.height = 160+350+20
        } else {
            //self.viewHeightConstraint.constant = 950
            frame.size.height = 1000
        }

        UIView.animate(withDuration: 0.5, animations: {
            if(self.viewRideLater.alpha == 0) {
                //self.viewHeightConstraint.constant = 160+350+20 // 20 is extra space
                self.scrollViewMain.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 160+350+20)
            } else {
                //self.viewHeightConstraint.constant = 950
                self.scrollViewMain.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
            }
            self.viewContainer.frame = frame
        }, completion:  { status in
            self.viewContainer.layoutIfNeeded()
            self.scrollViewMain.layoutIfNeeded()
        })
        
    }
}



extension SechudleTimeVC : CKCalendarDelegate{
    
    func calendar(_ calendar: CKCalendarView!, didSelect date: Date!)
    {
        if(date != nil)
        {
        let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMMM dd, yyyy"
            
            self.btnSelectedDateOtlt.setTitle(dateFormatterPrint.string(from: date) , for: .normal)

            dateFormatterPrint.dateFormat = "dd MMM yyyy hh:mm:ss"
            let str = dateFormatterPrint.string(from: date)
            self.selected_Date_From_Calender = dateFormatterPrint.date(from: str)!
            
            //By Krishna
            self.convertDateFromTime(selectedString: (self.btnStartTimeOtlt.titleLabel?.text)!)
            
        }
       
    }
    func calendar(_ calendar: CKCalendarView!, didChangeToMonth date: Date!) {
        
    }
    
    func calendar(_ calendar: CKCalendarView!, willSelect date: Date!) -> Bool {
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
        
        let selectedDateString = dateFormatterPrint.string(from: date)
        let todayString = dateFormatterPrint.string(from: Date())
        
        if(selectedDateString == todayString)
        {
            showAlert("You not able to choose current date")
            return false
        }
        
        if(date.compare(Date()) == .orderedDescending)
        {
            let newDate = Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()
            if(date.compare(newDate) == .orderedDescending)
            {
                showAlert("You can schedule a job up to 3 months from current date.")
                return false
            }
        }
        if(date.compare(Date()) == .orderedSame)
        {
            showAlert("You cannot schedule a later job on current date.")
            return false
        }
        if(date.compare(Date()) == .orderedAscending)
        {
            showAlert("You cannot scheduler a later job for past.")
            return false
        }
        
        return true
    }
    
}

