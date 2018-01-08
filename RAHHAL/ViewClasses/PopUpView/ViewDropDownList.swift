//
//  ViewDropDownList.swift
//  PocketBrokerConsumer
//
//  Created by MR on 14/02/17.
//  Copyright © 2017 Mind Roots Technologies. All rights reserved.
//

protocol ViewDropDownListDelegates {
    
    func cancelDropDownList()
    
    func doneDropDownList(arrList:[String], isMultiSelection: Bool)
    
    func doneDropDownList(arrList:[String], arrSelecedIndex: [Int], isMultiSelection: Bool)
}


import UIKit

class ViewDropDownList: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var tblDropDownList: UITableView!
    
    @IBOutlet var viewMain: UIView!
   
    private var arrList = [String]()
    
    private var arrSelecedList = [String]()
    
    private var arrSelecedIndex = [Int]()
    
    private var isMultipleSelected = false
    
    var delegate: ViewDropDownListDelegates?
    
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        
        delegate?.cancelDropDownList()
    }
    
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        
        delegate?.doneDropDownList(arrList: arrSelecedList, isMultiSelection: isMultipleSelected)
    }
    
    
    func setList(title: String?, list:[String], arrSelecedList: [String]?, isCornerRaduis: Bool, isMultipleSelection: Bool) -> Void {
        
        viewMain.layer.cornerRadius = 10
        
        viewMain.layer.masksToBounds  = true
        
        isMultipleSelected = isMultipleSelection
        
        self.frame = CGRect(x: 0, y: 0, width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight)
        
        if let arr = arrSelecedList {
            
            if arr.count == 1 {
                
                if arr[0] as String == "" {
                 
                    self.arrSelecedList = [String]()
                }
                else {
                    
                    self.arrSelecedList = arr
                }
            }
            else {
                
                self.arrSelecedList = arr
            }
        }
        
        if let strTitle = title{
            
            lblTitle.text = strTitle
        }
                
        arrList = list
        
        tblDropDownList.tableFooterView = UIView()
        
        tblDropDownList.dataSource = self
        
        tblDropDownList.delegate = self
        
        tblDropDownList.reloadData()
        
        CommonFile.shared.animationScaling(view: viewMain)
    }
    
    
    func setFrame(startPoints: CGPoint, size: CGSize) {
        
        self.frame = CGRect(x: startPoints.x, y: startPoints.y, width: size.width, height: size.height)
    }
    
    //MARK:- UITable Delegates & Datasource 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: DropDownTVCell!
        
        if  (cell == nil) {
            
            let nib:NSArray = Bundle.main.loadNibNamed("DropDownTVCell", owner: self, options: nil)! as NSArray
            
            cell = nib.object(at: 0)as? DropDownTVCell
        }
        
        cell.setContent(text: arrList[indexPath.row], arrSelectedValue: arrSelecedList)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedContent = arrList[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath) as! DropDownTVCell
        
        if isMultipleSelected {
            
            if arrSelecedList.contains(selectedContent) {
                
                let index = arrSelecedList.index(where: { $0 == selectedContent })
                
                if index != nil {
                
                    arrSelecedList.remove(at: index!)
                    
                    cell.accessoryType = .none
                }
            }
            else {
                
                arrSelecedList.append(selectedContent)
                
                cell.accessoryType = .checkmark
            }
        }
        else {
            
            if !arrSelecedList.isEmpty {
                
                let index = arrList.index(where: { $0 == arrSelecedList[0] })
                
                if index != nil {
                    
                    let cellOldSelected = tableView.cellForRow(at: IndexPath(row: index!, section: 0)) as! DropDownTVCell
                    
                    cellOldSelected.accessoryType = .none
                }
            }
            
            arrSelecedIndex.removeAll()
            
            arrSelecedIndex.append(indexPath.row)
            
            arrSelecedList.removeAll()
            
            arrSelecedList.append(selectedContent)
            
            cell.accessoryType = .checkmark
            
            delegate?.doneDropDownList(arrList: arrSelecedList, arrSelecedIndex: arrSelecedIndex, isMultiSelection: isMultipleSelected)
        }
    }
}
