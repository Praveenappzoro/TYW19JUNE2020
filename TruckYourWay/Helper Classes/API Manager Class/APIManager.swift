//
//  APIManager.swift
//  Hotelier
//
//  Created by AppZoro Technologies on 27/03/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import UIKit
import Alamofire



struct UploadMedia:Decodable
{
    let filename: String
    let name: String
//    struct Details:Decodable {
//        let status:Int
//        let message:String
//        let data:String
//    }
}

class APIManager: NSObject
{
    static let sharedInstance = APIManager()
    
    enum result {
        case Success
        case Failure
    }
    
    enum HTTPMethodType:String
    {
        case post = "POST"
        case get = "GET"
        case delete = "DELETE"
    }
    
    
    // MARK:-  Load Data from get or post API
    
    func getDataFromAPI(_ urlString:String, _ methodName:HTTPMethodType, _ parameters:[String:Any]?, _ completion:@escaping (result,Data?,NSDictionary?,Error?,String)->())
    {
        
        print("==================")
        print("==================")
        print("URL ---> \(urlString)")
        print("PARAMS ----> \(parameters ?? [:])")
        print("==================")
        print("==================")
        if (Utility.sharedInstance.hasConnectivity() == false)
        {
            DispatchQueue.main.async(execute: {
                 completion(.Failure,nil,nil,nil,"Please check your Internet Connection.")
                return
            })
            
        }
        
        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        guard let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
        {
            completion(.Failure,nil,nil,nil,"Url Formation error!")
            return
        }
        
        guard let url = URL(string: encodedUrl) else
        {
            completion(.Failure,nil,nil,nil,"Url Formation error!")
            return
        }
        
        let request = NSMutableURLRequest(url: url,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        request.httpMethod = methodName.rawValue
        request.allHTTPHeaderFields = headers
        
        if methodName.rawValue == "POST", var param = parameters
        {
            param["device_token"] = Constant.MyVariables.appDelegate.deviceToken
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: param, options: []) else
            {
                completion(.Failure,nil,nil,nil,"Url Formation error!")
                return
            }
            request.httpBody = jsonData
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil)
            {
                DispatchQueue.main.async
                    {
                        completion(.Failure,nil,nil,error,MSGTRY)
                        return
                    }
                
            }
            else
            {
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                {
                    DispatchQueue.main.async
                        {
                            guard let errorType = try? JSONDecoder().decode(ResponsError.self, from: data!) else {
                                completion(.Failure,nil,nil,nil,MSGTRY)
                                return
                            }
                            completion(.Failure,data!,nil,nil,errorType.error_message)
                                return
                        }
                }
                
                let responseString = String(data: data!, encoding: .utf8)
                  print("responseString = \(String(describing: responseString))")
                do
                {
                    guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else
                    {
                        completion(.Failure,nil,nil,nil,MSGTRY)
                        return
                    }        //    print(json)
                    DispatchQueue.main.async
                        {
                            let jsonDict = Utility.sharedInstance.convertAllDictionaryValueToNil(json.mutableCopy() as! NSMutableDictionary)
                            
                            guard jsonDict.value(forKey: "error_type") != nil else
                                        {
                                             completion(.Success,data!,jsonDict,nil, "Success")
                                          
                                          
                                          return
                                        }
                            guard  let message = jsonDict.value(forKey: "error_message") else
                            {
                                completion(.Failure,nil,nil,nil,"Please try after some time")
                                return
                            }
                            
                            if Int("\(jsonDict.value(forKey: "error_type") ?? 0)") == -21 {
                                USER_DEFAULT.set(nil, forKey: "userData")
                                Constant.MyVariables.appDelegate.navigationController?.stopAnimating()


                                let vc = LoginVC.init(nibName: "LoginVC", bundle: nil)
                                vc.isDeviceChanged = true
                                vc.alertMessage = message as! String
                                Constant.MyVariables.appDelegate.navigationController = UINavigationController.init(rootViewController: vc)
                                Constant.MyVariables.appDelegate.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
                                Constant.MyVariables.appDelegate.navigationController?.navigationBar.isHidden = true
                                Constant.MyVariables.appDelegate.window?.rootViewController = Constant.MyVariables.appDelegate.navigationController
                                Constant.MyVariables.appDelegate.window?.makeKeyAndVisible()
                                
                            } else {
                                completion(.Failure,nil,nil,nil,message as! String)
                            }
                            
                            
                           
//                            guard let statusCheck = try? JSONDecoder().decode(    DataError.self, from: data!) else
//                            {
//                                completion(.Failure,nil,nil,nil,"Unable to extract data.")
//                                return
//                            }
//
//                            if statusCheck.response.status == 1
//                            {
//                                completion(.Success,data!,jsonDict,nil,statusCheck.response.message ?? "Success")
//                            }
//                            else
//                            {
////                                guard let errorType = try? JSONDecoder().decode(ResponsError.self, from: data!) else {
////                                    completion(.Failure,nil,nil,nil,MSGTRY)
////                                    return
////                                }
//                                 completion(.Failure,data!,nil,nil,statusCheck.response.error ?? "Please try again in a moment.")
//                            }
                          
                        }
                    
                }
                catch
                {
                    // print(error)
                    DispatchQueue.main.async
                        {
                            completion(.Failure,nil,nil,nil,MSGTRY)
                            return
                        }
                }
            }
        })
        dataTask.resume()
    }
    
    func getArrayDataFromAPI(_ urlString:String, _ methodName:HTTPMethodType, _ parameters:[String:Any]?, _ completion:@escaping (result,Data?,NSDictionary?,Error?,String)->())
    {
        
        
        if (Utility.sharedInstance.hasConnectivity() == false)
        {
            DispatchQueue.main.async(execute: {
                completion(.Failure,nil,nil,nil,"Please check your Internet Connection.")
                return
            })
            
        }
        
        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        guard let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
        {
            completion(.Failure,nil,nil,nil,"Url Formation error!")
            return
        }
        
        guard let url = URL(string: encodedUrl) else
        {
            completion(.Failure,nil,nil,nil,"Url Formation error!")
            return
        }
        
        let request = NSMutableURLRequest(url: url,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = methodName.rawValue
        request.allHTTPHeaderFields = headers
        
        if methodName.rawValue == "POST", var param = parameters
        {
            param["device_token"] = Constant.MyVariables.appDelegate.deviceToken

            guard let jsonData = try? JSONSerialization.data(withJSONObject: param, options: []) else
            {
                completion(.Failure,nil,nil,nil,"Url Formation error!")
                return
            }
            request.httpBody = jsonData
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil)
            {
                DispatchQueue.main.async
                    {
                        completion(.Failure,nil,nil,error,MSGTRY)
                        return
                }
                
            }
            else
            {
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
                {
                    DispatchQueue.main.async
                        {
                            guard let errorType = try? JSONDecoder().decode(ResponsError.self, from: data!) else {
                                completion(.Failure,nil,nil,nil,MSGTRY)
                                return
                            }
                            completion(.Failure,data!,nil,nil,errorType.error_message)
                            return
                    }
                }
                
                let responseString = String(data: data!, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                do
                {
                    guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else
                    {
                        completion(.Failure,nil,nil,nil,MSGTRY)
                        return
                    }
                    //    print(json)
                    DispatchQueue.main.async
                        {
//                            let jsonDict = Utility.sharedInstance.convertAllDictionaryValueToNil(json.mutableCopy() as! NSMutableDictionary)
                            
                            completion(.Success,data!,json,nil,"Success")
                            
//                            if jsonDict.object(forKey: "error_type") == nil
//                            {
//                                completion(.Success,data!,jsonDict,nil,"Success")
//                            }
//                            else
//                            {
//                                guard let errorType = try? JSONDecoder().decode(ResponsError.self, from: data!) else {
//                                    completion(.Failure,nil,nil,nil,MSGTRY)
//                                    return
//                                }
//                                completion(.Failure,data!,nil,nil,errorType.error_message)
//                            }
                            
                    }
                    
                }
                catch
                {
                    // print(error)
                    DispatchQueue.main.async
                        {
                            completion(.Failure,nil,nil,nil,MSGTRY)
                            return
                    }
                }
            }
        })
        dataTask.resume()
    }
    
  
    
  
    
    
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, completion:@escaping (result,String)->() ) {
        // contentMode = mode
        if (Utility.sharedInstance.hasConnectivity() == false)
        {
            completion(.Failure, "Please check your Internet Connection.")
            return
            
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                
                else {
                    print( "Return")
                    completion(.Failure, "Please try again in a moment.")
                    return
            }
            
            DispatchQueue.main.async() { () -> Void in
                //self.image = image
                print( "DispatchQueue")
//                self.ApiProfileChange(image: image, completion: { (result, msg) in
//                    switch result
//                    {
//                    case .Failure:
//                        completion(.Failure, msg)
//                        break
//                    case .Success:
//                        completion(.Success, msg)
//                        break
//                    }
//
//                })
            }
            
            }.resume()
    }
    
    func ApiProfileChange(image : UIImage, completion:@escaping (result, String, String?)->())
    {
        if (Utility.sharedInstance.hasConnectivity() == false)
        {
            completion(.Failure,"Please check your Internet Connection.",nil)
            return

        }
        
        let timestamp = Date().timeIntervalSince1970
        let imageName = String(format:"%f.png",timestamp)

        let URL = try! URLRequest(url: BSE_URL_UploadMedia, method: .post)

        Alamofire.upload(multipartFormData:
            { (multipartFormData) in
                if  let imageData = UIImageJPEGRepresentation((image), 0.3)
                {
                    multipartFormData.append(imageData, withName: "theFile", fileName: imageName, mimeType: "image/jpg")
                }

        }, with: URL, encodingCompletion: { (result) in

            switch result
            {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if response.result.value != nil
                    {

                        if let JSON = response.result.value, let data = response.data
                        {
                            print("JSON: \(JSON)")
                            guard let UploadedImgData = try? JSONDecoder().decode(UploadMedia.self, from: data) else {
                                completion(.Failure,"Please check your internet connection and try again.", nil)
                                return
                            }
                            
                            NotificationCenter.default.post(name: Notification.Name("updateUserProfile"), object: nil)
                            
                            completion(.Success, "Successfully uploaded!", UploadedImgData.filename)
                        }
                        else
                        {
                            completion(.Failure, "Unable to upload!",nil)
                        }
                    }
                    else
                    {
                        completion(.Failure, "Unable to upload!",nil)
                    }
                }

            case .failure(_):
                DispatchQueue.main.async(execute: {
                    completion(.Failure, "Unable to upload!",nil)
                })
                break
            }
        })

    }
    
    func APICallingForZIPCode(_ zipCode:String,_ completion:@escaping (result,NSDictionary?,Error?,String)->())
    {
        let dict:NSMutableDictionary = NSMutableDictionary()
        
        if (Utility.sharedInstance.hasConnectivity() == false)
        {
            completion(.Failure,nil,nil,"Please check your Internet Connection.")
            return
            
        }
        
        let strUrl : String = Main_BSE_URL+"/api/Zip?zip=" + zipCode
        
        self.getDataFromAPI(strUrl, .get, nil) { (result,data, json, error, msg) in
            
            switch result
            {
            case .Failure:
                DispatchQueue.main.async(execute: {
                    print(msg)
                    completion(.Failure,nil,error,msg)
                    return
                })
                break
            case .Success:
                DispatchQueue.main.async(execute: {
                    print(json ?? "found json nil")

                })
                break
            }
            
        }
        
        
    }
    
    func uploadImage(_ pic:UIImage, _ onSuccess:@escaping (String)->()?, _ onFailure:@escaping (String)->()?)
    {
        
        self.ApiProfileChange(image: pic) { (result, msg, fileName) in
            switch result
            {
            case .Failure:
                DispatchQueue.main.async(execute:
                    {
                       onFailure(msg)
                })
                break
            case .Success:
                DispatchQueue.main.async(execute:
                    {
                        guard let name = fileName else {
                            onFailure(msg)
                            return
                        }
                       onSuccess(name)
                })
                break
            }
        }
    }
    
    func APILogout(deviceToken:String, userId:String)
    {
        self.getDataFromAPI("\(Main_BSE_URL)/api/account/Logout?DeviceToken=\(deviceToken)&UserId=\(userId)", .post, nil) { (result,data,json, error, msg) in
            switch result
            {
            case .Failure:
                DispatchQueue.main.async(execute: {
                    print("error-:  \(String(describing: error))  msg:-  \(msg)")
                })
                break
            case .Success:
                DispatchQueue.main.async(execute: {
                    print(json ?? "Json not found")
                })
                break
            }
        }
    }
    
    func APILikePost(_ postId:Int, _ dict:NSDictionary, completion:@escaping (String)->())
    {
        self.getDataFromAPI("\(Main_BSE_URL)/api/LikePost", .post, dict as? [String : Any]) { (result,data, json, error, msg) in
            switch result
            {
            case .Failure:
                DispatchQueue.main.async(execute: {
//                    self.stopAnimating()
                    print(msg)
//                    Utility.sharedInstance.showAlert("Alert", msg: msg, controller: self)
                    completion(msg)
                    return
                })
                break
            case .Success:
                DispatchQueue.main.async(execute: {
//                    self.stopAnimating()
                    guard let jsonData = json else {return}
//                    let succeed = jsonData["Succeed"] as? Bool
//                    if succeed == true
//                    {
//
//                    }
//                    else
//
//                    {
//                        completion((jsonData["Message"] as? String)!)
//
////                    Utility.sharedInstance.showAlert("Alert", msg: (json?["Message"] as? String)!, controller: self)
//                    }
                })
                break
            }
        }
    }
    
}
