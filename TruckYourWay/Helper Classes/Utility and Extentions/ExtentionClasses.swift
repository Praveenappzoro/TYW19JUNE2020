//
//  ExtentionClasses.swift
//  Hotelier
//
//  Created by AppZoro Technologies on 26/03/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//
import Foundation
import AVFoundation
import UIKit
import UserNotifications
import PDFKit
//import NVActivityIndicatorView

extension UIViewController:NVActivityIndicatorViewable, UIPopoverPresentationControllerDelegate
{

    func startAnimating(_ message:String)
    {
        let size = CGSize(width: 100, height:50)
        self.startAnimating(size, message: message, type: NVActivityIndicatorType(rawValue: 3)!)
    }
    
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.delegate = self as? UIGestureRecognizerDelegate
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addRightBarBtn(with urlStr:String, selector:Selector, borderWidth:CGFloat)
    {
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        rightBtn.addTarget(self, action: selector, for: .touchUpInside)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView.image = #imageLiteral(resourceName: "menu")
        rightBtn.addSubview(imageView)
        let rightBarBtn = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.setRightBarButton(rightBarBtn, animated: true)
    }
    
    func addRightBarBtn(with image:UIImage, selector:Selector, borderWidth:CGFloat)
    {
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        rightBtn.addTarget(self, action: selector, for: .touchUpInside)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        imageView.image = #imageLiteral(resourceName: "menu")
        rightBtn.addSubview(imageView)
        let rightBarBtn = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.setRightBarButton(rightBarBtn, animated: true)
    }
    
    func addBackButton(with backImage:UIImage?, title:String?, vc:UIViewController)
    {
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        backBtn.tintColor = UIColor.white
        backBtn.backgroundColor = UIColor.red
        if let back = backImage {
            backBtn.setImage(back, for: .normal)
        }
        if let backName = title {
            backBtn.setTitle("  "+backName, for: .normal)
        }
        backBtn.contentHorizontalAlignment = .left
        backBtn.addTarget(vc, action:  #selector(backAction), for: .touchUpInside)
        
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        vc.navigationItem.backBarButtonItem = backBarBtn
        //        vc.navigationController?.navigationItem.setLeftBarButton(backBarBtn, animated: true)
        
    }
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func addBackButton(with backImage:UIImage, title:String) {
        let btnLeftMenu: UIButton = UIButton()
        //        btnLeftMenu.titleLabel?.font = UIFont.init(name: "SF-Pro-Display-Regular", size: 8)
        btnLeftMenu.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btnLeftMenu.setImage(backImage, for: .normal)
        btnLeftMenu.setTitle(title, for: .normal);
        btnLeftMenu.sizeToFit()
        btnLeftMenu.addTarget(self, action: #selector (backButtonClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        print(btnLeftMenu.titleLabel?.font.description ?? "not found")
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backButtonClick(sender : UIButton) {
        self.navigationController?.popViewController(animated: true);
    }
    
    func showAlert(_ msg:String){
        Utility.sharedInstance.showAlert("Alert", msg: msg, controller: self)
    }
    
    func showAlert(with customAction:@escaping ()->(), _ msg:String, _ isShowCancel:Bool){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
            customAction()
        }))
        if isShowCancel
        {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(with title:String, _ customAction:@escaping ()->(), _ msg:String, _ isShowCancel:Bool){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
            customAction()
        }))
        if isShowCancel
        {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func addPopOver(with sourceView:UIView){
        //        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "PopOverVC") as! PopOverVC
        //        popoverContent.modalPresentationStyle = .popover
        //        guard let popover = popoverContent.popoverPresentationController else {return}
        //        popoverContent.preferredContentSize = CGSize(width: 160, height: 100)
        //        popover.delegate = self
        //        popover.sourceView = sourceView
        //        popover.sourceRect = sourceView.bounds
        //        self.present(popoverContent, animated: true, completion: nil)
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func connectUserNotificationDelegate()
    {
        //        if #available(iOS 10.0, *) {
        //            UNUserNotificationCenter.current().delegate = self
        //        } else {
        //            // Fallback on earlier versions
        //        }
    }
    
    @available(iOS 10.0, *)
    func fireMessageNotification(_ chatData:SaveMessageLoacally)
    {
        //creating the notification content
        let content = UNMutableNotificationContent()
        //adding title, subtitle, body and badge
        content.title = chatData.COLUMN_SENDER_NAME
        content.body = chatData.COLUMN_MESSAGE
        content.userInfo = [
            "peer_id":chatData.COLUMN_RECEIVER_ID,
            "message":chatData.COLUMN_MESSAGE,
            "name":chatData.COLUMN_SENDER_NAME,
            "image":chatData.COLUMN_SENDER_IMAGE,
            "type":"0",
            "creation_time":chatData.COLUMN_CREATION_DATE,
            "group_id":"0",
            "group_name":""
            ] as [String:Any]
        content.sound =  UNNotificationSound.default()
        content.badge = 1
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "MessageNotification", content: content, trigger: trigger)
        //adding the notification to notification center
//        if chatData.COLUMN_SENDER_ID != "\(loginUserData.response.data.user_id)"
//        {
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        }
        
    }
    
    func convertToDictionary(responseData: Data) -> [String: Any]?
    {
        do{
            return try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
        }
        catch{
            print(error.localizedDescription)
        }
        return nil
    }
}

class MyButton : UIButton {
    var row : Int?
    var section : Int?
    var material_image : String = ""
}

extension String
{
    func isValidPassword() -> Bool{
        let passwordRegex = "^(?=.*[a-z])(?=.*\\d).{8,20}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isGoofStreghOfPaa() -> Bool{
        let passwordRegex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=_])(?=\\S+$).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func imageWith() -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = .white
        nameLabel.font = UIFont.init(name: "SF-PRO-DISPLAY-REGULAR", size: 17)
        nameLabel.text = "+"+self
        nameLabel.adjustsFontSizeToFitWidth = true
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    func extractURLs() -> [URL] {
        var urls : [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                    urls.append(url)
                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
    
    func isValidEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        if let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx) as NSPredicate? {
            return emailTest.evaluate(with: self)
        }
        return false
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.endIndex.encodedOffset
        } else {
            return false
        }
    }
    
    func checkEnglishPhoneNumberFormat(string: String, text:String) -> (Bool, String){
        var phonetext:String = text
        if string == ""{ //BackSpace
            return (true,phonetext)
        }else if self.count < 3{
            if self.count == 1{
                phonetext = "("
            }
        }else if self.count == 5{
            phonetext = phonetext + ") "
        }
        else if self.count == 10{
            phonetext = phonetext + "-"
        }else if self.count > 14{
            return (false,phonetext)
        }
        return (true,phonetext)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}

//@IBDesignable
extension UIImageView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.showShadow()
            }
        }
    }
    
    func showShadow(shadowColor: CGColor = UIColor.darkGray.cgColor,
                    shadowOffset: CGSize = CGSize.zero,
                    shadowOpacity: Float = 0.5,
                    shadowRadius: CGFloat = 5.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    public func imageFromServerURL(with urlString: String, defaultImage : String?, size:CGSize?) {
        let activty = UIActivityIndicatorView()
        
        if urlString == BSE_URL_LoadMedia{
            return
        }
        self.image = nil
        if let di = defaultImage {
            self.image = UIImage(named: di)
            self.showIndicator(activty: activty)
        }
        
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
            self.removeIndicator(activty: activty)
            return
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache.shared
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let session = URLSession(configuration: configuration)
        session.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                guard let data = data, let downloadedImage = UIImage(data: data) else {
                    print("unable to extract image")
                    return
                }
                ImageCache.shared.save(image: downloadedImage, forKey: urlString)
                if size != nil
                {
                    self.image = self.resizeImage(image: downloadedImage, targetSize: size!)
                }
                else
                {
                    self.image = downloadedImage
                }
                self.layer.masksToBounds = true
                self.removeIndicator(activty: activty)
            })
        }).resume()
    }
    public func resize(height: CGFloat) -> UIImage? {
        let scale = height / self.frame.size.height
        let width = self.frame.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        self.draw(CGRect(x:0, y:0, width:width, height:height))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    func showIndicator(activty:UIActivityIndicatorView){
        activty.frame = CGRect(x: (self.frame.width/2)-20, y: (self.frame.height/2)-20, width: 40, height: 40)
        activty.activityIndicatorViewStyle = .white
        activty.color = UIColor.lightGray
        activty.hidesWhenStopped = true
        self.addSubview(activty)
        activty.startAnimating()
    }
    
    func removeIndicator(activty:UIActivityIndicatorView){
        activty.stopAnimating()
    }
    
    private static var taskKey = 0
    private static var urlKey = 0
    private var currentTask: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var currentURL: URL? {
        get { return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func loadImageAsync(with urlString: String?, defaultImage : String?, size:CGSize?){
        // cancel prior task, if any
        if urlString == BSE_URL_LoadMedia{
            return
        }
        let activty = UIActivityIndicatorView()
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        // reset imageview's image
        self.image = nil
        // allow supplying of `nil` to remove old image and then return immediately
        guard let urlString = urlString else { return }
        // check cache
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
//            self.removeIndicator(activty: activty)
            return
        }
        if let di = defaultImage {
            self.image = UIImage(named: di)
//            self.showIndicator(activty: activty)
        }
        else
        {
            self.backgroundColor = UIColor.lightGray
        }
        // download
        let url = URL(string: urlString)!
        currentURL = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil
            //error handling
            if let error = error {
                // don't bother reporting cancelation errors
                if (error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorCancelled {
                    return
                }
                print(error)
                return
            }
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("unable to extract image")
                return
            }
            ImageCache.shared.save(image: downloadedImage, forKey: urlString)
            if url == self?.currentURL {
                DispatchQueue.main.async {
                    if size != nil{
                        self?.image = self?.resizeImage(image: downloadedImage, targetSize: size!)
                    }
                    else{
                        self?.image = downloadedImage
                    }
                    self?.layer.masksToBounds = true
//                    self?.removeIndicator(activty: activty)
                }
            }
        }
        // save and start new task
        currentTask = task
        task.resume()
    }
}

extension UIImage{
    private static var taskKey = 0
    private static var urlKey = 0
    private var currentTask: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &UIImage.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImage.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var currentURL: URL? {
        get { return objc_getAssociatedObject(self, &UIImage.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImage.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func getImageFromUrl(with arrimgUrls: [String], completion:@escaping ([UIImage]?,Bool)->()) {
        // cancel prior task, if any
        var arrImages:[UIImage] = []
        for i in 0..<arrimgUrls.count
        {
            let urlstr = arrimgUrls[i]
            downloadImage(from: urlstr, i, completionHandler: { (image, tag) in
                DispatchQueue.main.async(execute: {
                    if image != nil{
                        arrImages.insert(image!, at: tag)
                        if tag == arrimgUrls.count-1{
                            completion(arrImages, true)
                        }
                    }
                    else{
                        if tag == arrimgUrls.count-1{
                            completion(nil, false)
                        }
                    }
                })
            })
        }
    }
    
    func downloadImage(from urlStr:String, _ atIndex:Int, completionHandler:@escaping (UIImage?,Int)->()){
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        if let cachedImage = ImageCache.shared.image(forKey: urlStr) {
            completionHandler(cachedImage,atIndex)
        }
        // download
        let url = URL(string: urlStr)!
        currentURL = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil
            //error handling
            if let error = error {
                // don't bother reporting cancelation errors
                if (error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorCancelled {
                    print(error)
                    completionHandler(nil,atIndex)
                    return
                }
                completionHandler(nil,atIndex)
                print(error)
                return
            }
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("unable to extract image")
                completionHandler(nil,atIndex)
                return
            }
            ImageCache.shared.save(image: downloadedImage, forKey: urlStr)
            if url == self?.currentURL {
                DispatchQueue.main.async {
                    completionHandler(downloadedImage,atIndex)
                }
            }
        }
        // save and start new task
        currentTask = task
        task.resume()
    }
}

class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol!
    
    static let shared = ImageCache()
    
    private init() {
        // make sure to purge cache on memory pressure
        observer = NotificationCenter.default.addObserver(forName: .UIApplicationDidReceiveMemoryWarning, object: nil, queue: nil) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

extension UINavigationController
{
    /// Given the kind of a (UIViewController subclass),
    /// removes any matching instances from self's
    /// viewControllers array.
    func removeAnyViewControllers(ofKind kind: AnyClass)
    {
        self.viewControllers = self.viewControllers.filter { !$0.isKind(of: kind)}
    }
    /// Given the kind of a (UIViewController subclass),
    /// returns true if self's viewControllers array contains at
    /// least one matching instance.
    func containsViewController(ofKind kind: AnyClass) -> Bool
    {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
}

@available(iOS 11.0, *)
class ImageStampAnnotation: PDFAnnotation {
    var image: UIImage!
    // A custom init that sets the type to Stamp on default and assigns our Image variable
    init(with image: UIImage!, forBounds bounds: CGRect, withProperties properties: [AnyHashable : Any]?) {
        super.init(bounds: bounds, forType: PDFAnnotationSubtype.stamp, withProperties: properties)
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(iOS 11.0, *)
    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        // Get the CGImage of our image
        guard let cgImage = self.image.cgImage else { return }
        // Draw our CGImage in the context of our PDFAnnotation bounds
        context.draw(cgImage, in: self.bounds)
    }
}
//@IBDesignable
extension UITextField {
    func takeScreenshot(fullName: String) -> UIImage {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
    @IBInspectable var circleShadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadiusView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = cornerRadiusView
            self.clipsToBounds = true
        }
    }
    
    func constraintsToFill(otherView: Any) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: otherView, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: otherView, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: otherView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: otherView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ]
    }
    
    func constraintsToCenter(otherView: Any) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: otherView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: otherView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        ]
    }
    
    func addShadow(){
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5
        self.generateOuterShadow()
    }
    
    open func generateOuterShadow() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = layer.cornerRadius
        view.layer.shadowRadius = layer.shadowRadius
        view.layer.shadowOpacity = layer.shadowOpacity
        view.layer.shadowColor = layer.shadowColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.clipsToBounds = false
        view.tag = 123
        view.backgroundColor = .clear
        superview?.insertSubview(view, belowSubview: self)
        let constraints = [
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            ]
        superview?.addConstraints(constraints)
    }
    
    
    open func generateEllipticalShadow() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = layer.cornerRadius
        view.layer.shadowRadius = layer.shadowRadius
        view.layer.shadowOpacity = layer.shadowOpacity
        view.layer.shadowColor = layer.shadowColor
        view.layer.shadowOffset = CGSize.zero
        view.clipsToBounds = false
        view.backgroundColor = .white
        
        let ovalRect = CGRect(x: 0, y: frame.size.height + 10, width: frame.size.width, height: 15)
        let path = UIBezierPath(ovalIn: ovalRect)
        view.layer.shadowPath = path.cgPath
        superview?.insertSubview(view, belowSubview: self)
        let constraints = [
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            ]
        superview?.addConstraints(constraints)
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

class PaddingLabel: UILabel {
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
extension UILabel {
    func makeLink(){
    }
    
    func underline(_ fontColor:UIColor, _ font:UIFont) {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle,
                                          value: NSUnderlineStyle.styleSingle.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttributes([NSAttributedStringKey.foregroundColor: fontColor], range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttributes([NSAttributedStringKey.font: font], range: NSRange(location: 0, length: attributedString.length))
            
            attributedText = attributedString
        }
    }
    
    func makeLabelTextPosition (positionIdentifier : String){
        let rect = self.textRect(forBounds: bounds, limitedToNumberOfLines: 0)
        
        switch positionIdentifier
        {
        case "VerticalAlignmentTop":
            self.frame = CGRect(x: bounds.origin.x+5, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            //                CGRectMake(bounds.origin.x+5, bounds.origin.y, rect.size.width, rect.size.height)
            break;
        case "VerticalAlignmentMiddle":
            self.frame = CGRect(x: bounds.origin.x+5, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            
            //                CGRectMake(bounds.origin.x+5,bounds.origin.y + (bounds.size.height - rect.size.height) / 2,  rect.size.width, rect.size.height);
            break;
        case "VerticalAlignmentBottom":
            self.frame = CGRect(x: bounds.origin.x+5, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            break;
        default:
            self.frame = bounds;
            break;
        }
    }
}

extension UIButton
{
    func underline() {
        if let textString = self.titleLabel?.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle,
                                          value: NSUnderlineStyle.styleSingle.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray], range: NSRange(location: 0, length: attributedString.length))
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
}

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

public extension UIScrollView {
    public var content_x: CGFloat {
        set(f) {
            contentOffset.x = f
        }
        get {
            return contentOffset.x
        }
    }
    public var content_y: CGFloat {
        set(f) {
            contentOffset.y = f
        }
        get {
            return contentOffset.y
        }
    }
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
    func scrollToLast() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: true)
    }
}

extension Formatter {
    static let monthMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter
    }()
    static let hour12: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h"
        return formatter
    }()
    static let minute0x: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter
    }()
    static let amPM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter
    }()
}
extension Date {
    var monthMedium: String  { return Formatter.monthMedium.string(from: self) }
    var hour12:  String      { return Formatter.hour12.string(from: self) }
    var minute0x: String     { return Formatter.minute0x.string(from: self) }
    var amPM: String         { return Formatter.amPM.string(from: self) }
    
    func getElapsedInterval() -> String
    {
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year" :
                "\(year)" + " " + "years"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month" :
                "\(month)" + " " + "months"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day" :
                "\(day)" + " " + "days"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour" :
                "\(hour)" + " " + "hrs"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "min" :
                "\(minute)" + " " + "min"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "sec" :
                "\(second)" + " " + "sec"
        } else {
            return "Just Now"
        }
    }
}

extension Date
{
    func todayString() -> String{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: Date())
    }
}

extension UITableView {
    func setOffsetToBottom(animated: Bool) {
        self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height), animated: animated)
    }
    
    func scrollToLastRow(animated: Bool, section:Int) {
        if self.numberOfRows(inSection: section) > 0 {
            self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: section)-1, section: section ), at: .bottom, animated: animated)
        }
    }
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate,alertDismissDelegate {
    
    //for displaying notification when app is in foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.userInfo)
//        if var topController = UIApplication.shared.keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//            let alert = UIAlertController(title: "\(notification.request.content.userInfo)", message: nil, preferredStyle: UIAlertControllerStyle.alert)
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { _ in
//                //Cancel Action
//            }))
//
//            topController.present(alert, animated: true, completion: nil)
//            // topController should now be your topmost view controller
//        }
        guard let dicts = notification.request.content.userInfo as? [String:Any] else {return}
        let dict = dicts as NSDictionary
        print(dict )
        guard let strType = dict.value(forKey: "type") as? String else {
            let notification = UNUserNotificationCenter.current()
            notification.removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
            completionHandler([.alert, .badge, .sound])
            return  }
        guard let notType = NotificationType(rawValue: strType) else {
            print("Unable to get type of notification.")
            let notification = UNUserNotificationCenter.current()
            notification.removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
            completionHandler([.alert, .badge, .sound])
            return
        }
        
        switch notType {
        case .jobAccept:
            print("Job Accepted!")
            //            Constant.MyVariables.appDelegate.truckCartModel = nil
            //            Constant.MyVariables.appDelegate.saveTrucCartData()
            //            USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AcceptJobByDriver"), object: nil, userInfo: dicts as [AnyHashable : Any])
            
            break
        case .laterJobAccept:
            let dictMain  = dicts as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            
            let rootVC = Constant.MyVariables.appDelegate.window?.rootViewController
            
            if rootVC is UINavigationController {
                let nav = rootVC as! UINavigationController
                nav.visibleViewController?.showCustomAlertWith(message: alertMessage, actions: nil, isSupportHiddedn: false)
            } else {
                rootVC!.showCustomAlertWith(message: alertMessage, actions: nil, isSupportHiddedn: false)
            }
            
            break
            
        case .laterJobStarted:
            print("Later Job Accepted!")
            let dictMain  = dicts as! NSDictionary
            let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            let alert = CustomAlert(title: alertMessage, image: UIImage(named: "logomain")!, typeAlert: "jobDeclined", ButtonTitle: "OKAY")
            alert.typeAlert = NotificationType.laterJobAccept.rawValue
            alert.dictNotification = dictss.mutableCopy() as! NSMutableDictionary
            alert.delegate = self
            alert.show(animated: true)
            
        case .jobDeclined:
            print("Job Declined")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeclinedJobByDriver"), object: nil, userInfo: dicts as [AnyHashable : Any])
            let dictMain  = dicts as! NSDictionary
            let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
            let truckNumber = dictss.value(forKey: "truck_no") as? String ?? ""
            let alert = CustomAlert(title: "Truck \(truckNumber) has declined your request. Please choose another Service Provider.", image: UIImage(named: "logomain")!, typeAlert: "jobDeclined", ButtonTitle: "OKAY")
            alert.typeAlert = "jobDeclined"
            alert.dictNotification = dictss.mutableCopy() as! NSMutableDictionary
            alert.delegate = self
            alert.show(animated: true)
            break
        case .newJobRequest:
            
            let apsPayload = dicts["aps"] as! [String: AnyObject]
            if let mySoundFile : String = apsPayload["sound"] as? String {
                playSound(fileName: mySoundFile)
            }
            
            let dictMain  = dicts as NSDictionary
            print(dictMain)
            let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
            let b_details = dictss.value(forKey: "bill_details") as! NSDictionary
            let jobType = b_details.value(forKey: "job_type") as? String ?? ""
            let alert = CustomAlert(title: "You have been selected for a new \(jobType.uppercased()) job!", image: UIImage(named: "logomain")!, typeAlert: "newJobRequest", ButtonTitle: "View", (dictss.mutableCopy() as? NSMutableDictionary) )
            alert.typeAlert = "newJobRequest"
            alert.dictNotification = dictss.mutableCopy() as? NSMutableDictionary
            alert.delegate = self
            alert.show(animated: true)
            break
        case .loadEnroute:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadEnRouteNotification"), object: nil, userInfo: dicts as [AnyHashable : Any])
            
            let dictMain  = dicts as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            
            let rootVC = Constant.MyVariables.appDelegate.window?.rootViewController
            
            if rootVC is UINavigationController {
                let nav = rootVC as! UINavigationController
                nav.visibleViewController?.showCustomAlertWith(message: alertMessage, actions: nil, isSupportHiddedn: true)
            } else {
                rootVC!.showCustomAlertWith(message: alertMessage, actions: nil, isSupportHiddedn: false)
            }
            
            break
            
        case .loadCompleted:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoOfLoadsCompleted"), object: nil, userInfo: dicts as [AnyHashable : Any])
            break
        case .jobCompleted:
            let dictMain  = dicts as! NSDictionary
            let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
            checkJobCompletionFor(bill: dictss)
            break
            
        case .accountSuspended:
            USER_DEFAULT.set(nil, forKey: "userData")
            let dictMain  = dicts as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            
            let login = LoginVC.init(nibName: "LoginVC", bundle: nil)
            login.isSuspended = true
            login.alertMessage = alertMessage
            self.navigationController?.pushViewController(login, animated: true)
            break
        case .accountDeleted:
            let dictMain  = dicts as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            
            USER_DEFAULT.set(nil, forKey: "userData")
            let login = LoginVC.init(nibName: "LoginVC", bundle: nil)
            login.isDeleted = true
            login.alertMessage = alertMessage
            self.navigationController?.pushViewController(login, animated: true)
            break
            
        case .deviceChanged:
            let dictMain  = dicts as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            
            USER_DEFAULT.set(nil, forKey: "userData")
            let login = LoginVC.init(nibName: "LoginVC", bundle: nil)
            login.isDeviceChanged = true
            login.alertMessage = alertMessage
            
            self.navigationController?.pushViewController(login, animated: true)
            
        case .nowJobDeleted, .laterJobDeleted:
            let dictMain  = dicts as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            
            let rootVC = Constant.MyVariables.appDelegate.window?.rootViewController
            
            if rootVC is UINavigationController {
                let nav = rootVC as! UINavigationController
                nav.visibleViewController?.showCustomAlertWith(true, message: alertMessage, actions: nil, isSupportHiddedn: false)
            } else {
                rootVC!.showCustomAlertWith(true, message: alertMessage, actions: nil, isSupportHiddedn: false)
            }
            
        case .laterJobReminder:
            let dictMain  = dicts as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            
            let rootVC = Constant.MyVariables.appDelegate.window?.rootViewController
            
            if rootVC is UINavigationController {
                let nav = rootVC as! UINavigationController
                nav.visibleViewController?.showCustomAlertWith(message: alertMessage, actions: nil, isSupportHiddedn: false)
            } else {
                rootVC!.showCustomAlertWith(message: alertMessage, actions: nil, isSupportHiddedn: false)
            }
            
        case .laterJobStart:
            let apsPayload = dicts["aps"] as! [String: AnyObject]
            if let mySoundFile : String = apsPayload["sound"] as? String {
                playSound(fileName: mySoundFile)
            }
            
            let dictMain  = dicts as! NSDictionary
            let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
            //            let b_details = dictss.value(forKey: "bill_details") as! NSDictionary
            //            let jobType = b_details.value(forKey: "job_type") as? String ?? ""
            //            let alert = CustomAlert(title: "You have been selected for a new \(jobType.uppercased()) job!", image: UIImage(named: "logomain")!, typeAlert: "newJobRequest", ButtonTitle: "View")
            //            alert.typeAlert = "newJobRequest"
            //            alert.dictNotification = dictss.mutableCopy() as! NSMutableDictionary
            //            alert.delegate = self
            //            alert.show(animated: true)
            
            
            let jobDetails = JobAcceptDriver.init(nibName: "JobAcceptDriver", bundle: nil)
            let dictNoti  = dictss.mutableCopy() as! NSMutableDictionary
            let arr = dictNoti.value(forKey: "materials") as! NSArray
            jobDetails.isFromNotification = true
            jobDetails.isLaterJob = true
            
            jobDetails.dictConfirmation = dictNoti.mutableCopy() as! NSMutableDictionary
            jobDetails.arrConfirmation = arr.mutableCopy() as! NSMutableArray
            let VC =  window?.visibleViewController()
            VC!.navigationController?.pushViewController(jobDetails, animated: true)
       
        default:
            let notification = UNUserNotificationCenter.current()
            notification.removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
            completionHandler([.alert, .badge, .sound])
        }
        
        let notification = UNUserNotificationCenter.current()
        notification.removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler([.alert, .badge, .sound])
    }
   
    // For handling tap and user actions
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        if var topController = UIApplication.shared.keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//            let alert = UIAlertController(title: "\(response.notification.request.content.userInfo)", message: nil, preferredStyle: UIAlertControllerStyle.alert)
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { _ in
//                //Cancel Action
//            }))
//
//            topController.present(alert, animated: true, completion: nil)
//            // topController should now be your topmost view controller
//        }
        print(response.notification.request.content.userInfo)
        guard let dicts = response.notification.request.content.userInfo as? [String:Any] else {
            return}
        let dict = dicts as? NSDictionary
        
        guard let strType = dict?.value(forKey: "type") as? String else {
            
            let notification = UNUserNotificationCenter.current()
            notification.removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            completionHandler()
            return  }
        
        guard let notType = NotificationType(rawValue: strType) else {
            print("Unable to get type of notification.")
            
            let notification = UNUserNotificationCenter.current()
            notification.removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            completionHandler()
            return
        }

        if UIApplication.shared.applicationState == .active {
            return
        }
        
        switch notType {
        case .jobAccept:
            print("Job Accepted!")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AcceptJobByDriver"), object: nil, userInfo: dicts as [AnyHashable : Any])
            //            Constant.MyVariables.appDelegate.truckCartModel = nil
            //            Constant.MyVariables.appDelegate.saveTrucCartData()
            
            break
        case .laterJobAccept:
            //            print("Later Job Accepted!")
            //            let dictMain  = dicts as NSDictionary
            //            let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
            //            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            //            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            //            let alert = CustomAlert(title: alertMessage, image: UIImage(named: "logomain")!, typeAlert: "jobDeclined", ButtonTitle: "OKAY")
            //            alert.typeAlert = NotificationType.laterJobAccept.rawValue
            //            alert.dictNotification = dictss.mutableCopy() as! NSMutableDictionary
            //            alert.delegate = self
            //            alert.show(animated: true)
            
            let dictMain  = dicts as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            
            let rootVC = Constant.MyVariables.appDelegate.window?.rootViewController
            
            if rootVC is UINavigationController {
                let nav = rootVC as! UINavigationController
                nav.visibleViewController?.showCustomAlertWith(message: alertMessage, actions: nil, isSupportHiddedn: false)
            } else {
                rootVC!.showCustomAlertWith(message: alertMessage, actions: nil, isSupportHiddedn: false)
            }
            
            break
            
        case .laterJobStarted:
            print("Later Job Accepted!")
            let dictMain  = dicts as! NSDictionary
            let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            let alert = CustomAlert(title: alertMessage, image: UIImage(named: "logomain")!, typeAlert: "jobDeclined", ButtonTitle: "OKAY")
            alert.typeAlert = NotificationType.laterJobAccept.rawValue
            alert.dictNotification = dictss.mutableCopy() as! NSMutableDictionary
            alert.delegate = self
            alert.show(animated: true)
            
        case .jobDeclined:
            print("Job Declined")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeclinedJobByDriver"), object: nil, userInfo: dicts as [AnyHashable : Any])
            let dictMain  = dicts as! NSDictionary
            let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
            let truckNumber = dictss.value(forKey: "truck_no") as? String ?? ""
            let alert = CustomAlert(title: "Truck \(truckNumber) has declined your request. Please choose another Service Provider.", image: UIImage(named: "logomain")!, typeAlert: "jobDeclined", ButtonTitle: "OKAY")
            alert.typeAlert = "jobDeclined"
            alert.dictNotification = dictss.mutableCopy() as! NSMutableDictionary
            alert.delegate = self
            alert.show(animated: true)
            break
        case .newJobRequest:
            let apsPayload = response.notification.request.content.userInfo["aps"] as! [String: AnyObject]
            if let mySoundFile : String = apsPayload["sound"] as? String {
                playSound(fileName: mySoundFile)
            }
            let dictMain  = dicts as! NSDictionary
            let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
            let b_details = dictss.value(forKey: "bill_details") as! NSDictionary
            let jobType = b_details.value(forKey: "job_type") as? String ?? ""
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                let alert = CustomAlert(title: "You have been selected for a new \(jobType.uppercased()) job!", image: UIImage(named: "logomain")!, typeAlert: "newJobRequest", ButtonTitle: "View", dictss.mutableCopy() as? NSMutableDictionary)
                alert.typeAlert = "newJobRequest"
                alert.dictNotification = dictss.mutableCopy() as! NSMutableDictionary
                alert.delegate = self
                alert.show(animated: true)
            }
            
            
            break
        case .loadEnroute:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadEnRouteNotification"), object: nil, userInfo: dicts as [AnyHashable : Any])
            let dictMain  = dicts as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            
            let rootVC = Constant.MyVariables.appDelegate.window?.rootViewController
            
            if rootVC is UINavigationController {
                let nav = rootVC as! UINavigationController
                nav.visibleViewController?.showCustomAlertWith(message: alertMessage, actions: nil, isSupportHiddedn: true)
            } else {
                rootVC!.showCustomAlertWith(message: alertMessage, actions: nil, isSupportHiddedn: false)
            }
            
            break
        case .loadCompleted:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoOfLoadsCompleted"), object: nil, userInfo: dicts as [AnyHashable : Any])
            break
        case .jobCompleted:
            let dictMain  = dicts as! NSDictionary
            let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
            checkJobCompletionFor(bill: dictss)
            break
            
        case .accountSuspended:
            let dictMain  = dicts as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            
            USER_DEFAULT.set(nil, forKey: "userData")
            let login = LoginVC.init(nibName: "LoginVC", bundle: nil)
            login.isSuspended = true
            login.alertMessage = alertMessage
            self.navigationController?.pushViewController(login, animated: true)
            
            break
            
        case .accountDeleted:
            
            let dictMain  = dicts as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            
            USER_DEFAULT.set(nil, forKey: "userData")
            let login = LoginVC.init(nibName: "LoginVC", bundle: nil)
            login.isDeleted = true
            login.alertMessage = alertMessage
            
            self.navigationController?.pushViewController(login, animated: true)
            
            break
            
        case .deviceChanged:
            let dictMain  = dicts as! NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            
            USER_DEFAULT.set(nil, forKey: "userData")
            let login = LoginVC.init(nibName: "LoginVC", bundle: nil)
            login.isDeviceChanged = true
            login.alertMessage = alertMessage
            
            self.navigationController?.pushViewController(login, animated: true)
            
            break
            
        case .nowJobDeleted, .laterJobDeleted:
            let dictMain  = dicts as NSDictionary
            guard let apsDict = dictMain.value(forKey: "aps") as? NSDictionary else { return }
            let alertMessage = apsDict.value(forKey: "alert") as? String ?? ""
            let rootVC = Constant.MyVariables.appDelegate.window?.rootViewController
            
            if rootVC is UINavigationController {
                let nav = rootVC as! UINavigationController
                nav.visibleViewController?.showCustomAlertWith(true, message: alertMessage, actions: nil, isSupportHiddedn: false)
            } else {
                rootVC!.showCustomAlertWith(true, message: alertMessage, actions: nil, isSupportHiddedn: false)
            }
            
        case .laterJobStart:
            let apsPayload = dicts["aps"] as! [String: AnyObject]
            if let mySoundFile : String = apsPayload["sound"] as? String {
                playSound(fileName: mySoundFile)
            }
            
            let dictMain  = dicts as! NSDictionary
            let dictss  = dictMain.value(forKey: "payload") as! NSDictionary
            //            let b_details = dictss.value(forKey: "bill_details") as! NSDictionary
            //            let jobType = b_details.value(forKey: "job_type") as? String ?? ""
            //            let alert = CustomAlert(title: "You have been selected for a new \(jobType.uppercased()) job!", image: UIImage(named: "logomain")!, typeAlert: "newJobRequest", ButtonTitle: "View")
            //            alert.typeAlert = "newJobRequest"
            //            alert.dictNotification = dictss.mutableCopy() as! NSMutableDictionary
            //            alert.delegate = self
            //            alert.show(animated: true)
            
            
            let jobDetails = JobAcceptDriver.init(nibName: "JobAcceptDriver", bundle: nil)
            let dictNoti  = dictss.mutableCopy() as! NSMutableDictionary
            let arr = dictNoti.value(forKey: "materials") as! NSArray
            jobDetails.isFromNotification = true
            jobDetails.isLaterJob = true
            
            jobDetails.dictConfirmation = dictNoti.mutableCopy() as! NSMutableDictionary
            jobDetails.arrConfirmation = arr.mutableCopy() as! NSMutableArray
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let VC =  self.window?.visibleViewController()
                VC!.navigationController?.pushViewController(jobDetails, animated: true)
            }
        case .Admin:
            let notification = UNUserNotificationCenter.current()
            notification.removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            completionHandler()
        default:
            
            let notification = UNUserNotificationCenter.current()
            notification.removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            completionHandler()
        }
        
        let notification = UNUserNotificationCenter.current()
        notification.removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        completionHandler()
    }
    
    
    
    func playSound(fileName: String) {
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forAuxiliaryExecutable: fileName) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
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
    
    func TapOnDismiss(getType: String)
    {
        print("NeedTo Call")
    }
    
    func checkJobCompletionFor(bill: NSDictionary) {
        
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {
            return
        }
        let bill_No = bill.value(forKey: "bill_no") as? String ?? ""

        let parameters = [
            "bill_no": bill_No,
            "access_token": self.loginUserData.access_token ?? "",
            "refresh_token": self.loginUserData.refresh_token ?? "",
            ] as [String : Any]
        DispatchQueue.main.async(execute: {
            APIManager.sharedInstance.getDataFromAPI(BSE_URL_CHECK_BILL_COMPETION_CODE, .post, parameters) { (result, data, json, error, msg) in
                
//                switch result
//                {
//                case .Failure:
//                    break
//                case .Success:
                    DispatchQueue.main.async(execute: {
                        print(json as Any)
                        if let status: Bool = json?.value(forKey: "status") as? Bool {
                            if status {
                                let driverRatingVC = DriverRatingVC.init(nibName: "DriverRatingVC", bundle: nil)
                                driverRatingVC.payloadDict = bill.mutableCopy() as! NSMutableDictionary
                                let VC =  self.window?.visibleViewController()
                                VC!.navigationController?.pushViewController(driverRatingVC, animated: true)
                            } else {
                                let VC =  self.window?.visibleViewController()
                                VC!.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    })
//                    break
//                }
            }
        })
        
        
        
//        let driverRatingVC = DriverRatingVC.init(nibName: "DriverRatingVC", bundle: nil)
//        driverRatingVC.payloadDict = bill.mutableCopy() as! NSMutableDictionary
//        let VC =  window?.visibleViewController()
//        VC!.navigationController?.pushViewController(driverRatingVC, animated: true)
    }
    
}

extension UIWindow
{
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if vc.isKind(of: UINavigationController.self) {
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
        } else if vc.isKind(of: UITabBarController.self) {
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom( vc: tabBarController.selectedViewController!)
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController.presentedViewController!)
            } else {
                return vc;
            }
        }
    }
    
    
    
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.width)
    }
}

extension UITapGestureRecognizer {
    struct AssociatedKeys {
        static var row: UInt8 = 0
        static var section: UInt8 = 1
    }
    var tag:Int?
    {
        get
        {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.row) as? Int else {
                return 0
            }
            return value
        }
        set
        {
            if  let value = newValue
            {
                objc_setAssociatedObject(self, &AssociatedKeys.row, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var section:Int?
    {
        get
        {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.section) as? Int else {
                return 0
            }
            return value
        }
        set
        {
            if  let value = newValue
            {
                objc_setAssociatedObject(self, &AssociatedKeys.section, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = CGSize(width: label.attributedText!.width(withConstrainedHeight: label.frame.height), height: label.frame.height)
        textContainer.size = labelSize
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension UIApplication {
    
    var visibleViewController: UIViewController? {

        guard let rootViewController = keyWindow?.rootViewController else {
            return nil
        }

        return getVisibleViewController(rootViewController)
    }
    
    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        
        return rootViewController
    }
}
