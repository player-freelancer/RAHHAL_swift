//
//  AppDelegate.swift
//  RAHHAL
//
//  Created by RAJ on 02/12/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import Firebase
import Fabric
//import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var  reachability : Reachability!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSPlacesClient.provideAPIKey("AIzaSyDplRT91OpjXDlqxm9FIiNsYRT6ztDLy1c")

        FirebaseApp.configure()
        
        Fabric.sharedSDK().debug = true
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.callReachability()
        
        
        if let isLoggedIn = UserDefaults.standard.value(forKey: "kLoggedIn") as? Bool, isLoggedIn == true {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController: RPNavigationVC = mainStoryboard.instantiateViewController(withIdentifier: "rpNavigationVC") as! RPNavigationVC
            self.window?.rootViewController = initialViewController
            
            self.window?.makeKeyAndVisible()
        }
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func callReachability() -> Void {
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkConnection(notification:)), name: ReachabilityChangedNotification, object: nil)
        
        reachability = Reachability.init()
        
        do {
            
            try reachability.startNotifier()
        }
        catch {
            
            print("Reachability Error")
        }
    }
    
    @objc func networkConnection(notification : NSNotification) -> Void {
        
        print("Check Internet Connection  :::::  \(reachability.isReachable)")
        
         if !self.reachability.isReachable {
            
            self.alertForNetworkError()
        }
    }
    
    
    func alertForNetworkError() -> Void {
        
        DispatchQueue.main.async {
            
            CommonFile.shared.hudDismiss()
            let topWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindowLevelAlert + 1
            let alert = UIAlertController(title: alertTitleError, message: Please_check_your_internet_connection, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: OKString, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in }))
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
    }

}

