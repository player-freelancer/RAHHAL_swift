//
//  ColorExt.swift
//  PocketBrokerConsumer
//
//  Created by Raj on 11/02/17.
//  Copyright © 2017 Raj. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func colorTheme() -> UIColor {
        
        return UIColor(red: 253.0/255.0, green: 204/255.0, blue: 65/255.0, alpha: 1.0)
    }
    
    class func colorBackgroundDate() -> UIColor {
        
        return UIColor(red: 133/255.0, green: 125/255.0, blue: 125/255.0, alpha: 1.0)
    }
    
    class func colorSelectedTabItem() -> UIColor {
        
        return UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
    }
    
    class func colorCellSubTitle() -> UIColor {
        
        return UIColor(red: 119/255.0, green: 119/255.0, blue: 119/255.0, alpha: 1.0)
    }
    
    class func colorSelectedTabBottomLine() -> UIColor {
        
        return UIColor(red: 53/255.0, green: 157/255.0, blue: 231/255.0, alpha: 1.0)
    }
    
    class func colorGreenRibbon() -> UIColor {
        
        return UIColor(red: 33/255, green: 177/255, blue: 76/255, alpha: 1)
    }
    
    class func colorYellowForAppointmentStatus() -> UIColor {
    
        return UIColor(red: 255.0/255, green: 200.0/255, blue: 13.0/255, alpha:1.0)
    }
    
    class func colorBlueForAppointmentStatus() -> UIColor {
        
        return UIColor(red: 32.0/255, green: 81.0/255, blue: 143.0/255, alpha:1.0)
    }
    
    class func colorBorder() -> UIColor {
        
        return UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0)
    }
    
    class func colorSelectedCell() -> UIColor {
        
        return UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
    }
    
    class func colorSelectedCompassButton() -> UIColor {
        
        return UIColor(red: 35/255.0, green: 103/255.0, blue: 166/255.0, alpha: 1.0)
    }
    
    class func colorGreen() -> UIColor {
        
        return UIColor(red: 12.0/255, green: 150.0/255, blue: 4.0/255, alpha: 1)
    }
    
}

extension UIImageView {
    
    func maskWith(color: UIColor) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        tintColor = color
    }
    
}
