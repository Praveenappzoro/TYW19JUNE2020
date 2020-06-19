//
//  ResponseError.swift
//  UnSplashSocket
//
//  Created by AppZoro Technologies on 15/05/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import Foundation
import UIKit

struct ResponsError: Decodable
{
    let error_type : Int
    let error_name : String
    let error_message : String
}

struct HaulingData
{
    let id : Int
    let quantity : Int
    let size : String
    let category : String
    let material_image : String
    let version_no : String
    let status : String
}

struct DeliveryData: Codable
{
    var id : Int = 0
    var quantity : Int = 0
    var size : String = ""
    var category : String = ""
    var material_image : String = ""
    var version_no : String = ""
    var status : String = ""
    var distance : String = ""
    var uuid : String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case quantity
        case size
        case category
        case material_image
        case version_no
        case status
        case distance
        case uuid
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let idd = try values.decode(Int.self, forKey: .id)
        let qnty = try values.decode(Int.self, forKey: .quantity)
        let siz = try values.decode(String.self, forKey: .size)
        let cat = try values.decode(String.self, forKey: .category)
        let mat_image = try values.decode(String.self, forKey: .material_image)
        let versoin = try values.decode(String.self, forKey: .version_no)
        let stat = try values.decode(String.self, forKey: .status)
        let dis = try values.decode(String.self, forKey: .distance)
        let uid = try values.decode(String.self, forKey: .uuid)

        self.init(id: idd , quantity: qnty , size: siz , category: cat, material_image: mat_image, version_no: versoin, status: stat, dis: dis, uid: uid)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(size, forKey: .size)
        try container.encode(category, forKey: .category)
        try container.encode(material_image, forKey: .material_image)
        try container.encode(version_no, forKey: .version_no)
        try container.encode(status, forKey: .status)
        try container.encode(distance, forKey: .distance)
        try container.encode(uuid, forKey: .uuid)
        
    }

    init(id: Int, quantity: Int, size: String, category: String, material_image: String, version_no: String, status: String, dis: String, uid: String) {
        self.id = id
        self.quantity = quantity
        self.size = size
        self.category = category
        self.material_image = material_image
        self.version_no = version_no
        self.status = status
        self.distance = dis
        self.uuid = uid
    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(quantity, forKey: "quantity")
//        aCoder.encode(size, forKey: "size")
//        aCoder.encode(category, forKey: "category")
//        aCoder.encode(material_image, forKey: "material_image")
//        aCoder.encode(version_no, forKey: "version_no")
//        aCoder.encode(status, forKey: "status")
//    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//        let idd = aDecoder.decodeObject(forKey: "id")
//        let qnty = aDecoder.decodeObject(forKey: "quantity")
//        let siz = aDecoder.decodeObject(forKey: "size")
//        let cat = aDecoder.decodeObject(forKey: "category")
//        let mat_image = aDecoder.decodeObject(forKey: "material_image")
//        let versoin = aDecoder.decodeObject(forKey: "version_no")
//        let stat = aDecoder.decodeObject(forKey: "status")
//
//
//        self.init(idd as! Int, qnty as! Int, siz as! String, cat as! String, mat_image as! String, versoin as! String, stat as! String)
//    }
    
}


struct DeliveryResponse: Codable {
    
    var object: [DeliveryData]
    
    init(object: [DeliveryData]) {
        self.object = object
    }
    
    enum CodingKeys: String, CodingKey {
        case object
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let obj = try values.decode([DeliveryData].self, forKey: .object)
        self.init(object: obj)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(object, forKey: .object)
    }

//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(object, forKey: "object")
//    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//        let object = aDecoder.decodeObject(forKey: "object")
//        self.init(object as! [DeliveryData])
//    }
    
}


