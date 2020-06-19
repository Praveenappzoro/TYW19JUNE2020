//
//  ChangePasswordVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/12/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

   
    @IBOutlet weak var textOldPassword: CustomTxtField!
    
    @IBOutlet weak var textNewPassword: CustomTxtField!
    
    @IBOutlet weak var textConfirmPassword: CustomTxtField!
    
    var loginUserData:LoggedInUser!

     @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var subViewPopUp: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subViewPopUp.layer.cornerRadius = 10
        self.subViewPopUp.layer.masksToBounds = true
//        self.textOldPassword.placeHolders(imageName: "password", text: " Current Password")
        self.textNewPassword.placeHolders(imageName: "password", text: " New Password")
        self.textConfirmPassword.placeHolders(imageName: "password", text: " Confirm Password")
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionChangeEmail(_ sender: Any) {
        self.viewPopUp.alpha = 1

    }
    
    @IBAction func HideViewPopUpOnOkay(_ sender: Any) {
        

                self.viewPopUp.alpha = 0
                
    }
    @IBAction func actionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionChangePassword(_ sender: Any)
    {
        self.APIChangePassword()
    }
    
    func APIChangePassword()
    {
    
        guard Validation.isblank(testString: textNewPassword.text!) else
        {
            self.showAlert("Please enter new password")
        return
        }
        guard Validation.isblank(testString: textConfirmPassword.text!) else
        {
        self.showAlert("Please enter confirm password")
        return
        }
        
        if (textNewPassword.text! != textConfirmPassword.text)
        {
            self.showAlert("Make sure new password and confirm password must be same.")
            return
        }
        
        
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {
            return
        }
        let parameters = [
            "user_id":self.loginUserData.user_id ?? "",
            "password":self.textNewPassword.text!,
            "access_token":self.loginUserData.access_token ?? "",
            "refresh_token":self.loginUserData.refresh_token ?? "",
        ] as [String : Any]
        
        self.startAnimating("")
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_change_password, .post, parameters) { (result, data, json, error, msg) in
        
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
        
        let alertController = UIAlertController(title: "Truck Your Way",
        message: "Password updated successfully.",
        preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok",
        style: UIAlertActionStyle.default,
        handler: {(alert: UIAlertAction!) in
        self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion:nil)
        })
        }
        
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
