//
//  ChatHistoryDBTbl.swift
//  UnSplashSocket
//
//  Created by AppZoro Technologies on 21/05/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import Foundation
import UIKit

//struct ChatHistoryDBTblData
//{
//    var message_id: String = "1234"
//    var messageTxt: String = "default message"
//    var peer_id:String = "1234"
//    var creation_time: String = "12/10/2018 2:55 am"
//    var status: String = "sent"
//    var sender_name: String = "Pankaj Gupta"
//    var type:String = "Text"
//    var image: String = "default image"
//    var group_id:String = "123"
//    var group_name:String = "Appzoro technology"
//
//    init?(_ json:NSDictionary)
//    {
//        guard let msgId = json.object(forKey: "message_id") as? String,let peerId = json.object(forKey: "peer_id") as? String,let creationTime = json.object(forKey: "creation_time") as? String,let status = json.object(forKey: "status") as? String,let senderName = json.object(forKey: "sender_name") as? String,let type = json.object(forKey: "type") as? String,let image = json.object(forKey: "image") as? String,let groupId = json.object(forKey: "group_id") as? String,let groupName = json.object(forKey: "group_name") as? String   else {
//            return nil
//        }
//        self.message_id = msgId
//        self.peer_id = peerId
//        self.status = status
//        self.creation_time = creationTime
//        self.group_id = groupId
//        self.group_name = groupName
//        self.image = image
//        self.sender_name = senderName
//        self.type = type
//    }
//}

struct GetChatMessage:Decodable
{
    let response:response
    struct response:Decodable
    {
        let status:Int
        let message:String
        let data:[SendMessageData]
        
    }
}

struct SendMessageData:Codable
{
    let COLUMN_SENDER_ID:String
    let COLUMN_SENDER_NAME:String
    let COLUMN_SENDER_IMAGE:String
    let COLUMN_RECEIVER_ID:String
    let COLUMN_RECEIVER_NAME:String
    let COLUMN_RECEIVER_IMAGE:String
    let COLUMN_MESSAGE:String
    let COLUMN_CREATION_DATE:String
    var COLUMN_MESSAGE_ID:Int = -1
    var COLUMN_MESSAGE_STATUS:String = "0"
}

struct SaveMessageLoacally
{
    let COLUMN_SENDER_ID:String
    let COLUMN_SENDER_NAME:String
    let COLUMN_SENDER_IMAGE:String
    let COLUMN_RECEIVER_ID:String
    let COLUMN_RECEIVER_NAME:String
    let COLUMN_RECEIVER_IMAGE:String
    let COLUMN_MESSAGE:String
    let COLUMN_CREATION_DATE:String
    var COLUMN_MESSAGE_ID:Int = -1
    var COLUMN_MESSAGE_STATUS:String = "0"
    
//    init?(SentData:SendMessageData)
//    {
//        self.sender_id = SentData.sender_id
//        self.peer_id = SentData.peer_id
//        self.message = SentData.message
//        self.name = SentData.name
//        self.image = SentData.image
//        self.type = SentData.type
//        self.creation_time = SentData.creation_time
//        self.group_id = SentData.group_id
//        self.id = SentData.id
//        self.group_name = SentData.group_name
//    }
}
