//
//  LogInUserData.swift
//  UnSplashSocket
//
//  Created by AppZoro Technologies on 15/05/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import Foundation
import UIKit

typealias Codable = Encodable & Decodable

struct LoggedInUser: Decodable
{
//    let response:Details
    
    let user_id:String?
    let email:String?
    let type:String?
    let first_log_in:String?
    let device_token:String?
    let firstname:String?
    let lastname:String?
    let access_token:String?
    let refresh_token:String?
    let longitude:String?
    let latitude:String?
    let profile_image:String?
    let contact:String?
    let address:String?
    let city:String?
    let state:String?
    let zipcode:String?
    let equipment:String?
    let truck_number:String?
    let ein:String?
    let company:String?
    let company_address:String?
    let company_city:String?
    let company_state:String?
    let company_zipcode:String?
    let truck_image:String?
    let insurance_image1:String?
    let insurance_image2:String?
    let insurance_image3:String?
    let cdl_license:String?
    let license_plate:String?
    let total_trucks:String?
    let ratings:String?
    let active:Int?

    var fullName:String{
        return (self.firstname ?? "")+" "+(self.lastname ?? "")
    }
    
    struct MaterialList:Decodable
    {
        let category:String?
        let material_image:String?
    }
    
    struct Data:Decodable
    {
        let user_id:String?
        let email:String?
        let type:String?
        let device_token:String?
        let firstname:String?
        let lastname:String?
        let access_token:String?
        let refresh_token:String?
        let longitude:String?
        let latitude:String?
        let profile_image:String?
        let contact:String?
        let address:String?
        let city:String?
        let state:String?
        let zipcode:String?
        let company:String?
        let company_address:String?
        let company_city:String?
        let company_state:String?
        let company_zipcode:String?
        var fullName:String{
            return (self.firstname ?? "")+" "+(self.lastname ?? "")
        }
    
    }
    
   
}

struct PdfInitialFull: Decodable
{
    let initialName:String?
    let fullSignature:String?
}

struct DataPdf:Decodable
{
    let initialName:String?
    let fullSignature:String?
}

struct DataError:Decodable
{
    let response:Details
    
    struct Details:Decodable
    {
        let status:Int
        let error:String?
        let message:String?
    }
}


struct CivicRoles:Decodable {
    let civic_role:String
}

struct SocialLink:Decodable
{
    let link_type:String
    let link_url:String
}

struct EditUserData: Codable
{
    let user_id : String
    let name : String
    let email : String
    let city : String
    let state : String
    let address :String
    let active : String
    let profile : String
    let active_groups : String
    var access_token : String
    var refresh_token : String
    let contact:String
    let username:String
    let cover_image:String
}

struct VisibleRooms:Decodable
{
    let id:Int64
    let user_id:Int64
    let visibility:Bool
    let category_id:Int64?
    let room_name:String
    let nick_name:String?
    let image:String?
    let room_description:String?
    let room_status:Bool
    let room_url:String?
    let enabled:String
}


