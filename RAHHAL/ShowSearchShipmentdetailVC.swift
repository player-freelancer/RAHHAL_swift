//
//  ShowSearchShipmentdetailVC.swift
//  RAHHAL
//
//  Created by Macbook on 1/3/18.
//  Copyright © 2018 RAJ. All rights reserved.
//

import UIKit
import Firebase

class ShowSearchShipmentdetailVC: UIViewController, UIPopoverPresentationControllerDelegate, PopOverVCDelegates, UITextFieldDelegate, UITextViewDelegate, ViewDayNDatePickerDelegates, AddressViewControllerDelegate, SearchCityNameVCDelegate {
    
    
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
    
    
    
    var dictShipmentInfo = [String : String]()
    
    var viewDayNDatePicker: ViewDayNDatePicker!
    
    var isOnDemandShipment = Bool()
    
    var endEditingNow = String()
    
    var queue = OperationQueue()
    
    var frameViewContainer = CGRect()
    
    
    private var channelRefHandle: DatabaseHandle?
    
    private var channels: [Channel] = []
    
    private lazy var channelRef: DatabaseReference = Database.database().reference()
    
    private lazy var dbChatShipment = channelRef.child("ChatShipment")
    
    var isPressButtonChatReq = Bool()
    
    var otherUserId = String()
    
    var myUserId = String()
    
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let dictUserInfo = UserDefaults.standard.object(forKey: "kUser") as! [String: AnyObject]
        
        myUserId = dictUserInfo["id"] as! String
        
        otherUserId = dictShipmentInfo["userId"]!
        
        viewContainer.isUserInteractionEnabled = false
        
        btnShipmentType.setTitle( dictShipmentInfo["type"], for: .normal)
        txtSelectCity.text = dictShipmentInfo["city_name"]
        
        txtPrice.text = dictShipmentInfo["fees"]
        
        txtWeight.text = dictShipmentInfo["weight"]
        
        txtFrom.text = dictShipmentInfo["pickup_location"]
        
        txtTo.text = dictShipmentInfo["drop_location"]
        
        if let startDate = dictShipmentInfo["start_date"] {
            
            if startDate.count < 13 {
                
                btnStartDate.setTitle(startDate, for: .normal)
            }
            else {
                
                let getDate = TimeStatus.getDate(isApplyTimeZone: false, strDate: startDate, oldFormatter: "yyyy-MM-dd hh:mm:ss", newFormat: "yyyy-MM-dd")
                
                btnStartDate.setTitle(getDate, for: .normal)
            }
        }
        
        if let startDate = dictShipmentInfo["end_date"] {
            
            if startDate.count < 13 {
                
                btnEndDate.setTitle(startDate, for: .normal)
            }
            else {
                
                let getDate = TimeStatus.getDate(isApplyTimeZone: false, strDate: startDate, oldFormatter: "yyyy-MM-dd hh:mm:ss", newFormat: "yyyy-MM-dd")
                
                btnEndDate.setTitle(getDate, for: .normal)
            }
        }
            
        txtViewDescription.text = dictShipmentInfo["note"]
        
        self.navigationView()
        
        self.observeChannels()
        
        self.chatSetting()
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
        
        self.navigationItem.navTitle(title: "Shipment Info")
        
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
            dictShipmentInfo["from_location"] = sytCityName
            txtFrom.text = sytCityName
        }
        else if type == "to" {
            btnTo.setTitle("", for: .normal)
            dictShipmentInfo["to_location"] = sytCityName
            txtTo.text = sytCityName
        }
    }
    
    
    // MARK: - UIButton Actions
    @IBAction func btnShipmentTypeAction(_ sender: UIButton) {
        /*
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
        
        self.present(popController, animated: true, completion: nil)*/
    }
    
    
    @IBAction func btnSelectCityAction(_ sender: UIButton) {
        /*
        let searchCityNameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchCityNameVC") as! SearchCityNameVC
        
        searchCityNameVC.searchType = "selectCity"
        
        searchCityNameVC.delegate = self
        
        self.navigationController?.pushViewController(searchCityNameVC, animated: true)*/
    }
    
    
    @IBAction func btnFromLocationAction(_ sender: UIButton) {
        /*
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
        }*/
    }
    
    
    @IBAction func btnToLocationAction(_ sender: UIButton) {
        /*
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
        }*/
    }
    
    
    @IBAction func btnStartDateAction(_ sender: UIButton) {
        /*
        endEditingNow = "yes"
        
        self.startPoint()
        
        self.view.endEditing(true)
        
        self.openViewDatePicker(dateType: "start")*/
    }
    
    
    @IBAction func btnEndDateAction(_ sender: UIButton) {
        /*
        endEditingNow = "yes"
        
        self.startPoint()
        
        self.view.endEditing(true)
        
        self.openViewDatePicker(dateType: "end")*/
    }
    
    
    @IBAction func btnChatRequestAction(_ sender: UIButton) {
        
//        UIAlertController.Alert(title: "", msg: "Coming Soon", vc: self)
        
        self.callChatVC()
    }
    
    
    func openViewDatePicker(dateType: String) -> Void {
        /*
        self.view.endEditing(true)
        
        if viewDayNDatePicker != nil {
            
            viewDayNDatePicker.removeFromSuperview()
        }
        viewDayNDatePicker = Bundle.main.loadNibNamed("ViewDayNDatePicker", owner: nil, options: nil)?[0] as? ViewDayNDatePicker
        
        viewDayNDatePicker.frame = CGRect(x: 0, y: self.view.frame.size.height - 200, width: DeviceInfo.TheCurrentDeviceWidth, height: 200)
        
        var dateSelected = String()
        
        if dateType == "start" {
            
            dateSelected = dictShipmentInfo["departure"] ?? ""
        }
        else {
            
            if dictShipmentInfo["departure"] == "" {
                
                UIAlertController.Alert(title: "", msg: "Please select Start Date", vc: self)
                
                return
            }
            
            if dictShipmentInfo["arrival"] == "" {
                
                dateSelected = dictShipmentInfo["departure"] ?? ""
            }
            else {
                
                dateSelected = dictShipmentInfo["arrival"] ?? ""
            }
        }
        
        viewDayNDatePicker.setOldDate(oldDate: dateSelected, dateType: dateType)
        
        viewDayNDatePicker.delegates = self
        
        self.view.addSubview(viewDayNDatePicker)*/
    }
    
    
    //MARK:- ViewDayNDatePicker Dalegates
    func btnCancelActionDatePickerView(dateType: String) -> Void {
        /*
        if dateType == "start" {
            dictShipmentInfo["departure"] = ""
            btnStartDate.setTitle("Start Date", for: .normal)
            dictShipmentInfo["arrival"] = ""
            btnEndDate.setTitle("End Date", for: .normal)
        }
        else if dateType == "end" {
            dictShipmentInfo["arrival"] = ""
            btnEndDate.setTitle("End Date", for: .normal)
        }
        
        self.hideDatePickerView()*/
    }
    
    
    func hideDatePickerView() -> Void {
        
        if viewDayNDatePicker != nil {
            
            viewDayNDatePicker.removeFromSuperview()
        }
    }
    
    
    func btnDoneActionDatePickerView(strDate: String, strDateAndTime: String, dateType: String) -> Void {
        /*
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
            dictShipmentInfo["departure"] = strOrderDeliveryDate
            
            btnStartDate.setTitle(strOrderDeliveryDate, for: .normal)
            
            dictShipmentInfo["arrival"] = ""
            btnEndDate.setTitle("End Date", for: .normal)
        }
        else if dateType == "end" {
            dictShipmentInfo["arrival"] = strOrderDeliveryDate
            btnEndDate.setTitle(strOrderDeliveryDate, for: .normal)
        }*/
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
            
            dictShipmentInfo["from_location"] = strAddress
            
            txtFrom.text = strAddress
        }
        else if strAddressType == "to" {
            
            dictShipmentInfo["to_location"] = strAddress
            
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
        //                CVC.selectAddressStr = dictShipmentInfo["city_name"] as! NSString
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
        //                CVC.selectAddressStr = dictShipmentInfo["city_name"] as! NSString
        //                CVC.delegate = self
        //                CVC.addressType = "to"
        //                self .present(CVC, animated: true, completion: nil)
        //            }
        //        }
        //        else if txtSelectCity == textField {
        //
        //        }
        //        else
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
            
            return updatedText.count <= 5
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
    
    
    // MARK: Firebase related methods
    func observeChannels() {
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = dbChatShipment.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.count > 0 {
                let idPhone = channelData["name"] as! String
                //                if self.isPressButtonChatReq == false {
                
                self.channels.append(Channel(id: id, name: name, panterId: self.otherUserId))
                //                }
                print(channelData)
                print(self.channels)
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    
    func chatSetting() -> Void {
        
        let shipmentId = dictShipmentInfo["id"] as! String
        
        let title = dictShipmentInfo["title"]!
        
        let participants = "shipment\(shipmentId)-\(myUserId)"
        let participants1 = "shipment\(shipmentId)-\(otherUserId)"
        
        self.isPressButtonChatReq = true
        
        CommonFile.shared.hudShow(strText: "")
        
        FirebaseManager.sharedInstance.checkChannelAlreadyExist(keyWord: "shipment", keyWordId: shipmentId) { (status) in
            
            CommonFile.shared.hudDismiss()
            
            if status {
                
                print("Chat channel already exist.")
                
                //                self.getMyChannel()
            }
            else {
                
                let newChannelRef = self.dbChatShipment.childByAutoId()
                
                
                let channelItem = [
                    "name": "Deal\(participants)",
                    "chatRequestBy":self.myUserId,
                    "chatRequestTo":self.otherUserId,
                    "shipmentId": shipmentId,
                    "title": title,
                    ] as [String : Any]
                newChannelRef.setValue(channelItem)
                
                print(newChannelRef.key)
                
                //                self.channels.append(Channel(id: newChannelRef.key, name: "Deal\(participants)", idPhone: "Deal\(participants)"))
                
                //                self.callChatVC(name: "Deal\(participants)")
            }
        }
        
    }
    
    
    func callChatVC() -> Void {
        
        let shipmentId = dictShipmentInfo["id"] as! String
        let dictUserInfo = UserDefaults.standard.object(forKey: "kUser") as! [String: AnyObject]
        
        let myUserId = dictUserInfo["id"] as! String
        let name = "Dealshipment\(shipmentId)-\(myUserId)"
        
        
        let myChannel = channels.filter { (($0 ).name == name) }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let chatVC = storyboard.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
        
        //        let chatViewController = ChatViewController(nibName: "ChatViewController", bundle: nil)
        
        chatVC.channelRef = channelRef.child(myChannel[0].id)
        
        chatVC.channel = myChannel[0]
        
        chatVC.chatType = "ChatShipment"
        
        chatVC.senderDisplayName = "Shipment"
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

