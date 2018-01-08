//
//  PostTripVC.swift
//  RAHHAL
//
//  Created by Macbook on 12/30/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit

class PostTripVC: UIViewController, UIPopoverPresentationControllerDelegate, PopOverVCDelegates, UITextFieldDelegate, UITextViewDelegate, ViewDayNDatePickerDelegates, AddressViewControllerDelegate, SearchCityNameVCDelegate {

    @IBOutlet var svMain: UIScrollView!
    
    @IBOutlet var viewContainer: UIView!
    
    @IBOutlet var viewSelectCity: UIView!
    
    @IBOutlet var viewShipmentType: UIView!
    
    @IBOutlet var viewFromLoc: UIView!
    
    @IBOutlet var viewToLoc: UIView!
    
    @IBOutlet var viewWeight: UIView!
    
    @IBOutlet var viewPrice: UIView!
    
    @IBOutlet var viewStartDate: UIView!
    
    @IBOutlet var viewEndDate: UIView!
    
    @IBOutlet var viewDesc: UIView!
    
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
    
    @IBOutlet var txtViewDescription: UITextView!
    
    @IBOutlet var btnSubmit: UIButton!
    
    
    
    var dictTripInfo = [String : String]()
    
    var viewDayNDatePicker: ViewDayNDatePicker!
    
    var isOnDemandShipment = Bool()
    
    var endEditingNow = String()
    
    var queue = OperationQueue()
    
    var frameViewContainer = CGRect()
    
    var tripType = String()
    
    
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if tripType == "update" {
            
            btnSubmit.setTitle("Update", for: .normal)
        }
        else if tripType == "search" {
            
            btnSubmit.setTitle("Chat Request", for: .normal)
            
            viewContainer.isUserInteractionEnabled = false
        }
        
        if dictTripInfo.isEmpty {
            
        if isOnDemandShipment {
            
            viewShipmentType.isHidden = true
            dictTripInfo["type"] = "Within City"
        }
        else {
            
            viewSelectCity.isHidden = true
            dictTripInfo["type"] = ""
        }
        
//        dictTripInfo["title"] = ""
        dictTripInfo["from_location"] = ""
        dictTripInfo["to_location"] = ""
        dictTripInfo["weight"] = ""
        dictTripInfo["departure"] = ""
        dictTripInfo["arrival"] = ""
//        dictTripInfo["fees"] = ""
//        dictTripInfo["pictureIds"] = ""
        dictTripInfo["city_name"] = ""
        dictTripInfo["note"] = ""
        
        }
        else {
            
            
            viewShipmentType.isUserInteractionEnabled = false
            
            let startDate = TimeStatus.getDate(isApplyTimeZone: false, strDate: dictTripInfo["departure"]!, oldFormatter: "yyyy-MM-dd hh-mm-ss", newFormat: "yyyy-MM-dd")
let endDate = TimeStatus.getDate(isApplyTimeZone: false, strDate: dictTripInfo["arrival"]!, oldFormatter: "yyyy-MM-dd hh-mm-ss", newFormat: "yyyy-MM-dd")
            
            var dictOldTrip = [String: String]()
            dictOldTrip["type"] = dictTripInfo["type"]
            dictOldTrip["from_location"] = dictTripInfo["from_location"]
            dictOldTrip["to_location"] = dictTripInfo["to_location"]
            dictOldTrip["weight"] = dictTripInfo["weight"]
            dictOldTrip["departure"] = startDate
            dictOldTrip["arrival"] = endDate
            dictOldTrip["city_name"] = dictTripInfo["city_name"]
            dictOldTrip["note"] = dictTripInfo["note"]
            dictOldTrip["tripId"] = dictTripInfo["id"]
            
            dictTripInfo.removeAll()
            
            dictTripInfo = dictOldTrip
            
            btnShipmentType.setTitle(dictTripInfo["type"], for: .normal)
            txtSelectCity.text = dictTripInfo["city_name"]
            txtFrom.text = dictTripInfo["from_location"]
            txtTo.text = dictTripInfo["to_location"]
            
            btnStartDate.setTitle(startDate, for: .normal)
            
            btnEndDate.setTitle(endDate, for: .normal)
            
            txtWeight.text =  dictTripInfo["weight"]
            
            if let fees = dictTripInfo["fees"] {
                
                txtPrice.text = fees
            }
            
            txtViewDescription.text = dictTripInfo["note"]
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
        
//        if isOnDemandShipment {
//            self.navigationItem.navTitle(title: "Post Express Delivery")
//        }
//        else {
//            self.navigationItem.navTitle(title: "Post Shipment")
//        }
        if tripType == "update" {
            
            self.navigationItem.navTitle(title: "Update Trip")
        }
        else if tripType == "search" {
            
            self.navigationItem.navTitle(title: "Trip Info")
        }
        else {
            
            self.navigationItem.navTitle(title: "Post Trip")
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
            dictTripInfo["city_name"] = sytCityName
            txtSelectCity.text = sytCityName
        }
        else if type == "from" {
            btnFrom.setTitle("", for: .normal)
            dictTripInfo["from_location"] = sytCityName
            txtFrom.text = sytCityName
        }
        else if type == "to" {
            btnTo.setTitle("", for: .normal)
            dictTripInfo["to_location"] = sytCityName
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
        
        if let routeType = dictTripInfo["type"]?.Trim() {
            
            if routeType.isEmpty {
                
                UIAlertController.Alert(title: "", msg: "First select trip type", vc: self)
            }
            else if routeType == "Within City" {
                
                let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectUserAddressViewController") as! selectUserAddressViewController
                
                CVC.selectAddressStr = dictTripInfo["city_name"] as! NSString
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
        
        if let routeType = dictTripInfo["type"]?.Trim() {
            
            if routeType.isEmpty {
                
                UIAlertController.Alert(title: "", msg: "First select trip type", vc: self)
            }
            else if routeType == "Within City" {
                
                let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectUserAddressViewController") as! selectUserAddressViewController
                
                CVC.selectAddressStr = dictTripInfo["city_name"] as! NSString
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
            
            dateSelected = dictTripInfo["departure"] ?? ""
        }
        else {
            
            if dictTripInfo["departure"] == "" {
                
                UIAlertController.Alert(title: "", msg: "Please select Start Date", vc: self)
                
                return
            }
            
            if dictTripInfo["arrival"] == "" {
                
                dateSelected = dictTripInfo["departure"] ?? ""
            }
            else {
                
                dateSelected = dictTripInfo["arrival"] ?? ""
            }
        }
        
        viewDayNDatePicker.setOldDate(oldDate: dateSelected, dateType: dateType)
        
        viewDayNDatePicker.delegates = self
        
        self.view.addSubview(viewDayNDatePicker)
    }
    
    
    //MARK:- ViewDayNDatePicker Dalegates
    func btnCancelActionDatePickerView() -> Void {
        
        if viewDayNDatePicker != nil {
            
            viewDayNDatePicker.removeFromSuperview()
        }
    }
    
    
    func btnDoneActionDatePickerView(strDate: String, strDateAndTime: String, dateType: String) -> Void {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-d"
        
        self.btnCancelActionDatePickerView()
        
        let strOrderDeliveryDate = strDate
        
        print(strOrderDeliveryDate)
        
        let dateFormatter1 = DateFormatter()
        
        dateFormatter1.dateFormat = "yyyy-MM-d HH:mm:ss"
        
        let dateOne1 = dateFormatter1.date(from: strDateAndTime)
        
        print(dateOne1)
        
        if dateType == "start" {
            dictTripInfo["departure"] = strOrderDeliveryDate
            
            btnStartDate.setTitle(strOrderDeliveryDate, for: .normal)
            
            dictTripInfo["arrival"] = ""
            btnEndDate.setTitle("End Date", for: .normal)
        }
        else if dateType == "end" {
            dictTripInfo["arrival"] = strOrderDeliveryDate
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
        dictTripInfo["type"] = strDate
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
            
            yAiz = viewStartDate.frame.origin.y + viewStartDate.frame.size.height + space
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
            viewWeight.frame = CGRect(x: viewWeight.frame.origin.x, y: yAiz, width: viewWeight.frame.size.width, height: viewWeight.frame.size.height)
            
            viewPrice.frame = CGRect(x: viewPrice.frame.origin.x, y: yAiz, width: viewPrice.frame.size.width, height: viewPrice.frame.size.height)
            
            yAiz = viewWeight.frame.origin.y + viewWeight.frame.size.height + space
            viewStartDate.frame = CGRect(x: viewStartDate.frame.origin.x, y: yAiz, width: viewStartDate.frame.size.width, height: viewStartDate.frame.size.height)
            
            viewEndDate.frame = CGRect(x: viewEndDate.frame.origin.x, y: yAiz, width: viewEndDate.frame.size.width, height: viewEndDate.frame.size.height)
            
            yAiz = viewStartDate.frame.origin.y + viewStartDate.frame.size.height + space
            viewDesc.frame = CGRect(x: viewDesc.frame.origin.x, y: yAiz, width: viewDesc.frame.size.width, height: viewDesc.frame.size.height)
        }
    }
    
    
    //MARK: - AddressViewControllerDelegate
    func callbackWitAddress(strAddress: String, strAddressType: String) {
        
        print(strAddress)
        if strAddressType == "from" {
            
            dictTripInfo["from_location"] = strAddress
            
            txtFrom.text = strAddress
        }
        else if strAddressType == "to" {
            
            dictTripInfo["to_location"] = strAddress
            
            txtTo.text = strAddress
        }
    }
    
    
    // MARK: - UITextField Delegates
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        if txtFrom == textField {
//            if isOnDemandShipment {
//                let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectUserAddressViewController") as! selectUserAddressViewController
//
//                CVC.selectAddressStr = dictTripInfo["city_name"] as! NSString
//
//                CVC.delegate = self
//                CVC.addressType = "from"
//                self .present(CVC, animated: true, completion: nil)
//            }
//        }
//        else if txtTo == textField {
//
//            if isOnDemandShipment {
//                let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectUserAddressViewController") as! selectUserAddressViewController
//
//                CVC.selectAddressStr = dictTripInfo["city_name"] as! NSString
//                CVC.delegate = self
//                CVC.addressType = "to"
//                self .present(CVC, animated: true, completion: nil)
//            }
//        }
//        else if txtSelectCity == textField {
//
//        }
//        else
//        if txtWeight == textField {
//
//            adjustFrame(yAxiz: -50)
//        }
//        else if txtPrice == textField {
//
//            adjustFrame(yAxiz: -50)
//        }
    }
    
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        if endEditingNow == "yes" {
            
            endEditingNow = ""
            return
        }
        
//        if txtSelectCity == textField {
//
//        }
//        else if txtFrom == textField {
//
//        }
//        else if txtTo == textField {
//
//        }
//        else if txtWeight == textField {
//            
//            txtPrice.becomeFirstResponder()
//        }
//        else if txtPrice == textField {
//            
//            self.startPoint()
//        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if txtWeight == textField {
            
            dictTripInfo["weight"] = updatedText
        }
        else if txtPrice == textField {
            
            dictTripInfo["fees"] = updatedText
        }
        
//        if txtFrom == textField || txtTo == textField || txtSelectCity == textField {
//
//            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getHintsFromTextField), object: textField)
//
//            self.perform(#selector(getHintsFromTextField), with: textField, afterDelay: 0.5)
//        }
        
        if txtWeight == textField {
            
            return updatedText.count <= 3
        }
        else if txtPrice == textField {
            
            return updatedText.count <= 8
        }
        return true
    }
    
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        adjustFrame(yAxiz: -100  )
        
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
            
            dictTripInfo["note"] = changedText
            
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
    
    
    
    func checkValidationAndPostShipment() -> Void {
        
//        let title = dictTripInfo["title"]
        let type = dictTripInfo["type"]
        let city = dictTripInfo["city_name"]
        let from = dictTripInfo["from_location"]
        let to = dictTripInfo["to_location"]
        let weight = dictTripInfo["weight"]
        let fees = dictTripInfo["fees"]
        let startDate = dictTripInfo["departure"]
        let endDate = dictTripInfo["arrival"]
        //        let pic = dictTripInfo["pictureIds"]
        
        //        if (pic?.isEmpty)! {
        //
        //            dictTripInfo.removeValue(forKey: "pictureIds")
        //        }
        
        let note = dictTripInfo["note"]
        
//        guard !(title?.Trim().isEmpty)! else {
//
//            UIAlertController.Alert(title: "", msg: "Title cannot be left blank.", vc: self)
//
//            return
//        }
        
        if isOnDemandShipment {
            
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
        
        guard !(weight?.Trim().isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "Weight cannot be left blank.", vc: self)
            return
        }
        
//        guard !(fees?.Trim().isEmpty)! else {
//
//            UIAlertController.Alert(title: "", msg: "Currency cannot be left blank.", vc: self)
//            return
//        }
        
        guard !(startDate?.Trim().isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "Start date cannot be left blank.", vc: self)
            return
        }
        
        guard !(endDate?.Trim().isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "End date cannot be left blank.", vc: self)
            return
        }
        
        
        /*
        if isOnDemandShipment {
            
            
            let arrMySelectedCity = arrSelectCity.filter({ ($0 == city!) })
            
            if arrMySelectedCity.isEmpty {
                
                UIAlertController.Alert(title: "", msg: "Please fill valid City Name", vc: self)
                return
            }
            //            else {
            //
            //                dictTripInfo["city_name"] = String(format: "%@ %@", city!, arrMySelectedCity[0]["country"] as! String )
            //
            //            }
        }
        else {
            
            let arrMySelectedToCity = arrToCity.filter({ ($0 == to!) })
            
            if arrMySelectedToCity.isEmpty {
                
                UIAlertController.Alert(title: "", msg: "Please fill valid To Address", vc: self)
                return
            }
            //            else {
            //
            //                dictTripInfo["drop_location"] = String(format: "%@ %@", to!, arrMySelectedToCity[0]["country"] as! String)
            //            }
            
            let arrMySelectedFromCity = arrFromCity.filter({ ($0 == from!) })
            
            if arrMySelectedFromCity.isEmpty {
                
                UIAlertController.Alert(title: "", msg: "Please fill valid From Address", vc: self)
                return
            }
            //            else {
            //                dictTripInfo["pickup_location"] = String(format: "%@ %@", from!, arrMySelectedFromCity[0]["country"] as! String )
            //            }
        }
        */
        
        dictTripInfo["departure"] = String(format: "%@ 00:00:00", startDate!)
        
        dictTripInfo["arrival"] = String(format: "%@ 00:00:00", endDate!)
        
        
        print(dictTripInfo)
        
        if tripType == "update" {
            
            self.updateOldTrip()
        }
        else if tripType == "search" {
            
//            self.createNewTrip()
            UIAlertController.Alert(title: "", msg: "Coming soon", vc: self)
        }
        else {
            
            self.createNewTrip()
        }
    }
 
    
    func createNewTrip() -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        TripsVM.shared.newTrip(dictTripInfo: dictTripInfo, completionHandler: { (dictResponse) in
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
    
    
    func updateOldTrip() -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        
        TripsVM.shared.updateTrip(dictUserInfo:  dictTripInfo, completionHandler: { (dictResponse) in
            
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
