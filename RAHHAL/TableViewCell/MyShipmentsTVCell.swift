//
//  MyShipmentsTVCell.swift
//  RAHHAL
//
//  Created by RAJ on 10/12/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit
import SDWebImage

class MyShipmentsTVCell: UITableViewCell {

    @IBOutlet var btnCross: UIButton!
    
    @IBOutlet weak var imgShipment: UIImageView!
    
    @IBOutlet weak var imgOnDemand: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblFromAddress: UILabel!
    
    @IBOutlet weak var lblToAddress: UILabel!
    
    @IBOutlet weak var lblWeight: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func showMyShipmentData(dictShipment:[String: AnyObject]) -> Void {
        
        
        print(UserDefaults.standard.value(forKey: "kToken"))
        
        lblTitle.text = dictShipment["title"] as? String ?? ""
        
        lblFromAddress.text = dictShipment["pickup_location"] as? String ?? ""
        
        lblToAddress.text = dictShipment["drop_location"] as? String ?? ""
        
        if let weight = dictShipment["weight"] as? String {
            
            lblWeight.text = "\(weight) Kg"
        }
        lblPrice.text = dictShipment["fees"] as? String ?? ""
        
        imgOnDemand.isHidden = true
        
        if let typeShipment = dictShipment["type"] as? String, typeShipment == "Within City" {
            
            imgOnDemand.isHidden = false
        }
        
        if let arrImg = dictShipment["images"] as? [[String: AnyObject]], !arrImg.isEmpty {
            
            let dictFirst = arrImg[0]
            
            let urlStr = String(format: "%@%@", imgShipmentBaseUrl, dictFirst["source_path"] as! String)
            
            imgShipment.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "placeholderAsserts"), options: []) { (image, error, imageCacheType, imageUrl) in
                
            }
        }
        
//        imgShipment
    }

}
