//
//  ShipmentDetailsVC.swift
//  RAHHAL
//
//  Created by RAJ on 14/12/17.
//  Copyright © 2017 RAJ. All rights reserved.
//



import UIKit

class ShipmentDetailsVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, ViewDayNDatePickerDelegates, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AddressViewControllerDelegate, SearchCityNameVCDelegate {

    @IBOutlet var viewContainer: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet var btnImgProduct: UIButton!
    
    @IBOutlet var btnImgProduct2: UIButton!
    
    @IBOutlet var btnImgProduct3: UIButton!
    
    @IBOutlet var viewStartDate: UIView!
    
    @IBOutlet var btnStartDate: UIButton!
    
    
    @IBOutlet var viewEndDate: UIView!
    
    @IBOutlet var btnEndDate: UIButton!
    
    
    @IBOutlet var viewPrice: UIView!
    
    @IBOutlet var txtPrice: UITextField!
    
    @IBOutlet var viewWeight: UIView!
    
    @IBOutlet var txtWeight: UITextField!
    
    @IBOutlet var txtFromAddress: UITextField!
    
    @IBOutlet var txtToAddress: UITextField!
    
    @IBOutlet var txtViewDescription: UITextView!
    
    var dictShipmentDetails = [String: AnyObject]()
    
    var btnUpdate: UIBarButtonItem!
    
    var viewDayNDatePicker: ViewDayNDatePicker!
    
    var imagePicker: UIImagePickerController!
    
    var imgSelectedProduct = UIButton()
    
    var endEditingNow = String()
    
    var queue = OperationQueue()
    
    
    
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        print(dictShipmentDetails)
        
        self.createUI()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationView()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    func createUI() -> Void {
        
        viewStartDate.addshadow(top: true, left: false, bottom: false, right: false)
        
        viewEndDate.addshadow(top: true, left: false, bottom: false, right: false)
        
        viewPrice.addshadow(top: false, left: true, bottom: true, right: true)
        
        viewWeight.addshadow(top: false, left: true, bottom: true, right: true)
        
        print(dictShipmentDetails)
        
        lblTitle.text = dictShipmentDetails["title"] as? String ?? ""
        
        txtFromAddress.text = dictShipmentDetails["pickup_location"] as? String ?? ""
        
        txtToAddress.text = dictShipmentDetails["drop_location"] as? String ?? ""
        
        txtFromAddress.leftSpaceOfTextField()
        
        txtToAddress.leftSpaceOfTextField()
        
        if let weight = dictShipmentDetails["weight"] as? String {
            
            txtWeight.text = weight//"\(weight) Kg"
        }
        
        txtPrice.text = dictShipmentDetails["fees"] as? String ?? ""
        
        if let strStartDate = dictShipmentDetails["start_date"] as? String  {
            
            let arrStartDate = strStartDate.components(separatedBy: " ")
            dictShipmentDetails["start_date"] = arrStartDate[0] as AnyObject
            btnStartDate.setTitle(arrStartDate[0], for: .normal)
            
//            lblStartDate.text = arrStartDate[0]
        }
        
        if let strEndDate = dictShipmentDetails["end_date"] as? String  {
            
            let arrEndDate = strEndDate.components(separatedBy: " ")
            dictShipmentDetails["end_date"] = arrEndDate[0] as AnyObject
            btnEndDate.setTitle(arrEndDate[0], for: .normal)
//            lblEndDate.text = arrEndDate[0]
        }
        
        txtViewDescription.text = dictShipmentDetails["note"] as? String ?? ""
        
        if let arrImg = dictShipmentDetails["images"] as? [[String: AnyObject]], !arrImg.isEmpty {
            
            for i in 0..<arrImg.count {
                
                let dictFirst = arrImg[i]
                
                let urlStr = String(format: "%@%@", imgShipmentBaseUrl, dictFirst["source_path"] as! String)
                
                if i == 0 {
                    btnImgProduct.sd_setShowActivityIndicatorView(true)
                    btnImgProduct.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
                    btnImgProduct.sd_setImage(with: URL(string: urlStr), for: UIControlState.normal, placeholderImage: UIImage(named: "placeholderAsserts"), options: [], completed: { (image, error, imageCacheType, imageUrl) in
                    
                        if (error != nil) {
                            // Failed to load image
                            
                            self.btnImgProduct.setImage(UIImage(named: "placehoderProfile"), for: .normal)
                        } else {
                            // Successful in loading image
                            self.btnImgProduct.setImage(image, for: .normal)
                        }
                    })
                }
                else if i == 1 {
                    btnImgProduct2.sd_setShowActivityIndicatorView(true)
                    btnImgProduct2.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
                    btnImgProduct2.sd_setImage(with: URL(string: urlStr), for: UIControlState.normal, placeholderImage: UIImage(named: "placeholderAsserts"), options: [], completed: { (image, error, imageCacheType, imageUrl) in
                        
                        if (error != nil) {
                            // Failed to load image
                            self.btnImgProduct2.setImage(UIImage(named: "placehoderProfile"), for: .normal)
                        } else {
                            // Successful in loading image
                            self.btnImgProduct2.setImage(image, for: .normal)
                        }
                    })
                }
                else if i == 2 {
                    
                    btnImgProduct3.sd_setShowActivityIndicatorView(true)
                    btnImgProduct3.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
                    
                    btnImgProduct3.sd_setImage(with: URL(string: urlStr), for: UIControlState.normal, placeholderImage: UIImage(named: "placeholderAsserts"), options: [], completed: { (image, error, imageCacheType, imageUrl) in
                        
                        if (error != nil) {
                            // Failed to load image
                            self.btnImgProduct3.setImage(UIImage(named: "placehoderProfile"), for: .normal)
                        } else {
                            // Successful in loading image
                            self.btnImgProduct3.setImage(image, for: .normal)
                        }
                    })
                }
            }
        }
        
        self.dictShipmentDetails["pictureIds"] = "" as AnyObject
        
//        viewContainer.isUserInteractionEnabled = false
    }

    
    //MARK:- Navigation
    func navigationView() -> Void {
        
//        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        self.navigationItem.navTitle(title: "Shipment Detail")
        
        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        btnUpdate = UIBarButtonItem(title: "Update", style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnUpdateAction))
        
        btnUpdate.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.fontMontserratLight16()], for: .normal)
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "arrowBack"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = UIFont.fontMontserratLight16()
        button.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightButton(btn: btnUpdate)
    }
    
    
    @objc func btnBackAction() -> Void {
        
        print("Back Click")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func btnUpdateAction() -> Void {
        
        print("Btn Edit Click")
        self.checkValidationAndPostShipment()
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
    
    
    func openViewDatePicker(dateType: String) -> Void {
        
        self.view.endEditing(true)
        
        if viewDayNDatePicker != nil {
            
            viewDayNDatePicker.removeFromSuperview()
        }
        viewDayNDatePicker = Bundle.main.loadNibNamed("ViewDayNDatePicker", owner: nil, options: nil)?[0] as? ViewDayNDatePicker
        
        viewDayNDatePicker.frame = CGRect(x: 0, y: self.view.frame.size.height - 200, width: DeviceInfo.TheCurrentDeviceWidth, height: 200)
        
        var dateSelected = String()
        
        if dateType == "start" {
            
            dateSelected = dictShipmentDetails["start_date"] as! String ?? ""
        }
        else {
            
            if dictShipmentDetails["start_date"] as! String == "" {
                
                UIAlertController.Alert(title: "", msg: "Please select Start Date", vc: self)
                
                return
            }
            
            if dictShipmentDetails["end_date"] as! String == "" {
                
                dateSelected = dictShipmentDetails["start_date"] as! String ?? ""
            }
            else {
                
                dateSelected = dictShipmentDetails["end_date"] as! String ?? ""
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
            dictShipmentDetails["start_date"] = strOrderDeliveryDate as AnyObject
            
            btnStartDate.setTitle(strOrderDeliveryDate, for: .normal)
            
            dictShipmentDetails["end_date"] = "" as AnyObject
            btnEndDate.setTitle("End Date", for: .normal)
        }
        else if dateType == "end" {
            dictShipmentDetails["end_date"] = strOrderDeliveryDate as AnyObject
            btnEndDate.setTitle(strOrderDeliveryDate, for: .normal)
        }
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
    
    @IBAction func btnFromLocationAction(_ sender: UIButton) {
        
        if let routeType = (dictShipmentDetails["type"] as? String)?.Trim() {
            
            if routeType.isEmpty {
                
                UIAlertController.Alert(title: "", msg: "First select trip type", vc: self)
            }
            else if routeType == "Within City" {
                
                let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectUserAddressViewController") as! selectUserAddressViewController
                
                CVC.selectAddressStr = dictShipmentDetails["city_name"] as! NSString
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
        
        if let routeType = (dictShipmentDetails["type"] as? String)?.Trim() {
            
            if routeType.isEmpty {
                
                UIAlertController.Alert(title: "", msg: "First select trip type", vc: self)
            }
            else if routeType == "Within City" {
                
                let CVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectUserAddressViewController") as! selectUserAddressViewController
                
                CVC.selectAddressStr = dictShipmentDetails["city_name"] as! NSString
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
    
    
    // MARK: - SearchCityNameVCDelegate
    func getSelectedCityName(sytCityName: String, type: String, vc: UIViewController) {
        
        vc.navigationController?.popViewController(animated: true)
        
        if type == "selectCity" {
            
//            btnSelectCity.setTitle("", for: .normal)
            dictShipmentDetails["city_name"] = sytCityName as AnyObject
//            txtSelectCity.text = sytCityName
        }
        else if type == "from" {
//            btnFrom.setTitle("", for: .normal)
            dictShipmentDetails["pickup_location"] = sytCityName as AnyObject
            txtFromAddress.text = sytCityName
        }
        else if type == "to" {
//            btnTo.setTitle("", for: .normal)
            dictShipmentDetails["drop_location"] = sytCityName as AnyObject
            txtToAddress.text = sytCityName
        }
    }
    
    //MARK: - AddressViewControllerDelegate
    func callbackWitAddress(strAddress: String, strAddressType: String) {
        
        print(strAddress)
        if strAddressType == "from" {
            
            dictShipmentDetails["pickup_location"] = strAddress as AnyObject
            
            txtFromAddress.text = strAddress
        }
        else if strAddressType == "to" {
            
            dictShipmentDetails["drop_location"] = strAddress as AnyObject
            
            txtToAddress.text = strAddress
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
            return
        }
        
        if txtPrice == textField {
            
            txtWeight.becomeFirstResponder()
        }
        else if txtWeight == textField {
            
            self.startPoint()
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if txtWeight == textField {
            
            dictShipmentDetails["weight"] = updatedText as AnyObject
        }
        else if txtPrice == textField {
            
            dictShipmentDetails["fees"] = updatedText as AnyObject
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
        
        adjustFrame(yAxiz: -150  )
        
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
            
            dictShipmentDetails["note"] = changedText as AnyObject
            
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
        
        let shipmentId = dictShipmentDetails["id"]
        let title = (dictShipmentDetails["title"] as? String)?.Trim()
        
        let type = (dictShipmentDetails["type"] as? String)?.Trim()
        let city = (dictShipmentDetails["city_name"] as? String)?.Trim()
        let from = (dictShipmentDetails["pickup_location"] as? String)?.Trim()
        let to = (dictShipmentDetails["drop_location"] as? String)?.Trim()
        let weight = (dictShipmentDetails["weight"] as? String)?.Trim()
        let fees = (dictShipmentDetails["fees"] as? String)?.Trim()
        let startDate = (dictShipmentDetails["start_date"] as? String)?.Trim()
        let endDate = (dictShipmentDetails["end_date"] as? String)?.Trim()
        let pic = dictShipmentDetails["pictureIds"]
        let note = dictShipmentDetails["note"]
        
        //        if (pic?.isEmpty)! {
        //
        //            dictShipmentInfo.removeValue(forKey: "pictureIds")
        //        }
        
        
        
        guard !(title?.isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "Title cannot be left blank.", vc: self)
            
            return
        }
        
        if type == "Within City" {
            
            guard !(city?.isEmpty)! else {
                
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
        
        guard !(from?.isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "From cannot be left blank.", vc: self)
            return
        }
        
        guard !(to?.isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "To cannot be left blank.", vc: self)
            return
        }
        
        guard !(weight?.Trim().isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "Weight cannot be left blank.", vc: self)
            return
        }
        
        guard !(fees?.isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "Currency cannot be left blank.", vc: self)
            return
        }
        
        guard !(startDate?.isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "Start date cannot be left blank.", vc: self)
            return
        }
        
        guard !(endDate?.isEmpty)! else {
            
            UIAlertController.Alert(title: "", msg: "End date cannot be left blank.", vc: self)
            return
        }
        
        var dictShipmentInfo = [String: AnyObject]()
        
        dictShipmentInfo["shipmentId"] = shipmentId
        dictShipmentInfo["title"] = title as AnyObject
        
        dictShipmentDetails["type"] = type as AnyObject
        dictShipmentInfo["city_name"] =  city as AnyObject
        dictShipmentInfo["pickup_location"] =  from as AnyObject
        dictShipmentInfo["drop_location"] =  to as AnyObject
        dictShipmentInfo["weight"] =  weight as AnyObject
        dictShipmentInfo["fees"] =  fees as AnyObject
        dictShipmentInfo["start_date"] =  String(format: "%@ 00:00:00", startDate!) as AnyObject
        dictShipmentInfo["end_date"] =  String(format: "%@ 00:00:00", endDate!) as AnyObject
        dictShipmentInfo["pictureIds"] =  pic
        dictShipmentInfo["note"] =  note
        
        print(dictShipmentInfo)
        
        CommonFile.shared.hudShow(strText: "")
        ShipmentsVM.shared.updateShipment(dictUserInfo: dictShipmentInfo as! [String : String], completionHandler: { (dictResponse) in
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
                                    
                                    var pic = self.dictShipmentDetails["pictureIds"] as! String

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
                                    self.dictShipmentDetails["pictureIds"] = pic as AnyObject
                                    
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
        
        let destinationSize = CGSize(width: CGFloat(200), height: CGFloat(200))
        
        UIGraphicsBeginImageContext(destinationSize)
        
        image.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(destinationSize.width), height: CGFloat(destinationSize.height)))
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
