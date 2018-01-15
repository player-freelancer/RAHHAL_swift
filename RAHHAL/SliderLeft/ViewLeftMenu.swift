//
//  ViewLeftMenu.swift
//  LeftMenu
//
//  Created by MR on 03/02/17.
//  Copyright © 2017 MR. All rights reserved.
//

protocol ViewLeftMenuDelegates {
    
    func indexStatus(index: Int)
}

import UIKit

class ViewLeftMenu: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var imgBg: UIImageView!
    
    @IBOutlet var tblMenu: UITableView!
    
    @IBOutlet var imgUserProfile: UIImageView!
    
    @IBOutlet var lblUserName: UILabel!
    
    @IBOutlet var lblUserContact: UILabel!
    
    var delegates: ViewLeftMenuDelegates?
    
    let arrTitle = ["My Shipments","My Trips","Favourite Routes","Settings","Logout"]

    func reloadMenu() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserInfo), name: NSNotification.Name(rawValue: "RefershUserInfo"), object: nil)
        
       self.refreshUserInfo()
        
        
        tblMenu.frame = CGRect(x: 0, y: tblMenu.frame.origin.y, width: DeviceInfo.TheCurrentDeviceWidth / 1.2, height: tblMenu.frame.size.height)
        
        tblMenu.tableFooterView = UIView()
        
        tblMenu.dataSource = self
        
        tblMenu.delegate = self
        
        tblMenu.reloadData()
    }
    
    
    @objc func refreshUserInfo() -> Void {
        
        if let dictUserInfo = UserDefaults.standard.value(forKey: "kUser") as? [String:AnyObject] {
            
            let fName = dictUserInfo["first_name"] as! String
            
            let lName = dictUserInfo["last_name"] as! String
            
            let phoneNo = dictUserInfo["mobile"] as! String
            
            lblUserName.text = String(format: "%@ %@", fName, lName)
            
            lblUserContact.text = phoneNo
            
            if let imgUrl = dictUserInfo["profile_image"] as? String {
                
                let urlStr = String(format: "%@%@", imgShipmentBaseUrl, imgUrl)
                
                imgUserProfile.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "placehoderProfile"), options: []) { (image, error, imageCacheType, imageUrl) in
                    
                    if (error != nil) {
                        // Failed to load image
                        self.imgUserProfile.image = UIImage(named: "placehoderProfile")
                    } else {
                        // Successful in loading image
                        self.imgUserProfile.image = image
                    }
                }
            }
            
        }
    }
    
    // MARK: - Buttons Action
    @IBAction func btnLogoutAction(_ sender: UIButton) {
   
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

//        appDelegate.setInitialVC()
    }
    
    
    //MARK: UITableView Delegates & Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrTitle.count > 0 {
            
            return arrTitle.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell =  tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomLeftMenuTableViewCell
       
        if  (cell == nil) {
            
            let nib:NSArray = Bundle.main.loadNibNamed("CustomLeftMenuTableViewCell", owner: self, options: nil)! as NSArray
           
            cell = nib.object(at: 0)as? CustomLeftMenuTableViewCell
        }
        
        cell?.selectionStyle = .none
        
        cell?.setContents(strTitle: arrTitle[indexPath.row])
        
        cell?.imgLeftIcon.image = UIImage(named: "leftMenu\(indexPath.row+1)")
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if DeviceInfo.IS_4_INCHES() {
         
            return 44.0
        }
        
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegates?.indexStatus(index: indexPath.row)
    }
    
    @IBAction func btnCallProfileScreenAction(_ sender: UIButton) {
        
        
        delegates?.indexStatus(index: 1000)
    }
    
}
