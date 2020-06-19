//
//  CustomAlert.swift
//  ModalView
//
//  Created by Aatish Rajkarnikar on 3/20/17.
//  Copyright © 2017 Aatish. All rights reserved.
//

import UIKit

protocol alertDismissDelegate: class {
    func TapOnDismiss(getType: String)
}

class CustomAlert: UIView, Modal {
    
   let separatorLineLabel = UILabel()
    weak var delegate:alertDismissDelegate?
    var backgroundView = UIView()
    var dialogView = UIView()
    var typeAlert:String = ""
    var seconds = 60
    var timer = Timer()
    var dictNotification: NSMutableDictionary?

    convenience init(title:String,image:UIImage,typeAlert:String,ButtonTitle:String, _ dictNotification: NSMutableDictionary? = [:]) {
        self.init(frame: UIScreen.main.bounds)
        self.dictNotification = dictNotification
        initialize(title: title, image: image,typeAlert:typeAlert,ButtonTitle:ButtonTitle)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func OnSelectSectionAlertActionType(_ sender: CustomButton){
        if(self.typeAlert == "newJobRequest"){
                let jobDetails = JobAcceptDriver.init(nibName: "JobAcceptDriver", bundle: nil)
                let dictMain  = dictNotification
                let arr = dictMain?.value(forKey: "materials") as! NSArray
                jobDetails.isFromNotification = true
                jobDetails.dictConfirmation = dictMain?.mutableCopy() as! NSMutableDictionary
                jobDetails.arrConfirmation = arr.mutableCopy() as! NSMutableArray
           // let valuee = self.seconds
           // jobDetails.seconds = self.seconds
                let VC =  window?.visibleViewController()
                VC!.navigationController?.pushViewController(jobDetails, animated: true)
        }
        dismiss(animated: true)
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            self.dismiss(animated: true)
            //Send alert to indicate time's up.
        } else {
            seconds -= 1
            separatorLineLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func initialize(title:String, image:UIImage,typeAlert:String,ButtonTitle:String){
        if(typeAlert == "newJobRequest"){
            self.manageTimerScreen()
            runTimer()
        }
        dialogView.clipsToBounds = true
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        let dialogViewWidth = frame.width-20
        let imageView = UIImageView()
        imageView.frame.origin = CGPoint(x: 20, y: 10 )
        imageView.frame.size = CGSize(width: frame.width-40 , height: 140)
        imageView.image = image
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        dialogView.addSubview(imageView)
        
        if(typeAlert == "newJobRequest"){
            separatorLineLabel.textAlignment = .center
            separatorLineLabel.textColor = .white
            separatorLineLabel.text = timeString(time: TimeInterval(seconds))
            separatorLineLabel.frame = CGRect.init(x: 0, y: imageView.frame.size.height + 30, width: frame.width-20, height: 25)
            separatorLineLabel.backgroundColor = UIColor.init(red: 156.0/255.0, green: 190.0/255.0, blue: 56.0/255.0, alpha: 1.0)
            dialogView.addSubview(separatorLineLabel)
        }
        let titleLabel = UILabel(frame: CGRect(x: 8, y: separatorLineLabel.frame.size.height+10+imageView.frame.size.height+10, width: dialogViewWidth-16, height: 120))
        if(typeAlert != "newJobRequest"){
            titleLabel.text = title
        }
        else{
            if(title.contains("HAULING")){
                titleLabel.attributedText = self.addBoldText(fullString: title as NSString, boldPartsOfString: ["HAULING"], font: UIFont.systemFont(ofSize: 17), boldFont: UIFont.boldSystemFont(ofSize: 18))
            }
            else if(title.contains("DELIVERY")){
                titleLabel.attributedText = self.addBoldText(fullString: title as NSString, boldPartsOfString: ["DELIVERY"], font: UIFont.systemFont(ofSize: 17), boldFont: UIFont.boldSystemFont(ofSize: 18))
            }
        }
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        dialogView.addSubview(titleLabel)
        let buttonOK = CustomButton(frame: CGRect(x: ((frame.width-20)-120)/2, y: titleLabel.frame.height+10+separatorLineLabel.frame.size.height+10+imageView.frame.size.height+10, width: 120, height: 50))
        buttonOK.setTitle(ButtonTitle, for: .normal)
        buttonOK.borderColor = UIColor.init(red: 156.0/255.0, green: 190.0/255.0, blue: 56.0/255.0, alpha: 1.0)
        buttonOK.borderWidth = 5
        buttonOK.setTitleColor(UIColor.init(red: 111.0/255.0, green: 113.0/255.0, blue: 121.0/255.0, alpha: 1.0), for: .normal)
        buttonOK.cornerRadius = 25
        buttonOK.titleLabel?.textAlignment = .center
        buttonOK.addTarget(self, action: #selector(self.OnSelectSectionAlertActionType(_:)), for: .touchUpInside)
        dialogView.addSubview(buttonOK)
        let dialogViewHeight = buttonOK.frame.size.height + 10 + titleLabel.frame.size.height + 10 + separatorLineLabel.frame.size.height + 10 + imageView.frame.height + 10
        dialogView.frame.origin = CGPoint(x: 10, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-20, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        addSubview(dialogView)
    }
    
    func manageTimerScreen() {
        print("Accept Request --------------- ")
        if ((self.dictNotification?["bill_details"] as? NSDictionary) != nil) {
            
            let timestamp = (self.dictNotification?["bill_details"] as! NSDictionary)["moment"] as? String
            let dateStarted = Int("\(timestamp ?? "0")")!
            let dateNow = Date().millisecondsSince1970
            let timeDifference = dateNow - dateStarted
            seconds = seconds - timeDifference
            print(timeDifference)
        }
      //  self.runTimer()
    }
    @objc func didTappedOnBackgroundView(){
        if(typeAlert == "newJobRequest"){
        }
//        dismiss(animated: true)
    }
    
    func TapOnDismiss(){
    }
    
    func addBoldText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedStringKey.font:font!]
        let boldFontAttribute = [NSAttributedStringKey.font:boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
}
