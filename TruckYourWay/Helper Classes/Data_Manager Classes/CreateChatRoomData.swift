//
//  CreateChatRoomData.swift
//  UnSplashSocket
//
//  Created by AppZoro Technologies on 16/05/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import Foundation
import UIKit


enum VisibilityType:String
{
    case All_Trusted_Connections = "All Trusted Connections"
    case Guests_Only = "Guests Only"
}
struct CreateChatRoomData:Decodable
{
    let id: Int
    let code: String
    let members: String
    let admin: String
    let status: String
    let name: String
    let image: String
    let admin_image: String
}

struct AllChatRoomsData:Decodable
{
    let my_rooms:[CreateChatRoomData]
    let shared_rooms:[CreateChatRoomData]
    let public_rooms:[CreateChatRoomData]
}

struct JoinChatRoom:Decodable
{
    let success_type:Int
    let success_message:String
}

struct MyHostedRooms:Decodable
{
    let response:Details
    struct Details:Decodable
    {
        let status:Int
        let message:String
        let data:[ChatData]
    }
    
    struct Data:Decodable
    {
        let id:Int64
        let user_id:Int64
        let visibility:Bool
        let category_id:Int64?
        let room_name:String
        let nick_name:String
        let image:String
        let room_description:String
//        let enabled:String
//        let created:String
//        let modified:String
        let category:CategoryDetails
    }
}

struct MyFavoriteOrGuestRooms:Decodable
{
    let response:Details
    struct Details:Decodable
    {
        let status:Int
        let message:String
        let data:[ChatData]
    }
    
   
}

struct ChatData:Decodable
{
    let id:Int64
    let user_id:Int64
    let visibility:Bool
    let category_id:Int64?
    let room_name:String
    let nick_name:String
    let image:String
    let room_description:String
    let user:UserData
    let category:CategoryDetails?
}

struct UserData:Decodable
{
    let id:Int64
    let first_name:String?
    let last_name:String?
    let email:String?
    let image:String?
    let request_id:Int64?
    var fullName:String{
        return "\(self.first_name ?? "") \(self.last_name ?? "")"
    }
}

struct roomUsers:Decodable
{
    let id:Int64
    let first_name:String?
    let last_name:String?
    let email:String?
    let image:String?
    let friend_status:String?
    var fullName:String{
        return "\(self.first_name ?? "") \(self.last_name ?? "")"
    }
}

struct CategoryDetails:Decodable
{
    let id:Int64
    let category_name:String
}

struct RoomCategories:Decodable
{
    let response:Details
    struct Details:Decodable
    {
        let status:Int
        let message:String
        let data:[Data]
    }
    
    struct Data:Decodable
    {
        let id:Int64
        let category_name:String
        let enabled:String
        let created:String?
        let modified:String?
    }
}


struct SingleRoomDetails:Decodable
{
    let response:Details
    struct Details:Decodable
    {
        let status:Int
        let message:String
        let data:Data
    }
    
    struct Data:Decodable
    {
        let id:Int64
        let user_id:Int64
        let visibility:Bool
        let category_id:Int64?
        let room_name:String
        let nick_name:String
        let image:String
        let room_description:String
        let room_url:String
        let room_status:Bool
        let user:UserData
        let favorite_status:Bool
        let room_users:[roomUsers]
        let category:CategoryDetails?
        let total_connected_users:Int64?
    }
}

struct PendigRoomRequestData:Decodable
{
    let response:Details
    struct Details:Decodable
    {
        let status:Int
        let message:String
        let data:[Data]
    }
    
    struct Data:Decodable
    {
        let id:Int64
        let user_id:Int64
        let room_id:Int64
        let created:String
        let room:room
        let user:user
    }
    struct room:Decodable
    {
        let room_name:String
        let image:String
    }
    struct user:Decodable
    {
        let first_name:String?
        let last_name:String?
        let image:String
        var fullName:String
        {
            return "\(self.first_name ?? "") \(self.last_name ?? "")"
        }
    }
}


