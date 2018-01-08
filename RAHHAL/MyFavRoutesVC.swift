//
//  MyFavRoutesVC.swift
//  RAHHAL
//
//  Created by Macbook on 1/1/18.
//  Copyright © 2018 RAJ. All rights reserved.
//

import UIKit

class MyFavRoutesVC: UIViewController , UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var tblMyFavRoute: UITableView!
    
    @IBOutlet var viewNoFavRoute: UIView!
    
    @IBOutlet var btnLeftClickable: UIButton!
    
    var  btnMenu : UIBarButtonItem!
    
    var btnFilterFavRoute: UIBarButtonItem!
    
    var arrMyFavRoute = [[String:AnyObject]]()
    
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plaveholderView = Bundle.main.loadNibNamed("ViewPlaceHolder", owner: nil, options: nil)?[0] as! ViewPlaceHolder
        
        plaveholderView.setPlaceHolderText(strString: "Currently, you don't have any favorite route")
        
        viewNoFavRoute.addSubview(plaveholderView)
        
        tblMyFavRoute.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationView()
        
        self.getMyFavRoutesAPI()
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Navigation
    func navigationView() -> Void {
        
        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        self.navigationItem.navTitle(title: "Favorite Route")
        
        self.navigationController?.navigationBar.makeColorNavigationBar()
        
        btnMenu = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnMenuAction))
        
//        btnFilterFavRoute = UIBarButtonItem(image: #imageLiteral(resourceName: "filterIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnFilterFavRouteAction(sender:)))
        
        self.navigationItem.leftBarButtonItem = btnMenu
        
//        self.navigationItem.rightButton(btn: btnFilterFavRoute)
    }
    
    
    //MARK: - UIButton Action
    @IBAction func btnPostFavRouteAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let postFavRouteVC = storyboard.instantiateViewController(withIdentifier: "PostFavRouteVC") as! PostFavRouteVC
        
        postFavRouteVC.isOnDemandFavRoute = false
        
        self.navigationController?.pushViewController(postFavRouteVC, animated: true)
    }
    
    
    @IBAction func btnFindShipmentAction(_ sender: UIButton) {
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
    
    
    @objc func btnFilterFavRouteAction(sender: UIBarButtonItem) {
        
        print("Filter Shipments")
        
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
        
        let point = sender.convert(CGPoint.zero, to: tblMyFavRoute)
        
        let indexPath = tblMyFavRoute.indexPathForRow(at: point)
        
        self.deleteFavRoute(index: (indexPath?.row)!)
    }
    
    
    //MARK:- UITableView DataSource & Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrMyFavRoute.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            self.tblMyFavRoute.dequeueReusableCell(withIdentifier: "myFavRouteTVCell", for: indexPath as IndexPath) as! MyFavRouteTVCell
        
        cell.showMyFavRouteData(dictShipment: arrMyFavRoute[indexPath.row])
        
        cell.btnCross.addTarget(self, action: #selector(btnDeleteTriptAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let postFavRouteVC = storyboard.instantiateViewController(withIdentifier: "PostFavRouteVC") as! PostFavRouteVC
        
        postFavRouteVC.isUpdateOldRoute = true
        
        postFavRouteVC.isOnDemandFavRoute = false
        
        postFavRouteVC.dictFavRouteInfo = arrMyFavRoute[indexPath.row] as! [String : String]
        
        self.navigationController?.pushViewController(postFavRouteVC, animated: true)
    }
    
    
    func getMyFavRoutesAPI() -> Void {
        
        CommonFile.shared.hudShow(strText: "")
        
        arrMyFavRoute.removeAll()
        
        FavRouteVM.shared.getMyFavRoutes(pageNumber: 1, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                print(dictResponse)
                CommonFile.shared.hudDismiss()
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    if let data = dictResponse["data"] as? [String: AnyObject] {
                        
                        if let response = data["response"] as? String, response == "success" {
                            
                            self.arrMyFavRoute = data["routes"] as! [[String: AnyObject]]
                            
                            if self.arrMyFavRoute.isEmpty {
                                
                                self.viewNoFavRoute.isHidden = false
                                
                                self.tblMyFavRoute.isHidden = true
                            }
                            else {
                                
                                self.viewNoFavRoute.isHidden = true
                                
                                self.tblMyFavRoute.isHidden = false
                            }
                            
                            self.tblMyFavRoute.reloadData()
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
    
    
    func deleteFavRoute(index: Int) -> Void {
        
        let routeId = arrMyFavRoute[index]["id"] as! String
        
        CommonFile.shared.hudShow(strText: "")
        
        FavRouteVM.shared.deleteFavRoute(routeId: routeId, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                print(dictResponse)
                CommonFile.shared.hudDismiss()
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    self.arrMyFavRoute.remove(at: index)
                    
                    self.tblMyFavRoute.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    //        tblMyFavRoute.reloadData()
                    
                    self.tblMyFavRoute.isHidden = false
                    
                    self.viewNoFavRoute.isHidden = true
                    
                    if self.arrMyFavRoute.isEmpty {
                        
                        self.tblMyFavRoute.isHidden = true
                        
                        self.viewNoFavRoute.isHidden = false
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
