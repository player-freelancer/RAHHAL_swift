//
//  MyProfileVC.swift
//  RAHHAL
//
//  Created by Macbook on 12/28/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MyProfileHeaderDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var tblMyProfile: UITableView!
    
    @IBOutlet var btnLeftClickable: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    var  btnMenu : UIBarButtonItem!
    
    var btnTick: UIBarButtonItem!
    
    var viewHeader: MyProfileHeader!

    var isImageChanged = Bool()
    
    var arrTitle = ["First Name", "Last Name", "Mobile No.", "About"]
    
    var dictUserInfo = [String: AnyObject]()
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        
        dictUserInfo = UserDefaults.standard.value(forKey: "kUser") as! [String: AnyObject]
        
        print(dictUserInfo)
        
        self.createUI()
        
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationView()
    }
    

    override func didReceiveMemoryWarning() {
       
        super.didReceiveMemoryWarning()
    }
    

    func createUI() -> Void {
        
        viewHeader =  Bundle.main.loadNibNamed("MyProfileHeader", owner: nil, options: nil)?[0] as! MyProfileHeader
        
        viewHeader.delegate = self
        
        if let imgProfile = dictUserInfo["profile_image"] as? String {
            
            let urlStr = String(format: "%@%@", imgShipmentBaseUrl, imgProfile)
            
            viewHeader.imgMyProfilePic.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "placehoderProfile"), options: []) { (image, error, imageCacheType, imageUrl) in
                
            }
        }
        
        tblMyProfile.tableHeaderView = viewHeader
        
        tblMyProfile.tableFooterView = UIView()
    }
    
    
    //MARK:- Navigation
    func navigationView() -> Void {
        
        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        self.navigationItem.navTitle(title: "My Shipments")
        
        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        btnMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnMenuAction))
        
        btnTick = UIBarButtonItem(image: #imageLiteral(resourceName: "tick"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnFtickSubmitAction(sender:)))
        
        self.navigationItem.leftBarButtonItem = btnMenu
        
        self.navigationItem.rightButton(btn: btnTick)
    }
    
    
    //MARK: - UIButton Action
    @objc func btnMenuAction() {
        
        print("Menu Button Click")
        self.view.endEditing(true)
        
        if self.navigationController?.view.frame.origin.x == 0 {
            
            UIView.animate(withDuration: 0.4) {
                
                self.navigationController?.view.frame = CGRect(x: DeviceInfo.TheCurrentDeviceWidth / 1.2, y: 0, width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight)
                
                self.btnLeftClickable.isHidden = false
            }
        }
        else {
            
            UIView.animate(withDuration: 0.4) {
                
                self.navigationController?.view.frame = CGRect(x: 0, y: 0, width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight)
                
                self.btnLeftClickable.isHidden = true
            }
        }
    }
    
    
    @objc func btnFtickSubmitAction(sender: UIBarButtonItem) {
        
        print("Tick")
        
        self.view.endEditing(true)
        
        self.startPoint()
        
        self.updateMyProfileInfo()
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
        
        viewHeader.imgMyProfilePic.image = image
        
        isImageChanged = true
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- UITableView DataSource & Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            self.tblMyProfile.dequeueReusableCell(withIdentifier: "myprofileTVCell", for: indexPath as IndexPath) as! MyprofileTVCell
        
        cell.selectionStyle = .none
        
        cell.txtValue.isHidden = true
        
        cell.txtViewValue.isHidden = true
        
        let strTitle = arrTitle[indexPath.row]
        
        cell.lblTitle.text = strTitle
        
        cell.txtValue.isUserInteractionEnabled = true
        
//        cell.txtValue.textColor = UIColor.black
        
        cell.txtValue.delegate = self
        
        cell.txtViewValue.delegate = self
        
//        cell.txtValue.returnKeyType = .next
        
        switch strTitle {
            
        case "First Name":
            cell.txtValue.text = strTitle
            
            cell.txtValue.tag = 2000
            
            cell.txtValue.text = dictUserInfo["first_name"] as? String
            
            cell.txtValue.isHidden = false
            
        case "Last Name":
            cell.txtValue.text = strTitle
            
            cell.txtValue.tag = 2001
            
            cell.txtValue.text = dictUserInfo["last_name"] as? String
            
            cell.txtValue.isHidden = false
            
        case "Mobile No.":
            cell.txtValue.text = strTitle
            
            cell.txtValue.tag = 2002
            
            cell.txtValue.textColor = UIColor.colorTheme()
            
            cell.txtValue.isUserInteractionEnabled = false
            
            let coutryCode = dictUserInfo["country_code"] as! String
            
            cell.txtValue.text = String(format: "%@-%@", coutryCode, (dictUserInfo["mobile"] as? String)!)
            
            cell.txtValue.isHidden = false
            
        case "About":
            cell.txtViewValue.text = ""
            
            cell.txtValue.tag = 2003
            
            cell.txtViewValue.isHidden = false
            cell.txtViewValue.isUserInteractionEnabled = false
        default:
            break;
        }
        
        return cell
    }
    
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let shipmentDetailsVC = storyboard.instantiateViewController(withIdentifier: "shipmentDetailsVC") as! ShipmentDetailsVC
//
//        shipmentDetailsVC.dictShipmentDetails = arrMyShipments[indexPath.row]
//
//        self.navigationController?.pushViewController(shipmentDetailsVC, animated: true)
    }

    
    // MARK: - UITextField Delegates
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        self.startPoint()
        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 2000 {
            self.adjustFrame(yAxiz: -50)
        }
        else if textField.tag == 2001 {
            self.adjustFrame(yAxiz: -100)
        }
        else if textField.tag == 2002 {
            
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if textField.tag == 2000 {
            dictUserInfo["first_name"] = updatedText as AnyObject
        }
        else if textField.tag == 2001 {
            dictUserInfo["last_name"] = updatedText as AnyObject
        }
        else if textField.tag == 2002 {
            
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
            
//            dictShipmentInfo["note"] = changedText
            
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
    
    
    func updateMyProfileInfo() -> Void {
        
        let fName = (dictUserInfo["first_name"] as! String).Trim()
        
        let lName = (dictUserInfo["last_name"] as! String).Trim()
        
        guard !(fName.isEmpty) && !(lName.isEmpty) else {
            
            UIAlertController.Alert(title: alertTitleWaning, msg: Please_fill_all_the_fields, vc: self)
            
            return
        }
       
        var imgProfile: UIImage?
        
        if isImageChanged {
            
            imgProfile = self.scaledImage(viewHeader.imgMyProfilePic.image!)
        }
        CommonFile.shared.hudShow(strText: "")
        
        UserVM.shared.updateProfileAPI(FName: fName, LName: lName, imgProfile: imgProfile, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                CommonFile.shared.hudDismiss()
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    if let dictUser = dictResponse["data"] as? [String: AnyObject] {
                        
                        if let response = dictUser["response"] as? String, response == "success" {
                            
                            self.dictUserInfo = dictUser["user"] as! [String: AnyObject]
                            
                            UserDefaults.standard.set(self.dictUserInfo, forKey: "kUser")
                            
                            UserDefaults.standard.synchronize()
                            
                            self.createUI()
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefershUserInfo"), object: nil)
                        }
                    }
                }
                else {
                    
                    let errorMsg = dictResponse["message"] as? String ?? Something_went_wrong_please_try_again
                    
                    UIAlertController.Alert(title: alertTitleError, msg: errorMsg, vc: self)
                }
            }
        }, failure: { (errorCode) in
            
            DispatchQueue.main.async {
                CommonFile.shared.hudDismiss()
                
                UIAlertController.Alert(title: alertTitleError, msg: Something_went_wrong_please_try_again, vc: self)
            }
        })
    }
    
    
    func scaledImage(_ image: UIImage) -> UIImage {
        
        let destinationSize = CGSize(width: CGFloat((200)), height: CGFloat((200)))
        
        UIGraphicsBeginImageContext(destinationSize)
        
        image.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(destinationSize.width), height: CGFloat(destinationSize.height)))
        
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
