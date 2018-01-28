//
//  OTPVerificationVC.swift
//  RAHHAL
//
//  Created by RAJ on 03/12/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit

class OTPVerificationVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    @IBOutlet weak var txtFirst: UITextField!
    
    @IBOutlet weak var txtSecond: UITextField!
    
    @IBOutlet weak var txtThird: UITextField!
    
    @IBOutlet weak var txtFourth: UITextField!
    
    @IBOutlet weak var lblResend: FRHyperLabel!
    
    @IBOutlet weak var btnResent: UIButton!
    
    @IBOutlet weak var viewTimerOTPVerify: UIView!
    
    @IBOutlet weak var imgLoding: UIImageView!
    
    @IBOutlet weak var lblShowSecondsCount: UILabel!
    
    var myMobileNumber = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createUI()
        
        lblPhoneNumber.text = String(format: "+%@-%@", countAreaCode, myMobileNumber)
        
        self.addKeyBoardObservers()
        
        runningTimer()
    }

    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    func createUI() -> Void {
        
        let attributes = [NSAttributedStringKey.font:  UIFont.fontMontserratLight14(), NSAttributedStringKey.foregroundColor: UIColor.white]
        //        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)]
        
        lblResend.attributedText = NSAttributedString(string: lblResend.text!, attributes: attributes)
        
        let handler = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            
            self.resendOTPCode()
        }
        
        lblResend.setLinksForSubstrings(["Resend"], withLinkHandler: handler)
    }
    
    
    func runningTimer() -> Void {
        
        var count = 60
        
        self.lblShowSecondsCount.text = "\(count)"
        
        self.lblResend.isHidden = true
        self.btnResent.isHidden = true
        
        self.viewTimerOTPVerify.isHidden = false
        
        self.imgLoding.rotate360Degrees(duration: 2)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            
            if count == 0 {
                
                timer.invalidate()
                
                self.lblResend.isHidden = false
                self.btnResent.isHidden = false
                
                self.viewTimerOTPVerify.isHidden = true
            }
            
            count = count - 1
            
            self.lblShowSecondsCount.text = "\(count)"
        }
    }
    
    //MARK: - Notifications
    func addKeyBoardObservers() -> Void {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func removeKeyBoardObservers() -> Void {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            var frame = self.view.frame
            
            frame.origin.y = -200
            
            self.view.frame = frame
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            var frame = self.view.frame
            
            frame.origin.y = 0
            
            self.view.frame = frame
        }
    }

    
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnVerifyAction(_ sender: UIButton) {
        
        var otpCode = String()
        
        if let str1Char = txtFirst.text?.Trim() {
            
            otpCode = otpCode + str1Char
        }
        
        if let str2Char = txtSecond.text?.Trim() {
            
            otpCode = otpCode + str2Char
        }
        
        if let str3Char = txtThird.text?.Trim() {
            
            otpCode = otpCode + str3Char
        }
        
        if let str4Char = txtFourth.text?.Trim() {
            
            otpCode = otpCode + str4Char
        }
        
        self.verifyOTP(otp: otpCode)
    }
    
    
    @IBAction func btnResendOTPAction(_ sender: UIButton) {
    
        self.resendOTPCode()
    }
    
    
    func callDashboard() -> Void {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let rpNavigationVC = storyboard.instantiateViewController(withIdentifier: "rpNavigationVC") as! RPNavigationVC
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        appdelegate.window?.rootViewController = rpNavigationVC
    }
    
    
    //MARK: - call APIs
    func verifyOTP(otp: String) -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        
        UserVM.shared.verifyOTPAPI(phoneNo: myMobileNumber, otpCode: otp, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                print(dictResponse)
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    if let dictUser = dictResponse["data"] as? [String: AnyObject] {
                        
                        if let response = dictUser["response"] as? String, response == "success" {
                            
                            print(dictUser)
                            
                            UserDefaults.standard.set(dictUser["token"] as! String, forKey: "kToken")
                            
                            UserDefaults.standard.set(dictUser["user"] as! [String:AnyObject], forKey: "kUser")
                            
                            self.checkExistUserOnFirebase()
                        }
                        else {
                            CommonFile.shared.hudDismiss()
                        }
                    }
                    else {
                        CommonFile.shared.hudDismiss()
                    }
                }
                else {
                    
                    CommonFile.shared.hudDismiss()
                    let errorMsg = dictResponse["message"] as? String ?? Something_went_wrong_please_try_again
                    
                    UIAlertController.Alert(title: alertTitleError, msg: errorMsg, vc: self)
                }
            }
        }, failure: { (errorCode) in
            
            DispatchQueue.main.async {
                CommonFile.shared.hudDismiss()
                print(errorCode)
                UIAlertController.Alert(title: alertTitleError, msg: Something_went_wrong_please_try_again, vc: self)
            }
        })
    }
    
    
    func resendOTPCode() -> Void {
        CommonFile.shared.hudShow(strText: "")
        UserVM.shared.resendOTPAPI(phoneNo: myMobileNumber, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                print(dictResponse)
                CommonFile.shared.hudDismiss()
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    self.runningTimer()
                    //                    self.performSegue(withIdentifier: "otpVerificationVCSegue", sender: self)
                }
                else {
                    
                    let errorMsg = dictResponse["message"] as? String ?? Something_went_wrong_please_try_again
                    
                    UIAlertController.Alert(title: alertTitleError, msg: errorMsg, vc: self)
                }
            }
        }, failure: { (errorCode) in
            
            DispatchQueue.main.async {
                CommonFile.shared.hudDismiss()
                print(errorCode)
                UIAlertController.Alert(title: alertTitleError, msg: Something_went_wrong_please_try_again, vc: self)
            }
        })
    }
    
    
    func checkExistUserOnFirebase() -> Void {
        
        if let dictUserInfo = UserDefaults.standard.object(forKey: "kUser") as? [String: AnyObject] {
         
            let myId = dictUserInfo["id"] as! String
            
            FirebaseManager.sharedInstance.checkUserNameAlreadyExist(userId: myId) { (isExistUser) in
                if isExistUser {
                    
                    CommonFile.shared.hudDismiss()
                    self.callDashboard()
                }
                else {
                    
                    self.registrationOnFireBase()
                }
            }
        }
    }
    
    
    func registrationOnFireBase() -> Void {
        
        FirebaseManager.sharedInstance.CreateUser { (status, errorMsg) in
            
            CommonFile.shared.hudDismiss()
            if status == "yes" {
                
                self.callDashboard()
                
            }
        }
    }
    
    
    //MARK: - Delegate UITextField
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print(string)
        
//        let textFieldText: NSString = (textField.text ?? "") as NSString
//
//        let strFloor = textFieldText.replacingCharacters(in: range, with: string)
        
        textField.text = string
        
        textField.resignFirstResponder()
        
        return false
    }
    
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.text = ""
        
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        let strFloor = textField.text as! String
        if textField == txtFirst {
            if strFloor.count > 0 {
                txtSecond.becomeFirstResponder()
            }
            else {
                txtFirst.becomeFirstResponder()
            }
        }
        else if textField == txtSecond {
            if strFloor.count > 0 {
                txtThird.becomeFirstResponder()
            }
            else {
                txtFirst.becomeFirstResponder()
            }
        }
        else if textField == txtThird {
            if strFloor.count > 0 {
                txtFourth.becomeFirstResponder()
            }
            else {
                txtSecond.becomeFirstResponder()
            }
        }
        else if textField == txtFourth {
            if strFloor.count > 0 {
                txtFourth.resignFirstResponder()
                return true
            }
            else {
                txtThird.becomeFirstResponder()
            }
        }
        return false
    }
}


extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
