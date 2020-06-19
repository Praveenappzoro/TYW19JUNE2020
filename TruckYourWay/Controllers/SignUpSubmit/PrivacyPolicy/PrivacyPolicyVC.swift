//
//  PrivacyPolicyVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/10/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit

class PrivacyPolicyVC: UIViewController ,UIWebViewDelegate{

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.bounces = false;
        let url = URL (string: BSE_URL_Privcy_Policy)
        let requestObj = URLRequest(url: url!)
        self.startAnimating("Loading...")
        self.webView.loadRequest(requestObj)
//        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
    }


    @IBAction func actionCloseIcon(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //#MARK:- WebViewDelegate's
    func webViewDidStartLoad(_ webView: UIWebView){
        //        self.startAnimating("Loading...")
    } // show indicator
    func webViewDidFinishLoad(_ webView: UIWebView){
        self.stopAnimating()
    } // hide indicator
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        self.stopAnimating()
    } // hide indicator


}
