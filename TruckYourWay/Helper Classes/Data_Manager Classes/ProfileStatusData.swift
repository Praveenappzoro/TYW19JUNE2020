//
//  ProfileStatusData.swift
//  UnSplashSocket
//
//  Created by APPZOROMAC on 17/07/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import Foundation
import  UIKit

var isComingFromMenu:Bool = false

struct StatusList:Decodable
{
    let response:Response
    
    struct Response:Decodable
    {
        let status:Int64
        let message:String
        var data:[StatusData]
        let pagination:Pagination
    }
}

struct StatusData:Decodable
{
    let id:Int64
    let user_id:Int64
    let profile_status:String
    var created:String
    let modified:String
    var date:String?
}

struct CreateStatus:Decodable
{
    let response:Response
    
    struct Response:Decodable
    {
        let status:Int64
        let message:String
        var data:StatusData
    }
}

