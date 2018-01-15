//
//  RPNavigationVC.swift
//  RAHHAL
//
//  Created by RAJ on 10/12/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit
import Foundation

class RPNavigationVC: UINavigationController, ViewLeftMenuDelegates {

    var viewLeftMenu: ViewLeftMenu!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: "kLoggedIn")
        UserDefaults.standard.synchronize()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        viewLeftMenu = Bundle.main.loadNibNamed("ViewLeftMenu", owner: nil, options: nil)?[0] as! ViewLeftMenu
        
        viewLeftMenu.frame = CGRect(x: 0, y: 0, width: DeviceInfo.TheCurrentDeviceWidth / 1.2, height: self.view.frame.size.height)
        
        viewLeftMenu.reloadMenu()
        
        viewLeftMenu.delegates = self
        
        appDelegate.window?.addSubview(viewLeftMenu)
        
//        appDelegate.window?.sendSubview(toBack: viewLeftMenu)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "homeVC") as! HomeVC

        self.pushViewController(homeVC, animated: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    func indexStatus(index: Int) -> Void {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch index {
            
        case 0:
            
            let homeVC = storyboard.instantiateViewController(withIdentifier: "homeVC") as! HomeVC
            
            self.viewControllers = [homeVC]
        case 1:
            print("index \(index)")
            let myTripsVC = storyboard.instantiateViewController(withIdentifier: "myTripsVC") as! MyTripsVC
            
            self.viewControllers = [myTripsVC]
        case 2:
            print("index \(index)")
            
            let myFavRoutesVC = storyboard.instantiateViewController(withIdentifier: "MyFavRoutesVC") as! MyFavRoutesVC
            
            self.viewControllers = [myFavRoutesVC]
        case 3:
            print("index \(index)")
        case 4:
            print("index \(index)")
            UserDefaults.standard.set(false, forKey: "kLoggedIn")
            UserDefaults.standard.synchronize()
            
            let myFavRoutesVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.viewControllers = [myFavRoutesVC]
        case 5:
            print("index \(index)")
            UserDefaults.standard.set(false, forKey: "kLoggedIn")
            UserDefaults.standard.synchronize()
            
            let myFavRoutesVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            
            self.viewControllers = [myFavRoutesVC]
        case 1000:
            print("index Profile \(index)")
            
            let myProfileVC = storyboard.instantiateViewController(withIdentifier: "myProfileVC") as! MyProfileVC
            
            self.viewControllers = [myProfileVC]
        
        default:
            break
        }
        
        self.resetFrame()
    }
    
    
    func resetFrame() -> Void {
        
        if self.view.frame.origin.x == 0 {
            
            UIView.animate(withDuration: 0.4) {
                self.view.frame = CGRect(x: DeviceInfo.TheCurrentDeviceWidth / 1.5, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }
        else {
            
            UIView.animate(withDuration: 0.4) {
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }
    }
}


extension UINavigationController {
    
    func resetVC(arrVC: [UIViewController]) -> Void {
        
        viewControllers = arrVC
    }
}


extension UINavigationItem {
    
    func leftMoreThenOneButtons(btn : UIBarButtonItem, btn2 : UIBarButtonItem) -> Void {
        
        btn.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont(name: "HelveticaNeue", size: 18)!], for: UIControlState.normal)
        
        leftBarButtonItems = [btn, btn2]
    }
}

extension UINavigationController {
    
    func makeNavigationbar (title: String){
        
        self.navigationItem.title = title
        
        navigationController?.isNavigationBarHidden = false
    }
}


extension UINavigationBar {
    
    func makeColorNavigationBar () {
        
        isTranslucent = false
        
        barTintColor = UIColor.colorTheme()
        
        tintColor = UIColor.white
        
        titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.fontMontserratRegulat20()]
    }
    
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        super.sizeThatFits(size)
        
        let sizeThatFits = super.sizeThatFits(size)
        
        //sizeThatFits.height = 56
        
        return sizeThatFits
    }
    
    
    func getCentre(imgView : UIImageView) {
        
        imgView.center = self.center
    }
}


extension UINavigationItem {
    
    func navTitle(title: String) -> Void {
        
        self.title = title
    }
    
    
    func makeNavWithImage(strImageName: String) -> Void {
        let viewNav = UIView()
        
        let imgView = UIImageView(image: UIImage(named: "strImageName"))
        
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        
        imgView.center = viewNav.center
        
        viewNav.addSubview(imgView)
        
        self.titleView = viewNav
    }
    
    
    func hideDefaultBackButton() -> Void {
        
        hidesBackButton = true
    }
    
    
    func rightButton(btn : UIBarButtonItem) -> Void {
        
        btn.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white,  NSAttributedStringKey.font : UIFont(name: "HelveticaNeue", size: 18)!], for: UIControlState.normal)
        
        rightBarButtonItem = btn
    }
}
