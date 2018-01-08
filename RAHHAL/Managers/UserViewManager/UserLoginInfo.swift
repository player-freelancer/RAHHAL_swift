//
//  UserLoginInfo.swift
//  ordertron
//
//  Created by MR on 16/11/16.
//  Copyright © 2016 MR. All rights reserved.
//

import Foundation

struct UserLoginInfo {
    
    let companyId : String!
    
    let companyName : String!
    
    let companyPrefix : String!
    
    let currencyCode : String!
    
    let currencySymbol : String!
    
    let customerBusiness : String!
    
    let messageCount : String!
    
    let shippingCost : String!
    
    let shippingStatus : String!
    
    let taxGST : String!
    
    let taxPercentage : String!
    
    let type : String!
    
    let level : String!
    
    let companyLogo : String!
    
    init(company_id: String, company_name: String, company_prefix: String, currency_code: String, currency_symbol: String, customer_business: String, message_count: String, shipping_cost: String, shipping_status: String, tax_label: String, tax_percentage : String, type : String, level : String, companyLogo : String) {

        self.companyId = company_id
        
        self.companyName = company_name
        
        self.companyPrefix = company_prefix
        
        self.currencyCode = currency_code
        
        self.currencySymbol = currency_symbol
        
        self.customerBusiness = customer_business
        
        self.messageCount = message_count
        
        self.shippingCost = shipping_cost
        
        self.shippingStatus = shipping_status
        
        self.taxGST = tax_label
        
        self.taxPercentage = tax_percentage
        
        self.type = type
        
        self.level = level
        
        self.companyLogo = companyLogo
    }
    
    static func albumWithJSON(results : NSArray) -> [UserLoginInfo] {
        var userLoginInfo = [UserLoginInfo]()
        
        if results.count > 0
        {
            for result in results {
                
                if let dataDict = result as? [String:AnyObject] {
                
                    let getCompanyId = dataDict["customer_id"] as! String
                    
                    let getCompanyName = dataDict["company_name"] as! String
                    
                    let getCompanyPrefix = dataDict["company_prefix"] as! String
                    
                    let getCurrencyCode = dataDict["currency_code"] as! String
                    
                    let getCurrencySymbol = dataDict["currency_symbol"] as! String
                    
                    let getCustomerBusiness = dataDict["customer_business"] as! String
                
                    let getMessageCount = dataDict["message_count"] as! String
                
                    let getShippingCost = dataDict["shipping_cost"] as! String
                    
                    let getShippingStatus = dataDict["shipping_status"] as! String
                    
                    let getTaxGST = dataDict["tax_label"] as! String
                    
                    let getTaxPercentage = dataDict["tax_percentage"] as! String
                    
                    let getType = dataDict["type"] as! String
                    
                    let getLevel = dataDict["level"] as! String
                    
                    UserDefaults.standard.set(getLevel, forKey: "kLevel")
                    
                    UserDefaults.standard.synchronize()

                    let getLogo = dataDict["company_logo"] as! String
                    
                    let newDictForUserInfo = UserLoginInfo(company_id: getCompanyId, company_name: getCompanyName, company_prefix: getCompanyPrefix, currency_code: getCurrencyCode, currency_symbol: getCurrencySymbol, customer_business: getCustomerBusiness, message_count: getMessageCount as String, shipping_cost: getShippingCost, shipping_status: getShippingStatus, tax_label: getTaxGST, tax_percentage: getTaxPercentage, type: getType, level: getLevel, companyLogo: getLogo)
                    
                    userLoginInfo.append(newDictForUserInfo)
                }
            }
        }
        return userLoginInfo
    }
}
