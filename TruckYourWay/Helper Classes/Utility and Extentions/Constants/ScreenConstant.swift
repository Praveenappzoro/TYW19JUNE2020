//
//  ScreenConstant.swift
//  UnSplashSocket
//
//  Created by AppZoro Technologies on 08/05/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import Foundation
import UIKit

struct Device {
    // MARK: - Singletons
    static var TheCurrentDevice: UIDevice {
        struct Singleton {
            static let device = UIDevice.current
        }
        return Singleton.device
    }
    
    static var DeviceID: String {
        struct Singleton {
            static let deviceID = (UIDevice.current.identifierForVendor?.uuidString) ?? ""
        }
        return Singleton.deviceID
    }
    
    static var DeviceToken: String {
        struct Singleton {
            static let deviceToken = "AppDelegateVariable.appDelegate.deviceToken"
        }
        return Singleton.deviceToken
    }
    
    static var TheCurrentDeviceVersion: Float {
        struct Singleton {
            static let version = Float(UIDevice.current.systemVersion)
        }
        return Singleton.version!
    }
    
    static var ScreenHeight: CGFloat {
        struct Singleton {
            static let height = UIScreen.main.bounds.size.height
        }
        return Singleton.height
    }
    
    static var ScreenWidth: CGFloat {
        struct Singleton {
            static let width = UIScreen.main.bounds.size.width
        }
        return Singleton.width
    }
    
    // MARK: - Device Idiom Checks
    static var PHONE_OR_PAD: String {
        if isPhone() {
            return "iPhone"
        } else if isPad() {
            return "iPad"
        }
        return "Not iPhone nor iPad"
    }
    
    static var DEBUG_OR_RELEASE: String {
        #if DEBUG
            return "Debug"
        #else
            return "Release"
        #endif
    }
    
    static var SIMULATOR_OR_DEVICE: String {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return "Simulator"
        #else
            return "Device"
        #endif
    }
    
    static func isPhone() -> Bool {
        return TheCurrentDevice.userInterfaceIdiom == .phone
    }
    
    static func isPad() -> Bool {
        return TheCurrentDevice.userInterfaceIdiom == .pad
    }
    
    static func isDebug() -> Bool {
        return DEBUG_OR_RELEASE == "Debug"
    }
    
    static func isRelease() -> Bool {
        return DEBUG_OR_RELEASE == "Release"
    }
    
    static func isSimulator() -> Bool {
        return SIMULATOR_OR_DEVICE == "Simulator"
    }
    
    static func isDevice() -> Bool {
        return SIMULATOR_OR_DEVICE == "Device"
    }
    
    // MARK: - Device Version Checks
    enum Versions: Float {
        case Five = 5.0
        case Six = 6.0
        case Seven = 7.0
        case Eight = 8.0
        case Nine = 9.0
    }
    
    static func isVersion(version: Versions) -> Bool {
        return TheCurrentDeviceVersion >= version.rawValue && TheCurrentDeviceVersion < (version.rawValue + 1.0)
    }
    
    static func isVersionOrLater(version: Versions) -> Bool {
        return TheCurrentDeviceVersion >= version.rawValue
    }
    
    static func isVersionOrEarlier(version: Versions) -> Bool {
        return TheCurrentDeviceVersion < (version.rawValue + 1.0)
    }
    
    static var CURRENT_VERSION: String {
        return "\(TheCurrentDeviceVersion)"
    }
    
    // MARK: iOS 5 Checks
    static func IS_OS_5() -> Bool {
        return isVersion(version: .Five)
    }
    
    static func IS_OS_5_OR_LATER() -> Bool {
        return isVersionOrLater(version: .Five)
    }
    
    static func IS_OS_5_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(version: .Five)
    }
    
    // MARK: iOS 6 Checks
    static func IS_OS_6() -> Bool {
        return isVersion(version: .Six)
    }
    
    static func IS_OS_6_OR_LATER() -> Bool {
        return isVersionOrLater(version: .Six)
    }
    
    static func IS_OS_6_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(version: .Six)
    }
    
    // MARK: iOS 7 Checks
    static func IS_OS_7() -> Bool {
        return isVersion(version: .Seven)
    }
    
    static func IS_OS_7_OR_LATER() -> Bool {
        return isVersionOrLater(version: .Seven)
    }
    
    static func IS_OS_7_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(version: .Seven)
    }
    
    // MARK: iOS 8 Checks
    static func IS_OS_8() -> Bool {
        return isVersion(version: .Eight)
    }
    
    static func IS_OS_8_OR_LATER() -> Bool {
        return isVersionOrLater(version: .Eight)
    }
    
    static func IS_OS_8_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(version: .Eight)
    }
    
    // MARK: iOS 9 Checks
    static func IS_OS_9() -> Bool {
        return isVersion(version: .Nine)
    }
    
    static func IS_OS_9_OR_LATER() -> Bool {
        return isVersionOrLater(version: .Nine)
    }
    
    static func IS_OS_9_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(version: .Nine)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  =  UIDevice.current.userInterfaceIdiom == .phone && Device.ScreenHeight < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && Device.ScreenHeight == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && Device.ScreenHeight == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && Device.ScreenHeight	 == 736.0
    }
}


