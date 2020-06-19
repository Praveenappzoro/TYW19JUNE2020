//
//  NotificationUpdate.swift
//  UnSplashSocket
//
//  Created by APPZOROMAC on 23/07/18.
//  Copyright © 2018 AppZoro Technologie=. All rights reserved.
//

import Foundation
import UIKit

struct NOtificationList:Decodable
{
    let response:Response
    struct Response:Decodable
    {
        let status:Int
        let message:String
        let data:[NotificationData]
        let pagination:Pagination
    }
}

struct NotificationData :Decodable
{
    let id:Int64
    let sender_id:Int64
    let receiver_id:Int64
    let title:String
    let room_id:Int64?
    let type:String
    let message:String
    let is_read:String
    let created:String
    let modified:String
    let user:UserData
    let room:RoomDetails?
    
    struct RoomDetails:Decodable
    {
        let id:Int64
        let room_name:String
        let nick_name:String
        let image:String
        let request_id:Int64
    }
}

struct ChatNotification :Decodable
{
    let id:Int64
    let sender_id:Int64
    let receiver_id:Int64
    let message:String
    let  created:String
    let  modified:String
    let image:String

    struct RoomDetails:Decodable
    {
        let id:Int64
        let room_name:String
        let nick_name:String
        let image:String
        let request_id:Int64
    }
}


