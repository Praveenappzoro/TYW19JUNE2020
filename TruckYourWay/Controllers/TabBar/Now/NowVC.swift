//
//  NowVC.swift
//  TruckYourWay
//
//  Created by Samradh Agarwal on 04/09/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

var strLocation: String = ""


var selectedCordinates: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
class NowVC: UIViewController {

    //MARK:- Otulets
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var btnEnterJobOtlt: CustomButton!
    
    @IBOutlet weak var btnSetLocationOtlt: CustomButton!
    @IBOutlet weak var btnHelp: UIButton!
    
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var subViewPopUp: UIView!
    
    @IBOutlet weak var BottomViewheightConstraint: NSLayoutConstraint!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var dictLoc: NSMutableDictionary = [:]
    
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    var selected_Date: String = ""
    var delivery_type: String = ""
    var later_start: Int = 0
    var later_end: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.subViewPopUp.layer.cornerRadius = 10
        self.subViewPopUp.layer.masksToBounds = true
        
        self.addMapOnScreen()
        self.getCurrentLocationFromGoogle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getSearchAndSelectedLocation(_:)), name: NSNotification.Name(rawValue: "SearchAndChooseLocation"), object: nil)

//        self.BottomViewheightConstraint.constant = 80
        self.btnSetLocationOtlt.isHidden = true
        self.btnHelp.isHidden = false
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setStatusBarCOLOR()
        prepareBackgroundView()
        if isComeHome {
            isComeHome = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.tabBarController?.selectedIndex = 2
            }
        }
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
        
        if let sModel = Constant.MyVariables.appDelegate.truckCartModel {
            sModel.pickedCordinates = self.dictLoc
            Constant.MyVariables.appDelegate.saveTrucCartData()
        }

        //USER_DEFAULT.set(AppState.TruckScheduleTime.rawValue, forKey: APP_STATE_KEY)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.items?[1].badgeValue = nil
        self.tabBarController?.tabBar.tintColor = themeColorOrange
//        self.tabBarController?.tabBar.items?[1].isEnabled = false
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.view.layoutIfNeeded()

//        Constant.MyVariables.appDelegate.truckCartModel = nil
//        Constant.MyVariables.appDelegate.saveTrucCartData()
//        USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)
        
        if Constant.MyVariables.appDelegate.truckCartModel == nil {
            Constant.MyVariables.appDelegate.truckCartModel = TruckCartModel.init()
        }
        
        if Constant.MyVariables.appDelegate.truckCartModel != nil {
            let lDic = Constant.MyVariables.appDelegate.truckCartModel?.pickedCordinates
            if(lDic!.count > 0) {
                let locDic = lDic as! NSMutableDictionary
                self.dictLoc.setValue(locDic["lat"], forKey: "lat")
                self.dictLoc.setValue(locDic["long"], forKey: "long")
                self.dictLoc.setValue(locDic["LocationName"], forKey: "LocationName")
                
                self.btnEnterJobOtlt.setTitle((locDic["LocationName"] as! String), for: .normal)
                
                //                self.BottomViewheightConstraint.constant = 150
                self.btnSetLocationOtlt.isHidden = false
                self.btnHelp.isHidden = true
                let camera = GMSCameraPosition.camera(withLatitude: locDic["lat"] as! Double,
                                                      longitude: locDic["long"] as! Double,
                                                      zoom: self.zoomLevel)
                
                let markerDestination = GMSMarker()
                markerDestination.position = CLLocationCoordinate2D(latitude: locDic["lat"] as! Double, longitude: locDic["long"] as! Double)
                markerDestination.title = "Truck your Way"
                markerDestination.snippet = locDic["LocationName"] as! String
                markerDestination.map = self.mapView
                self.mapView(self.mapView, markerInfoWindow: markerDestination)
                
                if self.mapView.isHidden {
                    self.mapView.isHidden = false
                    self.mapView.camera = camera
                } else {
                    self.mapView.animate(to: camera)
                }
            }
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool)
//    {
//        self.tabBarController?.tabBar.items?[1].isEnabled = true
//    }
    
    @IBAction func actionOkOnPopUp(_ sender: Any)
    {
        self.viewPopUp.isHidden = true
    }
    
    @IBAction func actionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionEnterJob(_ sender: Any)
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true) {
            if(self.btnEnterJobOtlt.titleLabel?.text != "Enter job site address to request service.")
            {
//                let views = autocompleteController.view.subviews
//                let subviewsOfSubview = views.first!.subviews
//                let subOfNavTransitionView = subviewsOfSubview[1].subviews
//                let subOfContentView = subOfNavTransitionView[2].subviews
//                let searchBar = subOfContentView[0] as! UISearchBar
//                searchBar.text = self.btnEnterJobOtlt.titleLabel?.text
//                searchBar.delegate?.searchBar?(searchBar, textDidChange: (self.btnEnterJobOtlt.titleLabel?.text)!)
                
                let views = autocompleteController.view.subviews
                guard let subviewsOfSubview = views.first?.subviews else { return }
                if subviewsOfSubview.count > 1 {
                    let subOfNavTransitionView = subviewsOfSubview[1].subviews
                    if subOfNavTransitionView.count > 2 {
                        let subOfContentView = subOfNavTransitionView[2].subviews
                        if subOfContentView.count > 0 {
                            guard let searchBar = subOfContentView[0] as? UISearchBar else { return }
                            searchBar.text = self.btnEnterJobOtlt.titleLabel?.text
                            searchBar.delegate?.searchBar?(searchBar, textDidChange: (self.btnEnterJobOtlt.titleLabel?.text)!)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func actionSetLocation(_ sender: Any)
    {
        
        let dropLat = self.dictLoc.value(forKey: "lat") as? Double ?? 0.0
        let dropLong = self.dictLoc.value(forKey: "long") as? Double ?? 0.0

        let coordinate₀ = CLLocation(latitude: dropLat, longitude: dropLong)

        let distanceInMilesInDouble = Double(((coordinate₀.distance(from: cordinatesForCentralAtlanta)/1000)*0.621371))
       
        //UNCOMMENT FOR LIVE
        if(distanceInMilesInDouble > 50)
        {
            self.viewPopUp.isHidden = false
            return
        }
        
        let sModel = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
        sModel.pickedCordinates = self.dictLoc
        Constant.MyVariables.appDelegate.saveTrucCartData()
        
//        let sechudleVC =  SechudleTimeVC.init(nibName: "SechudleTimeVC", bundle: nil)
        let sechudleVC =  SechudleTimeVC.init(nibName: "SechudleTimeVC", bundle: nil)

//        let dateFormat = DateFormatter.init()
//        dateFormat.dateFormat = "dd MMMM YYYY"
//        let strCurrent = dateFormat.string(from: Date())
//        sechudleVC.selected_Date =  strCurrent
//        sechudleVC.delivery_type = "now"
//        sechudleVC.later_start = 0
//        sechudleVC.later_end = 0
        sechudleVC.pickedCordinates = self.dictLoc
        self.navigationController?.pushViewController(sechudleVC, animated: true)
        
//        let sechudleVC = JobRequestVC.init(nibName: "JobRequestVC", bundle: nil)
//            sechudleVC.selected_Date =  selected_Date
//            sechudleVC.delivery_type = delivery_type
//            sechudleVC.later_start = later_start
//            sechudleVC.later_end = later_end
//            sechudleVC.pickedCordinates = self.dictLoc.mutableCopy() as! NSMutableDictionary
//
//        self.navigationController?.pushViewController(sechudleVC, animated: true)
    }
    
    @IBAction func actionHelp(_ sender: Any)
    {
        if let url = URL(string: BSE_URL_HELP) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @objc func getSearchAndSelectedLocation(_ notification: NSNotification) {
        
        if let cordinates = notification.userInfo?["cordinates"] as? [String : AnyObject]
        {
           
            let dict = cordinates as NSDictionary
                let sechudleVC = JobRequestVC.init(nibName: "JobRequestVC", bundle: nil)
            sechudleVC.pickedCordinates = dict as! NSMutableDictionary
                self.navigationController?.pushViewController(sechudleVC, animated: true)
            // do something with your image
        }
    }
    
    //MARK:- Configure Google map
    func addMapOnScreen() {

    mapView.settings.myLocationButton = true
    mapView.isMyLocationEnabled = true

//    mapView.isHidden = true
    }
    func getCurrentLocationFromGoogle()
    {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .light)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension NowVC: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
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



extension BottomLocationSheetVC:  UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = self.searchResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedLocationName = self.searchResults[indexPath.row]
       let selectedLocation = self.arrSearchLocation.object(at: indexPath.row) as? GMSAutocompletePrediction
        
        let placeClient = GMSPlacesClient()
        
        placeClient.lookUpPlaceID(selectedLocation?.placeID ?? "") { (place, error) -> Void in
                self.startAnimating("")
            if let error = error {
                //show error
                return
            }
            
            if let place = place {
                 self.stopAnimating()
                
                
//                place.coordinate.latitude
//                place.coordinate.longitude
                let dict = [
                    "cordinates":["lat" : place.coordinate.latitude,"long": place.coordinate.longitude,"LocationName":selectedLocationName]
                           ] as [String: AnyObject]
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SearchAndChooseLocation"), object: nil, userInfo: dict)

                
                let sModel = Constant.MyVariables.appDelegate.truckCartModel ?? TruckCartModel()
                sModel.pickedCordinates = dict as! NSMutableDictionary
                Constant.MyVariables.appDelegate.saveTrucCartData()

            } else {
                self.stopAnimating()
                //show error
            }
        }
    }
}
extension NowVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress ?? "")")
//        print("Place attributions: \(place.attributions ?? "")")
        self.btnEnterJobOtlt.setTitle((place.formattedAddress as! String), for: .normal)
        let placeClient = GMSPlacesClient()
        
        placeClient.lookUpPlaceID(place.placeID!) { (place, error) -> Void in
            self.startAnimating("")
            if let error = error {
                //show error
                return
            }
            
            if let place = place {
                self.stopAnimating()
                
                self.dictLoc.setValue(place.coordinate.latitude, forKey: "lat")
                self.dictLoc.setValue(place.coordinate.longitude, forKey: "long")
                self.dictLoc.setValue(place.formattedAddress, forKey: "LocationName")
               
                
//                self.BottomViewheightConstraint.constant = 150
                self.btnSetLocationOtlt.isHidden = false
                self.btnHelp.isHidden = true
                let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                                      longitude: place.coordinate.longitude,
                                                      zoom: self.zoomLevel)
                
                let markerDestination = GMSMarker()
                markerDestination.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                markerDestination.title = "Truck your Way"
                markerDestination.snippet = place.formattedAddress
                markerDestination.map = self.mapView
                self.mapView(self.mapView, markerInfoWindow: markerDestination)
                if self.mapView.isHidden {
                    self.mapView.isHidden = false
                    self.mapView.camera = camera
                } else {
                    self.mapView.animate(to: camera)
                }
                
            } else {
                self.stopAnimating()
                //show error
            }
        }
        dismiss(animated: true, completion: nil)
    
}
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = "Hi there!"
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "I am a custom info window."
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
        return view
    }
}

extension NowVC : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
}

