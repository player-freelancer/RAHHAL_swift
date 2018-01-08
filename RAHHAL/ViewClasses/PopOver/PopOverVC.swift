//
//  PopOverVC.swift
//  PBAgent
//
//  Created by MR on 27/03/17.
//  Copyright © 2017 MR. All rights reserved.
//

protocol PopOverVCDelegates {
    
    func getPopOverValue(strDate: String, vc: UIViewController)
}


import UIKit

class PopOverVC: UIViewController {

    var strSelectedDate = String()
    
    var delegates: PopOverVCDelegates?
    
    
    //MARK: VC LifeCycle
    override func viewDidLoad() {
    
        super.viewDidLoad()
    }

    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - UIButton Actions
    @IBAction func btnAddAppointmentAction(_ sender: UIButton) {
        strSelectedDate = (sender.titleLabel?.text)!
        delegates?.getPopOverValue(strDate: strSelectedDate, vc: self)
    }
    
    
    @IBAction func btnAddTimeOffAction(_ sender: UIButton) {
        strSelectedDate = (sender.titleLabel?.text)!
        delegates?.getPopOverValue(strDate: strSelectedDate, vc: self)
    }
    
    
    @IBAction func btnAddOpenHouseAction(_ sender: UIButton) {
        strSelectedDate = (sender.titleLabel?.text)!
        delegates?.getPopOverValue(strDate: strSelectedDate, vc: self)
    }
}
