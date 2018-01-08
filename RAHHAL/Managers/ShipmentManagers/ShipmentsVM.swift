//
//  UserVM.swift
//  OrderTron
//
//  Created by MR on 10/11/16.
//  Copyright © 2016 MR. All rights reserved.
//

import UIKit

class ShipmentsVM: NSObject {
    
    static let shared : ShipmentsVM = {
        
        let instance = ShipmentsVM()
        
        return instance
    }()
    
    
    func newShipment(dictUserInfo: [String : String], completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "shipment/create", dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            print("dictResponse : \(dictResponse)")
            completionHandler(dictResponse)
            
        }, failure: { (errorCode) in
            
            print("errorCode : \(errorCode)")
            failure(errorCode)
        })
    }
    
    
    func uploadShipmentImage(imgShipment: UIImage, completionHandler:@escaping ( _ dict :[String:AnyObject]) -> Void, failure:@escaping ( _ error :String) -> Void) -> Void  {
        
        let dict = [String: AnyObject]()
        
        WebService.sharedInstance.postMethodWithParamsAndImage(strURL: "shipment/uploadimage", dictParams: dict as NSDictionary, image: imgShipment, imagesKey: "image", imageName: "image", completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse as! [String : AnyObject])
            
        }, failue: { (errorCode) in
            
            failure(errorCode)
        })
    }
    
    
    func updateShipment(dictUserInfo: [String : String], completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
//        shipmentId,pictureIds
        
        WebService.sharedInstance.postMethodWithParams(strURL: "shipment/update", dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            print("dictResponse : \(dictResponse)")
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            print("errorCode : \(errorCode)")
            failure(errorCode)
        })
    }
    
    func deleteShipment(shipmentId: String , completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        var dict = [String: AnyObject]()
        
        dict["shipmentId"] = shipmentId as AnyObject
        
        WebService.sharedInstance.postMethodWithParams(strURL: "shipment/delete", dict: dict as NSDictionary, completionHandler: { (dictResponse) in
            
            print("dictResponse : \(dictResponse)")
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            print("errorCode : \(errorCode)")
            failure(errorCode)
        })
    }
    
    
    func getMyShipments( completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void{
        
        WebService.sharedInstance.getMethedWithoutParams("shipment/myShipment", completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            failure(errorCode)
        })
    }
    
    
    func findShipment(dictUserInfo: [String : String], completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        //        shipmentId,pictureIds
        
        WebService.sharedInstance.postMethodWithParams(strURL: "search/shipment", dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
            
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
