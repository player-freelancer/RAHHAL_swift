//
//  MessagesVC.swift
//  RAHHAL
//
//  Created by Macbook on 1/28/18.
//  Copyright © 2018 RAJ. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UIViewController {

    @IBOutlet var btnLeftClickable: UIButton!
    
    var  btnMenu : UIBarButtonItem!
    
    var arrTripsMessage = [[String: Any]]()
    
    var arrShipmentsMessage = [[String: Any]]()
    
    private var channelsTrip: [Channel] = []
    
    private var channelsShipment: [Channel] = []
    
    private lazy var channelRef: DatabaseReference = Database.database().reference()
    
    var myUserId = String()
    
    let serialQueueSyncApi = DispatchQueue(label: "syncApi")
    
    var apiCount = 0
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let dictUserInfo = UserDefaults.standard.object(forKey: "kUser") as! [String: AnyObject]
        
        myUserId = dictUserInfo["id"] as! String
        
        self.syncDataFromFirebase()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- Navigation
    func navigationView() -> Void {
        
        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        self.navigationItem.navTitle(title: "My Messages")
        
        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        btnMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnMenuAction))
        
        //        btnFilterShipment = UIBarButtonItem(image: #imageLiteral(resourceName: "filterIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnFilterShipmentAction(sender:)))
        
        self.navigationItem.leftBarButtonItem = btnMenu
        
        //        self.navigationItem.rightButton(btn: btnFilterShipment)
    }
    
    @IBAction func btnTripChatAction(_ sender: UIButton) {
    }
    
    @IBAction func btnShipmentChatAction(_ sender: UIButton) {
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
    
    func getmessages() -> Void {
        
        print("arrShipmentsMessage : \(arrShipmentsMessage)")
        
        print("arrTripsMessage : \(arrTripsMessage)")
    }
    
    
    // MARK: - Get Chat Messages
    func syncDataFromFirebase() -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        
        serialQueueSyncApi.sync {
            
            self.getMyShipmentChat(completionHandler: { (status) in
                
                if self.checkStatusAllAPI() == 2 {
                    
                    self.apiCount = 0
                    
                    self.getmessages()
                    
                    CommonFile.shared.hudDismiss()
                }
            })
        }
        
        serialQueueSyncApi.sync {
            
            self.getMyTripsChat(completionHandler: { (status) in
                
                if self.checkStatusAllAPI() == 2 {
                    
                    self.apiCount = 0
                    
                    self.getmessages()
                    
                    CommonFile.shared.hudDismiss()
                }
            })
        }
    }
    
    func checkStatusAllAPI() -> Int {
        apiCount = apiCount + 1
        return apiCount
    }
    

    func getMyShipmentChat(completionHandler:@escaping (_ status: Bool) -> Void) -> Void {
        
        FirebaseManager.sharedInstance.getMyAllShipments(key: "chatRequestBy") { (arrMyFirebaseChat) in
            
            self.arrShipmentsMessage = arrMyFirebaseChat
//            for dictChatInfo in arrMyFirebaseChat {
//
//                var tripName = dictChatInfo["name"] as! String
//                tripName = tripName.replacingOccurrences(of: "Dealshipment", with: "")
//                let arr = tripName.split(separator: "-")
//
//                if arr[1] == self.myUserId {
//
//                    self.arrShipmentsMessage.append(dictChatInfo)
//                }
//            }
            
            completionHandler(true)
//            arrShipmentsMessage = arrMyFirebaseChat
        }
    }
    
    
    
    func getMyTripsChat(completionHandler:@escaping (_ status: Bool) -> Void) -> Void {
        
        FirebaseManager.sharedInstance.getMyAllTrips(key: "chatRequestBy") { (arrMyFirebaseChat) in
            
            self.arrTripsMessage = arrMyFirebaseChat
            
//            for dictChatInfo in arrMyFirebaseChat {
//
//                var tripName = dictChatInfo["name"] as! String
//                tripName = tripName.replacingOccurrences(of: "Dealtrip", with: "")
//                let arr = tripName.split(separator: "-")
//                if arr[1] == self.myUserId {
//
//                    self.arrTripsMessage.append(dictChatInfo)
//                }
//            }
            completionHandler(true)
//            arrTripsMessage = arrMyFirebaseChat
        }
    }
    
 

}
