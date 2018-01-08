//
//  UserVM.swift
//  OrderTron
//
//  Created by MR on 10/11/16.
//  Copyright © 2016 MR. All rights reserved.
//

import UIKit

class TripsVM: NSObject {
    
    static let shared : TripsVM = {
        
        let instance = TripsVM()
        
        return instance
    }()
    
    
    func newTrip(dictTripInfo: [String : String], completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "trip/create", dict: dictTripInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            print("dictResponse : \(dictResponse)")
            completionHandler(dictResponse)
            
        }, failure: { (errorCode) in
            
            print("errorCode : \(errorCode)")
            failure(errorCode)
        })
    }
    
    
    func uploadTripImage(imgShipment: UIImage, completionHandler:@escaping ( _ dict :[String:AnyObject]) -> Void, failure:@escaping ( _ error :String) -> Void) -> Void  {
        
        let dict = [String: AnyObject]()
        
        WebService.sharedInstance.postMethodWithParamsAndImage(strURL: "trip/uploadimage", dictParams: dict as NSDictionary, image: imgShipment, imagesKey: "image", imageName: "image", completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse as! [String : AnyObject])
            
        }, failue: { (errorCode) in
            
            failure(errorCode)
        })
    }
    
    
    func updateTrip(dictUserInfo: [String : String], completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
//        shipmentId,pictureIds
        
        WebService.sharedInstance.postMethodWithParams(strURL: "trip/update", dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            print("dictResponse : \(dictResponse)")
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            print("errorCode : \(errorCode)")
            failure(errorCode)
        })
    }
    
    func deleteTrip(tripId: String , completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        var dict = [String: AnyObject]()
        
        dict["tripId"] = tripId as AnyObject
        
        WebService.sharedInstance.postMethodWithParams(strURL: "trip/delete", dict: dict as NSDictionary, completionHandler: { (dictResponse) in
            
            print("dictResponse : \(dictResponse)")
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            print("errorCode : \(errorCode)")
            failure(errorCode)
        })
    }
    
    
    func getMyTrips(pageNumber: Int, completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void{
        
        let subUrl = "trip/myTrips?page=\(pageNumber)"
        
        WebService.sharedInstance.getMethedWithoutParams(subUrl, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            failure(errorCode)
        })
    }
    
    
    func findTrips(dictInfo: [String: AnyObject] , completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        let dict = [String: AnyObject]()
        
        WebService.sharedInstance.postMethodWithParams(strURL: "search/trip", dict: dictInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            print("dictResponse : \(dictResponse)")
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            print("errorCode : \(errorCode)")
            failure(errorCode)
        })
    }
    
    
    func searchCity(strKeyword: String, completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void{
        
        WebService.sharedInstance.getMethedWithoutParams("search/city?keyword=\(strKeyword)", completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            failure(errorCode)
        })
    }
}
