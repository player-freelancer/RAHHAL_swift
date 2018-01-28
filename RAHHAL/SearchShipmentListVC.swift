//
//  SearchShipmentListVC.swift
//  RAHHAL
//
//  Created by Macbook on 1/3/18.
//  Copyright © 2018 RAJ. All rights reserved.
//

import UIKit

class SearchShipmentListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var tblSearchShipment: UITableView!
    
    var arrSearchShipment = [[String:AnyObject]]()
    
    var pagingSpinner: UIActivityIndicatorView!
    
    var pageNo = 2
    
    var totalCount = 0
    
    var dictShipmentInfo = [String: AnyObject]()
    
    var dictPage = [String: AnyObject]()
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSearchShipment.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        totalCount = Int(dictPage["total"] as! String)!
        
        pagingSpinner = CommonFile.shared.activityIndicatorView()
        
        tblSearchShipment.tableFooterView = pagingSpinner
        
        self.navigationView()
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Navigation
    func navigationView() -> Void {
        
        self.navigationItem.navTitle(title: "Shipments")
        
        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "arrowBack"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = UIFont.fontMontserratLight16()
        button.addTarget(self, action: #selector(btnBackAction), for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func btnBackAction() {
        
        print("Menu Button Click")
        self.view.endEditing(true)
        
        self.navigationController?.popViewController(animated: true)
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
    
    
    
    //MARK:- UITableView DataSource & Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearchShipment.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            self.tblSearchShipment.dequeueReusableCell(withIdentifier: "myTripsTVCell", for: indexPath as IndexPath) as! MyTripsTVCell
        
        cell.showSearchShipmentData(dictShipment: arrSearchShipment[indexPath.row])
        
        return cell
    }
    
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let showSearchShipmentdetailVC = storyboard.instantiateViewController(withIdentifier: "ShowSearchShipmentdetailVC") as! ShowSearchShipmentdetailVC
        
        showSearchShipmentdetailVC.dictShipmentInfo = arrSearchShipment[indexPath.row] as! [String : String]
        
        self.navigationController?.pushViewController(showSearchShipmentdetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if arrSearchShipment.count < totalCount && indexPath.row == (arrSearchShipment.count-1) {
            
            self.searchShipmentsAPI()
        }
    }
    
    
    
    func searchShipmentsAPI() -> Void {
        
        self.pagingSpinner.startAnimating()
        
        dictShipmentInfo["page"] = "\(pageNo)" as AnyObject
        
        ShipmentsVM.shared.findShipment(dictUserInfo: dictShipmentInfo as! [String : String], completionHandler: { (dictResponse) in
            DispatchQueue.main.async {
                
                CommonFile.shared.hudDismiss()
                
                print(dictResponse)
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    if let dictUser = dictResponse["data"] as? [String: AnyObject] {
                        
                        if let response = dictUser["response"] as? String, response == "success" {
                            
                            let arrShipment = dictUser["shipments"] as! [[String: AnyObject]]
                            
                            self.pageNo = self.pageNo + 1
                                
                            self.arrSearchShipment.append(contentsOf: arrShipment)
                            
                            self.tblSearchShipment.reloadData()
                            
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

