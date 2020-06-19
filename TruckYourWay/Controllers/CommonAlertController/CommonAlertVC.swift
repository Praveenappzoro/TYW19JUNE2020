//
//  CommonAlertVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 5/7/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import UIKit

class CommonAlertVC: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var buttonContact: UIButton!
    @IBOutlet weak var buttonCancel: CustomButton!
    @IBOutlet weak var buttonOkay: CustomButton!
    
    var message: String = ""
    var actionDic: [String: () -> Void]?
    var isContactNumberHidden: Bool = true
    var isAdminDeletedJob: Bool = false
    var isCancelHide = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBarCOLOR()

        viewContainer.layer.cornerRadius = 20.0
        viewContainer.layer.masksToBounds = true
        buttonContact.isHidden = isContactNumberHidden
        self.labelMessage.text = message

        if actionDic == nil {
            buttonCancel.isHidden = true
        } else {
            var count = 0
            for (key, _) in actionDic! {
                if count > 1 {
                    return
                }
                let buttonTitle: String = key.uppercased()
                if buttonTitle == "OKAY" || buttonTitle == "OK" || buttonTitle == "YES" {
                    buttonOkay.setTitle(buttonTitle, for: .normal)
                } else {
                    buttonCancel.setTitle(buttonTitle, for: .normal)
                }
                count += 1
            }
        }
        if isCancelHide {
            buttonCancel.isHidden = true
        }
    }

    // MARK: - IBAction Methods
    
    @IBAction func contactButtonAction(sender: UIButton) {
        if let url = URL(string: "tel://\(tywHelpPhoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

        if actionDic != nil {
            var count = 0
            for (key, value) in actionDic! {
                let action: () -> Void = value
                if key == sender.titleLabel?.text?.uppercased() {
                    action()
                }
                count += 1
            }
        }
    }
    
    @IBAction func okayButtonAction(sender: UIButton) {
        
        
        self.dismiss(animated: true, completion: {
            if self.isAdminDeletedJob {
                if let userData = USER_DEFAULT.object(forKey: "userData") as? Data {
                    guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
                    
                    if(loginUpdate.type == "service") {
                        let vc = TabBar.init(nibName: "TabBar", bundle: nil)
                        vc.selectedIndex = 1
                        Constant.MyVariables.appDelegate.navigationController = UINavigationController.init(rootViewController: vc)
                        let nowVC = AcceptingJobVC.init(nibName: "AcceptingJobVC", bundle: nil)
                        nowVC.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "now_Tab"), tag: 1)
                        nowVC.tabBarItem.imageInsets = UIEdgeInsets(top:6, left: 0, bottom: -6, right: 0)
                        (vc.selectedViewController as! UINavigationController).navigationBar.isHidden = true
                        nowVC.navigationController?.navigationBar.isHidden = true
                        (vc.selectedViewController as! UINavigationController).viewControllers = [nowVC]
                        Constant.MyVariables.appDelegate.window?.rootViewController = Constant.MyVariables.appDelegate.navigationController
                    }
                    else {
                        
                        let root = UIApplication.shared.visibleViewController
                        if root is TabBar {
                            let tab = root as! TabBar
                            if let vc = self.getRootFromTab(tab) {
                                print(vc)
                                if vc is TrackDriverVC {
                                    let vc = TabBar.init(nibName: "TabBar", bundle: nil)
                                    vc.selectedIndex = 1
                                    (vc.selectedViewController as! UINavigationController).navigationBar.isHidden = true
                                    Constant.MyVariables.appDelegate.navigationController = UINavigationController.init(rootViewController: vc)
                                    let nowVC = NowVC.init(nibName: "NowVC", bundle: nil)
                                    nowVC.tabBarItem = UITabBarItem(title: "", image: UIImage.init(named: "truck_cart_Tab"), tag: 1)
                                    nowVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
                                    nowVC.navigationController?.navigationBar.isHidden = true
                                    (vc.selectedViewController as! UINavigationController).viewControllers = [nowVC]
                                    Constant.MyVariables.appDelegate.window?.rootViewController = Constant.MyVariables.appDelegate.navigationController
                                }
                            }                            
                        }
                    }
                }
                return
            }
        })
        if actionDic != nil {
            var count = 0
            for (key, value) in actionDic! {
                let action: () -> Void = value
                if key == sender.titleLabel?.text?.uppercased() {
                    action()
                }
                count += 1
            }
        }
    }
    
    func getRootFromTab(_ tab: TabBar) -> UIViewController? {
        let tabRoot = tab.selectedViewController
        if tabRoot is UINavigationController {
            let tabNav = tabRoot as! UINavigationController
            let last = tabNav.viewControllers.last
            if last is TabBar {
                let vc = getRootFromTab(last as! TabBar)
                return vc
            } else {
                return last!
            }
        }
        return nil
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
