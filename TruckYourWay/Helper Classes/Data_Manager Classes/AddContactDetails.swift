//
//  AddContactDetails.swift
//  UnSplashSocket
//
//  Created by AppZoro Technologies on 18/05/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import Foundation
import UIKit

struct AddContactDetails:Decodable
{
    let ArrEmailConfirmation:[Contacts]
}
struct Contacts:Decodable
{
    let email:String
    let status:String
}

//struct UsersData:Decodable
//{
//    let response:Details
//    
//    struct Details:Decodable
//    {
//        let status:Int
//        let message:String
//        let data:[UserDetails]
//    }
//}
//
//struct UserDetails:Decodable
//{
//    let id:Int64
//    let email:String
//    let first_name:String?
//    let last_name:String?
//    let phone_number:String?
//    let image:String?
//    let friend_status:String
//}


