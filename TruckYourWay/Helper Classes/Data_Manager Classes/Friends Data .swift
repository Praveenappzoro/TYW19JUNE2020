//
//  Friends Data .swift
//  UnSplashSocket
//
//  Created by AppZoro Technologies on 05/07/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import Foundation
import UIKit

struct FriendList:Decodable
{
    let response:Response
    
    struct Response:Decodable
    {
        let status:Int64
        let message:String
        let data:[FriendData]
        let pagination:Pagination
    }
}

struct MyFriendList:Decodable
{
    let response:Response
    
    struct Response:Decodable
    {
        let status:Int64
        let message:String
        let data:[MyFriendData]
        let pagination:Pagination
    }
}

struct MyFriendData:Decodable
{
    let id:Int64
    let email:String
    let first_name:String?
    let last_name:String?
    let phone_number:String?
    let image:String
    let friend_status:String?
    let room_invitation_status:String?
    var fullName:String
    {
        return (self.first_name ?? "") + " " + (self.last_name ?? "")
    }
}

struct FriendData:Decodable
{
    let id:Int64
    let email:String
    let first_name:String?
    let last_name:String?
    let phone_number:String?
    let image:String
    let friend_status:String = ""
    let notification_id:Int64
    let created:String = ""
    let room_invitation_status:String = ""
    var fullName:String
    {
        return (self.first_name ?? "") + " " + (self.last_name ?? "")
    }
}

struct PendingFriendReuest:Decodable
{
    let response:Response
    
    struct Response:Decodable
    {
        let status:Int64
        let message:String
        let data:[FriendData]
        
    }
}

struct SendRequest:Decodable
{
    let response:Response
    
    struct Response:Decodable
    {
        let status:Int64
        let message:String
    }
}

struct Pagination:Decodable
{
    let next:Int
    let count:Int64
    let per_page:Int
}
