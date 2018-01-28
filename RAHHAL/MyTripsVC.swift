//
//  MyTripsVC.swift
//  RAHHAL
//
//  Created by Macbook on 12/28/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit
import Firebase

class MyTripsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet var tblMyShipments: UITableView!
    
    @IBOutlet var viewNoTrip: UIView!
    
    @IBOutlet var btnLeftClickable: UIButton!
    
    var  btnMenu : UIBarButtonItem!
    
    var btnFilterShipment: UIBarButtonItem!
    
    var arrMyTrips = [[String:AnyObject]]()
    
    var myUserId = String()
    
    var pagingSpinner: UIActivityIndicatorView!
    
    var pageNo = 1
    
    var totalCount = 0
    
    private var channels: [Channel] = []
    
    private lazy var channelRef: DatabaseReference = Database.database().reference()
//    private lazy var DBTable = DBRef.child("TripChat")
    
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dictUserInfo = UserDefaults.standard.object(forKey: "kUser") as! [String: AnyObject]
        
        myUserId = dictUserInfo["id"] as! String
        
        let plaveholderView = Bundle.main.loadNibNamed("ViewPlaceHolder", owner: nil, options: nil)?[0] as! ViewPlaceHolder
        
        plaveholderView.setPlaceHolderText(strString: "Currently, you don't have any trips")
        
        viewNoTrip.addSubview(plaveholderView)
        
        pagingSpinner = CommonFile.shared.activityIndicatorView()
        
        tblMyShipments.tableFooterView = pagingSpinner
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationView()
        
        self.getMyTripsAPI(isCallFirstTime: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Navigation
    func navigationView() -> Void {
        
        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        self.navigationItem.navTitle(title: "My Trips")
        
        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        btnMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnMenuAction))
        
//        btnFilterShipment = UIBarButtonItem(image: #imageLiteral(resourceName: "filterIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnFilterShipmentAction(sender:)))
        
        self.navigationItem.leftBarButtonItem = btnMenu
        
//        self.navigationItem.rightButton(btn: btnFilterShipment)
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
        
    }
    
    
    //MARK: - UIButton Action
    @IBAction func btnPostTripAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let postTripVC = storyboard.instantiateViewController(withIdentifier: "postTripVC") as! PostTripVC
        
        postTripVC.isOnDemandShipment = false
        
        self.navigationController?.pushViewController(postTripVC, animated: true)
    }
    
    
    @IBAction func btnFindShipmentAction(_ sender: UIButton) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let searchShipmentVC = storyboard.instantiateViewController(withIdentifier: "SearchShipmentVC") as! SearchShipmentVC
        
        searchShipmentVC.isOnDemandShipment = true
        
        self.navigationController?.pushViewController(searchShipmentVC, animated: true)
    }
    
    
    @IBAction func btnOnDemandAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let postShipmentVC = storyboard.instantiateViewController(withIdentifier: "postShipmentVC") as! PostShipmentVC
        
        postShipmentVC.isOnDemandShipment = true
        
        self.navigationController?.pushViewController(postShipmentVC, animated: true)
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
    
    @objc func btnChatTripAction(sender: UIButton) -> Void {
    
        let point = sender.convert(CGPoint.zero, to: tblMyShipments)
        
        let indexPath = tblMyShipments.indexPathForRow(at: point)
        
        let dictChatInfo = arrMyTrips[(indexPath?.row)!]
        
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
            
            chatVC.chatType = "ChatTrips"
            
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    
    @objc func btnDeleteTriptAction(sender: UIButton) -> Void {
        
        let point = sender.convert(CGPoint.zero, to: tblMyShipments)
        
        let indexPath = tblMyShipments.indexPathForRow(at: point)
        
        self.deleteShipment(index: (indexPath?.row)!)
        
//        arrMyTrips.remove(at: (indexPath?.row)!)
//
//        tblMyShipments.deleteRows(at: [indexPath!], with: .automatic)
//        //        tblMyShipments.reloadData()
//
//        tblMyShipments.isHidden = false
//
//        imgNoShipment.isHidden = true
//        if arrMyTrips.isEmpty {
//
//            tblMyShipments.isHidden = true
//
//            imgNoShipment.isHidden = false
//        }
    }
    
    
    //MARK:- UITableView DataSource & Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyTrips.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            self.tblMyShipments.dequeueReusableCell(withIdentifier: "myTripsTVCell", for: indexPath as IndexPath) as! MyTripsTVCell
        
        cell.showMyTripData(dictShipment: arrMyTrips[indexPath.row])
        
        cell.btnChat.backgroundColor = UIColor.clear
        
        if let statusMsgUnread = arrMyTrips[indexPath.row]["unread"] as? String, statusMsgUnread == "1" {
            
            cell.btnChat.backgroundColor = UIColor.green
        }
        
        cell.btnChat.addTarget(self, action: #selector(btnChatTripAction(sender:)), for: .touchUpInside)
        
        cell.btnCross.addTarget(self, action: #selector(btnDeleteTriptAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let postTripVC = storyboard.instantiateViewController(withIdentifier: "postTripVC") as! PostTripVC
        
        postTripVC.tripType = "update"
        
        postTripVC.isOnDemandShipment = false
        
        postTripVC.dictTripInfo = arrMyTrips[indexPath.row] as! [String : String]
        
        self.navigationController?.pushViewController(postTripVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if arrMyTrips.count < totalCount && indexPath.row == (arrMyTrips.count-1) {
            
            self.getMyTripsAPI(isCallFirstTime: false)
        }
    }
    
    /*
    func getFireBaseTrips() -> Void {
        
        FirebaseManager.sharedInstance.getMyAllTrips { (arrTrip) in
            
            print(arrTrip)
            
            if !arrTrip.isEmpty {
                
                for dictTripInfo in arrTrip {
                    
                    let isPresent = arrTrip.contains(where: { ($0["id"] as! String == dictTripInfo["tripId"] as! String) })
                    
                    if isPresent {
                        
                    }
                }
            }
            else {
                
                for dict in self.arrMyTrips {
                    
                    FirebaseManager.sharedInstance.createNewTripChat(dictTripInfo: dict)
                }
            }
            
        }
    }*/
    
    
    func getMyTripsAPI(isCallFirstTime: Bool) -> Void {
        
        if isCallFirstTime {
            
            CommonFile.shared.hudShow(strText: "")
            
            arrMyTrips.removeAll()
        }
        else {
            
            self.pagingSpinner.startAnimating()
        }
        
        
        TripsVM.shared.getMyTrips(pageNumber: pageNo, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                print(dictResponse)
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    self.pageNo = self.pageNo + 1
                    
                    if let data = dictResponse["data"] as? [String: AnyObject] {
                        
                        if let dictPage = data["page"] as? [String: AnyObject] {
                            
                            self.totalCount = Int(dictPage["total"] as! String)!
                        }
                        
                        if let response = data["response"] as? String, response == "success" {
                            
                            let arrTrip = data["trips"] as! [[String: AnyObject]]
                            
                            if isCallFirstTime {
                                self.arrMyTrips = arrTrip
                            }
                            else {
                                self.arrMyTrips.append(contentsOf: arrTrip)
                            }
                            
                            
                            if self.arrMyTrips.isEmpty {
                                
                                self.viewNoTrip.isHidden = false
                                
                                self.tblMyShipments.isHidden = true
                            }
                            else {
                                
                                self.viewNoTrip.isHidden = true
                                
                                self.tblMyShipments.isHidden = false
                            }
                            
                        }
                    }
                    
                    self.getMyTripsChat()
                }
                else {
                    
                    let errorMsg = dictResponse["message"] as? String ?? Something_went_wrong_please_try_again
                    
                    UIAlertController.Alert(title: alertTitleError, msg: errorMsg, vc: self)
                    CommonFile.shared.hudDismiss()
                    
                    self.pagingSpinner.stopAnimating()
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
    
    
    func getMyTripsChat() -> Void {
        
        FirebaseManager.sharedInstance.getMyAllTrips(key: "chatRequestTo") { (arrMyFirebaseChat) in
            
            DispatchQueue.main.async {
                
                if !arrMyFirebaseChat.isEmpty {
                    
                    for dictChatInfo in arrMyFirebaseChat {
                        
                        var tripName = dictChatInfo["name"] as! String
                        tripName = tripName.replacingOccurrences(of: "Dealtrip", with: "")
                        let arr = tripName.split(separator: "-")
                        
                        if self.arrMyTrips.contains(where: { ($0["id"] as! String == arr[0]) }){
                            
                            if let index = self.arrMyTrips.index(where: { ($0["id"] as! String == arr[0]) }) as? Int {
                                
                                var dictMyTrip = self.arrMyTrips[index]
                                
                                dictMyTrip["chatId"] = dictChatInfo["chatId"] as AnyObject
                                
                                dictMyTrip["name"] = dictChatInfo["name"] as AnyObject
                                
                                dictMyTrip["patnerId"] = arr[1] as AnyObject
                                
                                dictMyTrip["unread"] = dictChatInfo["unread\(self.myUserId)"]
                                
                                self.arrMyTrips[index] = dictMyTrip
                            }
                        }
                    }
                }
                
                self.tblMyShipments.reloadData()
                
                CommonFile.shared.hudDismiss()
                
                self.pagingSpinner.stopAnimating()
            }
        }
    }
    
    
    func deleteShipment(index: Int) -> Void {
        
        let tripId = arrMyTrips[index]["id"] as! String
        
        CommonFile.shared.hudShow(strText: "")
        
        TripsVM.shared.deleteTrip(tripId: tripId, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                print(dictResponse)
                CommonFile.shared.hudDismiss()
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    self.arrMyTrips.remove(at: index)
                    
                    self.tblMyShipments.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    //        tblMyShipments.reloadData()
                    
                    self.tblMyShipments.isHidden = false
                    
                    self.viewNoTrip.isHidden = true
                    
                    if self.arrMyTrips.isEmpty {
                        
                        self.tblMyShipments.isHidden = true
                        
                        self.viewNoTrip.isHidden = false
                    }
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
