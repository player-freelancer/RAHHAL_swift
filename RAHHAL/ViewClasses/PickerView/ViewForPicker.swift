//
//  ViewForPicker.swift
//  PBAgent
//
//  Created by MR on 14/04/17.
//  Copyright © 2017 MR. All rights reserved.
//

protocol ViewForPickerDelegates {
    
    func getValueFromPickerView(strValue: String, keyString: String, view: UIView) -> Void
}


import UIKit

class ViewForPicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var pickerViewCommon: UIPickerView!
    
    var arrForPickerView = [String]()
    
    var selectedPickerIndex = 0
    
    var keyString = String()
    
    var delegates: ViewForPickerDelegates?
    
    
    func setPickerData(arr: [String], selectedValue: String, keyType: String) -> Void {
        
        keyString = keyType
        
        arrForPickerView = arr
        
        pickerViewCommon.reloadAllComponents()
        
        if arrForPickerView.contains(selectedValue) {
            
            selectedPickerIndex = arrForPickerView.index(of: selectedValue)!
            
             pickerViewCommon.selectRow(selectedPickerIndex, inComponent: 0, animated: false)
        }
        
        self.isHidden = false
    }
 
    
    //MARK:- UIButton Action
    @IBAction func btnCancelAction(_ sender: UIButton) {
        
        selectedPickerIndex = 0
        
        self.isHidden = true
    }
    
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        
        delegates?.getValueFromPickerView(strValue: arrForPickerView[selectedPickerIndex], keyString: self.keyString, view: self)
    }
    
    
    //MARK: - PickerView Delegates & Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if !arrForPickerView.isEmpty {
            
            return 1
        }
        
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return arrForPickerView.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return arrForPickerView[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedPickerIndex = row
    }
}
