//
//  ForgotPasswordVC.swift
//  TruckYourWay
//
//  Created by Samradh Agarwal on 05/09/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var textEmail: CustomTxtField!
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.textEmail.placeHolders(imageName: "email", text: " Email")
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
   
    
    @IBAction func ActionBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func ActionSubmit(_ sender: Any)
    {
        self.APIForgotPassword()
    }
    
    
    
    func APIForgotPassword()
    {
        
        guard Validation.isblank(testString: textEmail.text!) else
        {
            self.showAlert("Enter a valid email")
            return
        }
        guard Validation.isValidEmail(emailString: textEmail.text!) else
        {
            self.showAlert("Please enter valid email id")
            return
        }
        
        let parameters = [
            "email":textEmail.text!,
            ] as [String : Any]
        
        self.startAnimating("")
        
        APIManager.sharedInstance.getDataFromAPI(BSE_URL_forgot_password, .post, parameters) { (result, data, json, error, msg) in
            
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
                                                            message: "We've sent you a reset password email on your registered email : \(self.textEmail.text!)",
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
