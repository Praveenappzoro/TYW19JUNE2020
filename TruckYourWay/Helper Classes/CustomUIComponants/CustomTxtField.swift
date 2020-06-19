//
//  CustomTxtField.swift
//  Hotelier
//
//  Created by AppZoro Technologies on 26/03/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import UIKit

class CustomTxtField: UITextField
{
    
    fileprivate let borderTop = CALayer()
    fileprivate let borderLeft = CALayer()
    fileprivate let borderBottom = CALayer()
    fileprivate let borderRight = CALayer()
    
    open var txtFieldObj: Any!
    open var textSetion:Int!
    open var textRow:Int!
    open var isToolBar = true // true - code working as default done button for date picker or time picker or date and time picker. Flase - override this function and add next previous or done button
    
    var row : Int?
    var section : Int?
    
    open var paddingTop:      CGFloat = 0
   @IBInspectable open var paddingLeft:CGFloat = 0
   {
        didSet
        {
            UIEdgeInsetsMake(0, paddingLeft, 0, 0)
        }
    }
    
    
    open var paddingBottom:   CGFloat = 0
    @IBInspectable open var paddingRight:CGFloat = 0
    {
        didSet
        {
            UIEdgeInsetsMake(0, 0, 0, paddingRight)
        }
    }//24 For cross button
    
    @IBInspectable open var leftViewImage:UIImage? {
        didSet
        {
            self.setLeftViewImage(leftViewImage!)
        }
    }
    
    func placeHolders(imageName:String, text: String) -> NSAttributedString
    {
        
        var newBounds = bounds
        newBounds.origin.x += paddingLeft
        newBounds.origin.y += paddingTop
        newBounds.size.height -= paddingTop + paddingBottom
        newBounds.size.width -= paddingLeft + paddingRight
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        attachment.bounds = CGRect(x: newBounds.origin.x, y: newBounds.origin.y-5, width: 20, height: 20)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: "")
        myString.append(attachmentStr)
        let myString1 = NSMutableAttributedString(string: text)
        myString.append(myString1)
        self.attributedPlaceholder = myString
    return myString
  }
    
    @IBInspectable open var rightViewImage:UIImage? {
        didSet
        {
            self.setRightViewImage(rightViewImage!)
        }
    }
    
    
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!, NSAttributedStringKey.font: self.font!])
        }
    }
    
    
    
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }    }
    
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet { layer.cornerRadius = cornerRadius }    }
    
    @IBInspectable open var borderColor: UIColor? {
        didSet { layer.borderColor = borderColor?.cgColor }
    }
    
    // MARK:- Set Placeholder Color
//   override open var placeholderColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22) {
//        didSet{ changeAttributedPlaceholderColor() }
//    }
//
//    fileprivate func changeAttributedPlaceholderColor() {
//
//        if (self.attributedPlaceholder?.length != nil) {
//            if self.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
//
//                self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
//            }
//        }
//    }
    
    // MARK:- Set Placeholder New Bounds
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    fileprivate func newBounds(_ bounds: CGRect) -> CGRect {
        
        var newBounds = bounds
        newBounds.origin.x += paddingLeft
        newBounds.origin.y += paddingTop
        newBounds.size.height -= paddingTop + paddingBottom
        newBounds.size.width -= paddingLeft + paddingRight
        return newBounds
    }
    
    // MARK:- Set Input Picker
    open var inputPicker: Bool = false { didSet{ setInputTyePicker() } }
    fileprivate func setInputTyePicker() {
        
        if inputPicker {
            let pickerView  : UIPickerView = UIPickerView()
            self.inputView = pickerView
            
            pickerView.tag = self.tag
            if isToolBar {
                self.addTootalBar(for: nil, type: .done)
            }
        }
    }
    
    // MARK:- Set Time Picker
    open var timePicker: Bool = false { didSet{ setInputTypeTimePicker() } }
    fileprivate func setInputTypeTimePicker() {
        
        if timePicker {
            
            let datePickerView  : UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.time
            self.inputView = datePickerView
            datePickerView.tag = self.tag
            datePickerView.addTarget(self, action: #selector(self.updateTimeTextField(_:)), for: UIControlEvents.valueChanged)
            if isToolBar {
                self.addTootalBar(for: nil, type: .done)
            }
        }
    }
    
    @objc func updateTimeTextField(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        self.text = formatter.string(from: sender.date)
    }
    
    // MARK:- Set Date Picker
    open var datePicker: Bool = false { didSet{ setInputTyeDatePicker() } }
    fileprivate func setInputTyeDatePicker() {
        
        if datePicker {
            
            let datePickerView  : UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            let currentDate: Date = Date()
            //for maximumDate components
            //let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
            //let components: NSDateComponents = NSDateComponents()
            //components.calendar = calendar
            //components.year = -18
            //let minDate: NSDate = calendar.dateByAddingComponents(components, toDate: currentDate, options: nil)!
            //components.year = 0
            //let maxDate: NSDate = calendar.dateByAddingComponents(components, toDate: currentDate, options: nil)!
            datePickerView.maximumDate = currentDate
            
            self.inputView = datePickerView
            datePickerView.tag = self.tag
            datePickerView.addTarget(self, action: #selector(self.updateDateTextField(_:)), for: UIControlEvents.valueChanged)
            if isToolBar {
                self.addTootalBar(for: nil, type: .done)
            }
        }
    }
    
    @objc func updateDateTextField(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        //formatter.dateStyle = .ShortStyle
        self.text = formatter.string(from: sender.date)
    }
    
    func inputAccessoryViewDidFinish(_ sender:AnyObject) {
        self.resignFirstResponder()
    }
    
    // MARK:- Set Line View
    
    // Set Lines in UITextField like Material design in Android
    
    open var linesWidth: CGFloat = 0.5 { didSet{ drawLines() } }
    open var linesColor: UIColor = UIColor.lightGray { didSet{ drawLines() } }
    
    open var leftLine: Bool   = false { didSet{ drawLines() } }
    open var rightLine: Bool  = false { didSet{ drawLines() } }
    open var bottomLine: Bool = false { didSet{ drawLines() } }
    open var topLine: Bool    = false { didSet{ drawLines() } }
    
    fileprivate func drawLines() {
        
        if bottomLine {
            //let border = CALayer()
            borderBottom.frame = CGRect(x: 0.0, y: frame.size.height - linesWidth, width: frame.size.width, height: linesWidth)
            borderBottom.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderBottom)
        }
        
        if topLine {
            //let border = CALayer()
            borderTop.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: linesWidth)
            borderTop.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderTop)
        }
        
        if rightLine {
            //let border = CALayer()
            borderRight.frame = CGRect(x: frame.size.width - linesWidth, y: 0.0, width: linesWidth, height: frame.size.height);
            borderRight.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderRight)
        }
        
        if leftLine {
            //let border = CALayer()
            borderLeft.frame = CGRect(x: 0.0, y: 0.0, width: linesWidth, height: frame.size.height);
            borderLeft.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderLeft)
        }
    }
}

extension CustomTxtField
{
    
    public func updateAppearance(_ color: UIColor? = UIColor.lightGray) {
        self.bottomLine = true
        self.linesWidth = 1.0
        self.linesColor = color!
    }
    
    public func setLeftViewImage(_ textFieldImg: UIImage!) {
        
        //setting left image
        
        self.paddingLeft = 40
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let paddingImage = UIImageView()
        paddingImage.image = textFieldImg
        paddingImage.contentMode = .center
        paddingImage.frame = CGRect(x: 6, y: 6, width: 25, height: 25)
        paddingView.addSubview(paddingImage)
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.always
    }
    
    
    public func setRightViewImage(_ textFieldImg: UIImage!) {
        
        //setting right image
        self.paddingRight = 40
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
//        paddingView.contentMode = .center
        let paddingImage = UIImageView()
        paddingImage.image = textFieldImg
        paddingImage.contentMode = .center
        paddingImage.frame = CGRect(x: 0, y: 6, width: 25, height: 25)
        paddingView.addSubview(paddingImage)
        paddingView.isUserInteractionEnabled = false
        self.rightView = paddingView
        self.rightViewMode = UITextFieldViewMode.always
    }
}


// MARK: - Add Tootbar
extension CustomTxtField {
    
    enum tagType : Int {
        case next = 0
        case previous
        case done
        
        var text : String {
            switch self {
            case .next:
                return "Next"
            case .previous:
                return "Previous"
            default:
                return "Done"
            }
        }
    }
    
    
    func addTootalBar(for txtF : Any?, type : tagType) {
        isToolBar = false
        txtFieldObj = txtF // its object for next or previous
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
        toolbar.barStyle = UIBarStyle.default
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: type.text , style: .plain, target: self, action: #selector(self.inputAccessoryViewDidPressed(_:)))
        doneButton.tag = type.rawValue
        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .normal)
        
        let items = [spaceButton, doneButton]
        toolbar.setItems(items, animated: true)
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func inputAccessoryViewDidPressed(_ sender:AnyObject) {
        if sender.tag == tagType.next.rawValue || sender.tag == tagType.previous.rawValue{
            (txtFieldObj as? UITextField)?.becomeFirstResponder()
            (txtFieldObj as? UITextView)?.becomeFirstResponder()
        }else {
            self.resignFirstResponder()
        }
    }
    
}
