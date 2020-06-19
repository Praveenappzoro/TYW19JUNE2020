//
//  DriveInfoBottomVC.swift
//  TruckYourWay
//
//  Created by Jitendra Jangir on 10/20/18.
//  Copyright © 2018 Samradh Agarwal. All rights reserved.
//

import UIKit
import Cosmos
class DriveInfoBottomVC: UIViewController {

    @IBOutlet weak var imgViewDriver: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblTruckId: UILabel!
    @IBOutlet weak var lblSelectedType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomLocationSheetVC.panGesture))
    view.addGestureRecognizer(gesture)
    self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
    // Do any additional setup after loading the view.
}

override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    definesPresentationContext = true
    UIView.animate(withDuration: 0.3) { [weak self] in
        let frame = self?.view.frame
        let yComponent = UIScreen.main.bounds.height - 200
        
        self?.view.frame = CGRect.init(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
    }
}
@objc func panGesture(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: self.view)
    let y = self.view.frame.minY
    
    let total = y + translation.y;
    let yComponent = UIScreen.main.bounds.height - 200
    if(yComponent < total)
    {
        self.view.frame = CGRect.init(x: 0, y: yComponent, width: self.view.frame.width, height: self.view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        return
    }
    self.view.frame = CGRect.init(x: 0, y: total > 100 ? y + translation.y : 100, width: view.frame.width, height:  view.frame.height)
    recognizer.setTranslation(CGPoint.zero, in: self.view)
}


}
