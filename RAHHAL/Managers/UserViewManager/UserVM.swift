//
//  UserVM.swift
//  OrderTron
//
//  Created by MR on 10/11/16.
//  Copyright © 2016 MR. All rights reserved.
//

import UIKit

class UserVM: NSObject {
    
    static let shared : UserVM = {
        
        let instance = UserVM()
        
        return instance
    }()
    
    
    func signupAPI(FName: String, LName: String, phoneNo: String, completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void{
        
        let dictUserInfo = ["first_name":FName,
                            "last_name":LName,
                            "mobile":"\(countAreaCode)\(phoneNo)",
                            "country_code":countAreaCode] as [String : String]
        
        WebService.sharedInstance.postMethodWithParams(strURL: "auth/register", dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            failure(errorCode)
        })
    }
    
    
    func loginAPI(phoneNo: String, completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        let dictUserInfo = ["mobile":String(format: "%@%@", countAreaCode, phoneNo)] as [String : String]
        
        WebService.sharedInstance.postMethodWithParams(strURL: "auth/login", dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            
            print("dictResponse : \(dictResponse)")
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            print("errorCode : \(errorCode)")
            failure(errorCode)
        })
    }
    
    
    func updateProfileAPI(FName: String, LName: String, imgProfile: UIImage?, completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void{
        
        var dictUserInfo = ["first_name":FName,
                            "last_name":LName] as [String : String]
        if let profilepic = imgProfile {
            
            WebService.sharedInstance.postMethodWithParamsAndImage(strURL: "user/update", dictParams: dictUserInfo as NSDictionary, image: profilepic, imagesKey: "profile", imageName: "profile", completionHandler: { (dictResponse) in
                
                completionHandler(dictResponse)
                
            }, failue: { (errorCode) in
                
                failure(errorCode)
            })
        }
        else {
            
            dictUserInfo["profile"] = ""
            
            WebService.sharedInstance.postMethodWithParams(strURL: "user/update", dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
                
                completionHandler(dictResponse)
            }, failure: { (errorCode) in
                
                failure(errorCode)
            })
        }
    }
    
    
    func getMyProfileAPI( completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        let dictInfo = [String: AnyObject]()
        
        WebService.sharedInstance.getMethodWithParams("user/profile", dict: dictInfo as NSDictionary, completionHandler: { (getUserDictResponse :NSDictionary) in
            
            completionHandler(getUserDictResponse)
        }, failure: { (strError :String) in
            
            failure(strError)
        })
    }
    
    /*
    func logoutAPI( completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        let dictInfo = [String: AnyObject]()
        
        WebService.sharedInstance.getMethodWithParams("logout", dict: dictInfo as NSDictionary, completionHandler: { (getUserDictResponse :NSDictionary) in
            
            completionHandler(getUserDictResponse)
        }, failure: { (strError :String) in
            
            failure(strError)
        })
    }*/
    
    func verifyOTPAPI(phoneNo: String, otpCode: String, completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        let dictUserInfo = ["mobile":String(format: "%@%@", countAreaCode, phoneNo),
                            "otp":otpCode] as [String : String]
        
        WebService.sharedInstance.postMethodWithParams(strURL: "auth/verifyOTP", dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            failure(errorCode)
        })
    }
    
    
    func resendOTPAPI(phoneNo: String, completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        let dictUserInfo = ["mobile":String(format: "%@%@", countAreaCode, phoneNo)] as [String : String]
        
        WebService.sharedInstance.postMethodWithParams(strURL: "auth/reSendOTP", dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            print("dictResponse : \(dictResponse)")
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            print("errorCode : \(errorCode)")
            failure(errorCode)
        })
    }
    
    
    func updateTokenAPI(token: String, completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void{
        
        let dictUserInfo = ["token":token,
                            "os":"IOS"] as [String : String]
        
        WebService.sharedInstance.postMethodWithParams(strURL: "user/UpdateToken", dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            failure(errorCode)
        })
    }
    
}
