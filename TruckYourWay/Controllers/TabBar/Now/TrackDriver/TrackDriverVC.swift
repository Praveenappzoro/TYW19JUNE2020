//
//  TrackDriverVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/20/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Cosmos

class TrackDriverVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var driverImgView: UIImageView!
    
    @IBOutlet weak var ratingViewDriver: CosmosView!
    
    @IBOutlet weak var lblDriverNumber: UILabel!
    @IBOutlet weak var lblMaterial: UILabel!
    @IBOutlet weak var lblJobType: UILabel!
    @IBOutlet weak var buttonBack: UIButton!

    // Popup Main
    
    @IBOutlet weak var viewDarkPopup: UIView!
    
    @IBOutlet weak var lblTitleOnLoadEnRoute: UILabel!
    @IBOutlet weak var subViewDarPopup: UIView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var marker = GMSMarker()
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    var pickup_Lat : Double = 0.0
    var pickup_Long : Double = 0.0
    var drop_Lat : Double = 0.0
    var drop_Long : Double = 0.0
    var truck_Lat : Double = 0.0
    var truck_Long : Double = 0.0
     var previousLocation: CLLocation?
    var globalTotalLoads = 1
    var globalCurrentLoads = 0
    
    var dictBillDetails : NSMutableDictionary = [:]
    var arrConfirmation: NSMutableArray = []
    var payloadDict : NSMutableDictionary = [:]
    var materialData : NSDictionary = [:]

    var tracking_Id : String = ""

    var isFromDriverList : Bool = false

    var loginUserData:LoggedInUser!
    
    var seconds = 3000000
    var secondsTwoHours = 7200
    var timer = Timer()
    var timerTwoHours = Timer()
    var isCallUpdateLocation: Bool = true
    
     private var carAnimator: CarAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        self.subViewDarPopup.layer.cornerRadius = 10
        self.subViewDarPopup.layer.masksToBounds = true
        
        self.driverImgView.layer.cornerRadius = 40
        self.driverImgView.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLoadCompleteNotification), name: NSNotification.Name(rawValue: "NoOfLoadsCompleted"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLoadEnRouteNotification), name: NSNotification.Name(rawValue: "LoadEnRouteNotification"), object: nil)
        
        self.navigationController?.navigationBar.isHidden = true
        
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {
            return
        }
        self.addMapOnScreen()
        self.getTrackCurrentJob()
//        if(self.dictBillDetails.count != 0)
//        {
//            self.showInfoOnScreen()
//            self.getDeliveryLocation()
//            self.updateLocationOnEveryFiveSeconds()
//        }
//        else
//        {
////            self.getBillInfoApi()
//
//            self.runTimerTwoHours()
//        }
        self.runTimer()
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        
        if isFromDriverList {
            buttonBack.isHidden = true
        } else {
            buttonBack.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        prepareBackgroundView()
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appIsComingFromBackground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        carAnimator = CarAnimator(carMarker: marker, mapView: mapView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.isCallUpdateLocation = false
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func appIsComingFromBackground() {
        self.getTrackCurrentJob()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionDismissJobEnRoutePopup(_ sender: Any)
    {
        self.viewDarkPopup.isHidden = true
    }
    
    func getTrackCurrentJob()
    {
//        let tracking_id =  String(self.dictBillDetails.value(forKey: "id") as? Int ?? 0)
        let params = [
            "tracking_id":self.tracking_Id,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? ""
            ] as NSDictionary
        
                self.startAnimating("")
        
        print(params)
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_GET_TRAKING_ID_DETAILS, .post, params as? [String : Any]) { (result, data, json, error, msg) in
            
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
                    
                        let dict = json?.value(forKey: "bill_details") as! NSDictionary
                    
                    
                    if dict["completed"] as? String == "true" {
                        self.checkJobCompletionFor(bill: dict)
                        return
                    }
                
                        self.dictBillDetails = dict.mutableCopy() as! NSMutableDictionary
                        self.materialData = json?.value(forKey: "material_data") as! NSDictionary
                        let arr = json?.value(forKey: "materials") as! NSArray
                        self.arrConfirmation = arr.mutableCopy() as! NSMutableArray
                        self.showInfoOnScreen()
                        self.getDeliveryLocation()
                        self.updateLocationOnEveryFiveSeconds()
                })
                break
            }
            
        }
    }
    
    @objc func getLoadCompleteNotification(_ userInfo: Notification){
        self.lblTimer.backgroundColor = .clear
        self.lblTimer.textColor = .darkGray
        
        let dicss = userInfo.userInfo as! [String: AnyObject]
        let dict = dicss as! NSDictionary
        let dictPayload = dict.value(forKey: "payload") as! NSDictionary
        self.payloadDict = dictPayload.mutableCopy() as! NSMutableDictionary
        self.globalCurrentLoads = Int(self.payloadDict.value(forKey: "load_no") as? String ?? "0")!
        self.endTimer()
        self.lblTimer.text = "\("LOAD ")\(self.globalCurrentLoads)\(" of ")\(self.globalTotalLoads) \("COMPLETE")"
//        let jobType = (self.dictBillDetails.value(forKey: "job_type") as? String)?.uppercased() ?? "DELIVERY"
        
//        if(self.arrConfirmation.count > 0 ) {
//            self.materialData = self.payloadDict.value(forKey: "material_data") as! NSDictionary
//            self.lblMaterial.text = "\(jobType)\(" ")\(self.materialData.value(forKey: "category") as? String ?? "") \(self.materialData.value(forKey: "size") as? String ?? "")"
//        } else {
//            self.lblMaterial.text = jobType
//        }
    }
    
     @objc func getLoadEnRouteNotification(_ userInfo: Notification){
        let dicss = userInfo.userInfo as! [String: AnyObject]
        let dicts = dicss as! NSDictionary
        let dictMain  = dicts as! NSDictionary
        let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
        guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
        let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
        self.lblTitleOnLoadEnRoute.text = alertMessage
        //self.viewDarkPopup.isHidden = false
    }
    
    //MARK:- Stop Timer
    func endTimer() {
        self.secondsTwoHours = 7200
        timerTwoHours.invalidate()
    }
    
    //MARK:- get Info for bill
    
//    func getBillInfoApi()
//    {
//            if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
//            {
//                guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
//                self.loginUserData = loginUpdate
//            }
//            else
//            {
//                return
//            }
//
//            let params = [
//                "bill_no":self.payloadDict.value(forKey: "bill_no") as? String ?? "",
//                "access_token":self.loginUserData.access_token ?? "",
//                "refresh_token":self.loginUserData.refresh_token ?? ""
//                ] as [String : Any]
//
//            self.startAnimating("")
//
//            APIManager.sharedInstance.getDataFromAPI(BSE_URL_GET_BILL_FIRST_DRIVER, .post, params) { (result, data, json, error, msg) in
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
//
//                    DispatchQueue.main.async(execute: {
//                        self.stopAnimating()
//                        print(json)
//                        let dict = json?.value(forKey: "bill_details") as! NSDictionary
//                        self.dictBillDetails = dict.mutableCopy() as! NSDictionary as! NSMutableDictionary
//                        self.showInfoOnScreen()
//                        self.getDeliveryLocation()
//                        self.updateLocationOnEveryFiveSeconds()
//                    })
//                    break
//                }
//
//            }
//        }
    
    //MARK:- Show info on screen
     func showInfoOnScreen()
     {
      
        let jobType = (self.dictBillDetails.value(forKey: "job_type") as? String)?.capitalizingFirstLetter() ?? "Delivery"
        let truck_image_Url = self.dictBillDetails.value(forKey: "truck_image") as? String ?? ""
        let truck_number = self.dictBillDetails.value(forKey: "truck_number") as? String ?? ""
        
        self.lblDriverNumber.text = "\("Truck ")\(truck_number)"
        
        self.driverImgView.loadImageAsync(with: BSE_URL_LoadMedia+truck_image_Url, defaultImage: "", size: self.driverImgView.frame.size)
        self.ratingViewDriver.rating = Double(self.dictBillDetails.value(forKey: "ratings") as? String ?? "0.0")!
        
        self.globalTotalLoads = Int(self.dictBillDetails.value(forKey: "total_loads") as? String ?? "0")!
        self.globalCurrentLoads = Int(self.dictBillDetails.value(forKey: "completed_loads") as? String ?? "0")!
        
        var materialString = ""
        if(self.arrConfirmation.count > 0 ) {
            var count = 0
            for data in self.arrConfirmation {
                let dic = data as! NSDictionary
                let cat = dic.value(forKey: "category") as? String ?? ""
                let name = dic.value(forKey: "name") as? String ?? ""
                let material = cat + " " + name
                materialString.append(material)
                if count < self.arrConfirmation.count - 1 {
                    materialString.append(", ")
                }
                count += 1
            }
            print("Final String -->\(materialString)")
            self.lblMaterial.text = materialString
            self.lblJobType.text = jobType
//            self.lblMaterial.text = "\(jobType)\(" ")\(self.materialData.value(forKey: "category") as? String ?? "") \(self.materialData.value(forKey: "size") as? String ?? "")"
        } else {
            self.lblMaterial.text = jobType
        }
        
        print(self.dictBillDetails["moment"] as Any)
      
//      let dateNow = Date().millisecondsSince1970
//      let timeDifference = dateNow - dateAccepted
//      seconds = seconds - timeDifference
      secondsTwoHours = 7200
        let timestamp = self.dictBillDetails["moment"] as? String
        let dateStarted = Int("\(timestamp ?? "0")")!
        let dateNow = Date().millisecondsSince1970
        let timeDifference = dateNow - dateStarted
        secondsTwoHours = secondsTwoHours - timeDifference
        print(timeDifference)
        
        if self.globalCurrentLoads > 0 {
            self.lblTimer.backgroundColor = .white
            self.lblTimer.textColor = .darkGray
            self.endTimer()
            self.lblTimer.text = "\("LOAD ")\(self.globalCurrentLoads)\(" of ")\(self.globalTotalLoads) \("COMPLETE")"
        } else {
            self.runTimerTwoHours()
            self.lblTimer.backgroundColor = #colorLiteral(red: 0.5333333333, green: 0.6823529412, blue: 0.1921568627, alpha: 1)
        }
     }
    
    //MARK:- Configure Google map
    func addMapOnScreen() {
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures   = true
        mapView.settings.tiltGestures   = true
        mapView.settings.rotateGestures = true
        mapView.animate(toZoom: zoomLevel)
    }
    
    func getDeliveryLocation()
    {
        self.pickup_Lat = Double(self.dictBillDetails.value(forKey: "pickup_latitude") as? String ?? "0.0")!
        self.pickup_Long = Double(self.dictBillDetails.value(forKey: "pickup_longitude") as? String ?? "0.0")!
        self.drop_Lat = Double(self.dictBillDetails.value(forKey: "drop_latitude") as? String ?? "0.0")!
        self.drop_Long = Double(self.dictBillDetails.value(forKey: "drop_longitude") as? String ?? "0.0")!
        self.polyLineDraw()
        
       
        //self.marker.position = CLLocationCoordinate2D(latitude: self.pickup_Lat, longitude: self.pickup_Long)
//        self.marker.icon =  #imageLiteral(resourceName: "moving_truck") // How can I set to a rectangle with color/text of my choosing?
//        self.marker.map = self.mapView // map is a GMSMapView
    }
    
    
    func polyLineDraw()
    {
        let polyLine = PolylineRoute()
        //mapView.clear()
        polyLine.getPolylineRoute(from: CLLocationCoordinate2D(latitude: self.pickup_Lat, longitude: self.pickup_Long), to: CLLocationCoordinate2D(latitude: self.drop_Lat, longitude: self.drop_Long), mapView: self.mapView,dictBillDetails:self.dictBillDetails, currentVC: self)
    }
    var loc1: CLLocation?
    
    func updateLocationOnEveryFiveSeconds()
    {
        let driver_Id =  String(self.dictBillDetails.value(forKey: "driver_id") as? String ?? "0")
        let params = [
            "user_id":driver_Id,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? ""
            ] as NSDictionary
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_START_GET_LOCATION, .post, params as? [String : Any]) { (result, data, json, error, msg) in
            
            switch result
            {
            case .Failure:
                DispatchQueue.main.async(execute: {
                })
                break
            case .Success:
                DispatchQueue.main.async(execute: {
                    self.truck_Lat =  Double(json?.value(forKey: "latitude") as? String ?? "0.0")!
                    self.truck_Long =   Double(json?.value(forKey: "longitude") as? String ?? "0.0")!
                    //self.marker.position = CLLocationCoordinate2D(latitude: self.pickup_Lat, longitude: self.pickup_Long)
                    self.marker.icon =  #imageLiteral(resourceName: "moving_truck")
                    
                    self.previousLocation = self.loc1
                    self.loc1 = CLLocation(latitude: self.truck_Lat, longitude: self.truck_Long)
                    
                    if let myLocation = self.loc1, let myLastLocation = self.previousLocation  {
                        self.carAnimator.animate(from: myLastLocation.coordinate, to: myLocation.coordinate)
                    }
//                    let loc2 = CLLocation(latitude: self.pickup_Lat, longitude: self.pickup_Long)
//                    let bearing = self.getBearingBetweenTwoPoints1(point1: loc1, point2: loc2)
////                    CATransaction.begin()
////                    CATransaction.setAnimationDuration(1.0)
//                    self.marker.position = loc1.coordinate
//                    self.marker.rotation = bearing
                    self.marker.map = self.mapView
//                  //  CATransaction.commit()
//
//                    //self.marker.map = self.mapView
//                    UIView.animate(withDuration: 3, animations: {
//                        self.mapView.animate(toLocation: self.marker.position)
//                    })
                })
                break
            }
            
        }
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
    
    
    //#MARK:- implement timer functionality
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        //        isTimerRunning = true
    }
    
    func runTimerTwoHours() {
      self.timerTwoHours.invalidate()
        self.timerTwoHours = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimerTwoHours)), userInfo: nil, repeats: true)
        //        isTimerRunning = true
    }
    
    @objc func updateTimer()
    {
        if(self.isCallUpdateLocation)
        {
            if(self.dictBillDetails.count != 0)
            {
                self.updateLocationOnEveryFiveSeconds()
            }
        }
    }
    
    @objc func updateTimerTwoHours()
    {
        if secondsTwoHours < 1 {
            timerTwoHours.invalidate()
            self.dismiss(animated: true)
            //Send alert to indicate time's up.
        } else {
            secondsTwoHours -= 1
            self.lblTimer.text = timeString(time: TimeInterval(secondsTwoHours))
        }
    }
}

extension TrackDriverVC: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
//        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                              longitude: location.coordinate.longitude,
//                                              zoom: zoomLevel)
//
//        if mapView.isHidden {
//            mapView.isHidden = false
//            mapView.camera = camera
//        } else {
//            self.marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//
//            marker.icon =  #imageLiteral(resourceName: "moving_truck") // How can I set to a rectangle with color/text of my choosing?
//            marker.map = self.mapView // map is a GMSMapView
//            mapView.animate(to: camera)
//        }
        
        //        listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
extension TrackDriverVC: GMSMapViewDelegate{
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        //marker.position = coordinate
    }
    
    /* handles dragging mapView */
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
    
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
//    /* set a custom Info Window */
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//
//        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
//        view.backgroundColor = UIColor.white
//        view.layer.cornerRadius = 6
//
//        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
//        lbl1.text = "Hi there!"
//        view.addSubview(lbl1)
//
//        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
//        lbl2.text = "I am a custom info window."
//        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
//        view.addSubview(lbl2)
//
//        return view
//    }
    
    
    func checkJobCompletionFor(bill: NSDictionary) {
        
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {
            return
        }
        let bill_No = bill.value(forKey: "bill_no") as? String ?? ""
        
        let parameters = [
            "bill_no": bill_No,
            "access_token": self.loginUserData.access_token ?? "",
            "refresh_token": self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
        DispatchQueue.main.async(execute: {
            APIManager.sharedInstance.getDataFromAPI(BSE_URL_CHECK_BILL_COMPETION_CODE, .post, parameters) { (result, data, json, error, msg) in
                DispatchQueue.main.async(execute: {
                    print(json as Any)
                    if let status: Bool = json?.value(forKey: "status") as? Bool {
                        if status {
                            let driverRatingVC = DriverRatingVC.init(nibName: "DriverRatingVC", bundle: nil)
                            driverRatingVC.payloadDict = bill.mutableCopy() as! NSMutableDictionary
                            self.navigationController?.pushViewController(driverRatingVC, animated: true)
                        } else {                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                })
            }
        })
    }
}


