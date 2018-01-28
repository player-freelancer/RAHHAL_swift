//
//  FirebaseManager.swift
//  Simple Chatting
//
//  Created by Mac OSX on 16/11/17.
//  Copyright © 2017 Mac OSX. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FirebaseManager: NSObject {

    let dbRef = Database.database().reference()
    
    private lazy var dbChatTrip = dbRef.child("ChatTrips")
    
    private lazy var dbChatShipment = dbRef.child("ChatShipment")
    
    static let sharedInstance : FirebaseManager = {
        let instance = FirebaseManager()
        return instance
    }()
    

    func checkUserNameAlreadyExist(userId: String, completion: @escaping(Bool) -> Void) {
        
        let ref = Database.database().reference()
        
        ref.child("Users").queryOrdered(byChild: "id").queryEqual(toValue: userId)
            .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                
                if snapshot.exists() {
                    
                    completion(true)
                }
                else {
                    completion(false)
                }
            })
    }
    
    
    func CreateUser( Completion:@escaping (_ Success:String,_ error1:String)-> Void) -> Void {
        
        
        if let dictUserInfo = UserDefaults.standard.object(forKey: "kUser") as? [String: AnyObject] {
            
            let phone = dictUserInfo["mobile"] as! String
            
            let fName = dictUserInfo["first_name"] as! String
            
            let lName = dictUserInfo["last_name"] as! String
            
            let userName = "\(fName) \(lName)"
            
            let Email = "\(phone)@rahhal.com"
            
            
            
            
            Auth.auth().createUser(withEmail: Email, password: phone, completion: { authData, error  in
                
                if error == nil
                {
                    
                    var userData = dictUserInfo
                    
                    userData["full_name"] = userName as AnyObject
                    
//                    let userData = ["Email": Email, "Password": Phone, "UserName": userName, "FirstName": FName, "LastName": LName, "PhoneNumber": Phone]
                    
                    let ref = Database.database().reference()
                    
                    ref.child("Users").child(authData!.uid).setValue(userData)
                    
                    Completion("yes", "")
                    
                } else {
                    
                    Completion("no", (error?.localizedDescription)!)
                    
                }
            })
        }
    }
    
    
    func getMyAllTrips(key:String, completion: @escaping(_ arrMyTrips: [[String:AnyObject]]) -> Void) -> Void {
        
        let dictUserInfo = UserDefaults.standard.object(forKey: "kUser") as! [String: AnyObject]
        
        let myUserId = dictUserInfo["id"] as! String
        
        let query = dbChatTrip.queryOrdered(byChild: key).queryEqual(toValue: myUserId)
       
        query.observeSingleEvent(of: .value, with: { snapshot in
            
            var arrGetMyTrips = [[String:AnyObject]]()
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                var dict = snap.value as! [String: AnyObject]
                let key = snap.key
                dict["chatId"] = key as AnyObject
                arrGetMyTrips.append(dict)
            }
            
            completion(arrGetMyTrips)
        })
    }
    
    
    func getMyAllShipments(key: String, completion: @escaping(_ arrMyTrips: [[String:AnyObject]]) -> Void) -> Void {
        
        let dictUserInfo = UserDefaults.standard.object(forKey: "kUser") as! [String: AnyObject]
        
        let myUserId = dictUserInfo["id"] as! String
        
        let query = dbChatShipment.queryOrdered(byChild: key).queryEqual(toValue: myUserId)
        
        query.observeSingleEvent(of: .value, with: { snapshot in
            
            var arrGetMyTrips = [[String:AnyObject]]()
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                var dict = snap.value as! [String: AnyObject]
                let key = snap.key
                dict["chatId"] = key as AnyObject
                arrGetMyTrips.append(dict)
            }
            
            completion(arrGetMyTrips)
        })
    }
    
    
    func createNewTripChat(dictTripInfo: [String: AnyObject]) -> Void {
        
        let myUserId = dictTripInfo["userId"] as! String
        
        let tripId = dictTripInfo["id"] as! String
        
        let usersRef = dbRef.child("TripChat")
        let newChannelRef = usersRef.childByAutoId()
        
        let participants = "trip\(tripId)-\(myUserId)"
        let channelItem = [
            "tripCreatedBy": myUserId,
            "tripId": tripId,
            "name": "Deal\(participants)",
            participants: true,
            ] as [String : Any]
        newChannelRef.setValue(channelItem)
    }
    
    
    func getMyChannelList(keyWord: String, keyWordId: String, completion: @escaping([Channel]) -> Void) -> Void {
        
        let dictUserInfo = UserDefaults.standard.object(forKey: "kUser") as! [String: AnyObject]
        
        let myUserId = dictUserInfo["id"] as! String
        
        let identity = "\(keyWord)\(keyWordId)-\(myUserId)"
        
        let query = dbChatTrip.queryOrdered(byChild: identity).queryEqual(toValue: true)
        
        query.observe(.value, with: { (snapshot) in
            
            var arrAllChannelList = [Channel]()
            
            if let allProfiles = snapshot.value as? [String:AnyObject] {
                for (key,value) in allProfiles {
                    print("\(key) -- \(value)")
                    
                    let dict = value as! [String: AnyObject]
                    let name = dict["name"] as! String
                    arrAllChannelList.append(Channel(id: key, name: name, panterId: name))
//                    arrAllChannelList.append(value as! [String : AnyObject])
                }
                
                 completion(arrAllChannelList)
            }
            
           
        })
        
    }
    
    
    func checkChannelAlreadyExist( keyWord: String, keyWordId: String, completion: @escaping(Bool) -> Void) {
        
        let dictUserInfo = UserDefaults.standard.object(forKey: "kUser") as! [String: AnyObject]
        
        let myUserId = dictUserInfo["id"] as! String
        
        let channelName = "\(keyWord)\(keyWordId)-\(myUserId)"
        
        dbChatTrip.queryOrdered(byChild: channelName).queryEqual(toValue: true).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            
            if snapshot.exists() {
                completion(true)
                
            }
            else {
                completion(false)
            }
        })
        
//        ref.child("ChatTable").queryOrdered(byChild: "name").queryEqual(toValue: newUserName)
//            .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
//
//                if snapshot.exists() {
//                    completion(true)
//
//                }
//                else {
//                    completion(false)
//                }
//            })
    }
    
    
}
