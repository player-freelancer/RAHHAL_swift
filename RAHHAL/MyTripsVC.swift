//
//  MyTripsVC.swift
//  RAHHAL
//
//  Created by Macbook on 12/28/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit

class MyTripsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet var tblMyShipments: UITableView!
    
    @IBOutlet var viewNoTrip: UIView!
    
    @IBOutlet var btnLeftClickable: UIButton!
    
    var  btnMenu : UIBarButtonItem!
    
    var btnFilterShipment: UIBarButtonItem!
    
    var arrMyTrips = [[String:AnyObject]]()
    
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plaveholderView = Bundle.main.loadNibNamed("ViewPlaceHolder", owner: nil, options: nil)?[0] as! ViewPlaceHolder
        
        plaveholderView.setPlaceHolderText(strString: "Currently, you don't have any trips")
        
        viewNoTrip.addSubview(plaveholderView)
        
        tblMyShipments.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationView()
        
        self.getMyTripsAPI()
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
    
    
    func getMyTripsAPI() -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        
        arrMyTrips.removeAll()
        
        TripsVM.shared.getMyTrips(pageNumber: 1, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                print(dictResponse)
                CommonFile.shared.hudDismiss()
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    if let data = dictResponse["data"] as? [String: AnyObject] {
                        
                        if let response = data["response"] as? String, response == "success" {
                            
                            self.arrMyTrips = data["trips"] as! [[String: AnyObject]]
                            
                            if self.arrMyTrips.isEmpty {
                                
                                self.viewNoTrip.isHidden = false
                                
                                self.tblMyShipments.isHidden = true
                            }
                            else {
                                
                                self.viewNoTrip.isHidden = true
                                
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
