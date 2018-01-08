//
//  PostShipmentVC.swift
//  RAHHAL
//
//  Created by Macbook on 12/17/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit
import SDWebImage

class PostShipmentVC: UIViewController, UIPopoverPresentationControllerDelegate, PopOverVCDelegates, UITextFieldDelegate, UITextViewDelegate, ViewDayNDatePickerDelegates, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ViewDropDownListDelegates, AddressViewControllerDelegate, SearchCityNameVCDelegate {
    
    @IBOutlet var svMain: UIScrollView!
    
    @IBOutlet var btnImgProduct1: UIButton!
    
    @IBOutlet var btnImgProduct2: UIButton!
    
    @IBOutlet var btnImgProduct3: UIButton!
    
    @IBOutlet var txtTitle: UITextField!
    
    @IBOutlet var viewSelectCity: UIView!
    
    @IBOutlet var viewShipmentType: UIView!
    
    @IBOutlet var btnShipmentType: UIButton!
    
    @IBOutlet var txtFrom: UITextField!
    
    @IBOutlet var txtTo: UITextField!
    
    @IBOutlet var txtSelectCity: UITextField!
    
    @IBOutlet var txtWeight: UITextField!
    
    @IBOutlet var txtPrice: UITextField!
    
    @IBOutlet var btnStartDate: UIButton!
    
    @IBOutlet var btnEndDate: UIButton!
    
    @IBOutlet var txtViewDescription: UITextView!
    
    var dictShipmentInfo = [String : String]()
    
    var viewDayNDatePicker: ViewDayNDatePicker!
    
    var imagePicker: UIImagePickerController!
    
    var isOnDemandShipment = Bool()
    
    var imgSelectedProduct = UIButton()
    
    var strSearch = String()
    
    var searchType = String()
    
    var arrSelectCity = [String]()
    var arrFromCity = [String]()
    var arrToCity = [String]()
    
    var dropDownViewObj: ViewDropDownList!
    
    var endEditingNow = String()
    
    var queue = OperationQueue()
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if isOnDemandShipment {
            
            viewShipmentType.isHidden = true
            dictShipmentInfo["type"] = "Within City"
        }
        else {
            
            viewSelectCity.isHidden = true
            dictShipmentInfo["type"] = ""
        }
        
        dictShipmentInfo["title"] = ""
        dictShipmentInfo["pickup_location"] = ""
        dictShipmentInfo["drop_location"] = ""
        dictShipmentInfo["weight"] = ""
        dictShipmentInfo["start_date"] = ""
        dictShipmentInfo["end_date"] = ""
        dictShipmentInfo["fees"] = ""
        dictShipmentInfo["pictureIds"] = ""
        dictShipmentInfo["city_name"] = ""
        dictShipmentInfo["note"] = ""
        
        self.navigationView()
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Navigation
    func navigationView() -> Void {
        
        if isOnDemandShipment {
            self.navigationItem.navTitle(title: "Post Express Delivery")
        }
        else {
           self.navigationItem.navTitle(title: "Post Shipment")
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
    
    // MARK: - UIButton Actions
    
    @IBAction func btnImageFirstAction(_ sender: UIButton) {
        
        imgSelectedProduct = sender
        
        self.chooseImageFromSource()
    }
    
    
    @IBAction func btnImageSecondAction(_ sender: UIButton) {
        
        imgSelectedProduct = sender
        
        self.chooseImageFromSource()
    }
    
    @IBAction func btnImageThirdAction(_ sender: UIButton) {
        
        imgSelectedProduct = sender
        
        self.chooseImageFromSource()
    }
    
    
    @IBAction func btnShipmentTypeAction(_ sender: UIButton) {
        
        endEditingNow = "yes"
        
        self.startPoint()
        
        self.view.endEditing(true)
        
        let point = sender.convert(CGPoint.zero, to: self.view)
        
        print(point)
        
        let xAxiz = sender.frame.size.width / 2

        let yAxiz = sender.frame.origin.y + 30

//        let selectedDate = dictInfo["selectedDate"] as! String

        let popController = PopOverVC(nibName: "PopOverVC", bundle: nil)

        popController.preferredContentSize = CGSize(width: 170, height: 150)

        popController.delegates = self

//        popController.strSelectedDate = selectedDate

        popController.modalPresentationStyle = UIModalPresentationStyle.popover

        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up

        popController.popoverPresentationController?.delegate = self

        popController.popoverPresentationController?.sourceView = self.view

        popController.popoverPresentationController?.sourceRect = CGRect(x: Int(xAxiz), y: Int(yAxiz), width: 55, height: 170)

        popController.popoverPresentationController?.backgroundColor = UIColor.white

        self.present(popController, animated: true, completion: nil)
    }
    
    @IBAction func btnFromLocationAction(_ sender: UIButton) {
        
        if let routeType = (dictShipmentInfo["type"] as? String)?.Trim() {
            
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
        
        if let routeType = (dictShipmentInfo["type"] as? String)?.Trim() {
            
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
        dictShipmentInfo["type"] = strDate
        btnShipmentType.setTitle(strDate, for: .normal)
        vc.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - UIImagePicker
    func chooseImageFromSource() -> Void {
        
        let alertController = UIAlertController(title: "Select Image", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Choose from gallery", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            self.showCamera(mediaType: "Gallery")
        }
        
        let openAction = UIAlertAction(title: "Open Camera", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            self.showCamera(mediaType: "Camera")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in }
        
        alertController.addAction(okAction)
        
        alertController.addAction(openAction)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showCamera(mediaType: String) {
        
        self.imagePicker = UIImagePickerController()
        
        if mediaType == "Camera" {
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                
                imagePicker.sourceType = .camera
            }
            else {
                
                UIAlertController.Alert(title: "Unable to access the Camera", msg: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.", vc: self)
            }
            
            imagePicker.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor : UIColor.black ]
        }
        else {
            
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        imagePicker.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        imagePicker.navigationBar.shadowImage = UIImage()
        
        imagePicker.navigationBar.isTranslucent = true
        
        imagePicker.navigationBar.tintColor = UIColor.black
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imgSelectedProduct.setImage(image, for: .normal)
        
//        imgProfileView.image = image
        
        picker.dismiss(animated: true, completion: nil)
        
        self.updateProductImage()
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - SearchCityNameVCDelegate
    func getSelectedCityName(sytCityName: String, type: String, vc: UIViewController) {
        
        vc.navigationController?.popViewController(animated: true)
        
        if type == "selectCity" {
            
            //            btnSelectCity.setTitle("", for: .normal)
            dictShipmentInfo["city_name"] = sytCityName
            //            txtSelectCity.text = sytCityName
        }
        else if type == "from" {
            //            btnFrom.setTitle("", for: .normal)
            dictShipmentInfo["pickup_location"] = sytCityName
            txtFrom.text = sytCityName
        }
        else if type == "to" {
            //            btnTo.setTitle("", for: .normal)
            dictShipmentInfo["drop_location"] = sytCityName
            txtTo.text = sytCityName
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
        
        if txtTitle == textField {
            
        }
        else if txtFrom == textField {
            if isOnDemandShipment {
            let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectUserAddressViewController") as! selectUserAddressViewController
            
            CVC.selectAddressStr = dictShipmentInfo["city_name"] as! NSString
            
                CVC.delegate = self
                CVC.addressType = "from"
            self .present(CVC, animated: true, completion: nil)
            }
        }
        else if txtTo == textField {
            
            if isOnDemandShipment {
                let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectUserAddressViewController") as! selectUserAddressViewController
                
                CVC.selectAddressStr = dictShipmentInfo["city_name"] as! NSString
                CVC.delegate = self
                CVC.addressType = "to"
                self .present(CVC, animated: true, completion: nil)
            }
        }
        else if txtSelectCity == textField {
        
        }
        else if txtWeight == textField {
            
             adjustFrame(yAxiz: -50)
        }
        else if txtPrice == textField {
            
             adjustFrame(yAxiz: -50)
        }
    }
    
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        if endEditingNow == "yes" {
            
            endEditingNow = ""
            return
        }
        
        if txtTitle == textField {
            
            if isOnDemandShipment {
                
//                txtSelectCity.becomeFirstResponder()
            }
            else {
               
                self.startPoint()
            }
        }
        else if txtSelectCity == textField {
   
        }
        else if txtFrom == textField {
            
        }
        else if txtTo == textField {
            
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
        
        if txtTitle == textField {
            
            dictShipmentInfo["title"] = updatedText
        }
        else if txtWeight == textField {
            
            dictShipmentInfo["weight"] = updatedText
        }
        else if txtPrice == textField {
            
            dictShipmentInfo["fees"] = updatedText
        }
        
        if txtFrom == textField || txtTo == textField || txtSelectCity == textField {
            
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getHintsFromTextField), object: textField)
            
            self.perform(#selector(getHintsFromTextField), with: textField, afterDelay: 0.5)
        }
        
        if txtWeight == textField {
            
           return updatedText.count <= 3
        }
        else if txtPrice == textField {
            
            return updatedText.count <= 8
        }
        return true
    }
    
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        adjustFrame(yAxiz: -140  )
        
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
            
            dictShipmentInfo["note"] = changedText
            
            return true
        }
        
        textView.resignFirstResponder()
        
        self.startPoint()
        
        return false
    }
    
    
    @objc func getHintsFromTextField(textField: UITextField) {
        
        let strTxt = textField.text?.Trim()
        
        if !(strTxt?.isEmpty)! {
            
            if strTxt == strSearch {
                
                return
            }
            strSearch = strTxt!
        }
        
        if isOnDemandShipment {
            if txtSelectCity == textField {
                
                searchType = "selectCity"
            }
        }
        else {
            
            if txtFrom == textField {
                
                searchType = "from"
            }
            else if txtTo == textField {
                
                searchType = "to"
            }
        }
        self.searchCityName()
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
    
    
    //MARK: - DropDown
    func openDropDownList(title: String, isMultiSelect: Bool, arrList: [String], arrSelected: [String]?) -> Void {
        
        if dropDownViewObj != nil {
            
            dropDownViewObj.removeFromSuperview()
        }
        
        dropDownViewObj =  Bundle.main.loadNibNamed("ViewDropDownList", owner: nil, options: nil)?[0] as! ViewDropDownList
        
        dropDownViewObj.delegate = self
        
        if isMultiSelect == false {
            
            dropDownViewObj.setList(title: title, list: arrList, arrSelecedList: arrSelected, isCornerRaduis: true, isMultipleSelection: isMultiSelect)
        }
        else {
            
            dropDownViewObj.setList(title: title, list: arrList, arrSelecedList: arrSelected, isCornerRaduis: true, isMultipleSelection: isMultiSelect)
        }
        
        dropDownViewObj.setFrame(startPoints: CGPoint(x: 0, y: 0), size: CGSize(width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight))
        
        self.view.addSubview(dropDownViewObj)
    }
    
    
    func cancelDropDownList() {
        
        dropDownViewObj.removeFromSuperview()
        
        dropDownViewObj = nil
    }
    
    
    func doneDropDownList(arrList: [String], arrSelecedIndex: [Int], isMultiSelection: Bool) {
        
        print(arrList)
        
        if !arrList.isEmpty {
            let name  = arrList[0]
            
            if self.searchType == "selectCity" {
                
                dictShipmentInfo["city_name"] = name
                
                txtSelectCity.text = name
            }
            else if self.searchType == "from" {
                
                dictShipmentInfo["pickup_location"] = name
                
                txtFrom.text = name
            }
            else if self.searchType == "to" {
                
                dictShipmentInfo["drop_location"] = name
                
                txtTo.text = name
            }
        }
        
        self.cancelDropDownList()
    }
    
    
    func doneDropDownList(arrList:[String], isMultiSelection: Bool) {
        
        self.cancelDropDownList()
    }
    
    
    
    func checkValidationAndPostShipment() -> Void {
        
        let title = dictShipmentInfo["title"]
        let type = dictShipmentInfo["type"]
        let city = dictShipmentInfo["city_name"]
        let from = dictShipmentInfo["pickup_location"]
        let to = dictShipmentInfo["drop_location"]
        let weight = dictShipmentInfo["weight"]
        let fees = dictShipmentInfo["fees"]
        let startDate = dictShipmentInfo["start_date"]
        let endDate = dictShipmentInfo["end_date"]
//        let pic = dictShipmentInfo["pictureIds"]
        
//        if (pic?.isEmpty)! {
//
//            dictShipmentInfo.removeValue(forKey: "pictureIds")
//        }
        
        let note = dictShipmentInfo["note"]
        
        guard !(title?.Trim().isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "Title cannot be left blank.", vc: self)
            
            return
        }
        
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
        
        guard !(fees?.Trim().isEmpty)! else {

            UIAlertController.Alert(title: "", msg: "Currency cannot be left blank.", vc: self)
            return
        }
        
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
//                dictShipmentInfo["city_name"] = String(format: "%@ %@", city!, arrMySelectedCity[0]["country"] as! String )
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
//                dictShipmentInfo["drop_location"] = String(format: "%@ %@", to!, arrMySelectedToCity[0]["country"] as! String)
//            }
            
            let arrMySelectedFromCity = arrFromCity.filter({ ($0 == from!) })
            
            if arrMySelectedFromCity.isEmpty {
                
                UIAlertController.Alert(title: "", msg: "Please fill valid From Address", vc: self)
                return
            }
//            else {
//                dictShipmentInfo["pickup_location"] = String(format: "%@ %@", from!, arrMySelectedFromCity[0]["country"] as! String )
//            }
        }
        */
        
        dictShipmentInfo["start_date"] = String(format: "%@ 00:00:00", startDate!)
        
        dictShipmentInfo["end_date"] = String(format: "%@ 00:00:00", endDate!)
       
        
        print(dictShipmentInfo)
        
        CommonFile.shared.hudShow(strText: "")
        ShipmentsVM.shared.newShipment(dictUserInfo: dictShipmentInfo, completionHandler: { (dictResponse) in
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
    
    
    func searchCityName() -> Void {
        
        ShipmentsVM.shared.searchCity(strKeyword: strSearch, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                print(dictResponse)
                
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    if let dictUser = dictResponse["data"] as? [String: AnyObject] {
                        
                        if let response = dictUser["response"] as? String, response == "success" {
                            
                            self.view.endEditing(true)
                            
                            let arrCity = dictUser["cities"] as! [[String:AnyObject]]
                            
                            if arrCity.isEmpty {
                                
                                if self.dropDownViewObj != nil {
                                    
                                    self.dropDownViewObj.removeFromSuperview()
                                }
                                return
                            }
//                            ($0["name"] as! String)
                            let arrCityOnly1 = arrCity.map({ (String(format: "%@/%@", $0["name"] as! String, $0["country"] as! String))})
                            
//                            print(arrCityOnly1)
                            
                            if self.searchType == "selectCity" {
                                
                                self.arrSelectCity = arrCityOnly1
                            }
                            else if self.searchType == "from" {
                                
                                self.arrFromCity = arrCityOnly1
                            }
                            else if self.searchType == "to" {
                                
                                self.arrToCity = arrCityOnly1
                            }
                            
//                            let arrCityOnly = arrCity.map({ ($0["name"] as! String)})
                            
                            self.openDropDownList(title: "Select", isMultiSelect: false, arrList: arrCityOnly1, arrSelected: [])
                        }
                    }
                }
            }
            
        }, failure: { (error) in
            
            DispatchQueue.main.async {
                print(error)
            }
        })
    }
    
    
    func updateProductImage() {
    
        if let imageShipment: UIImage = self.scaledImage(imgSelectedProduct.image(for: .normal)!) {
            
            queue.addOperation { () -> Void in
                
                ShipmentsVM.shared.uploadShipmentImage(imgShipment: imageShipment, completionHandler: { (dictResponse) in
                    
                    OperationQueue.main.addOperation({
                        
                        print(dictResponse)
                        
                        if let status = dictResponse["status"] as? Bool, status == true {
                            
                            if let dictUser = dictResponse["data"] as? [String: AnyObject] {
                                
                                if let response = dictUser["response"] as? String, response == "success" {
                                    
                                    let dictImageInfo = dictUser["image"] as! [String: AnyObject]
                                    
                                    let imageId = dictImageInfo["id"] as! String
                                    
                                    var pic = self.dictShipmentInfo["pictureIds"] as! String
                                    
                                    if pic.isEmpty {
                                        pic = "\(imageId)"
                                    }
                                    else {
                                        pic = "\(pic),\(imageId)"
                                    }
                                    
                                    var arrImageId = pic.components(separatedBy: ",")
                                    
                                    if arrImageId.count > 3 {
                                        
                                        arrImageId.remove(at: 0)
                                        
                                        pic = arrImageId.joined(separator: ",")
                                        
                                    }
                                    self.dictShipmentInfo["pictureIds"] = pic
                                    
                                }
                            }
                        }
                    })
                    
                }, failure: { (error) in
                    
                    
                    OperationQueue.main.addOperation({
                        print(error)
                        
                    })
                })
            }
        }
    }
    
    
    func scaledImage(_ image: UIImage) -> UIImage {
        
        let destinationSize = CGSize(width: CGFloat((300)), height: CGFloat((300)))
        
        UIGraphicsBeginImageContext(destinationSize)
        
        image.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(destinationSize.width), height: CGFloat(destinationSize.height)))
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
