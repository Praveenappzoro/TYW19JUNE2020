//
//  PolylineRoute.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 12/3/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class PolylineRoute: NSObject {

    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, mapView:GMSMapView,dictBillDetails:NSDictionary,currentVC:UIViewController){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=true&mode=driving&key=\(Google_Map_Key)")!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print(error!.localizedDescription)
                }
                else {
                    do {
                        if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                            guard let routes = json["routes"] as? NSArray else {
                                DispatchQueue.main.async {
                                }
                                return
                            }
                            print(json)
                            if (routes.count > 0) {
                                let overview_polyline = routes[0] as? NSDictionary
                                let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                                let points = dictPolyline?.object(forKey: "points") as? String
                                self.showPath(polyStr: points!, mapView:mapView)
                                DispatchQueue.main.async {
                                    let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                                    let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(0, 0, 0, 0))
                                    mapView.moveCamera(update)
                                    let markerSource = GMSMarker()
                                    markerSource.position = source
                                    markerSource.title = "Pickup-Location"
                                    markerSource.snippet = dictBillDetails.value(forKey: "pickup_address") as? String ?? ""
                                    markerSource.map = mapView
                                    self.mapView(mapView, markerInfoWindow: markerSource)
                                    let markerDestination = GMSMarker()
                                    markerDestination.position = destination
                                    markerDestination.title = "Drop-Location"
                                    markerDestination.snippet = dictBillDetails.value(forKey: "drop_address") as? String ?? ""
                                    markerDestination.map = mapView
                                    self.mapView(mapView, markerInfoWindow: markerDestination)
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                }
                            }
                        }
                    }
                    catch {
                        print("error in JSONSerialization")
                        DispatchQueue.main.async {
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String, mapView:GMSMapView){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = UIColor.black
        polyline.map = mapView // Your map view
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
