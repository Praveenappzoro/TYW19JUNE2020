//
//  SignInVC.swift
//  TruckYourWay
//
//  Created by Samradh Agarwal on 05/09/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var textEmail: CustomTxtField!
    @IBOutlet weak var textPassword: CustomTxtField!
    
    @IBOutlet weak var imgRememberCheck: UIImageView!
    
    @IBOutlet weak var btnIsRememberOtlt: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgRememberCheck.borderColor = UIColor(red: 206.0/255.0, green: 114.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        self.imgRememberCheck.borderWidth = 2
        
        self.textEmail.placeHolders(imageName: "email", text: " Email")
        self.textPassword.placeHolders(imageName: "password", text: " Password")

        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        self.checkIsRemember()
        // Do any additional setup after loading the view.
    }

    @IBAction func ActionLogin(_ sender: Any) {
        self.APIForLogin()
    }
    
    @IBAction func actionRememberToogle(_ sender: Any)
    {
        if(self.btnIsRememberOtlt.isSelected)
        {
            self.imgRememberCheck.borderWidth = 2
            self.btnIsRememberOtlt.isSelected = false
            self.imgRememberCheck.image = UIImage(named: "")
        }
        else
        {
            self.imgRememberCheck.borderWidth = 0
            self.btnIsRememberOtlt.isSelected = true
            self.imgRememberCheck.image = UIImage(named: "done")
        }
    }
    
    @IBAction func ActionBack(_ sender: Any)
    {
        if self.navigationController?.viewControllers.count == 1 {
            Constant.MyVariables.appDelegate.isLogin(isLogin: false)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionForgotPassword(_ sender: Any)
    {
        let login = ForgotPasswordVC.init(nibName: "ForgotPasswordVC", bundle: nil)
        self.navigationController?.pushViewController(login, animated: true)
    }
    
    
    func checkIsRemember()
    {
        guard let prefEmail = USER_DEFAULT.value(forKey: rememberMe_Email) else { return  }
        self.textEmail.text = prefEmail as? String
        if(self.textEmail.text != "")
        {
            self.btnIsRememberOtlt.isSelected = true
            self.imgRememberCheck.borderWidth = 0
            self.btnIsRememberOtlt.isSelected = true
            self.imgRememberCheck.image = UIImage(named: "done")
        }
        else
        {
            self.imgRememberCheck.borderWidth = 2
            self.btnIsRememberOtlt.isSelected = false
            self.imgRememberCheck.image = UIImage(named: "")
        }
    }
    
    //MARK:- Login Api Calling
    func APIForLogin()
    {
        
        guard Validation.isblank(testString: textEmail.text!) else
        {
            self.showAlert("Enter a valid email")
//            self.showCustomAlertWith(message: "Enter a valid email", actions: nil, isSupportHiddedn: true)
            return
        }
        guard Validation.isValidEmail(emailString: textEmail.text!) else
        {
            self.showAlert("Please enter valid email id")
//            self.showCustomAlertWith(message: "Please enter valid email id", actions: nil, isSupportHiddedn: true)

            return
        }
        guard Validation.isblank(testString: textPassword.text!) else
        {
            self.showAlert("Enter your password")
//            self.showCustomAlertWith(message: "Enter your password", actions: nil, isSupportHiddedn: true)

            return
        }
        
        let parameters = [
            "email":textEmail.text!,
            "password":textPassword.text!,
            "device_token":Constant.MyVariables.appDelegate.deviceToken
            ] as [String : Any]
        
        self.startAnimating("")
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_LOGIN, .post, parameters) { (result, data, json, error, msg) in
            switch result
            {
            case .Failure:
                DispatchQueue.main.async(execute: {
                    self.stopAnimating()
                    if msg.contains("suspended")
                    {
                            let login = LoginVC.init(nibName: "LoginVC", bundle: nil)
                            login.isSuspended = true
                            login.alertMessage = msg
                            self.navigationController?.pushViewController(login, animated: true)
                        
                    }
                    else
                    {
                        self.showAlert(msg)
                    }
                    
                })
                break
            case .Success:
                DispatchQueue.main.async(execute: {
                    self.stopAnimating()
                    guard let loginUser = try? JSONDecoder().decode(LoggedInUser.self, from: data!) else {return}
                    loginUserData = loginUser
                    
                    
                    if(loginUserData.type == "service")
                    {
                        if(loginUserData.active ?? 0 == 0)
                        {
                            USER_DEFAULT.set("0" , forKey: JobAcceptingPrefrence)
                        }
                        else
                        {
                            USER_DEFAULT.set("1" , forKey: JobAcceptingPrefrence)
                        }
                    }
                    
                    
                    USER_DEFAULT.set(data!, forKey: "userData")
                    
                    if(self.btnIsRememberOtlt.isSelected)
                    {
                       USER_DEFAULT.set(self.textEmail.text ?? "", forKey:rememberMe_Email)
                    }
                    if(!self.btnIsRememberOtlt.isSelected)
                    {
                       USER_DEFAULT.set("", forKey:rememberMe_Email)
                    }

                    if(loginUser.first_log_in == "true" && loginUser.type == "service")
                    {
                        if #available(iOS 11.0, *) {
                            let constract = ConstractServiceProviderVC.init(nibName: "ConstractServiceProviderVC", bundle: nil)
                            self.navigationController?.pushViewController(constract, animated: true)
                            return
                        }
//                        else {
//                            // Fallback on earlier versions
//                            AppDelegateVariable.appDelegate.isLogin(isLogin:true)
//                            return
//                        }

                    }
//                    if(loginUser.first_log_in != "true" && loginUser.type == "service")
//                    {
                        AppDelegateVariable.appDelegate.isLogin(isLogin:true)
                        return
//                    }
//                    if(loginUser.first_log_in == nil)
//                    {
//                        AppDelegateVariable.appDelegate.isLogin(isLogin:true)
//                    }
                    
                })
                break
            }
            
        }
    }
    
    func callDriverActiveStateApi(loginUserData:LoggedInUser)
    {
            let parameters = [
                "user_id":loginUserData.user_id!,
                "status":"1",
                "access_token":loginUserData.access_token!,
                "refresh_token": loginUserData.refresh_token!
                ] as! NSDictionary
            APIManager.sharedInstance.getDataFromAPI(BSE_URL_ACCEPTING_JOBS, .post, parameters as? [String : Any]) { (result, data, json, error, msg) in
                
                switch result
                {
                case .Failure:
                    DispatchQueue.main.async(execute: {
                        self.stopAnimating()
                        self.showAlert(msg)
                    })
                    break
                case .Success:
                    
                    DispatchQueue.main.async(execute: {
                        
                        USER_DEFAULT.set("1" , forKey: JobAcceptingPrefrence)
                        
                        
                    })
                    break
                }
            }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignInVC : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(string == " ")
        {
            return false
        }
        return true
    }
}
