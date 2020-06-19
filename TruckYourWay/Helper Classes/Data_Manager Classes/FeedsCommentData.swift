//
//  FeedsCommentData.swift
//  UnSplashSocket
//
//  Created by YASH COMPUTERS on 13/07/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import Foundation
import UIKit

struct FeedsCommentData:Decodable
{
    let response:Response
    struct Response:Decodable
    {
        let status:Int64
        let message:String
        let data:[CommentData]
    }
}

struct CommentData:Decodable
{
    let id:Int64
    let room_id:Int64
    let user_id:Int64
    let message:String
    let created:String
    let user:FeedUserData
}

struct SendCommentData:Decodable
{
    let response:Response
    struct Response:Decodable
    {
        let status:Int64
        let message:String
        let data:CommentData
    }
}
