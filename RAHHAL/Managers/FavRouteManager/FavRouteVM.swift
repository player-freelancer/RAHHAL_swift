//
//  UserVM.swift
//  OrderTron
//
//  Created by MR on 10/11/16.
//  Copyright © 2016 MR. All rights reserved.
//

import UIKit

class FavRouteVM: NSObject {
    
    static let shared : FavRouteVM = {
        
        let instance = FavRouteVM()
        
        return instance
    }()
    
    
    func newFavRoute(dictFavRouteInfo: [String : String], completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "route/create", dict: dictFavRouteInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            print("dictResponse : \(dictResponse)")
            completionHandler(dictResponse)
            
        }, failure: { (errorCode) in
            
            print("errorCode : \(errorCode)")
            failure(errorCode)
        })
    }
    
    
    
    func updateFavRoute(dictFavRouteInfo: [String : String], completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
//        shipmentId,pictureIds
        
        WebService.sharedInstance.postMethodWithParams(strURL: "route/update", dict: dictFavRouteInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            print("dictResponse : \(dictResponse)")
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            print("errorCode : \(errorCode)")
            failure(errorCode)
        })
    }
    
    
    func deleteFavRoute(routeId: String , completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        var dict = [String: AnyObject]()
        
        dict["routeId"] = routeId as AnyObject
        
        WebService.sharedInstance.postMethodWithParams(strURL: "route/delete", dict: dict as NSDictionary, completionHandler: { (dictResponse) in
            
            print("dictResponse : \(dictResponse)")
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            print("errorCode : \(errorCode)")
            failure(errorCode)
        })
    }
    
    
    func getMyFavRoutes(pageNumber: Int, completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void{
        
        let subUrl = "route/myRoutes"
        
        WebService.sharedInstance.getMethedWithoutParams(subUrl, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
        }, failure: { (errorCode) in
            
            failure(errorCode)
        })
    }
}
