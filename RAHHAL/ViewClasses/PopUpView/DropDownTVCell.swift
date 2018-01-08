//
//  DropDownTVCell.swift
//  PocketBrokerConsumer
//
//  Created by MR on 14/02/17.
//  Copyright © 2017 Mind Roots Technologies. All rights reserved.
//

import UIKit

class DropDownTVCell: UITableViewCell {

    @IBOutlet var lblListContent: UILabel!
    
    
    override func awakeFromNib() {
   
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    
    func setContent(text: String, arrSelectedValue: [String]) -> Void {
        
        if arrSelectedValue.contains(text) {
            
            self.accessoryType = .checkmark
        }
        
        lblListContent.text = text
    }
}
