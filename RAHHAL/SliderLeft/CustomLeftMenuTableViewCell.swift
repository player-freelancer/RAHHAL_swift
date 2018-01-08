//
//  CustomLeftMenuTableViewCell.swift
//  Adomee Consumer
//
//  Created by Mind Roots Technologies on 06/02/17.
//  Copyright © 2017 Mind Roots Technologies. All rights reserved.
//

import UIKit

class CustomLeftMenuTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
   
    @IBOutlet var imgLeftIcon: UIImageView!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }

    
    func setContents(strTitle: String) -> Void {
        
        lblTitle.text = strTitle
    }
}
