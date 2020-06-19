
import UIKit

class LastPageJobVC: UIViewController {
    
    @IBOutlet weak var labelMessage: UILabel!
    var isFromLaterJob = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true

        if isFromLaterJob {
            labelMessage.text = "Thank you for YOUR LATER order. Please refer to YOUR NOW/LATER tab for details of YOUR LATER job. Please contact Truck Your Way for changes to YOUR order.\nTruck Your Way, When You Need Service NOW or LATER.... "
        } else {
            labelMessage.text = "You have completed the job! Thank You for using Truck Your Way!"
        }
    }
    
    @IBAction func doneButtonAction(sender: UIButton) {
        if !isFromLaterJob {
        self.navigationController?.popToRootViewController(animated: true)
            self.tabBarController?.tabBar.isHidden = false
            Constant.MyVariables.appDelegate.acceptJobModel = nil
            Constant.MyVariables.appDelegate.saveAcceptJobData()
            USER_DEFAULT.set(nil, forKey: APP_STATE_KEY)
        } else {
            AppDelegateVariable.appDelegate.isLogin(isLogin:true)
        }
       
    }

}
