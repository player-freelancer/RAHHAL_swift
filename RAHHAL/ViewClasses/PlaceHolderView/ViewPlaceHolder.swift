//
//  ViewPlaceHolder.swift
//  RAHHAL
//
//  Created by Macbook on 1/4/18.
//  Copyright © 2018 RAJ. All rights reserved.
//

import UIKit

class ViewPlaceHolder: UIView {

    @IBOutlet var lblPlaceHohder: UILabel!
    

    func setPlaceHolderText(strString: String) -> Void {
        
        lblPlaceHohder.text = strString
    }
}
