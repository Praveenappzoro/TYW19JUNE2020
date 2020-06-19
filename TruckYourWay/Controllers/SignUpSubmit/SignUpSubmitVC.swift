//
//  SignUpSubmitVC.swift
//  TruckYourWay
//
//  Created by Samradh Agarwal on 05/09/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class SignUpSubmitVC: UIViewController {

    // MARK: - UI Components
    
    @IBOutlet weak var viewSubmitAlert: UIView!
    @IBOutlet weak var textConfirmPassword: CustomTxtField!
    @IBOutlet weak var textPassword: CustomTxtField!
    @IBOutlet weak var textEmail: CustomTxtField!
    @IBOutlet weak var btnCheckToggleOtlt: UIButton!
    @IBOutlet weak var btnCheckAgeOtlt: UIButton!

    @IBOutlet weak var heightForHeaderViewConstraint: NSLayoutConstraint!
     @IBOutlet weak var heightForMainViewConstraint: NSLayoutConstraint!
    // MARK: - Data Handlers
    var isConsumer:Bool = false
    var dictUserDetail: NSMutableDictionary = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if(self.isConsumer)
        {
            self.heightForHeaderViewConstraint.constant = 0
            self.heightForMainViewConstraint.constant = 668
        }
        else
        {
            self.heightForHeaderViewConstraint.constant = 50
            self.heightForMainViewConstraint.constant = 698
        }
        self.textEmail.placeHolders(imageName: "email", text: " E-mail")
        self.textPassword.placeHolders(imageName: "password", text: " New Password")
        self.textConfirmPassword.placeHolders(imageName: "password", text: " Confirm Password")
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    // MARK: -  Confirm Sign-Up Submit action
    
    @IBAction func actionLoginPopUp(_ sender: Any)
    {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                        self.viewSubmitAlert.alpha = 0
        }, completion: { (finished) -> Void in
//            self.APIForSignUpNewUser()
            if((self.navigationController?.viewControllers.count ?? 0)  > 0 )
            {
                self.navigationController?.viewControllers.removeAll()
            }
            let signIn = SignInVC.init(nibName: "SignInVC", bundle: nil)
            let nav = UINavigationController.init(rootViewController: signIn)
            nav.navigationBar.isHidden = true
            nav.interactivePopGestureRecognizer!.isEnabled = false
            AppDelegateVariable.appDelegate.window?.rootViewController = nav
        })
        
    }
    
    // MARK: -   Check Action on Privacy Policy
    
    
    @IBAction func ActionCheckTermsAndConditions(_ sender: Any)
    {
        if(self.btnCheckToggleOtlt.isSelected)
        {
            self.btnCheckToggleOtlt.isSelected = false
        }
        else
        {
            self.btnCheckToggleOtlt.isSelected = true
        }
    }
    @IBAction func actionCheckPrivacyPolicy(_ sender: Any)
    {
       let privacyPolicy = PrivacyPolicyVC.init(nibName: "PrivacyPolicyVC", bundle: nil)
        self.present(privacyPolicy, animated: true, completion: nil)
    }
    
    @IBAction func ActionAgeCheck(_ sender: Any)
    {
        if(self.btnCheckAgeOtlt.isSelected)
        {
            self.btnCheckAgeOtlt.isSelected = false
        }
        else
        {
            self.btnCheckAgeOtlt.isSelected = true
        }
    }
    
    // MARK: - Action Back Handler

    @IBAction func actionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Action On Click Login

    @IBAction func actionLogin(_ sender: Any)
    {
     
        if(self.checkValidationCallSignUpApi())
        {
            self.dictUserDetail.setValue(self.textEmail.text!, forKey: "email")
            self.dictUserDetail.setValue(self.textPassword.text!, forKey: "password")
            self.APIForSignUpNewUser()
//            if(isConsumer)
//            {
//                self.dictUserDetail.setValue(self.textEmail.text!, forKey: "email")
//                self.dictUserDetail.setValue(self.textPassword.text!, forKey: "password")
//
//                self.APIForSignUpNewUser()
//            }
//            else
//            {
//                self.dictUserDetail.setValue(self.textEmail.text!, forKey: "email")
//                self.dictUserDetail.setValue(self.textPassword.text!, forKey: "password")
//                // Show Custom Pop-up method for Consumer side
            
//                self.showCustomPopUp()
//            }
        }
 
    }
    
    
    func showCustomPopUp()
    {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.viewSubmitAlert.alpha = 1
                        
        }, completion: { (finished) -> Void in
            // ....
        })
    }
    //Mark :- Check validate params
    
    func checkValidationCallSignUpApi() -> Bool
    {
       
        guard Validation.isblank(testString: textEmail.text!) else
        {
            self.showAlert("Email can't be blank.")
            return false
        }
        
        guard Validation.isValidEmail(emailString: textEmail.text!) else
        {
            self.showAlert("Please enter valid email address")
            return false
        }
        
        guard Validation.isblank(testString: textPassword.text!) else
        {
            self.showAlert("Password can't be blank.")
            return false
        }
        
        guard Validation.isblank(testString: textConfirmPassword.text!) else
        {
            self.showAlert("Confirm password can't be blank.")
            return false
        }
        
        guard textPassword.text! == textConfirmPassword.text! else
        {
            self.showAlert("Password & Confirm password should be same.")
            return false
        }
        
        if(!self.btnCheckToggleOtlt.isSelected)
        {
            self.showAlert("Please agree to the Privacy Policy.")
            return false
        }
        if(!self.btnCheckAgeOtlt.isSelected)
        {
            self.showAlert("Please confirm that you are over 18 years of age.")
            return false
        }
        
        return true
        
    }
    
    //MARK:- Create New user Api Calling
    func APIForSignUpNewUser()
    {
        self.startAnimating("")
        
        let params = self.dictUserDetail as? [String : Any]
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_REGISTER, .post, params) { (result, data, json, error, msg) in
            
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
                self.stopAnimating()
                
                    guard let loginUser = try? JSONDecoder().decode(LoggedInUser.self, from: data!) else {return}
                    loginUserData = loginUser
                    if(self.isConsumer)
                    {
                         USER_DEFAULT.set("", forKey:rememberMe_Email)
                        loginUserData = loginUser
                        USER_DEFAULT.set(data!, forKey: "userData")
                        AppDelegateVariable.appDelegate.isLogin(isLogin:true)
                    }
                    else
                    {
                        self.showCustomPopUp()
                        
                    }
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
