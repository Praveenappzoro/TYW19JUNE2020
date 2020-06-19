
import Foundation
import UIKit
import GooglePlaces

// Development Server Url Truck your Way(TYW)

//#if DEBUG
//let Main_BSE_URL = "http://18.191.220.132/clone/v18042020/scripts/"
//#else
let Main_BSE_URL = "http://18.191.220.132/apis/scripts/" // LIVE SERVER
//#endif

//Production: http://18.191.220.132/apis/scripts/

//let Main_BSE_URL = "http://18.191.220.132/apis/scripts/" // LIVE SERVER
//let Main_BSE_URL = "http://18.191.220.132/test_apis/scripts/" // TEST SERVER
//let Main_BSE_URL = "http://192.168.1.129/TYW-backend/api/scripts/" //TEST Local
//let Main_BSE_URL = "http://192.168.1.106/TYW-Backend/api/scripts/" //TEST Local ROHAN


let MSGTRY : String = "Please try again in a moment."
let JobAcceptingPrefrence : String = "JobAccepting"
let LatitudePrefrence : String = "LatitudePrefrence"
let LongitudePrefrence : String = "LongitudePrefrence"

let ConstantStringForTruckNumber : String = "abcdefghijklmnopqrtuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//let Google_Map_Key = "AIzaSyDFQFVHtEjJSwayIRCa4eS9YVO7MJPvOXk" // for Appzoro Account

//let Google_Map_Key = "AIzaSyCu9RKDJsdH6j-89p6tcSu0eyBZmobnxVg" // for Turns account
let Google_Map_Key = "AIzaSyBLSy1njD-xFsNFwFQ8AgyEQIIxIOgo2U8" // Same as Android
//let Google_Map_Key = "AIzaSyCHQULgFeDaAJQLC-obSUNiIboPyq_oxhw" // New key generated



//GMSServices.provideAPIKey("AIzaSyCu9RKDJsdH6j-89p6tcSu0eyBZmobnxVg")

let BSE_URL_Privcy_Policy = "http://18.222.224.145:8000/tyw_admin/privacy.html"
let BSE_URL_Privcy_terms = "http://18.222.224.145:8000/tyw_admin/terms.html"
let BSE_URL_Cancelation_Policy = "http://18.222.224.145:8000/tyw_admin/cancellation-policy.html"
//let BSE_URL_HELP = "http://18.222.224.145:8000/tyw_admin/help.html"
let BSE_URL_HELP = "http://www.truckyourway.com/"


//let BSE_URL_PDF_File = "https://s3.amazonaws.com/tywbeta/1550570285F37SUU.pdf"
let BSE_URL_PDF_File = "https://s3.amazonaws.com/tywbeta/1561567975LG3S45.pdf"


let BSE_URL_UploadMedia = Main_BSE_URL+"upload_media.php"

let BSE_URL_LOGIN   = Main_BSE_URL+"login.php"
let BSE_URL_REGISTER   = Main_BSE_URL+"register.php"
let BSE_URL_forgot_password = Main_BSE_URL+"forgot_password.php"
let BSE_URL_change_password = Main_BSE_URL+"change_password.php"
let BSE_URL_EDIT_PROFILE = Main_BSE_URL+"edit_profile.php"
let BSE_URL_LOAD_MATERIALS = Main_BSE_URL+"load_materials.php"
let BSE_URL_LOAD_MATERIAL_BY_LOCATION = Main_BSE_URL+"load_material_by_location.php"
let BSE_URL_CALCULATE_BILL = Main_BSE_URL+"calculate_bill.php"
let BSE_URL_GENERATE_TOKEN = Main_BSE_URL+"generate_token.php"
let BSE_URL_PAY_BILL = Main_BSE_URL+"pay_bill.php"
let BSE_URL_GET_BILL_DRIVERS = Main_BSE_URL+"get_bill_drivers.php"
let BSE_URL_GET_CONSUMER_JOBS = Main_BSE_URL+"get_consumer_jobs.php"
let BSE_URL_SUBMIT_DRIVER = Main_BSE_URL+"submit_drivers.php"
let BSE_URL_ACCEPTING_JOBS = Main_BSE_URL+"accepting_jobs.php"
let BSE_URL_ACCEPT_JOB = Main_BSE_URL+"accept_job.php"
let BSE_URL_ACCEPT_LATER_JOB = Main_BSE_URL+"accept_later_job.php"
let BSE_URL_REGISTER_SERVICE = Main_BSE_URL+"register_service.php"
let BSE_URL_GET_DRIVER_JOBS = Main_BSE_URL+"get_driver_jobs.php"
let BSE_URL_GET_CONSUMER_HISTORY_MONTHS = Main_BSE_URL+"get_consumer_history_months.php"
let BSE_URL_GET_DRIVER_HISTORY_MONTHS = Main_BSE_URL+"get_driver_history_months.php"
let BSE_URL_GET_CONSUMER_MONTH_JOBS =  Main_BSE_URL+"get_consumer_month_jobs.php"
let BSE_URL_GET_DRIVER_MONTH_JOBS =  Main_BSE_URL+"get_driver_month_jobs.php"

let BSE_URL_GET_LATER_JOBS = Main_BSE_URL+"get_later_jobs.php"
let BSE_URL_START_JOB_LOADS = Main_BSE_URL+"start_job_loads.php"
let BSE_URL_COMPLETE_JOB_LOADS = Main_BSE_URL+"complete_job_loads.php"
let BSE_URL_START_GET_LOCATION = Main_BSE_URL+"get_location.php"
let BSE_URL_UPDATE_LOCATION = Main_BSE_URL+"update_location.php"
let BSE_URL_GET_BILL_FIRST_DRIVER = Main_BSE_URL+"get_bill_first_driver.php"
let BSE_URL_RATE_DRIVER = Main_BSE_URL+"rate_driver.php"
let BSE_URL_GET_TRAKING_ID_DETAILS = Main_BSE_URL+"get_tracking_id_details.php"
let BSE_URL_LOAD_HAULING_MATERIAL = Main_BSE_URL+"load_hauling_materials.php"
let BSE_URL_CHECK_SUSPENSION = Main_BSE_URL+"check_suspension.php"
let BSE_URL_UPDATE_ISP_CONTRACT = Main_BSE_URL+"update_isp_contract.php"
let BSE_URL_GET_USER_DETAILS = Main_BSE_URL+"get_user_details.php"
let BSE_URL_Logout = Main_BSE_URL+"logout.php"
let BSE_URL_APPLY_PROMO_CODE = Main_BSE_URL+"apply_promo_code.php"
let BSE_URL_CHECK_BILL_COMPETION_CODE = Main_BSE_URL+"check_bill_completion.php"
let BSE_URL_load_specific_category_distance = Main_BSE_URL+"load_specific_category_distance.php"

let BSE_URL_get_later_jobs = Main_BSE_URL + "get_later_jobs.php"
let BSE_get_consumer_jobs = Main_BSE_URL + "get_consumer_jobs.php"
let BSE_get_provider_current_job = Main_BSE_URL + "get_driver_running_job.php"
let DeviceToken_Preference = USER_DEFAULT.value(forKey: "DeviceToken") as? String ?? ""
let tywHelpPhoneNumber =  "4704241061"// (470) 424-1061 //"18002223333"
let pdfInitialName = "pdfInitial"
let pdfSignaturelName = "pdfSignature"
let tywAgreementPdf = "TYWAgreementPdf"
let cordinatesForCentralAtlanta = CLLocation(latitude: 33.7490, longitude: -84.3880)


let themeColorOrange = UIColor.init(red: 206.0/255.0, green: 114.0/255.0, blue: 54.0/255.0, alpha: 1.0)
let themeColorGreen = UIColor.init(red: 156.0/255.0, green: 190.0/255.0, blue: 56.0/255.0, alpha: 1.0)

let themeColorOrangeForLayer = UIColor.init(red: 206.0/255.0, green: 114.0/255.0, blue: 54.0/255.0, alpha: 1.0).cgColor
let themeColorGreenForLayer = UIColor.init(red: 156.0/255.0, green: 190.0/255.0, blue: 56.0/255.0, alpha: 1.0).cgColor

let BSE_URL_LoadMedia = "https://s3.amazonaws.com/tywbeta/"

let USER_DEFAULT = UserDefaults.standard

let rememberMe_Email = "RememberMeEmail"

let stringFromDate = Date().iso8601   //"2017-01-19T10:20:07+00:00"
let dateFromString = stringFromDate.dateFromISO8601!

let CURRENT_DATE = dateFromString.iso8601 as String

let TYW_ID_SUFFIX = "TYW_00"


let APP_STATE_KEY = "APP_STATE_KEY"
let TRUCK_CART_KEY = "TRUCK_CART_KEY"
let ACCEPT_JOB_KEY = "ACCEPT_JOB_KEY"


let arrayUsState: NSArray = ["Alabama","Alaska","American Samoa","Arizona","Arkansas","California","Colorado","Connecticut"
    ,"Delaware","District of Columbia","Florida","Georgia","Guam","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky"
    ,"Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada"
    ,"New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Northern Marianas Islands","Ohio"
    ,"Oklahoma","Oregon","Pennsylvania","Puerto Rico","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah",
     "Vermont","Virginia","Virgin Islands","Washington","West Virginia","Wisconsin","Wyoming"]


enum OptionalsEINCompanyTitles:String {
    case EINNumber = "EIN  Number (optional)"
    case CompanyName = "Company Name (optional)"
    case CompanyAddress = "Company Address"
}

enum MandetoryEINCompanyTitles:String {
    case EINNumber = "EIN  Number"
    case CompanyName = "Company Name"
    case CompanyAddress = "Company Address"
}

struct Constant
{
    struct MyVariables
    {
        //static var yourVariable = "someString"
        static var appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    static let font = Constant.Font()
    struct Font
    {
        func SetFontSize(_ fontsize:CGFloat ) -> UIFont
        {
            return UIFont(name:"Brandon Grotesque", size:fontsize)!
        }
    }
    static let showPopupView = Constant.showPopup()
    struct showPopup
    {
        func showAlertViewWithAlertView(_ viewAlert : UIView, WithBlackTransperentView viewblackTransperent: UIView, WithAlertShowBool isAlertShow: Bool )
        {
            if isAlertShow
            {
                viewAlert.transform = CGAffineTransform(scaleX: 0, y: 0)
                viewAlert.isHidden = false
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    viewAlert.transform = CGAffineTransform.identity
                    viewblackTransperent.isHidden = false
                    }, completion: { (isDone) -> Void in
                })
            }
            else
            {
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    viewAlert.transform = CGAffineTransform.identity
                    viewAlert.transform = CGAffineTransform(scaleX: 0, y: 0)
                    viewblackTransperent.isHidden = true
                    }, completion: { (isDone) -> Void in
                        viewAlert.isHidden = true
                })
            }
        }
    }
    
    struct slideMenuColors
    {
        static let colorTabNewsFeed = UIColor.init(red: 83/255, green: 180/255, blue: 223/255, alpha: 1)
        static let colorTabSearch = UIColor.init(red: 47/255, green: 164/255, blue: 217/255, alpha: 1)
        static let colorTabVendorReviews = UIColor.init(red: 28/255, green: 156/255, blue: 214/255, alpha: 1)
        static let colorTabDiscussion = UIColor.init(red: 29/255, green: 124/255, blue: 167/255, alpha: 1)
        static let colorTabShare = UIColor.init(red: 0/255, green: 80/255, blue: 125/255, alpha: 1)
        static let colorTabLogOut = UIColor.init(red: 0/255, green: 36/255, blue: 60/255, alpha: 1)
    }
    
    
    
}


func getResponseFromServer (urlString : String , postDictionry : NSDictionary) ->NSMutableDictionary
{
    var resultDictionary : NSMutableDictionary = [:]
        return resultDictionary
    
}




struct AppDelegateVariable
{
    //static var yourVariable = "someString"
    static var appDelegate = UIApplication.shared.delegate as! AppDelegate
}
func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage
{
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
    image.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}
//MARK: ---- Time Difference
func dateDiff(dateStr:String) -> String {
    let f:DateFormatter = DateFormatter()
    f.timeZone = NSTimeZone.local
    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    let now = f.string(from: NSDate() as Date)
   // let startDate = f.date(from: dateStr)
     let startDate = f.date(from: dateStr)
    let endDate = f.date(from: now)
   let calendar = NSCalendar.current
    
//    let calendarUnits = NSCalendar.Unit.CalendarUnitWeekOfMonth | NSCalendar.Unit.CalendarUnitDay | NSCalendar.Unit.CalendarUnitHour | NSCalendar.Unit.CalendarUnitMinute | NSCalendar.Unit.CalendarUnitSecond
    
    
   // let calendarUnits = calendar.dateComponents([.day, .month, .year, .hour , .minute , .second], from: self)
    let dateComponents =   calendar.dateComponents([.day, .month, .year, .hour , .minute , .second , .weekOfYear], from: startDate!,  to: endDate!)
    //    calendar.components([.day, .month, .year, .hour , .minute , .second], fromDate: startDate!, toDate: endDate!, options: .calendar)
    
    let weeks = Int(dateComponents.weekOfYear!)
    let days = Int(dateComponents.day!)
    let hours = Int(dateComponents.hour!)
    let min = Int(dateComponents.minute!)
    let sec = Int(dateComponents.second!)
    
    var timeAgo = ""
    
    if (sec >= 0){
        if (sec <= 1)
        {
            timeAgo = "Just Now"
        }
        else if (sec > 1)
        {
            timeAgo = "\(sec) Seconds Ago"
            } else
                {
                    timeAgo = "\(sec) Second Ago"
                }
        }
        else
        {
            timeAgo = "Just Now"
        }
    
    if (min > 0){
        if (min > 1) {
            timeAgo = "\(min) Minutes Ago"
        } else {
            timeAgo = "\(min) Minute Ago"
        }
    }
    
    if(hours > 0){
        if (hours > 1) {
            timeAgo = "\(hours) Hours Ago"
        } else {
            timeAgo = "\(hours) Hour Ago"
        }
    }
    
    if (days > 0) {
        if (days > 1) {
            timeAgo = "\(days) Days Ago"
        } else {
            timeAgo = "\(days) Day Ago"
        }
    }
    
    if(weeks > 0){
        if (weeks > 1) {
            timeAgo = "\(weeks) Weeks Ago"
        } else {
            timeAgo = "\(weeks) Week Ago"
        }
    }
    
    print("timeAgo is===> \(timeAgo)")
    return timeAgo;
}
//MARK: ------- Get Date formate According App



//MARK: ------ OPEN URL
func open(scheme: String)
{
    if let url = URL(string: scheme)
    {
        if #available(iOS 10, *)
        {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler:
                {
                                        (success) in
                                        print("Open \(scheme): \(success)")
                })
        }
        else
        {
            let success = UIApplication.shared.openURL(url)
            print("Open \(scheme): \(success)")
        }
    }
}

func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
    let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedStringKey.font:font])
    let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
    let size = CGSize.init(width: rect.size.width, height: rect.size.height)
    
    return size
}
func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage
{
    
    let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
    
    let contextSize: CGSize = contextImage.size
    
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var cgwidth: CGFloat = CGFloat(width)
    var cgheight: CGFloat = CGFloat(height)
    
    // See what size is longer and create the center off of that
    if contextSize.width > contextSize.height {
        posX = ((contextSize.width - contextSize.height) / 2)
        posY = 0
        cgwidth = contextSize.height
        cgheight = contextSize.height
    } else {
        posX = 0
        posY = ((contextSize.height - contextSize.width) / 2)
        cgwidth = contextSize.width
        cgheight = contextSize.width
    }
    
    let rect: CGRect = CGRect.init(x: posX, y: posY, width: cgwidth, height: cgheight)
        
      //  CGRectMake(posX, posY, cgwidth, cgheight)
    
    // Create bitmap image from context using the rect
    let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
    
    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    
    return image
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
//func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
//    let label:UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
//    label.numberOfLines = 0
//    label.lineBreakMode = NSLineBreakMode.byWordWrapping
//    label.font = font
//    label.text = text
//    
//    label.sizeToFit()
//    return label.frame.height
//}

public extension UIDevice
{
    
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case Unknown
    }
    var screenType: ScreenType
    {
        guard iPhone else { return .Unknown}
        switch UIScreen.main.nativeBounds.height
        {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return .Unknown
        }
    }
    
}
extension String
{
    func capitalizingFirstLetter() -> String
    {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter()
    {
        self = self.capitalizingFirstLetter()
    }
}
extension UILabel
{
    
   
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.width) )
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height
    }
    
   }
extension UIImageView
{
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit)
    {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit)
    {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize.init(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize.init(width: size.width * widthRatio, height:  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 2.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}


extension Date {
    
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss" // commented by jiten 
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        // "2017-01-19T10:20:07+00:00"
        return formatter
    }()
    var iso8601: String
    {
        return Date.iso8601Formatter.string(from: self)
    }
    
    
}

extension String {
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}




//MARK: ----- Encode/Decode Emoji
extension String {
    var decodeEmoji: String? {
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if decodedStr != nil{
            return decodedStr as String?
        }
        return self
    }
}
extension String
{
    var encodeEmoji: String? {
        let encodedStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
        return encodedStr as? String
    }
}

//MARK: ---- ROTATE IMAGE 
extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        bitmap!.rotate(by: degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        
        
        
        //CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage.typeID)
        bitmap!.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UILabel {
    
//    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
//        let readMoreText: String = trailingText + moreText
//
//        let lengthForVisibleString: Int = self.vissibleTextLength()
//        let mutableString: String = self.text!
//        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.characters.count)! - lengthForVisibleString)), with: "")
//        let readMoreLength: Int = (readMoreText.characters.count)
//        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.characters.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
//        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedStringKey.font: self.font])
//        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedStringKey.font: moreTextFont, NSAttributedStringKey.foregroundColor: moreTextColor])
//        answerAttributed.append(readMoreAttributed)
//        self.attributedText = answerAttributed
//    }
    
//    func vissibleTextLength() -> Int {
//        let font: UIFont = self.font
//        let mode: NSLineBreakMode = self.lineBreakMode
//        let labelWidth: CGFloat = self.frame.size.width
//        let labelHeight: CGFloat = self.frame.size.height
//        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
//
//        let attributes: [AnyHashable: Any] = [NSAttributedStringKey.font: font]
//        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as! [String : Any])
//        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
//
//        if boundingRect.size.height > labelHeight {
//            var index: Int = 0
//            var prev: Int = 0
//            let characterSet = CharacterSet.whitespacesAndNewlines
//            repeat {
//                prev = index
//                if mode == NSLineBreakMode.byCharWrapping {
//                    index += 1
//                } else {
//                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.characters.count - index - 1)).location
//                }
//            } while index != NSNotFound && index < self.text!.characters.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [String : Any], context: nil).size.height <= labelHeight
//            return prev
//        }
//        return self.text!.characters.count
//    }
}
