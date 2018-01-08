//
//  OTFile.swift
//
//  Created by Raj on 05/01/17.
//  Copyright © 2017 MR. All rights reserved.
//

import Foundation
import UIKit

let imgProfileBaseUrl = "http://dev.shipfor.net/assets/appimages/user/"
let imgShipmentBaseUrl = "http://dev.shipfor.net/assets/appimages/"
let countAreaCode = "966"

let alertTitleError = NSLocalizedString("Error", comment: "")
let alertTitleWaning = NSLocalizedString("Warning", comment: "")
let OKString = NSLocalizedString("OK", comment: "")
let Please_fill_all_the_fields = NSLocalizedString("Please fill all the fields.", comment: "")
let First_name_cannot_be_left_blank = NSLocalizedString("First name cannot be left blank.", comment: "")
let Last_name_cannot_be_left_blank = NSLocalizedString("Last name cannot be left blank.", comment: "")
let Mobile_No_cannot_be_left_blank = NSLocalizedString("Mobile No. cannot be left blank.", comment: "")
let Mobile_No_entered_is_incorrect = NSLocalizedString("Mobile No. entered is incorrect.", comment: "")
let OTP_entered_is_incorrect = NSLocalizedString("OTP entered is incorrect.", comment: "")
let You_must_agree_with_the_terms_and_conditions = NSLocalizedString("You must agree with the terms and conditions.", comment: "")
let Something_went_wrong_please_try_again = NSLocalizedString("Something went wrong, please try again", comment: "")
let Please_check_your_internet_connection = NSLocalizedString("Please check your internet connection", comment: "")


class CommonFile: NSObject {
    
    let hud = MBProgressHUD()
    
    static let shared : CommonFile = {
        
        let instance = CommonFile()
        
        return instance
    }()
    
    
    func hudShow(strText: String?) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        hud.show(true)
        
        if let strLoaderString = strText {
           
            hud.labelText = strLoaderString
        }
        
        hud.frame = (appDelegate.window?.frame)!
        
        hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.70)
        
        hud.color = UIColor.clear
        
        appDelegate.window?.addSubview(hud)
    }
    
    
    func hudDismiss() {
        
        DispatchQueue.main.async {
        
            self.hud.removeFromSuperview()
        }
    }
    
    
    func heightCalculate(arrCount: Int, numberOfColumn: Int, heightOfCell: Int) -> CGFloat {
        
        var numberOfRow = arrCount / numberOfColumn
        
        let reminder = arrCount % numberOfColumn
        
        if reminder != 0 {
            
            numberOfRow = Int(numberOfRow + 1)
        }
        
        return CGFloat((numberOfRow * heightOfCell) + 30)
    }
    
    
    func saveUserDetails(dictUserDetail: [String: AnyObject]) -> Void {
        
        let dataExample: Data = NSKeyedArchiver.archivedData(withRootObject: dictUserDetail)
    
        UserDefaults.standard.set(dictUserDetail["user_id"] as! String, forKey: "user_id")
        
        UserDefaults.standard.set(dataExample, forKey: "kUserDetails")
        
        UserDefaults.standard.synchronize()
    }
    
    
    func getUserDetails() -> [String: AnyObject] {
        
        let dataUserDetails = UserDefaults.standard.value(forKey: "kUserDetails") as! Data
        
        let dictionary = NSKeyedUnarchiver.unarchiveObject(with: dataUserDetails) as! [String : AnyObject]
        
        return dictionary
    }
    
    
    func getFavs() -> [[String: AnyObject]] {
        
        var arrFav = [[String: AnyObject]]()
        
        if let dataUserDetails = UserDefaults.standard.value(forKey: "kFav") as? Data {
            
            arrFav = NSKeyedUnarchiver.unarchiveObject(with: dataUserDetails) as! [[String: AnyObject]]
        }
        
        return arrFav
    }
    
    
    func setFavInUserDefualt(arrFav: [[String: AnyObject]]) -> Void {
        
        let dataFav: Data = NSKeyedArchiver.archivedData(withRootObject: arrFav)
        
        UserDefaults.standard.set(dataFav, forKey: "kFav")
        
        UserDefaults.standard.synchronize()
    }
    
    
    
    //MARK:- Activity Indicator
    func activityIndicatorView() -> UIActivityIndicatorView {
        
        let pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        pagingSpinner.frame = CGRect(x: 0, y: 0, width: DeviceInfo.TheCurrentDeviceWidth, height: 40)
        
        pagingSpinner.stopAnimating()
        
        pagingSpinner.color = UIColor.colorTheme()
        
        pagingSpinner.hidesWhenStopped = true
        
        return pagingSpinner
    }
    /*
    //MARK:- Set Profile Image
    func setProfileImage(imgView : UIImageView, photoUrl : String, strSubUrl: String) -> Void {
        
        imgView.isHidden = false
        
        imgView.layer.cornerRadius = imgView.frame.size.width/2
        
        if !photoUrl.isEmpty {
            
            imgView.setShowActivityIndicator(true)
            
            imgView.setIndicatorStyle(.gray)
            
            let imgBaseURL = String(format: "%@", UserDefaults.standard.value(forKey: "image_url") as! String)
            
            imgView.sd_setImage(with: URL(string: "\(imgBaseURL)\(strSubUrl)\(photoUrl)")) { (image, error, cache, urls) in
                
                if let _: Error = error  {
                    
                    imgView.image = UIImage(named: "placeHolderProfilePic")
                }
                else {
                    
                    imgView.image = image
                }
            }
        }
        else {
            
            imgView.image = UIImage(named: "placeHolderProfilePic")
        }
    }
    */
    
    //MARK:- Get String Size
    func stringSize(text : String, width: CGFloat, font: UIFont) -> CGSize {
        
        let maxSize = CGSize(width: Int(width), height: Int.max)
        
        let size = (text as NSString).boundingRect(with: maxSize,
                                                   options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                   attributes: [NSAttributedStringKey.font:font],
                                                   context: nil).size
        
        return size
    }
    
    
    func stringWidthSize(text : String, height: CGFloat, font: UIFont) -> CGSize {
        
        let maxSize = CGSize(width: Int.max, height: Int(height))
        
        let size = (text as NSString).boundingRect(with: maxSize,
                                                   options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                   attributes: [NSAttributedStringKey.font:font],
                                                   context: nil).size
        
        return size
    }
    
    
    //MARK:- Calculate String Height
    func heightForString(str: String, myFont: UIFont) -> CGSize {
        
        let maxLabelSize: CGSize = CGSize(width: DeviceInfo.TheCurrentDeviceWidth * 0.65, height:  CGFloat(9999))
        
        let contentNSString = str as NSString
        
        let expectedLabelSize = contentNSString.boundingRect(with: maxLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: myFont], context: nil)
        
        return expectedLabelSize.size
    }
    
    
    //MARK: - Start & end Date
     func getCalendarComponent(date: Date) -> NSDateComponents {
        
        let calendarGregorian = Calendar(identifier: .gregorian)
        
        return calendarGregorian.dateComponents([.hour, .minute], from: date as Date) as NSDateComponents!
    }
    
    
    func getStartAndEndDateTime(strSelectedDate: String) -> [Date] {
        
        let today = Date()
        
        let comps : NSDateComponents = self.getCalendarComponent(date: today)
        
        var hour : Int = comps.hour
        
        var minute : Int = comps.minute
        
        if (minute>00 && minute<15) {
            minute=15;
        }
        else if (minute>15 && minute<30) {
            minute=30;
        }
        else if (minute>30 && minute<45) {
            minute=45;
        }
        else if (minute>45 && minute<=59) {
            minute=00;
            
            hour = hour+1
        }
        
        let strMinute = minute == 0 ? "00" : "\(minute)"
        
        let strStartDate = "\(strSelectedDate) \(hour):\(strMinute)"
        
        let strEndDate = "\(strSelectedDate) \(hour+1):\(strMinute)"
        
        let startDate = TimeStatus.getDate(strDate: strStartDate, oldFormatter: "MMM dd, yyyy HH:mm")
        
        let endDate = TimeStatus.getDate(strDate: strEndDate, oldFormatter: "MMM dd, yyyy HH:mm")
        
        return [startDate, endDate]
    }
    
    
    func animationScaling(view: UIView) -> Void {
        
//        UIView.animate(withDuration: 0.2,
//               animations: {
//                view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        },
//               completion: { _ in
//                UIView.animate(withDuration: 0.2) {
//                    view.transform = CGAffineTransform.identity
//                }
//        })
    }
}


struct TimeStatus {
    
    static func getStrDateCallWithDate(isApplyTimeZone: Bool, date: Date , newFormat: String) -> String {
        
        let edtDf = DateFormatter()
        
        if isApplyTimeZone == true {
            
//            edtDf.timeZone = TimeZone(identifier: "UTC")
//            
//            edtDf.locale = Locale.current
        }
        
        edtDf.timeZone = TimeZone.current
        
        edtDf.dateFormat = newFormat
        
        let strNewDate = edtDf.string(from: date)
        
        return strNewDate
    }
    
    
    static func getDate(isApplyTimeZone: Bool, strDate: String, oldFormatter: String, newFormat: String) -> String {
        
        let dateStr = strDate;
        
        let dateFormat = DateFormatter()
        
        dateFormat.dateFormat = oldFormatter
        
        let date = dateFormat.date(from: dateStr)
        
        let strNewDate = self.getStrDateCallWithDate(isApplyTimeZone: isApplyTimeZone, date: date!, newFormat: newFormat)
        
        return strNewDate
    }
    
    static func getDate(strDate: String, oldFormatter: String) -> Date {
        
        let dateStr = strDate;
        
        let dateFormat = DateFormatter()
        
        dateFormat.dateFormat = oldFormatter
        
        return dateFormat.date(from: dateStr)!
    }
}



extension UIView {
    
    var parentViewController: UIViewController? {
        
        var parentResponder: UIResponder? = self
        
        while parentResponder != nil {
            
            parentResponder = parentResponder!.next
            
            if let viewController = parentResponder as? UIViewController {
                
                return viewController
            }
        }
        return nil
    }
}

public extension CGFloat {
    /**
     * Converts an angle in degrees to radians.
     */
    public func degreesToRadians() -> CGFloat {
        return 180.0
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) Year"   }
        if months(from: date)  > 0 { return "\(months(from: date)) Mon"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) Week"   }
        if days(from: date)    > 0 { return "\(days(from: date)) Day"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) Hr"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) Min" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) Sec" }
        return ""
    }
}


