//
//  MyprofileTVCell.swift
//  RAHHAL
//
//  Created by Macbook on 12/28/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit

class MyprofileTVCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var txtValue: UITextField!
   
    @IBOutlet var txtViewValue: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
