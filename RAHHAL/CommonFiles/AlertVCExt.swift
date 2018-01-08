//
//  OTExtensionAlertVC.swift
//
//  Created by Raj on 28/11/16.
//  Copyright © 2016 MR. All rights reserved.
//

import Foundation

import UIKit

@objc protocol AlertCustomDelegate {
    
    func callBackVC()
    
    @objc optional
    func callBackVCAPISuccess()
    
    @objc optional
    func checkUserData()
    
    @objc optional
    func callBackVCAPISuccess(btnName: String)
    
    @objc optional
    func callBackAlertYesAction(index: Int)
}

class AlertCustom: UIAlertController {
    
    var delegates:AlertCustomDelegate?
    
    
    func AlertForYesOrNo(strAlertTitle: String, strAlertMsg: String, index: Int, vc: UIViewController) -> Void {
        
        let myAlertVC = AlertCustom(title: strAlertTitle, message: strAlertMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            
            self.delegates?.callBackVC()
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            self.delegates?.callBackAlertYesAction!(index: index)
        }
        
        myAlertVC.addAction(defaultAction)
    
        myAlertVC.addAction(yesAction)
        
        vc.present(myAlertVC, animated: true, completion: nil)
    }
    
    
    func Alert(strTitle: String, msg: String, arrBtnsName: [String], vc: UIViewController) -> Void {
        
        let myAlertVC = AlertCustom(title: strTitle, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        for i in 0..<arrBtnsName.count {
            
            let btnName = arrBtnsName[i]
            
            if btnName.lowercased() == "cancel" {
                
                let defaultAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    
                    self.delegates?.callBackVC()
                }
                myAlertVC.addAction(defaultAction)
            }
            else {
                
                let defaultAction = UIAlertAction(title: btnName, style: .default) { (action) in
                    
                    self.delegates?.callBackVCAPISuccess!(btnName: btnName)
                }
                myAlertVC.addAction(defaultAction)
            }
        }
        
        vc.present(myAlertVC, animated: true, completion: nil)
    }
    
    
    func AlertForServerError(vc: UIViewController) -> Void {
        
        let myAlertVC = AlertCustom(title: "Error", message: "Server Error", preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            
            self.delegates?.callBackVC()
        }
        
        myAlertVC.addAction(defaultAction)
        
        vc.present(myAlertVC, animated: true, completion: nil)
    }
    
    /*
    func AlertWithDelegates(title: String, msg: String, vc: UIViewController) -> Void {
        
        let myAlertVC = AlertCustom(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            
            if title == ValidAlertTitle.ForgotPasswordAlertTitle {
                
                self.delegates?.callBackVCAPISuccess!()
            }
            else {
                
                self.delegates?.callBackVC()
            }
        }
        
        myAlertVC.addAction(defaultAction)
        
        vc.present(myAlertVC, animated: true, completion: nil)
    }*/
    
    
    func AlertForActivatedUser(vc: UIViewController) -> Void {
        
        let myAlertVC = AlertCustom(title: "", message: "Checking for account activation. Refer your email for the link.", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
            self.delegates?.callBackVC()
        }
        
        myAlertVC.addAction(cancelAction)
        
        vc.present(myAlertVC, animated: true, completion: nil)
    }
    
    
    class func AlertForStatusCode(errorCode : String ,vc: UIViewController) -> Void {
        
        var errorMsg = String()
        
        switch errorCode {
            
        case "400":
            errorMsg = "Something went wrong with the server."
        case "401":
            errorMsg = "Your session has expired. Please log in again."
        case "403":
            errorMsg = "Something went wrong with the server."
        case "404":
            errorMsg = "Something went wrong with the server."
        case "422":
            errorMsg = "Something went wrong with the server."
        case "500":
            errorMsg = "Something went wrong with the server."
        case "503":
            errorMsg = "Application is not currently available due the regular maintenance. Please try again in a few minutes."
        default:
            errorMsg = "Something went wrong with the server."
        }
        
        let myAlertVC = AlertCustom(title: "Error", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            
            if errorCode == "401" {
                
            }
        }
        
        myAlertVC.addAction(defaultAction)
        
        vc.present(myAlertVC, animated: true, completion: nil)
    }
}


extension UIAlertController {
    
    class func Alert(title: String, msg: String, vc: UIViewController?) -> Void {
        let myAlertVC = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: OKString, style: .default, handler: nil)
        
        myAlertVC.addAction(defaultAction)
        
        if vc != nil {
            
            vc?.present(myAlertVC, animated: true, completion: nil)
        }
        else {
            
            let topVC = UIApplication.shared.keyWindow?.rootViewController
            
            topVC?.present(myAlertVC, animated: true, completion: nil)
        }
    }
    
    
    class func AlertForNotImplementedYet(vc: UIViewController?) -> Void {
        
        let myAlertVC = UIAlertController(title: "", message: "Not implemented yet.", preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        myAlertVC.addAction(defaultAction)
        
        if vc != nil {
            
            vc?.present(myAlertVC, animated: true, completion: nil)
        }
        else {
            
            let topVC = UIApplication.shared.keyWindow?.rootViewController
            
            topVC?.present(myAlertVC, animated: true, completion: nil)
        }
    }
}
