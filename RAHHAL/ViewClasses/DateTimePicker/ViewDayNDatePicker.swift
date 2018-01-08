//
//  ViewDayNDatePicker.swift
//  ordertron
//
//  Created by Manya on 04/05/17.
//  Copyright © 2017 MR. All rights reserved.
//

protocol ViewDayNDatePickerDelegates {
        
    func btnCancelActionDatePickerView()
        
    func btnDoneActionDatePickerView(strDate: String, strDateAndTime: String, dateType: String)
}

import UIKit

class ViewDayNDatePicker: UIView {
        
    @IBOutlet var dayNDatePickerView: UIDatePicker!
    
    @IBOutlet var lblDayNDate: UILabel!
        
    var newDate = Date()
        
    var oldDate = String()
    
    var getStrDate : String!
    
    var getStrDateTime : String!
    
    var myDateType = String()
    
    var delegates: ViewDayNDatePickerDelegates?
    
        
    func setOldDate(oldDate: String, dateType: String) -> Void {
        
        myDateType = dateType
        
        dayNDatePickerView.minimumDate = Date()
        
        if dateType == "end" {
            
            dayNDatePickerView.minimumDate = TimeStatus.getDate(strDate: oldDate, oldFormatter: "yyyy-MM-dd")
        }
        
        if oldDate != "" {
            
            let dateFormat = DateFormatter()
            
            dateFormat.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormat.date(from: oldDate)
            
            self.getLblData(date: date!)
            
            dayNDatePickerView.setDate(date!, animated: false)
        }
        else {

            self.getLblData(date: Date())
        }
    }
        
    
    @IBAction func dayNDatePickerViewAction(_ sender:UIDatePicker) {
            
        newDate = sender.date
        
        self.getLblData(date: newDate)
    }
        
        
    @IBAction func btnCancelAction(_ sender: UIButton) {
            
        delegates?.btnCancelActionDatePickerView()
    }
        
        
    @IBAction func btnDoneAction(_ sender: UIButton) {
        
        delegates?.btnDoneActionDatePickerView(strDate: getStrDate, strDateAndTime: getStrDateTime, dateType: myDateType)
    }
    
    
    func getLblData(date : Date) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE"
        
        let dayString: String = dateFormatter.string(from: date).capitalized
        
        getStrDate = TimeStatus.getStrDateCallWithDate(isApplyTimeZone: false, date: newDate, newFormat: "yyyy-MM-dd")
        
        getStrDateTime = TimeStatus.getStrDateCallWithDate(isApplyTimeZone: false, date: newDate, newFormat: "yyyy-MM-dd HH:mm:ss")
        
        lblDayNDate.text = String(format:"%@ %@", dayString, getStrDate)
    }
}
