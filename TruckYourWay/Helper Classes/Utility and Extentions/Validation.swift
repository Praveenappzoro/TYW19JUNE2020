
//
//  Validation.swift
//  Cloneofinstagram
//
//  Created by Mahendra on 17/02/16.
//  Copyright © 2016 brsoftech. All rights reserved.
//

import UIKit

extension String
{
    var length: Int
    {
        return characters.count
    }
}

class Validation: NSObject
{
    class func isEnterCharacter(testString:String) -> Bool
    {
        let emailRegEx = "^[a-zA-Z ]*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testString)
    }
    
   class func isValidEmail(emailString:String) -> Bool
   {
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }
 
    class func isValidMobileNumber(testString:String) -> Bool
    {
        let teststring=testString.trimmingCharacters(in: NSCharacterSet.whitespaces)
        var newString = teststring
        newString = (newString.replacingOccurrences(of: "(", with: "") as NSString) as String
        newString = (newString.replacingOccurrences(of: ")", with: "") as NSString) as String
        newString = (newString.replacingOccurrences(of: "-", with: "") as NSString) as String
        newString = (newString.replacingOccurrences(of: " ", with: "") as NSString) as String

        if newString.length != 10
        {
            return false
        }
        
        let mobileRegex = "^([0-9]*)$"
        let mobileTemp = NSPredicate(format:"SELF MATCHES %@", mobileRegex)
        return mobileTemp.evaluate(with: newString)
    }
    
    class func isblank(testString : String) -> Bool
    {
        let trimstring = testString.trimmingCharacters(in: NSCharacterSet.whitespaces)
        return !trimstring.isEmpty
    }
    
    class func isLengthCorrect(testString : String,type : String) -> Bool
    {
        var strEditableString = ""
        strEditableString = testString.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
        strEditableString = strEditableString.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        strEditableString = strEditableString.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        strEditableString = strEditableString.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
        if(type == "mobile")
        {
           
            if(strEditableString.length < 10)
            {
                return false
            }
            else
            {
                return true
            }
        }
        if(type == "zip")
        {
            if(testString.length < 5)
            {
                return false
            }
            else
            {
                return true
            }
        }
        if(type == "ein")
        {
            if(strEditableString.length < 9)
            {
                return false
            }
            else
            {
                return true
            }
        }
        if(type == "truckNumber")
        {
            if(testString.length < 1)
            {
                return false
            }
            else
            {
                return true
            }
        }
        else
        {
                return true
        }
        
    }
    
    class func getUniqueDeviceIdentifierAsString() -> String
    {
        let appName = (Bundle.main.infoDictionary![(kCFBundleNameKey as String)] as! String)
        var strApplicationUUID = SSKeychain.password(forService: appName, account: "udid")
        if strApplicationUUID == nil
        {
            strApplicationUUID = UIDevice.current.identifierForVendor!.uuidString
            SSKeychain.setPassword(strApplicationUUID, forService: appName, account: "udid")
        }
        return strApplicationUUID!
    }
    
    class func setUserNameAsString(username :String)
    {
        let appName = (Bundle.main.infoDictionary![(kCFBundleNameKey as String)] as! String)
        SSKeychain.setPassword(username, forService: appName, account: "Easycom_UserName")
    }

    class func getUserNameAsString() -> String
    {
        let appName = (Bundle.main.infoDictionary![(kCFBundleNameKey as String)] as! String)
        let strUserName = SSKeychain.password(forService: appName, account: "Easycom_UserName")
        return strUserName!
    }

    class func setPasswordAsString(password :String)
    {
        let appName = (Bundle.main.infoDictionary![(kCFBundleNameKey as String)] as! String)
        SSKeychain.setPassword(password, forService: appName, account: "Easycom_Password")
    }

    class func getPasswordAsString() -> String
    {
        let appName = (Bundle.main.infoDictionary![(kCFBundleNameKey as String)] as! String)
        let strUserName = SSKeychain.password(forService: appName, account: "Easycom_Password")
        return strUserName!
    }
}
