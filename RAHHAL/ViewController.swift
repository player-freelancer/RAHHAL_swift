//
//  ViewController.swift
//  RAHHAL
//
//  Created by RAJ on 02/12/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtMobileNumber: UITextField!
    
    @IBOutlet var btnLogin: UIButton!
    
    @IBOutlet var lblSignUp: FRHyperLabel!
    
    var myPhoneNumber = String()
    
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        UserDefaults.standard.removeSuite(named: "kToken")
        
        UserDefaults.standard.synchronize()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.createUI()
    }
    

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    func createUI() -> Void {
        
        txtMobileNumber.leftImageOfTextField(imgName: "mobileNumber", imgSize: CGSize(width: 20, height: 25))
        
        let attributes = [NSAttributedStringKey.font:  UIFont.fontMontserratLight14(), NSAttributedStringKey.foregroundColor: UIColor.white]
//        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)]
        
        lblSignUp.attributedText = NSAttributedString(string: lblSignUp.text!, attributes: attributes)
        
        let handler = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            
            self.performSegue(withIdentifier: "signUpSegue", sender: self)
        }
        
        lblSignUp.setLinksForSubstrings(["Sign up"], withLinkHandler: handler)
    }
    

    //MARK: - UIButton Action
    @IBAction func btnLoginAction(_ sender: UIButton) {
        
        self.checkValidations()
    }
    
    
    @IBAction func btnSignUpAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "signUpSegue", sender: self)
    }
    
    func checkValidations() -> Void {
        
        myPhoneNumber = (txtMobileNumber.text?.Trim())!
        
        if !myPhoneNumber.isEmpty {
            
            let arrPhone = myPhoneNumber.components(separatedBy: "-")
            
            myPhoneNumber = arrPhone[1]
        }
        
        
        if !(myPhoneNumber.isPhoneNumber) {
            
            UIAlertController.Alert(title: alertTitleWaning, msg: Mobile_No_entered_is_incorrect, vc: self)
            
            return
        }
        
        self.callLoginAPI(phoneNumber: myPhoneNumber)
    }
    
    
    //MARK: - Segue
    func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        
        if segue.identifier == "signUpSegue" {
            
            let signUpVC = segue.destination as! SignUpVC
            
//            let signUpVC = storyboard?.instantiateViewController(withIdentifier: "signUpVC") as! SignUpVC
            
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
        else if segue.identifier == "otpVerificationVCSegue" {
            
            let oTPVerificationVC = segue.destination as! OTPVerificationVC
            
            oTPVerificationVC.myMobileNumber = myPhoneNumber
            
            self.navigationController?.pushViewController(oTPVerificationVC, animated: true)
        }
    }
    
    //MARK: - Delegate UITextField
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
    
        var strFloor = textFieldText.replacingCharacters(in: range, with: string)
        
        print(strFloor)
        
        print(range)
        
        if strFloor.count == 1 {
            
            strFloor = String(format: "+%@-%@", countAreaCode, strFloor)
        }
        
        if strFloor.count == 5 {
            
            strFloor = ""
        }
        
        txtMobileNumber.text = strFloor
        
        return false
    }
    
    
    //MARK: - APIs
    func callLoginAPI(phoneNumber: String) -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        
        UserVM.shared.loginAPI(phoneNo: phoneNumber, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
            
                print(dictResponse)
                CommonFile.shared.hudDismiss()
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
//                    self.performSegue(withIdentifier: "otpVerificationVCSegue", sender: self)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let otpVerificationVC = storyboard.instantiateViewController(withIdentifier: "otpVerificationVC") as! OTPVerificationVC
                    
                    otpVerificationVC.myMobileNumber = phoneNumber
                    
                    self.navigationController?.pushViewController(otpVerificationVC, animated: true)
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
}

