//
//  MyProfileHeader.swift
//  RAHHAL
//
//  Created by Macbook on 12/28/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

protocol MyProfileHeaderDelegate {
    
    func chooseImageFromSource()
}

import UIKit

class MyProfileHeader: UIView {

    @IBOutlet var imgMyProfilePic: UIImageView!

    var delegate: MyProfileHeaderDelegate?
    
    
    @IBAction func btnChangeProfilePicAction(_ sender: UIButton) {
        
        delegate?.chooseImageFromSource()
    }
    
}
