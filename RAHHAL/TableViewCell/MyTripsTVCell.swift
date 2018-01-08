//
//  MyTripsTVCell.swift
//  RAHHAL
//
//  Created by Macbook on 12/30/17.
//  Copyright © 2017 RAJ. All rights reserved.
//

import UIKit

class MyTripsTVCell: UITableViewCell {

    @IBOutlet var btnCross: UIButton!
    
    @IBOutlet var imgOnDemand: UIImageView!
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblFromAddress: UILabel!
    
    @IBOutlet var lblToAddress: UILabel!
    
    @IBOutlet var lblWeight: UILabel!
    
    @IBOutlet var lblPrice: UILabel!
    
    
    override func awakeFromNib() {
       
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    
    func showMyTripData(dictShipment:[String: AnyObject]) -> Void {
        
        
        lblTitle.text = dictShipment["type"] as? String ?? ""
        
        lblFromAddress.text = dictShipment["from_location"] as? String ?? ""
        
        lblToAddress.text = dictShipment["to_location"] as? String ?? ""
        
        if let weight = dictShipment["weight"] as? String {
            
            lblWeight.text = "\(weight) Kg"
        }
        lblPrice.text = dictShipment["fees"] as? String ?? ""
        
        imgOnDemand.isHidden = true
        
        if let typeShipment = dictShipment["type"] as? String, typeShipment == "Within City" {
            
            imgOnDemand.isHidden = false
        }
    }
    
    
    func showSearchTripData(dictShipment:[String: AnyObject]) -> Void {
        
        
        lblTitle.text = dictShipment["type"] as? String ?? ""
        
        lblFromAddress.text = dictShipment["from_location"] as? String ?? ""
        
        lblToAddress.text = dictShipment["to_location"] as? String ?? ""
        
        if let weight = dictShipment["weight"] as? String {
            
            lblWeight.text = "\(weight) Kg"
        }
        
        imgOnDemand.isHidden = true
        
        if let typeShipment = dictShipment["type"] as? String, typeShipment == "Within City" {
            
            imgOnDemand.isHidden = false
        }
    }
    
    
    func showSearchShipmentData(dictShipment:[String: AnyObject]) -> Void {
        
        
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
    }

}
