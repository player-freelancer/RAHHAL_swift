//
//  HomeVC.swift
//  RAHHAL
//
//  Created by RAJ on 05/12/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit
import Firebase
//import Crashlytics

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet var tblMyShipments: UITableView!

    @IBOutlet var viewNoShipmentPlaceholder: UIView!
   
    
    @IBOutlet var btnLeftClickable: UIButton!
    
    var  btnMenu : UIBarButtonItem!
    
    var btnFilterShipment: UIBarButtonItem!
    
    var arrMyShipments = [[String:AnyObject]]()
    
    var pagingSpinner: UIActivityIndicatorView!
    
    var pageNo = 1
    
    var totalCount = 0
    
    var myUserId = String()
    
    private var channels: [Channel] = []
    
    private lazy var channelRef: DatabaseReference = Database.database().reference()
    
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let dictUserInfo = UserDefaults.standard.object(forKey: "kUser") as! [String: AnyObject]
        
        myUserId = dictUserInfo["id"] as! String
        
        let plaveholderView = Bundle.main.loadNibNamed("ViewPlaceHolder", owner: nil, options: nil)?[0] as! ViewPlaceHolder
        
        plaveholderView.setPlaceHolderText(strString: "Currently, you don't have any shipments")
        
        viewNoShipmentPlaceholder.addSubview(plaveholderView)
       
        tblMyShipments.tableFooterView = UIView()
        
        pagingSpinner = CommonFile.shared.activityIndicatorView()
        
        tblMyShipments.tableFooterView = pagingSpinner
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        super.viewWillAppear(animated)
        
        self.navigationView()
        
        self.getMyShipmentsAPI(isCallFirstTime: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Navigation
    func navigationView() -> Void {
        
        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        self.navigationItem.navTitle(title: "My Shipments")
        
        self.navigationController?.navigationBar.makeColorNavigationBar()

        btnMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnMenuAction))
        
        btnFilterShipment = UIBarButtonItem(image: #imageLiteral(resourceName: "filterIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnFilterShipmentAction(sender:)))
 
        self.navigationItem.leftBarButtonItem = btnMenu
        
//        self.navigationItem.rightButton(btn: btnFilterShipment)
    }
    
    
    //MARK: - UIButton Action
    @IBAction func btnPostShipmentAction(_ sender: UIButton) {
        
//         Crashlytics.sharedInstance().crash()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let postShipmentVC = storyboard.instantiateViewController(withIdentifier: "postShipmentVC") as! PostShipmentVC
        
        postShipmentVC.isOnDemandShipment = false
        
        self.navigationController?.pushViewController(postShipmentVC, animated: true)
    }
    
    
    @IBAction func btnFindTravllersAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let searchTripVC = storyboard.instantiateViewController(withIdentifier: "SearchTripVC") as! SearchTripVC
        
        searchTripVC.isOnDemandShipment = true
        
        self.navigationController?.pushViewController(searchTripVC, animated: true)
    }
    
    
    @IBAction func btnOnDemandAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let postShipmentVC = storyboard.instantiateViewController(withIdentifier: "postShipmentVC") as! PostShipmentVC
        
        postShipmentVC.isOnDemandShipment = true
        
        self.navigationController?.pushViewController(postShipmentVC, animated: true)
    }
    
    
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

    
    @objc func btnFilterShipmentAction(sender: UIBarButtonItem) {
        
        print("Filter Shipments")
        /*
//        let point = sender.convert(CGPoint.zero, to: self.view)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let popController = storyboard.instantiateViewController(withIdentifier: "popOverInfoWithSegueVC") as! PopOverInfoWithSegueVC
        
        popController.preferredContentSize = CGSize(width: 200, height: 100)
        popController.modalPresentationStyle = .popover
        
        
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        
        popController.popoverPresentationController?.delegate = self
        
        popController.popoverPresentationController?.sourceView = self.view
        
        popController.popoverPresentationController?.sourceRect = CGRect(x: 200, y: 100, width: 150, height: 270)
        
        popController.popoverPresentationController?.backgroundColor = UIColor.yellow
        
        
//        let popover = popController.popoverPresentationController!
//        popover.delegate = self
//        popover.permittedArrowDirections = .up
        
//        popover.sourceView = sender as? UIView
//        popover.sourceRect = sender.bounds
//        popOverInfo
        
        present(popController, animated: true, completion:nil)*/
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverInfo" {
            let popoverViewController = segue.destination
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }

    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @objc func btnChatShipmentAction(sender: UIButton) -> Void {
        
        let point = sender.convert(CGPoint.zero, to: tblMyShipments)
        
        let indexPath = tblMyShipments.indexPathForRow(at: point)
        
        let dictChatInfo = arrMyShipments[(indexPath?.row)!]
        
        if let chatId = dictChatInfo["chatId"] as? String {
            
            let name = dictChatInfo["name"] as! String
            
            let patnerId = dictChatInfo["patnerId"] as! String
            
            
            self.channels.append(Channel(id: chatId, name: name, panterId: patnerId))
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let chatVC = storyboard.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
            
            //        let chatViewController = ChatViewController(nibName: "ChatViewController", bundle: nil)
            
            chatVC.channelRef = channelRef.child(channels[0].id)
            
            chatVC.channel = channels[0]
            
            chatVC.senderDisplayName = "kk"
            
            chatVC.chatType = "ChatShipment"
            
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    
    @objc func btnDeleteShipmentAction(sender: UIButton) -> Void {
        
        let point = sender.convert(CGPoint.zero, to: tblMyShipments)
        
        let indexPath = tblMyShipments.indexPathForRow(at: point)
        
        self.deleteShipment(shipmentId: arrMyShipments[(indexPath?.row)!]["id"] as! String)
        
        arrMyShipments.remove(at: (indexPath?.row)!)
        
        tblMyShipments.deleteRows(at: [indexPath!], with: .automatic)
//        tblMyShipments.reloadData()
        
        tblMyShipments.isHidden = false
        
        viewNoShipmentPlaceholder.isHidden = true
        
        if arrMyShipments.isEmpty {
            
            tblMyShipments.isHidden = true
            
            viewNoShipmentPlaceholder.isHidden = false
        }
    }
    
    
    //MARK:- UITableView DataSource & Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyShipments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            self.tblMyShipments.dequeueReusableCell(withIdentifier: "myShipmentsTVCell", for: indexPath as IndexPath) as! MyShipmentsTVCell
        
        cell.showMyShipmentData(dictShipment: arrMyShipments[indexPath.row])
        
        cell.btnChat.backgroundColor = UIColor.clear
        
        if let statusMsgUnread = arrMyShipments[indexPath.row]["unread"] as? String, statusMsgUnread == "1" {
            
            cell.btnChat.backgroundColor = UIColor.green
        }
        
        cell.btnChat.addTarget(self, action: #selector(btnChatShipmentAction(sender:)), for: .touchUpInside)
        
        cell.btnCross.addTarget(self, action: #selector(btnDeleteShipmentAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let shipmentDetailsVC = storyboard.instantiateViewController(withIdentifier: "shipmentDetailsVC") as! ShipmentDetailsVC
        
        shipmentDetailsVC.dictShipmentDetails = arrMyShipments[indexPath.row]
        
        self.navigationController?.pushViewController(shipmentDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if arrMyShipments.count < totalCount && indexPath.row == (arrMyShipments.count-1) {
            
            self.getMyShipmentsAPI(isCallFirstTime: false)
        }
    }
    
    
    func getMyShipmentsAPI(isCallFirstTime: Bool) -> Void {
        
        if isCallFirstTime {
            
            CommonFile.shared.hudShow(strText: "")
            pageNo = 1
            arrMyShipments.removeAll()
        }
        else {
            
            self.pagingSpinner.startAnimating()
        }
        
        ShipmentsVM.shared.getMyShipments(pageNo: pageNo, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                print(dictResponse)
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    self.pageNo = self.pageNo + 1
                    
                    if let data = dictResponse["data"] as? [String: AnyObject] {
                        
                        if let dictPage = data["page"] as? [String: AnyObject] {
                            
                            self.totalCount = Int(dictPage["total"] as! String)!
                        }
                        
                        if let response = data["response"] as? String, response == "success" {
                            
                            let arrShipment = data["shipments"] as! [[String: AnyObject]]
                            
                            if isCallFirstTime {
                                self.arrMyShipments = arrShipment
                            }
                            else {
                                self.arrMyShipments.append(contentsOf: arrShipment)
                            }
                            
                            if self.arrMyShipments.isEmpty {
                                
                                self.viewNoShipmentPlaceholder.isHidden = false
                                
                                self.tblMyShipments.isHidden = true
                            }
                            else {
                                
                                self.viewNoShipmentPlaceholder.isHidden = true
                                
                                self.tblMyShipments.isHidden = false
                            }
                            
                            self.getMyShipmentChat()
//                            self.tblMyShipments.reloadData()
                        }
                    }
                }
                else {
                    
                    
                    CommonFile.shared.hudDismiss()
                    self.pagingSpinner.stopAnimating()
                    let errorMsg = dictResponse["message"] as? String ?? Something_went_wrong_please_try_again
                    
                    UIAlertController.Alert(title: alertTitleError, msg: errorMsg, vc: self)
                }
            }
        }, failure: { (errorCode) in
            
            DispatchQueue.main.async {
                CommonFile.shared.hudDismiss()
                self.pagingSpinner.stopAnimating()
                print(errorCode)
                UIAlertController.Alert(title: alertTitleError, msg: Something_went_wrong_please_try_again, vc: self)
            }
        })
    }
    
    
    
    func getMyShipmentChat() -> Void {
        
        FirebaseManager.sharedInstance.getMyAllShipments(key: "chatRequestTo") { (arrMyFirebaseChat) in
            
            DispatchQueue.main.async {
                
                if !arrMyFirebaseChat.isEmpty {
                    
                    for dictChatInfo in arrMyFirebaseChat {
                        
                        var shipmentName = dictChatInfo["name"] as! String
                        shipmentName = shipmentName.replacingOccurrences(of: "Dealshipment", with: "")
                        let arr = shipmentName.split(separator: "-")
                        
                        print(arr)
                        
                        if self.arrMyShipments.contains(where: { ($0["id"] as! String == arr[0]) }){
                            
                            if let index = self.arrMyShipments.index(where: { ($0["id"] as! String == arr[0]) }) as? Int {
                                
                                var dictMyShipment = self.arrMyShipments[index]
                                
                                dictMyShipment["chatId"] = dictChatInfo["chatId"] as AnyObject
                                
                                dictMyShipment["name"] = dictChatInfo["name"] as AnyObject
                                
                                dictMyShipment["patnerId"] = arr[1] as AnyObject
                                
                                dictMyShipment["unread"] = dictChatInfo["unread\(self.myUserId)"]
                                
                                self.arrMyShipments[index] = dictMyShipment
                                
                            }
                        }
                    }
                }
                
                self.tblMyShipments.reloadData()
                self.pagingSpinner.stopAnimating()
                CommonFile.shared.hudDismiss()
            }
        }
    }
    
    
    func deleteShipment(shipmentId: String) -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        
        ShipmentsVM.shared.deleteShipment(shipmentId: shipmentId, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                print(dictResponse)
                CommonFile.shared.hudDismiss()
                
                if let status = dictResponse["status"] as? Bool, status == true {
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
