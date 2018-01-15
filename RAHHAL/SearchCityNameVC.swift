//
//  SearchCityNameVC.swift
//  RAHHAL
//
//  Created by Macbook on 12/31/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

protocol SearchCityNameVCDelegate {
    
    func getSelectedCityName(sytCityName: String, type: String, vc: UIViewController)
}


import UIKit
class SearchCityNameVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var imgMagnifier: UIImageView!
    
    @IBOutlet var txtSearch: UITextField!
    
    @IBOutlet var tblSearchResult: UITableView!
    
    @IBOutlet var lblNoResultFound: UILabel!
    
    var delegate: SearchCityNameVCDelegate?
    
    var arrCityNameList = [String]()
    
    var pagingSpinner: UIActivityIndicatorView!
    
    var strSearch = String()
    
    var searchType = String()
    
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()

        tblSearchResult.isHidden = true
        
        pagingSpinner = CommonFile.shared.activityIndicatorView()
        
        tblSearchResult.tableFooterView = pagingSpinner
        
        self.navigationView()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
//        self.getMyListingsApi(isCallFirstTime: true)
        
        if DeviceInfo.IS_5_8_INCHES() {
            
            imgMagnifier.frame = CGRect(x: imgMagnifier.frame.origin.x, y: imgMagnifier.frame.origin.y, width: imgMagnifier.frame.size.height, height: imgMagnifier.frame.size.height)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Navigation
    func navigationView() -> Void {
        
        self.navigationItem.navTitle(title: "Search")
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
    
    
    //MARK: - UITableView Delegates & Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !arrCityNameList.isEmpty {
            
            return arrCityNameList.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")
        
        cell?.textLabel?.text = arrCityNameList[indexPath.row]
        
        cell?.selectionStyle = .none
        
//        cell?.fillPreviewListingData(dictPreviewListing: arrMyListing[indexPath.row])
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        ListingsVM.shared.getListingDetailAPI(advertisementId: arrMyListing[indexPath.row]["advertisement_id"] as! String, vcParent: self)
        delegate?.getSelectedCityName(sytCityName: arrCityNameList[indexPath.row], type: searchType, vc: self)
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        if arrMyListing.count < resultTotalCount && indexPath.row == (arrMyListing.count-1) && arrMyListing.count <= offSet {
//
//            self.getMyListingsApi(isCallFirstTime: false)
//        }
//    }
    
    
    // MARK: - UITextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getHintsFromTextField), object: textField)
        
        self.perform(#selector(getHintsFromTextField), with: textField, afterDelay: 0.5)
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @objc func getHintsFromTextField(textField: UITextField) {
        
        let strTxt = textField.text?.Trim()
        
        if !(strTxt?.isEmpty)! {
            
            if strTxt == strSearch {
                
                return
            }
            
            strSearch = strTxt!
            
            self.searchCityName(isCallFirstTime: true)
        }
        
        if !strSearch.isEmpty {
            
            let strTxt = textField.text?.Trim()
            
            if (strTxt?.isEmpty)! {
                
                strSearch = strTxt!
                
                self.searchCityName(isCallFirstTime: true)
            }
        }
    }
    
    
    func searchCityName(isCallFirstTime: Bool) -> Void {
        
        ShipmentsVM.shared.searchCity(strKeyword: strSearch, completionHandler: { (dictResponse) in
            
            DispatchQueue.main.async {
                
                print(dictResponse)
                
                self.arrCityNameList.removeAll()
                
                if let status = dictResponse["status"] as? Bool, status == true {
                    
                    if let dictUser = dictResponse["data"] as? [String: AnyObject] {
                        
                        if let response = dictUser["response"] as? String, response == "success" {
                            
                            self.view.endEditing(true)
                            
                            let arrCity = dictUser["cities"] as! [[String:AnyObject]]
                            
                            if arrCity.isEmpty {
                                
                                self.lblNoResultFound.isHidden = false
                                
                                self.tblSearchResult.isHidden = true
                                
                                return
                            }
                            
                            self.lblNoResultFound.isHidden = true
                            
                            self.tblSearchResult.isHidden = false
                            
                            self.arrCityNameList = arrCity.map({ (String(format: "%@/%@", $0["name"] as! String, $0["country"] as! String))})
                            
                            self.tblSearchResult.reloadData()
                        }
                    }
                }
                else {
                    
                    self.lblNoResultFound.isHidden = false
                    
                    self.tblSearchResult.isHidden = true
                    
                    self.tblSearchResult.reloadData()
                }
            }
            
        }, failure: { (error) in
            
            DispatchQueue.main.async {
                print(error)
                
                self.lblNoResultFound.isHidden = false
                
                self.tblSearchResult.isHidden = true
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
