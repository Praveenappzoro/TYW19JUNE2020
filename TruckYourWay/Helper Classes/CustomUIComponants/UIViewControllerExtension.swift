//
//  UIViewControllerExtension.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 5/7/19.
//  Copyright © 2019 Samradh Agarwal. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showCustomAlertWith(_ isJobDeleted: Bool = false, message: String, actions: [String: () -> Void]?, isSupportHiddedn: Bool, isCancleHide: Bool = false) {

        let alert = CommonAlertVC.init(nibName: "CommonAlertVC", bundle: nil)
        alert.message = message
        alert.actionDic = actions
        alert.isCancelHide = isCancleHide
        alert.isContactNumberHidden = isSupportHiddedn        
        alert.isAdminDeletedJob = isJobDeleted
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func setStatusBarCOLOR() {
        if #available(iOS 13.0, *) {
           let app = UIApplication.shared
           let statusBarHeight: CGFloat = app.statusBarFrame.size.height
           
           let statusbarView = UIView()
           statusbarView.backgroundColor = UIColor.init(red: 206/255, green: 114/255, blue: 54/255, alpha: 1)
           let view = (self.view)!
            view.addSubview(statusbarView)
           statusbarView.translatesAutoresizingMaskIntoConstraints =   false
            statusbarView.heightAnchor
              .constraint(equalToConstant: statusBarHeight).isActive = true
          statusbarView.widthAnchor
              .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
          statusbarView.topAnchor
              .constraint(equalTo: view.topAnchor).isActive = true
          statusbarView.centerXAnchor
              .constraint(equalTo: view.centerXAnchor).isActive = true
       } else {
           let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
           statusBar?.backgroundColor = UIColor.init(red: 206/255, green: 114/255, blue: 54/255, alpha: 1)
       }
    }
}
