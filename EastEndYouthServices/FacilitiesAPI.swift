//
//  FacilitiesAPI.swift
//  YouthServices
//
//  Created by Southampton Dev on 7/22/16.
//  Copyright © 2016 TOS. All rights reserved.
//

import Foundation

enum FacilitiesResult  {
    case Success([Facility])
    case Failure(ErrorType)
}

enum FacilitiesError: ErrorType {
    case InvalidJSONData
}

struct FacilitiesAPI  {
    
    private static let baseURLString = "http://dev.southamptontownny.gov/getyouthservicesjson.ashx"
    
    private static let dateFormatter: NSDateFormatter =  {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    
    private static func facilityFromJSONObject(json: [String: AnyObject]) -> Facility?  {
        
        guard let
            
            name = json["F_Name"] as? String,
            addr = json["Address"] as? String,
            phone = json["Phone1"] as? String,
            url = json["WebLink"] as? String,
            fee = json["Fee"] as? String,
            lat = json["Lat"] as? String,
            lon = json["Lon"] as? String,
//            dist = 0 as? Double,
            description = json["Desc"] as? String else {
                return nil
        }
        /*
         email = json["Email"] as? String,
         zip = json["Zip"] as? String,
         addressLine3 = json["AddressLine3"] as? String,
         IPAddress = json["IPAddress"] as? String,
         isMapped = json["Mapped"] as? String,
         fee = json["Fee"] as? String,
         locationID = json["loc_ID"] as? String,
         xCoord = json["xCoord"] as? String,
         phone2 = json["Phone2"] as? String,
         lon = json["Lon"] as? String,
         weblink = json["WebLink"] as? String,
         civic = json["Civic"] as? String,
         fax = json["Fax"] as? String,
         addressLine2 = json["AddressLine2"] as? String,
         category = json["category"] as? String,
         submissionDate = json["SubmissionDate"] as? String,
         yCoord = json["yCoord"] as? String,
         addressLine1 = json["AddressLine1"] as? String,
         lat = json["Lat"] as? String,
         description = json["Desc"] as? String,
         address = json["Address"] as? String,
         name = json["F_Name"] as? String,
         contact = json["Contact"] as? String,
         phone2ext = json["Phone2xt"] as? String,
         title = json["Title"] as? String,
         phone1 = json["Phone1"] as? String,
         township = json["Township"] as? String,
         distFromCenter = json["DistFromCenter"] as? Double  else {
         return nil
         }
         
         return Facility(ID: id, Phone1Ext: phone1Ext, Email: email, Zip: zip, AddressLine3: addressLine3, IPAddress: IPAddress,
         Mapped: isMapped, Fee: fee, loc_ID: locationID, xCoord: xCoord, Phone2: phone2, Lon: lon, Weblink: weblink,
         Civic: civic, Fax: fax, AddressLine2: addressLine2, category: category, SubmissionDate: submissionDate, yCoord: yCoord,
         AddressLine1: addressLine1, Lat: lat, Desc: description, Address: address, F_Name: name, Contact: contact,
         Phone2xt: phone2ext, Title: title, Phone1: phone1, Township:township, DistFromCenter: distFromCenter)
         */
        
        return Facility(F_Name:name, Desc:description,  Address:addr, Telephone: phone, WebLink: url, Fee: fee, Lat: lat, Lon: lon, DistFromCenter: 0.0)
    }
    
    
    static func facilitiesURL() -> NSURL  {
        
        let components = NSURLComponents(string: baseURLString)!
        
        let queryItems = [NSURLQueryItem]()
        
        components.queryItems = queryItems
        
        return components.URL!
    }
    
    
    static func facilitiesFromJSONData(data: NSData) -> FacilitiesResult  {
        
        do {
//            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [NSJSONReadingOptions.AllowFragments])
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            
            guard let jsonDictionary = jsonObject as? [NSObject:AnyObject],
                facilities = jsonDictionary["services"] as? [String:AnyObject],
                facilitiesArray = facilities["service"] as? [[String:AnyObject]] else {
                    return .Failure(FacilitiesError.InvalidJSONData)
            }
            
            var finalFacilities = [Facility]()
            for facilityJSON in facilitiesArray  {
                
                if let facility = facilityFromJSONObject(facilityJSON)  {
                    
                    finalFacilities.append(facility)
                }
            }
            
            if finalFacilities.count == 0 && facilitiesArray.count > 0  {
                
                return .Failure(FacilitiesError.InvalidJSONData)
            }
            
            return .Success(finalFacilities)
        }
        catch let error {
            return .Failure(error)
        }
    }
}