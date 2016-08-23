//
//  Facility.swift
//  YouthServices
//
//  Created by Southampton Dev on 7/22/16.
//  Copyright © 2016 TOS. All rights reserved.
//

import UIKit

class Facility: NSObject  {
    let F_Name: String?
    let Desc: String?
    let Address: String?
    let Telephone: String?
    let WebLink: String?
    let Fee: String?
    let Lat: String?
    let Lon: String?
    let Category: String?
    var DistFromCenter: Double?
    
    init(F_Name: String,
         Desc: String,
         Address: String,
         Telephone: String,
         WebLink: String,
         Fee: String,
         Lat: String,
         Lon: String,
         Category: String,
         DistFromCenter: Double
        ) {
        
        self.F_Name = F_Name
        self.Desc = Desc
        self.Address = Address
        self.Telephone = Telephone
        self.WebLink = WebLink
        self.Fee = Fee
        self.Lat = Lat
        self.Lon = Lon
        self.Category = Category
        self.DistFromCenter = DistFromCenter
        super.init()
    }
    /*
     let ID: String?
     let Phone1Ext: String?
     let Email: String?
     let Zip: String?
     let AddressLine3: String?
     let IPAddress: String?
     let Mapped: String?
     let Fee: String?
     let loc_ID: String?
     let xCoord: String?
     let Phone2: String?
     let Lon: String?
     let Weblink: String?
     let Civic: String?
     let Fax: String?
     let AddressLine2: String?
     let category: String?
     let SubmissionDate:String?
     let yCoord: String?
     let AddressLine1: String?
     let Lat: String?
     let Desc: String?
     let Address: String?
     let F_Name: String?
     let Contact: String?
     let Phone2xt:String?
     let Title: String?
     let Phone1: String?
     let Township: String?
     let DistFromCenter: Double?
     
     init(
     ID: String, Phone1Ext: String, Email: String, Zip: String, AddressLine3: String, IPAddress: String,
     Mapped: String, Fee: String, loc_ID: String, xCoord: String, Phone2: String, Lon: String, Weblink: String,
     Civic: String, Fax: String, AddressLine2: String, category: String, SubmissionDate: String, yCoord: String,
     AddressLine1: String, Lat: String, Desc: String, Address: String, F_Name: String, Contact: String,
     Phone2xt: String, Title: String, Phone1: String, Township:String, DistFromCenter: Double
     )  {
     
     self.ID = ID
     self.Phone1Ext = Phone1Ext
     self.Email = Email
     self.Zip = Zip
     self.AddressLine3 = AddressLine3
     self.IPAddress = IPAddress
     self.Mapped = Mapped
     self.Fee = Fee
     self.loc_ID = loc_ID
     self.xCoord = xCoord
     self.Phone2 = Phone2
     self.Lon = Lon
     self.Weblink = Weblink
     self.Civic = Civic
     self.Fax = Fax
     self.AddressLine2 = AddressLine2
     self.category =  category
     self.SubmissionDate = SubmissionDate
     self.yCoord = yCoord
     self.AddressLine1 = AddressLine1
     self.Lat = Lat
     self.Desc = Desc
     self.Address = Address
     self.F_Name = F_Name
     self.Contact = Contact
     self.Phone2xt = Phone2xt
     self.Title = Title
     self.Phone1 = Phone1
     self.Township = Township
     self.DistFromCenter = DistFromCenter
     super.init()
     }
     */
}