//
//  CustomTextView.swift
//  Hotelier
//
//  Created by AppZoro Technologies on 19/10/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import UIKit

class CustomTextView: UITextView
{
    fileprivate let borderTop = CALayer()
    fileprivate let borderLeft = CALayer()
    fileprivate let borderBottom = CALayer()
    fileprivate let borderRight = CALayer()
    open var txtFieldObj: Any!
    open var textSetion:Int!
    open var textRow:Int!
    open var isToolBar = true // true - code working as default done button for date picker or time picker or date and time picker. Flase - override this function and add next previous or done button
    open var paddingTop:CGFloat = 0
   @IBInspectable open var paddingLeft:CGFloat = 0
   {
        didSet
        {
            UIEdgeInsetsMake(0, paddingLeft, 0, 0)
        }
    }
    
    open var paddingBottom:CGFloat = 0
    @IBInspectable open var paddingRight:CGFloat = 0
    {
        didSet
        {
            UIEdgeInsetsMake(0, 0, 0, paddingRight)
        }
    }//24 For cross button
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }    }
    
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet { layer.cornerRadius = cornerRadius }    }
    
    @IBInspectable open var borderColor: UIColor? {
        didSet { layer.borderColor = borderColor?.cgColor }
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
            borderBottom.frame = CGRect(x: 0.0, y: frame.size.height - linesWidth, width: frame.size.width, height: linesWidth)
            borderBottom.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderBottom)
        }
        if topLine {
            borderTop.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: linesWidth)
            borderTop.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderTop)
        }
        if rightLine {
            borderRight.frame = CGRect(x: frame.size.width - linesWidth, y: 0.0, width: linesWidth, height: frame.size.height);
            borderRight.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderRight)
        }
        if leftLine {
            borderLeft.frame = CGRect(x: 0.0, y: 0.0, width: linesWidth, height: frame.size.height);
            borderLeft.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderLeft)
        }
    }
}

extension CustomTextView
{
    public func updateAppearance(_ color: UIColor? = UIColor.lightGray) {
        self.bottomLine = true
        self.linesWidth = 1.0
        self.linesColor = color!
    }
}

// MARK: - Add Tootbar
extension CustomTextView {
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
