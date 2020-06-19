import UIKit
import Crashlytics


class AcceptingJobVC: UIViewController {
    
    //MARK:- IB Outlets
    @IBOutlet weak var switchOtlet: UISwitch!
    @IBOutlet var labelNoJobYet: UIView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var subViewPopup: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    var loginUserData:LoggedInUser!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.subViewPopup.layer.cornerRadius = 10
        self.subViewPopup.layer.masksToBounds = true
        self.buttonView.layer.cornerRadius = 25
        self.buttonView.layer.masksToBounds = true
        self.buttonView.layer.borderWidth = 5
        self.buttonView.layer.borderColor = UIColor(red: 156.0/255.0,green: 190.0/255.0, blue: 56.0/255.0, alpha: 1.0).cgColor
        
        
        let onColor  = UIColor.green
        let offColor = UIColor.red
        
        /*For on state*/
        self.switchOtlet.onTintColor = onColor
        
        /*For off state*/
        self.switchOtlet.tintColor = offColor
        self.switchOtlet.layer.cornerRadius = self.switchOtlet.frame.height / 2
        self.switchOtlet.backgroundColor = offColor
        
        
//        let button = UIButton(type: .roundedRect)
//        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
//        button.setTitle("Crash", for: [])
//        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//        view.addSubview(button)
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
         self.navigationController?.navigationBar.isHidden = true
        
        let str = USER_DEFAULT.value(forKey: JobAcceptingPrefrence) ?? "0"
        let strJobAccepting = str as! String
        
        self.switchOtlet.isOn = strJobAccepting == "1" ? true : false
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        Constant.MyVariables.appDelegate.acceptJobModel = nil
        Constant.MyVariables.appDelegate.saveAcceptJobData()
        USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)
        
        self.tabBarController?.tabBar.isHidden = false

    }
    //MARK:- IB Actions
    @IBAction func ActionHelp(_ sender: Any)
    {
        if let url = URL(string: BSE_URL_HELP) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func switchAction(_ sender: Any)
    {
        let switchh = sender as! UISwitch
        self.APIForUpdateJobAccepting(isAccepting: switchh.isOn)
    }
    
    //MARK:- Call Accept Job Api Calling
    func APIForUpdateJobAccepting(isAccepting:Bool)
    {
        
        if let userData = USER_DEFAULT.object(forKey: "userData") as? Data
        {
            guard let loginUpdate = try? JSONDecoder().decode(LoggedInUser.self, from: userData) else {return}
            self.loginUserData = loginUpdate
        }
        else
        {
            return
        }
        
        self.startAnimating("")
        
        let parameters = [
            "user_id":self.loginUserData.user_id!,
            "status":isAccepting == true ? "1" : "0",
            "access_token":self.loginUserData.access_token!,
            "refresh_token": self.loginUserData.refresh_token!
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
                    self.stopAnimating()
//                    let dict = json
                    let str = self.switchOtlet.isOn == true ? "1" : "0"
                    USER_DEFAULT.set(str , forKey: JobAcceptingPrefrence)
                   self.switchOtlet.isOn = str == "1" ? true : false
                    
                })
                break
            }
            
        }
    }
    
    


}
