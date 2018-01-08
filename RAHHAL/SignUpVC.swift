//
//  SignUpVC.swift
//  RAHHAL
//
//  Created by RAJ on 03/12/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtMobileNo: UITextField!
    
    @IBOutlet weak var btnCheckBoxTandC: UIButton!
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.createUI()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func createUI() -> Void {
        
        txtFirstName.leftImageOfTextField(imgName: "userLeftText", imgSize: CGSize(width: 20, height: 20))
        
        txtLastName.leftImageOfTextField(imgName: "userLeftText", imgSize: CGSize(width: 20, height: 20))
        
        txtMobileNo.leftImageOfTextField(imgName: "mobileNumber", imgSize: CGSize(width: 20, height: 25))
    }
    
    
    //MARK: - UIButton Actions
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnCheckBoxTermAndConditionAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func btnTermAndConditionAction(_ sender: UIButton) {
    }
    
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        let fName = txtFirstName.text?.Trim()
        
        let lName = txtLastName.text?.Trim()
        
        var mobileNo = txtMobileNo.text?.Trim()
        
        if !(mobileNo?.isEmpty)! {
            
            let arrPhone = mobileNo?.components(separatedBy: "-")
            
            mobileNo = arrPhone?[1]
        }
        
        guard !(fName?.isEmpty)! && !(lName?.isEmpty)! && !(mobileNo?.isEmpty)! else {
            
             UIAlertController.Alert(title: alertTitleWaning, msg: Please_fill_all_the_fields, vc: self)
            
            return
        }
        
        if !((mobileNo?.isPhoneNumber)!) {
            
            UIAlertController.Alert(title: alertTitleWaning, msg: Mobile_No_entered_is_incorrect, vc: self)
            
            return
        }
        
        guard btnCheckBoxTandC.isSelected else {
            
            UIAlertController.Alert(title: alertTitleWaning, msg: You_must_agree_with_the_terms_and_conditions, vc: self)
            return
        }
        
        self.userRegistration(fName: fName!, lName: lName!, myPhoneNo: mobileNo!)
    }
    
    
    // MARK: - Delegate UITextField
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        var frame = self.view.frame
        
        if textField == txtFirstName {
            
            txtLastName.becomeFirstResponder()
            
        }
        else if textField == txtLastName {
            
            txtMobileNo.becomeFirstResponder()
            
        }
        else if textField == txtMobileNo {
            textField.resignFirstResponder()
            
            return true
        }
        return false
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        var frame = self.view.frame
        
        if textField == txtLastName {
            
            txtLastName.becomeFirstResponder()
            frame.origin.y = -100
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = frame
            })
            
        }
        else if textField == txtMobileNo {
            
            txtMobileNo.becomeFirstResponder()
            frame.origin.y = -170
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = frame
            })
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtMobileNo {
            var frame = self.view.frame
            frame.origin.y = 00
            
            self.view.frame = frame
        }
    }
    
    //MARK: - Delegate UITextField
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if txtMobileNo == textField {
            
            let textFieldText: NSString = (textField.text ?? "") as NSString
            
            var strFloor = textFieldText.replacingCharacters(in: range, with: string)
            
            if strFloor.count == 1 {
                
                strFloor = String(format: "+%@-%@", countAreaCode, strFloor)
            }
            
            if strFloor.count == 5 {
                
                strFloor = ""
            }
            
            txtMobileNo.text = strFloor
            
            return false
        }
        
        return true
    }
    
    
    // MARK: - Call APIs
    func userRegistration(fName: String, lName: String, myPhoneNo: String) -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        
        UserVM.shared.signupAPI(FName: fName, LName: lName, phoneNo: myPhoneNo, completionHandler: { (dictResponse) in
            DispatchQueue.main.async {
                
                print(dictResponse)
                CommonFile.shared.hudDismiss()
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let otpVerificationVC = storyboard.instantiateViewController(withIdentifier: "otpVerificationVC") as! OTPVerificationVC
                    
                    otpVerificationVC.myMobileNumber = myPhoneNo
                    
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
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
