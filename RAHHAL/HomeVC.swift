//
//  HomeVC.swift
//  RAHHAL
//
//  Created by RAJ on 05/12/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit
//import Crashlytics

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet var tblMyShipments: UITableView!

    @IBOutlet var viewNoShipmentPlaceholder: UIView!
   
    
    @IBOutlet var btnLeftClickable: UIButton!
    
    var  btnMenu : UIBarButtonItem!
    
    var btnFilterShipment: UIBarButtonItem!
    
    var arrMyShipments = [[String:AnyObject]]()
    
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let plaveholderView = Bundle.main.loadNibNamed("ViewPlaceHolder", owner: nil, options: nil)?[0] as! ViewPlaceHolder
        
        plaveholderView.setPlaceHolderText(strString: "Currently, you don't have any shipments")
        
        viewNoShipmentPlaceholder.addSubview(plaveholderView)
       
        tblMyShipments.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationView()
        
        self.getMyShipmentsAPI()
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
    
    
    func getMyShipmentsAPI() -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        
        arrMyShipments.removeAll()
        
        ShipmentsVM.shared.getMyShipments(completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                print(dictResponse)
                CommonFile.shared.hudDismiss()
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    if let data = dictResponse["data"] as? [String: AnyObject] {
                        
                        if let response = data["response"] as? String, response == "success" {
                            
                            self.arrMyShipments = data["shipments"] as! [[String: AnyObject]]
                            
                            if self.arrMyShipments.isEmpty {
                                
                                self.viewNoShipmentPlaceholder.isHidden = false
                                
                                self.tblMyShipments.isHidden = true
                            }
                            else {
                                
                                self.viewNoShipmentPlaceholder.isHidden = true
                                
                                self.tblMyShipments.isHidden = false
                            }
                            
                            self.tblMyShipments.reloadData()
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
                print(errorCode)
                UIAlertController.Alert(title: alertTitleError, msg: Something_went_wrong_please_try_again, vc: self)
            }
        })
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
