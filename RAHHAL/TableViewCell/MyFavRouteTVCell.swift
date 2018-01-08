//
//  MyFavRouteTVCell.swift
//  RAHHAL
//
//  Created by Macbook on 1/1/18.
//  Copyright © 2018 RAJ. All rights reserved.
//

import UIKit

class MyFavRouteTVCell: UITableViewCell {

    @IBOutlet var btnCross: UIButton!
    
    @IBOutlet var imgOnDemand: UIImageView!
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblFromAddress: UILabel!
    
    @IBOutlet var lblToAddress: UILabel!
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    

    func showMyFavRouteData(dictShipment:[String: AnyObject]) -> Void {
        
        self.selectionStyle = .none
        
        lblTitle.text = dictShipment["type"] as? String ?? ""
        
        lblFromAddress.text = dictShipment["pickup_location"] as? String ?? ""
        
        lblToAddress.text = dictShipment["drop_location"] as? String ?? ""
        
        imgOnDemand.isHidden = true
        
//        if let typeShipment = dictShipment["type"] as? String, typeShipment == "Within City" {
//
//            imgOnDemand.isHidden = false
//        }
    }

}
