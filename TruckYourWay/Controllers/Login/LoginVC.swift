//
//  LoginVC.swift
//  TruckYourWay
//
//  Created by Samradh Agarwal on 04/09/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import AVFoundation

class LoginVC: UIViewController
{

    var isSuspended: Bool = false    
    var isDeleted: Bool = false
    var isDeviceChanged: Bool = false
    var alertMessage: String = ""


    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var labelMessage: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
//        if(self.isSuspended)
//        {
//            self.viewPopUp.isHidden = false
//        }
//        self.viewPopUp.isHidden = false

        if(self.isSuspended)
        {
            self.labelMessage.text = "\(alertMessage)"
            self.viewPopUp.isHidden = false
        } else if(self.isDeleted)
        {
            self.labelMessage.text = "\(alertMessage)"
            self.viewPopUp.isHidden = false
        } else if(self.isDeviceChanged)
        {
            self.labelMessage.text = "\(alertMessage)"
            self.viewPopUp.isHidden = false
        }
    }
    
    @IBAction func ActionServiceProviderSignUp(_ sender: Any)
    {
        let signUp = SignUpVC.init(nibName: "SignUpVC", bundle: nil)
            signUp.isConsumer = false
        self.navigationController?.pushViewController(signUp, animated: true)
    }
    
    @IBAction func ActionCustumerSignUp(_ sender: Any)
    {    
        let signUp = SignUpVC.init(nibName: "SignUpVC", bundle: nil)
            signUp.isConsumer = true
        self.navigationController?.pushViewController(signUp, animated: true)
    }
    
    @IBAction func actionLoginVC(_ sender: Any)
    {
        let login = SignInVC.init(nibName: "SignInVC", bundle: nil)
        self.navigationController?.pushViewController(login, animated: true)
    }

    @IBAction func actionCallToTYW(_ sender: Any)
    {
//        let button: UIButton = sender as! UIButton
        if let url = URL(string: "tel://\(tywHelpPhoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func actionOK(_ sender: Any)
    {
        self.viewPopUp.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.showPDF()
        
        Constant.MyVariables.appDelegate.truckCartModel = nil
        Constant.MyVariables.appDelegate.saveTrucCartData()
        
        Constant.MyVariables.appDelegate.acceptJobModel = nil
        Constant.MyVariables.appDelegate.saveAcceptJobData()
        USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)
    }
    
    
    //MARK:-  custom methods
    
}
