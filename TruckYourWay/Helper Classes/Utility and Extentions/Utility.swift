
import Foundation
import UIKit
import UserNotifications


class Utility
{
    
    static let sharedInstance = Utility()
    var navBarHeight:CGFloat = 0.0
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    fileprivate init() {}
    func showAlert(_ title:String, msg:String, controller:UIViewController)
    {
        let alertController = UIAlertController(title: title,
                                      message: msg,
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        controller.present(alertController, animated: true, completion: nil)
        
        //KRISHNA
       // controller.showCustomAlertWith(message: msg, actions: nil, isSupportHiddedn: true)
    }
    
    func EINNumberformat(einNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !einNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: einNumber).range(of: einNumber)
        var number = regex.stringByReplacingMatches(in: einNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 9 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 9)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 9 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{2})(\\d+)", with: "$1-$2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{2})(\\d+)", with: "$1-$2", options: .regularExpression, range: range)
        }

        return number
    }
    
    func USPhoneNumberformat(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        
        return number
    }
    
//    func navBarBackgroundImage(viewController:UIViewController)
//    {
//    viewController.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "Header"), for: .default)
//        let attrs = [
//            NSAttributedStringKey.font: UIFont().applicationFont(size: 20),
//            NSAttributedStringKey.foregroundColorNSAttributedStringKey.foregroundColor: UIColor.white
//                    ]
//        viewController.navigationController?.navigationBar.titleTextAttributes = attrs
//    }
    
    //Trim a String 
    func trim(_ str:String) -> String
    {
        let trimString:String = str.trimmingCharacters(in: CharacterSet.newlines)
        return trimString.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
   
    func hasConnectivity() -> Bool
    {
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().hashValue
        return networkStatus != 0
        return false
    }
	
//    func navigationView(controller:UIViewController,title:String) -> UIView
//    {
//        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: controller.view.frame.width, height: 64))
//        view.backgroundColor = UIColor.init(red: 91/255, green: 195/255, blue: 225/255, alpha: 1)
//        let leftBtn = UIButton.init(frame: CGRect.init(x: 10, y: 25, width: 40, height: 30))
//        leftBtn.backgroundColor = UIColor.clear
//        leftBtn.setImage(UIImage(named: "back.png")!, for: .normal)
//        leftBtn.addTarget(self, action: #selector(Utility.sharedInstance.leftBarBtn(controller:controller)), for: .touchUpInside)
//        view.addSubview(leftBtn)
//
//        let titleLbl = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: 30))
//        ti
//
//        return view
//    }
    
    func leftBarBtn(controller:UIViewController)
    {
        controller.navigationController?.popViewController(animated: true)
    }
    
    func convertAllDictionaryValueToNil(_ dict: NSMutableDictionary) -> NSDictionary
    {
        let arrayOfKeys = dict.allKeys as NSArray
        for i in 0..<arrayOfKeys.count
        {
            if (dict.object(forKey: arrayOfKeys.object(at: i))) is NSNull
            {
                dict .setObject("" as AnyObject, forKey: arrayOfKeys.object(at: i) as! String as NSCopying)
            }
        }
        
        return dict
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
    func getMessage(_ data:Data, _ completionHandler:@escaping (String)->())
    {
        var message:String = ""
        do
        {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
            {
                DispatchQueue.main.async
                    {
                        
                        guard let msg = json.object(forKey: "error_message") as? String else {
                            message = "Please try again in a moment."
                            completionHandler(message)
                            return
                        }
                        print(msg)
                        message = msg
                        completionHandler(message)
                    }
                
            }
            else
            {
                DispatchQueue.main.async {
                    message = "Please try again in a moment."
                    completionHandler(message)
                }
                
            }
            
        }
        catch
        {
            //print(error)
            DispatchQueue.main.async
                {
                    message = "Please try again in a moment."
                    completionHandler(message)
            }
            
        }
        
       
    }
    
    func manageDiscDate(dateStr:String) -> String
    {
        let date = dateStr.dateFromISO8601
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy 'at' hh:mm a"
        
        
        let calender = Calendar.current
        
        if calender.isDateInToday(date!) {
            return "Today at \(date!.hour12):\(date!.minute0x) \(date!.amPM)"
        }
        else if calender.isDateInYesterday(date!)
        {
            return "Yesterday at \(date!.hour12):\(date!.minute0x) \(date!.amPM)"
        }
        return formatter.string(from: date!)
    }
    
  
    
    func filterData(passCode:String, attributeName:String, arrSearch:NSMutableArray)->NSMutableArray
    {
        let predicate = NSPredicate(format: "\(attributeName) BEGINSWITH[c] %@", passCode)
        return ((arrSearch.filtered(using: predicate) as NSArray).mutableCopy() as? NSMutableArray)!
    }
    
    
    func makeLink(_ label:ActiveLabel, _ vc:UIViewController)
    {
        
        label.enabledTypes = [.url]
        label.handleURLTap { (linkUrl) in
            if UIApplication.shared.canOpenURL(linkUrl)
            {
                UIApplication.shared.openURL(linkUrl)
            }
            else
            {
                vc.showAlert("Unable to open URL!")
            }
        }
    }
    
    
}

extension UIScrollView {
    var isBouncing: Bool {
        return isBouncingTop || isBouncingLeft || isBouncingBottom || isBouncingRight
    }
    var isBouncingTop: Bool {
        return contentOffset.y < -contentInset.top
    }
    var isBouncingLeft: Bool {
        return contentOffset.x < -contentInset.left
    }
    var isBouncingBottom: Bool {
        let contentFillsScrollEdges = contentSize.height + contentInset.top + contentInset.bottom >= bounds.height
        return contentFillsScrollEdges && contentOffset.y > contentSize.height - bounds.height + contentInset.bottom
    }
    var isBouncingRight: Bool {
        let contentFillsScrollEdges = contentSize.width + contentInset.left + contentInset.right >= bounds.width
        return contentFillsScrollEdges && contentOffset.x > contentSize.width - bounds.width + contentInset.right
    }
}

extension UILabel
{
	func heightForView() -> CGFloat{
		let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.byWordWrapping
		label.font = self.font
		label.text = self.text
		
		label.sizeToFit()
		return label.frame.height
	}
}

extension UIColor
{
    func headerColor() -> UIColor
    {
        return UIColor(red: 77/255, green: 183/255, blue: 217/255, alpha: 1)
    }
}

extension UIFont
{
    func applicationFont(size:CGFloat) -> UIFont
    {
        return UIFont(name: "Helvetica-Bold", size: size)!
    }
}
extension UITableView
{
    func scrollToFirstRow(section:Int) {
        let indexPath = IndexPath(row: 0, section: section)
        self.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

//@available(iOS 10.0, *)
//extension UIViewController: UNUserNotificationCenterDelegate {
//
//
//    //for displaying notification when app is in foreground
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        //If you don't want to show notification when app is open, do something here else and make a return here.
//        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
//
//        completionHandler([.alert, .badge, .sound])
//    }
//
//    // For handling tap and user actions
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//
//        guard let dict = response.notification.request.content.userInfo as? NSDictionary else {return}
//        guard let dataDict = dict.object(forKey: "aps") as? NSDictionary else {return}
//        guard let screenNo = dataDict.object(forKey: "screenNo") as? Int else {return}
//        guard let notificationInfo = dataDict.object(forKey: "extraInfo") as? NSDictionary else {return}
//
//        AppDelegate.sharedDelegate().notificationData = nil
//
//        switch screenNo {
//        case 1:
//            AppDelegate.sharedDelegate().showCommentVC(data: notificationInfo)
//            break
//        case 2:
//            AppDelegate.sharedDelegate().showCommentVC(data: notificationInfo)
//            break
//        case 4:
//            AppDelegate.sharedDelegate().showDiscCommentVC(data: notificationInfo)
//            break
//        case 6:
//            guard let reviewId = notificationInfo.object(forKey: "Id") as? String else {return}
//            AppDelegate.sharedDelegate().showReviewCommentVC(reviewId: Int(reviewId)!)
//            break
//        case 7:
//            AppDelegate.sharedDelegate().openMyProfile()
//            break
//        default:
//            break
//
//        }
//
//        completionHandler()
//    }
//
//}

