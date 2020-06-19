//
//  CustomButton.swift
//  UnSplashSocket
//
//  Created by AppZoro Technologies on 07/05/18.
//  Copyright © 2018 AppZoro Technologies. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

     let border = CALayer()
    
    
    @IBInspectable open var borderWidth:CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var borderColor:UIColor = .lightGray {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable open var cornerRadius:CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable open var topBorderWidth: CGFloat = 0 {
        didSet {
            self.addTopBorderWithColor(self.topBorderColor, width: topBorderWidth)
        }
    }
    
    @IBInspectable open var topBorderColor: UIColor = .lightGray
    {
        didSet
        {
            self.addTopBorderWithColor(self.topBorderColor, width: topBorderWidth)
        }
    }
    
    @IBInspectable open var leftBorderWidth: CGFloat = 0 {
        didSet {
            self.addLeftBorderWithColor(self.leftBorderColor, width: leftBorderWidth)
        }
    }
    
    @IBInspectable open var leftBorderColor: UIColor = .lightGray
        {
        didSet
        {
            self.addLeftBorderWithColor(self.leftBorderColor, width: leftBorderWidth)
        }
    }
    
    
    
    @IBInspectable open var rightBorderWidth: CGFloat = 0 {
        didSet {
            self.addRightBorderWithColor(self.rightBorderColor, width: rightBorderWidth)
        }
    }
    
    @IBInspectable open var rightBorderColor: UIColor = .lightGray
        {
        didSet
        {
            self.addRightBorderWithColor(self.rightBorderColor, width: rightBorderWidth)
        }
    }
    
    @IBInspectable open var bottomBorderWidth: CGFloat = 0 {
        didSet {
            self.addBottomBorderWithColor(self.bottomBorderColor, width: bottomBorderWidth)
        }
    }
    
    @IBInspectable open var bottomBorderColor: UIColor = .lightGray
        {
        didSet
        {
            self.addBottomBorderWithColor(self.bottomBorderColor, width: bottomBorderWidth)
        }
    }
    
    func removeLayer()
    {
        guard let layers = self.layer.sublayers else {return}
        for border in layers {
            if border == self.border
            {
                border.removeFromSuperlayer()
            }
        }
    }
    
    
    
    func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
       
        border.cornerRadius = border.frame.height/2
        border.masksToBounds = true
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
//        let border = CALayer()
        border.cornerRadius = border.frame.height/2
        border.masksToBounds = true
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
//        let border = CALayer()
        border.cornerRadius = border.frame.height/2
        border.masksToBounds = true
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:5, y:self.frame.size.height - width, width:self.frame.size.width-10, height:width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(_ color: UIColor, width: CGFloat) {
//        let border = CALayer()
        border.cornerRadius = border.frame.height/2
        border.masksToBounds = true
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    

}
