//
//  SampleWatermark.swift
//  TruckYourWay
//
//  Created by Anil Choudhary on 20/02/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import UIKit
import PDFKit
import QuickLook
import AVFoundation

@available(iOS 11.0, *)
class SampleWatermark: PDFPage {
    
    override func draw(with box: PDFDisplayBox, to context: CGContext) {
        super.draw(with: box, to: context)
        
//        let strName =  USER_DEFAULT.value(forKey: pdfInitialName) ?? ""
//        let strSignature =  USER_DEFAULT.value(forKey: pdfSignaturelName) ?? ""
        
//        if( self.pageRef?.pageNumber == 5){
//            let string: NSString = strName as! NSString
//            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont(name: "Carybe", size: 22) ?? UIFont.boldSystemFont(ofSize: 22)]
//            let stringSize = string.size(withAttributes: attributes)
//
//            UIGraphicsPushContext(context)
//            context.saveGState()
//
//            let pageBounds = bounds(for: box)
//            context.translateBy(x: (pageBounds.size.width - stringSize.width) / 2, y: pageBounds.size.height)
//            context.scaleBy(x: 1.0, y: -1.0)
//            string.draw(at: CGPoint(x: pageBounds.midX-85, y: 60), withAttributes: attributes)
//            UIGraphicsBeginPDFPage()
//            context.restoreGState()
//            UIGraphicsPopContext()
//            UIGraphicsBeginPDFPage()
//
//            let string2: NSString = strName as! NSString
//                let attributes2: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont(name: "Carybe", size: 22) ?? UIFont.boldSystemFont(ofSize: 22)]
//                let stringSize2 = string2.size(withAttributes: attributes2)
//
//                UIGraphicsPushContext(context)
//                context.saveGState()
//
//                let pageBounds2 = bounds(for: box)
//                context.translateBy(x: (pageBounds2.size.width - stringSize2.width) / 2, y: pageBounds2.size.height)
//                context.scaleBy(x: 1.0, y: -1.0)
//
//                string2.draw(at: CGPoint(x: pageBounds2.midX-80, y: 258), withAttributes: attributes2)
//
//                context.restoreGState()
//                UIGraphicsPopContext()
//        }
//        if( self.pageRef?.pageNumber == 12){
//            let string: NSString = strSignature as! NSString
//            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont(name: "KaufmannBT-Regular", size: 40) ?? UIFont.boldSystemFont(ofSize: 30)]
//            let stringSize = string.size(withAttributes: attributes)
//
//            UIGraphicsPushContext(context)
//            context.saveGState()
//
//            let pageBounds = bounds(for: box)
//            context.translateBy(x: (pageBounds.size.width - stringSize.width) / 2, y: pageBounds.size.height)
//            context.scaleBy(x: 1.0, y: -1.0)
//            string.draw(at: CGPoint(x: pageBounds.minX-200, y: 250), withAttributes: attributes)
//            context.restoreGState()
//            UIGraphicsPopContext()
//        }
//
    }
//
}
