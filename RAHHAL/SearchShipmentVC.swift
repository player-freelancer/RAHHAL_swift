//
//  SearchShipmentVC.swift
//  RAHHAL
//
//  Created by Macbook on 1/2/18.
//  Copyright © 2018 RAJ. All rights reserved.
//

import UIKit

class SearchShipmentVC: UIViewController, UIPopoverPresentationControllerDelegate, PopOverVCDelegates, UITextFieldDelegate, ViewDayNDatePickerDelegates, AddressViewControllerDelegate, SearchCityNameVCDelegate {
    
    
    @IBOutlet var viewContainer: UIView!
    
    @IBOutlet var viewShipmentType: UIView!
    
    @IBOutlet var viewSelectCity: UIView!
    
    @IBOutlet var viewFromLoc: UIView!
    
    @IBOutlet var viewToLoc: UIView!
    
    @IBOutlet var viewWeight: UIView!
    
    @IBOutlet var viewPrice: UIView!
    
    @IBOutlet var viewStartDate: UIView!
    
    @IBOutlet var viewEndDate: UIView!
    
    @IBOutlet var btnShipmentType: UIButton!
    
    @IBOutlet var txtFrom: UITextField!
    
    @IBOutlet var btnFrom: UIButton!
    
    @IBOutlet var txtTo: UITextField!
    
    @IBOutlet var btnTo: UIButton!
    
    @IBOutlet var txtSelectCity: UITextField!
    
    @IBOutlet var btnSelectCity: UIButton!
    
    @IBOutlet var txtWeight: UITextField!
    
    @IBOutlet var txtPrice: UITextField!
    
    @IBOutlet var btnStartDate: UIButton!
    
    @IBOutlet var btnEndDate: UIButton!
    
    @IBOutlet var btnSubmit: UIButton!
    
    
    
    var dictShipmentInfo = [String : String]()
    
    var viewDayNDatePicker: ViewDayNDatePicker!
    
    var isOnDemandShipment = Bool()
    
    var endEditingNow = String()
    
    var queue = OperationQueue()
    
    var frameViewContainer = CGRect()
    
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        if isOnDemandShipment {
//
//            viewShipmentType.isHidden = true
//            dictShipmentInfo["type"] = "Within City"
//        }
//        else {
//
//            viewSelectCity.isHidden = true
//            dictShipmentInfo["type"] = ""
//        }
        
        viewSelectCity.isHidden = true
        dictShipmentInfo["type"] = ""
        dictShipmentInfo["pickup_location"] = ""
        dictShipmentInfo["drop_location"] = ""
        dictShipmentInfo["weight"] = ""
        dictShipmentInfo["start_date"] = ""
        dictShipmentInfo["end_date"] = ""
        dictShipmentInfo["fees"] = ""
        dictShipmentInfo["city_name"] = ""
        
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
        
        //        if isOnDemandShipment {
        //            self.navigationItem.navTitle(title: "Post Express Delivery")
        //        }
        //        else {
        //            self.navigationItem.navTitle(title: "Post Shipment")
        //        }
        
        self.navigationItem.navTitle(title: "Find Shipment")
        
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
            dictShipmentInfo["city_name"] = sytCityName
            txtSelectCity.text = sytCityName
        }
        else if type == "from" {
            btnFrom.setTitle("", for: .normal)
            dictShipmentInfo["pickup_location"] = sytCityName
            txtFrom.text = sytCityName
        }
        else if type == "to" {
            btnTo.setTitle("", for: .normal)
            dictShipmentInfo["drop_location"] = sytCityName
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
        
        if let routeType = dictShipmentInfo["type"]?.Trim() {
            
            if routeType.isEmpty {
                
                UIAlertController.Alert(title: "", msg: "First select trip type", vc: self)
            }
            else if routeType == "Within City" {
                
                let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectUserAddressViewController") as! selectUserAddressViewController
                
                CVC.selectAddressStr = dictShipmentInfo["city_name"] as! NSString
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
        
        if let routeType = dictShipmentInfo["type"]?.Trim() {
            
            if routeType.isEmpty {
                
                UIAlertController.Alert(title: "", msg: "First select trip type", vc: self)
            }
            else if routeType == "Within City" {
                
                let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectUserAddressViewController") as! selectUserAddressViewController
                
                CVC.selectAddressStr = dictShipmentInfo["city_name"] as! NSString
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
    
    
    @IBAction func btnStartDateAction(_ sender: UIButton) {
        
        endEditingNow = "yes"
        
        self.startPoint()
        
        self.view.endEditing(true)
        
        self.openViewDatePicker(dateType: "start")
    }
    
    
    @IBAction func btnEndDateAction(_ sender: UIButton) {
        
        endEditingNow = "yes"
        
        self.startPoint()
        
        self.view.endEditing(true)
        
        self.openViewDatePicker(dateType: "end")
    }
    
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        self.checkValidationAndPostShipment()
    }
    
    
    func openViewDatePicker(dateType: String) -> Void {
        
        self.view.endEditing(true)
        
        if viewDayNDatePicker != nil {
            
            viewDayNDatePicker.removeFromSuperview()
        }
        viewDayNDatePicker = Bundle.main.loadNibNamed("ViewDayNDatePicker", owner: nil, options: nil)?[0] as? ViewDayNDatePicker
        
        viewDayNDatePicker.frame = CGRect(x: 0, y: self.view.frame.size.height - 200, width: DeviceInfo.TheCurrentDeviceWidth, height: 200)
        
        var dateSelected = String()
        
        if dateType == "start" {
            
            dateSelected = dictShipmentInfo["start_date"] ?? ""
        }
        else {
            
            if dictShipmentInfo["start_date"] == "" {
                
                UIAlertController.Alert(title: "", msg: "Please select Start Date", vc: self)
                
                return
            }
            
            if dictShipmentInfo["end_date"] == "" {
                
                dateSelected = dictShipmentInfo["start_date"] ?? ""
            }
            else {
                
                dateSelected = dictShipmentInfo["end_date"] ?? ""
            }
        }
        
        viewDayNDatePicker.setOldDate(oldDate: dateSelected, dateType: dateType)
        
        viewDayNDatePicker.delegates = self
        
        self.view.addSubview(viewDayNDatePicker)
    }
    
    
    //MARK:- ViewDayNDatePicker Dalegates
    func btnCancelActionDatePickerView(dateType: String) -> Void {
        
        if dateType == "start" {
            dictShipmentInfo["start_date"] = ""
            
            btnStartDate.setTitle("Start Date", for: .normal)
            
            dictShipmentInfo["end_date"] = ""
            btnEndDate.setTitle("End Date", for: .normal)
        }
        else if dateType == "end" {
            dictShipmentInfo["end_date"] = ""
            btnEndDate.setTitle("End Date", for: .normal)
        }
        
       self.hideDatePickerView()
    }
    
    
    func hideDatePickerView() -> Void {
        
        if viewDayNDatePicker != nil {
            
            viewDayNDatePicker.removeFromSuperview()
        }
    }
    
    
    func btnDoneActionDatePickerView(strDate: String, strDateAndTime: String, dateType: String) -> Void {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-d"
        
        self.hideDatePickerView()
        
        let strOrderDeliveryDate = strDate
        
        print(strOrderDeliveryDate)
        
        let dateFormatter1 = DateFormatter()
        
        dateFormatter1.dateFormat = "yyyy-MM-d HH:mm:ss"
        
        let dateOne1 = dateFormatter1.date(from: strDateAndTime)
        
        print(dateOne1)
        
        if dateType == "start" {
            dictShipmentInfo["start_date"] = strOrderDeliveryDate
            
            btnStartDate.setTitle(strOrderDeliveryDate, for: .normal)
            
            dictShipmentInfo["end_date"] = ""
            btnEndDate.setTitle("End Date", for: .normal)
        }
        else if dateType == "end" {
            dictShipmentInfo["end_date"] = strOrderDeliveryDate
            btnEndDate.setTitle(strOrderDeliveryDate, for: .normal)
        }
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
        dictShipmentInfo["type"] = strDate
        btnShipmentType.setTitle(strDate, for: .normal)
        vc.dismiss(animated: true, completion: nil)
    }
    
    func setViewContents(type: String) -> Void {
        
        let space: CGFloat = 28.0
        
        if type == "Within City" {
            
            viewSelectCity.isHidden = false
            
            viewContainer.frame = CGRect(x: viewContainer.frame.origin.x, y: frameViewContainer.origin.y - 20, width: viewContainer.frame.size.width, height: frameViewContainer.size.height + 60)
            
            var yAiz = viewSelectCity.frame.origin.y + viewSelectCity.frame.size.height + space
            
            viewFromLoc.frame = CGRect(x: viewFromLoc.frame.origin.x, y: yAiz, width: viewFromLoc.frame.size.width, height: viewFromLoc.frame.size.height)
            
            yAiz = viewFromLoc.frame.origin.y + viewFromLoc.frame.size.height + space
            viewToLoc.frame = CGRect(x: viewToLoc.frame.origin.x, y: yAiz, width: viewToLoc.frame.size.width, height: viewToLoc.frame.size.height)
            
            yAiz = viewToLoc.frame.origin.y + viewToLoc.frame.size.height + space
            viewWeight.frame = CGRect(x: viewWeight.frame.origin.x, y: yAiz, width: viewWeight.frame.size.width, height: viewWeight.frame.size.height)
            
            viewPrice.frame = CGRect(x: viewPrice.frame.origin.x, y: yAiz, width: viewPrice.frame.size.width, height: viewPrice.frame.size.height)
            
            yAiz = viewWeight.frame.origin.y + viewWeight.frame.size.height + space
            viewStartDate.frame = CGRect(x: viewStartDate.frame.origin.x, y: yAiz, width: viewStartDate.frame.size.width, height: viewStartDate.frame.size.height)
            
            viewEndDate.frame = CGRect(x: viewEndDate.frame.origin.x, y: yAiz, width: viewEndDate.frame.size.width, height: viewEndDate.frame.size.height)
            
            
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
            viewWeight.frame = CGRect(x: viewWeight.frame.origin.x, y: yAiz, width: viewWeight.frame.size.width, height: viewWeight.frame.size.height)
            
            viewPrice.frame = CGRect(x: viewPrice.frame.origin.x, y: yAiz, width: viewPrice.frame.size.width, height: viewPrice.frame.size.height)
            
            yAiz = viewWeight.frame.origin.y + viewWeight.frame.size.height + space
            viewStartDate.frame = CGRect(x: viewStartDate.frame.origin.x, y: yAiz, width: viewStartDate.frame.size.width, height: viewStartDate.frame.size.height)
            
            viewEndDate.frame = CGRect(x: viewEndDate.frame.origin.x, y: yAiz, width: viewEndDate.frame.size.width, height: viewEndDate.frame.size.height)
            
        }
    }
    
    
    //MARK: - AddressViewControllerDelegate
    func callbackWitAddress(strAddress: String, strAddressType: String) {
        
        print(strAddress)
        if strAddressType == "from" {
            
            dictShipmentInfo["pickup_location"] = strAddress
            
            txtFrom.text = strAddress
        }
        else if strAddressType == "to" {
            
            dictShipmentInfo["drop_location"] = strAddress
            
            txtTo.text = strAddress
        }
    }
    
    
    // MARK: - UITextField Delegates
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if txtWeight == textField {
            
            adjustFrame(yAxiz: -50)
        }
        else if txtPrice == textField {
            
            adjustFrame(yAxiz: -50)
        }
    }
    
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        if endEditingNow == "yes" {
            
            endEditingNow = ""
            self.startPoint()
            return
        }
        else if txtWeight == textField {
            
            txtPrice.becomeFirstResponder()
        }
        else if txtPrice == textField {
            
            self.startPoint()
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if txtWeight == textField {
            if updatedText.count < 4 {
            dictShipmentInfo["weight"] = updatedText
            }
        }
        else if txtPrice == textField {
            if updatedText.count < 6 {
            dictShipmentInfo["fees"] = updatedText
            }
        }
        
        if txtWeight == textField {
            
            return updatedText.count <= 3
        }
        else if txtPrice == textField {
            
            return updatedText.count <= 5
        }
        return true
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
    
    
    
    func checkValidationAndPostShipment() -> Void {
        
        let type = dictShipmentInfo["type"]
        let city = dictShipmentInfo["city_name"]
        let from = dictShipmentInfo["pickup_location"]
        let to = dictShipmentInfo["drop_location"]
        
        
        if type == "Within City" {
            
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
        
        guard from?.Trim() != to?.Trim()  else {
            
            UIAlertController.Alert(title: "", msg: "From & To cannot match with each other.", vc: self)
            return
        }
        
        if dictShipmentInfo["start_date"] != "" {
            
            if dictShipmentInfo["end_date"] == "" {
                
                dictShipmentInfo["end_date"] = dictShipmentInfo["start_date"]
            }
        }
        
        print(dictShipmentInfo)
        
        self.searchShipmentsAPI()
        
    }
    
    
    func searchShipmentsAPI() -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        
        ShipmentsVM.shared.findShipment(dictUserInfo: dictShipmentInfo, completionHandler: { (dictResponse) in
            DispatchQueue.main.async {

                CommonFile.shared.hudDismiss()

                print(dictResponse)

                if let status = dictResponse["status"] as? Bool, status == true {

                    if let dictUser = dictResponse["data"] as? [String: AnyObject] {

                        if let response = dictUser["response"] as? String, response == "success" {

                            let arrSearchShipment = dictUser["shipments"] as! [[String: AnyObject]]
                            
                            if arrSearchShipment.isEmpty {
                                
                                UIAlertController.Alert(title: "", msg: "There are no shipment according to your search contents", vc: self)
                                return
                            }
                            else {
                                
                                let searchShipmentListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchShipmentListVC") as! SearchShipmentListVC
                                
                                searchShipmentListVC.arrSearchShipment = arrSearchShipment
                                
                                self.navigationController?.pushViewController(searchShipmentListVC, animated: true)
                            }
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

