//
//  PostFavRouteVC.swift
//  RAHHAL
//
//  Created by Macbook on 1/1/18.
//  Copyright © 2018 RAJ. All rights reserved.
//

import UIKit

class PostFavRouteVC: UIViewController, UIPopoverPresentationControllerDelegate, PopOverVCDelegates, UITextFieldDelegate, UITextViewDelegate, AddressViewControllerDelegate, SearchCityNameVCDelegate {

    @IBOutlet var svMain: UIScrollView!
    
    @IBOutlet var viewContainer: UIView!
    
    @IBOutlet var viewShipmentType: UIView!
    
    @IBOutlet var viewSelectCity: UIView!
    
    @IBOutlet var viewFromLoc: UIView!
    
    @IBOutlet var viewToLoc: UIView!
    
    @IBOutlet var viewDesc: UIView!
    
    @IBOutlet var btnShipmentType: UIButton!
    
    @IBOutlet var txtSelectCity: UITextField!
    
    @IBOutlet var btnSelectCity: UIButton!
    
    @IBOutlet var txtFrom: UITextField!
    
    @IBOutlet var btnFrom: UIButton!
    
    @IBOutlet var txtTo: UITextField!
    
    @IBOutlet var btnTo: UIButton!
    
    @IBOutlet var txtViewDescription: UITextView!
    
    
    @IBOutlet var btnSubmit: UIButton!
    
    var dictFavRouteInfo = [String : String]()
    
    var isOnDemandFavRoute = Bool()
    
    var imgSelectedProduct = UIButton()
    
    var endEditingNow = String()
    
    var frameViewContainer = CGRect()
    
    var isUpdateOldRoute = Bool()
    
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if dictFavRouteInfo.isEmpty {
            
            if isOnDemandFavRoute {
                
                viewShipmentType.isHidden = true
                dictFavRouteInfo["type"] = "Within City"
            }
            else {
                
                viewSelectCity.isHidden = true
                dictFavRouteInfo["type"] = ""
            }
            
            dictFavRouteInfo["pickup_location"] = ""
            dictFavRouteInfo["drop_location"] = ""
            dictFavRouteInfo["city_name"] = ""
            dictFavRouteInfo["note"] = ""
            
        }
        else {
            
            viewShipmentType.isUserInteractionEnabled = false
            
            var dictOldRoute = [String : String]()
            
            dictOldRoute["type"] = dictFavRouteInfo["type"]
            dictOldRoute["pickup_location"] = dictFavRouteInfo["pickup_location"]
            dictOldRoute["drop_location"] = dictFavRouteInfo["drop_location"]
            dictOldRoute["city_name"] = dictFavRouteInfo["city_name"]
            dictOldRoute["note"] = dictFavRouteInfo["note"]
            dictOldRoute["routeId"] = dictFavRouteInfo["id"]
            
            dictFavRouteInfo.removeAll()
            
            dictFavRouteInfo = dictOldRoute
            
            btnShipmentType.setTitle(dictFavRouteInfo["type"], for: .normal)
            txtSelectCity.text = dictFavRouteInfo["city_name"]
            txtFrom.text = dictFavRouteInfo["pickup_location"]
            txtTo.text = dictFavRouteInfo["drop_location"]
            
            txtViewDescription.text = dictFavRouteInfo["note"]
        }
        self.navigationView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        frameViewContainer = viewContainer.frame
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Navigation
    func navigationView() -> Void {
        
        if isUpdateOldRoute {
            self.navigationItem.navTitle(title: "Update Favorite Route")
            
            btnSubmit.setTitle("Update", for: .normal)
        }
        else {
            self.navigationItem.navTitle(title: "Create Favorite Route")
            
            btnSubmit.setTitle("Submit", for: .normal)
        }
        
        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "arrowBack"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = UIFont.fontMontserratLight16()
        button.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        //        self.navigationItem.rightButton(btn: btnEdit)
    }
    
    
    @objc func btnBackAction() -> Void {
        
        print("Back Click")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - SearchCityNameVCDelegate
    func getSelectedCityName(sytCityName: String, type: String, vc: UIViewController) {
        
        vc.navigationController?.popViewController(animated: true)
        
        if type == "selectCity" {
            
            btnSelectCity.setTitle("", for: .normal)
            dictFavRouteInfo["city_name"] = sytCityName
            txtSelectCity.text = sytCityName
        }
        else if type == "from" {
            btnFrom.setTitle("", for: .normal)
            dictFavRouteInfo["pickup_location"] = sytCityName
            txtFrom.text = sytCityName
        }
        else if type == "to" {
            btnTo.setTitle("", for: .normal)
            dictFavRouteInfo["drop_location"] = sytCityName
            txtTo.text = sytCityName
        }
    }
    
    
    // MARK: - UIButton Actions
    @IBAction func btnShipmentTypeAction(_ sender: UIButton) {
        
        endEditingNow = "yes"
        
        self.startPoint()
        
        self.view.endEditing(true)
        
        //        let point = sender.convert(CGPoint.zero, to: self.view)
        
        let popController = PopOverVC(nibName: "PopOverVC", bundle: nil)
        
        popController.preferredContentSize = CGSize(width: 170, height: 150)
        
        popController.delegates = self
        
        //        popController.strSelectedDate = selectedDate
        
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        
        popController.popoverPresentationController?.delegate = self
        
        popController.popoverPresentationController?.sourceView = sender as UIView
        
        popController.popoverPresentationController?.sourceRect = sender.frame
        
        popController.popoverPresentationController?.backgroundColor = UIColor.white
        
        self.present(popController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnSelectCityAction(_ sender: UIButton) {
        
        let searchCityNameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchCityNameVC") as! SearchCityNameVC
        
        searchCityNameVC.searchType = "selectCity"
        
        searchCityNameVC.delegate = self
        
        self.navigationController?.pushViewController(searchCityNameVC, animated: true)
    }
    
    
    @IBAction func btnFromLocationAction(_ sender: UIButton) {
        
        if let routeType = dictFavRouteInfo["type"]?.Trim() {
            
            if routeType.isEmpty {
                
                UIAlertController.Alert(title: "", msg: "First select route type", vc: self)
            }
            else if routeType == "Within City" {
                
                let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectUserAddressViewController") as! selectUserAddressViewController
                
                CVC.selectAddressStr = dictFavRouteInfo["city_name"] as! NSString
                CVC.delegate = self
                CVC.addressType = "from"
                self .present(CVC, animated: true, completion: nil)
            }
            else {
                
                let searchCityNameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchCityNameVC") as! SearchCityNameVC
                
                searchCityNameVC.searchType = "from"
                
                searchCityNameVC.delegate = self
                
                self.navigationController?.pushViewController(searchCityNameVC, animated: true)
            }
        }
    }
    
    
    @IBAction func btnToLocationAction(_ sender: UIButton) {
        
        if let routeType = dictFavRouteInfo["type"]?.Trim() {
            
            if routeType.isEmpty {
                
                UIAlertController.Alert(title: "", msg: "First select route type", vc: self)
            }
            else if routeType == "Within City" {
                
                let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectUserAddressViewController") as! selectUserAddressViewController
                
                CVC.selectAddressStr = dictFavRouteInfo["city_name"] as! NSString
                CVC.delegate = self
                CVC.addressType = "to"
                self .present(CVC, animated: true, completion: nil)
            }
            else {
                
                let searchCityNameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchCityNameVC") as! SearchCityNameVC
                
                searchCityNameVC.searchType = "to"
                
                searchCityNameVC.delegate = self
                
                self.navigationController?.pushViewController(searchCityNameVC, animated: true)
            }
        }
    }
    
    
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        self.checkValidationAndPostFavRoute()
    }
    
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        //do som stuff from the popover
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
    
    
    func getPopOverValue(strDate: String, vc: UIViewController) {
        
        print(strDate)
//        self.setViewContents(type: strDate)
        dictFavRouteInfo["type"] = strDate
        btnShipmentType.setTitle(strDate, for: .normal)
        vc.dismiss(animated: true, completion: nil)
    }
    
    
    func setViewContents(type: String) -> Void {
        
        let space: CGFloat = 28.0
        
        if type == "Within City" {
            
            viewSelectCity.isHidden = false
            
            viewContainer.frame = CGRect(x: viewContainer.frame.origin.x, y: frameViewContainer.origin.y, width: viewContainer.frame.size.width, height: frameViewContainer.size.height + 60)
            
            var yAiz = viewSelectCity.frame.origin.y + viewSelectCity.frame.size.height + space
            
            viewFromLoc.frame = CGRect(x: viewFromLoc.frame.origin.x, y: yAiz, width: viewFromLoc.frame.size.width, height: viewFromLoc.frame.size.height)
            
            yAiz = viewFromLoc.frame.origin.y + viewFromLoc.frame.size.height + space
            viewToLoc.frame = CGRect(x: viewToLoc.frame.origin.x, y: yAiz, width: viewToLoc.frame.size.width, height: viewToLoc.frame.size.height)
            
            yAiz = viewToLoc.frame.origin.y + viewToLoc.frame.size.height + space
            
            viewDesc.frame = CGRect(x: viewDesc.frame.origin.x, y: yAiz, width: viewDesc.frame.size.width, height: viewDesc.frame.size.height)
            
            
            //            viewContainer.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]
            //
            //            viewContainer.layoutIfNeeded()
        }
        else {
            
            viewSelectCity.isHidden = true
            
            
            viewContainer.frame = frameViewContainer
            
            var yAiz = viewSelectCity.frame.origin.y
            
            viewFromLoc.frame = CGRect(x: viewFromLoc.frame.origin.x, y: yAiz, width: viewFromLoc.frame.size.width, height: viewFromLoc.frame.size.height)
            
            yAiz = viewFromLoc.frame.origin.y + viewFromLoc.frame.size.height + space
            viewToLoc.frame = CGRect(x: viewToLoc.frame.origin.x, y: yAiz, width: viewToLoc.frame.size.width, height: viewToLoc.frame.size.height)
            
            yAiz = viewToLoc.frame.origin.y + viewToLoc.frame.size.height + space
           
            viewDesc.frame = CGRect(x: viewDesc.frame.origin.x, y: yAiz, width: viewDesc.frame.size.width, height: viewDesc.frame.size.height)
        }
    }
    
    
    //MARK: - AddressViewControllerDelegate
    func callbackWitAddress(strAddress: String, strAddressType: String) {
        
        print(strAddress)
        if strAddressType == "from" {
            
            dictFavRouteInfo["pickup_location"] = strAddress
            
            txtFrom.text = strAddress
        }
        else if strAddressType == "to" {
            
            dictFavRouteInfo["drop_location"] = strAddress
            
            txtTo.text = strAddress
        }
    }
    
    
    // MARK: - UITextField Delegates
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        adjustFrame(yAxiz: -40  )
        
        return true
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        if (text == "\n") {
            textView.resignFirstResponder()
            
            self.startPoint()
            
            return false
        }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if changedText.count <= 200 {
            
            dictFavRouteInfo["note"] = changedText
            
            return true
        }
        
        textView.resignFirstResponder()
        
        self.startPoint()
        
        return false
    }
    
    
    // MARK: - Adjust VC With Animation
    
    func startPoint() -> Void {
        
        let yAxiz =  Float((self.navigationController?.navigationBar.frame.size.height)!) + 20
        
        self.view.frame = CGRect(x: self.view.frame.origin.x, y: CGFloat(yAxiz), width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    func adjustFrame(yAxiz: Float) -> Void {
        
        var durationTime = 0.5
        
        if yAxiz == 0 {
            
            durationTime = 0
        }
        
        UIView.animate(withDuration: durationTime) {
            
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: CGFloat(yAxiz), width: self.view.frame.size.width, height: self.view.frame.size.height)
            
        }
    }
    
    
    
    func checkValidationAndPostFavRoute() -> Void {
        
        //        let title = dictFavRouteInfo["title"]
        let type = dictFavRouteInfo["type"]
        let city = dictFavRouteInfo["city_name"]
        let from = dictFavRouteInfo["pickup_location"]
        let to = dictFavRouteInfo["drop_location"]
        let note = dictFavRouteInfo["note"]
        
        
        if isOnDemandFavRoute {
            
            guard !(city?.Trim().isEmpty)! else {
                
                UIAlertController.Alert(title: "", msg: "Select City cannot be left blank.", vc: self)
                
                return
            }
        }
        else  {
            
            guard !(type?.Trim().isEmpty)! else {
                
                UIAlertController.Alert(title: "", msg: "Please select shipment type.", vc: self)
                
                return
            }
        }
        
        guard !(from?.Trim().isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "From cannot be left blank.", vc: self)
            return
        }
        
        guard !(to?.Trim().isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "To cannot be left blank.", vc: self)
            return
        }
        
        
        print(dictFavRouteInfo)
        
        if isUpdateOldRoute {
            
            self.updateFavRoute()
        }
        else {
            
            self.createNewFavRoute()
        }
    }
    
    
    func createNewFavRoute() -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        
        FavRouteVM.shared.newFavRoute(dictFavRouteInfo: dictFavRouteInfo, completionHandler: { (dictResponse) in
            DispatchQueue.main.async {
                
                CommonFile.shared.hudDismiss()
                
                print(dictResponse)
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    if let dictUser = dictResponse["data"] as? [String: AnyObject] {
                        
                        if let response = dictUser["response"] as? String, response == "success" {
                            
                            self.btnBackAction()
                        }
                        else  {
                            
                            let msgStr = dictResponse["message"] as! String
                            
                            UIAlertController.Alert(title: "", msg: msgStr, vc: self)
                        }
                    }
                }
                else {
                    let msgStr = dictResponse["message"] as! String
                    
                    UIAlertController.Alert(title: "", msg: msgStr, vc: self)
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
    
    
    func updateFavRoute() -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        
        FavRouteVM.shared.updateFavRoute(dictFavRouteInfo: dictFavRouteInfo, completionHandler: { (dictResponse) in
            DispatchQueue.main.async {
                
                CommonFile.shared.hudDismiss()
                
                print(dictResponse)
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    if let dictUser = dictResponse["data"] as? [String: AnyObject] {
                        
                        if let response = dictUser["response"] as? String, response == "success" {
                            
                            self.btnBackAction()
                        }
                        else  {
                            
                            let msgStr = dictResponse["message"] as! String
                            
                            UIAlertController.Alert(title: "", msg: msgStr, vc: self)
                        }
                    }
                }
                else {
                    let msgStr = dictResponse["message"] as! String
                    
                    UIAlertController.Alert(title: "", msg: msgStr, vc: self)
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