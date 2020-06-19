//
//  UserFeedsData.swift
//  UnSplashSocket
//
//  Created by YASH COMPUTERS on 07/07/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import Foundation
import UIKit

struct Feeds:Decodable
{
    let response:Response
    
    struct Response:Decodable
    {
        let status:Int64
        let message:String
        let data:[FeedsData]
        let pagination:Pagination
    }
}

struct FeedsData:Decodable
{
    let id:Int64
    let room_id:Int64
    let room_name:String
    let user_id:Int64
    let message:String
    let created:String
    let total_comment:Int64?
    let user:FeedUserData
    var date:String?
}

struct FeedUserData:Decodable
{
    let id:Int64
    let first_name:String
    let last_name:String
    let image:String
    var fullName:String{
        return "\(first_name) \(last_name)"
    }
}

struct CreateFeed:Decodable
{
    var response:Response
    
    struct Response:Decodable
    {
        let status:Int64
        let message:String
        var data:FeedsData
    }
}

//struct UniveralFeed:Decodable
//{
//    let response:Response
//
//    struct Response:Decodable
//    {
//        let status:Int64
//        let message:String
//        let data:[FeedsData]
//        let pagination:Pagination
//    }
//}
//
//struct UniversalFeedData:Decodable
//{
//
//}


