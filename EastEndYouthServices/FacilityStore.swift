//
//  FacilityStore.swift
//  GEER
//
//  Created by Southampton Dev on 8/8/16.
//  Copyright © 2016 TOS. All rights reserved.
//

import UIKit


class FacilityStore  {
  
  
  var allFacilities = [Facility]()
  
  
  func processFacilitiesRequest(data data: NSData?, error: NSError?) -> FacilitiesResult {
    
    guard let jsonData = data else  {
      return .Failure(error!)
    }
    
    return FacilitiesAPI.facilitiesFromJSONData(jsonData)
  }
  
  
  let session: NSURLSession = {
    
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    return NSURLSession(configuration: config)
    
  }()
  
  func fetchFacilities(completion completion: (FacilitiesResult) -> Void)  {
    
    let url = FacilitiesAPI.facilitiesURL()
    let request = NSURLRequest(URL: url)
    let task = session.dataTaskWithRequest(request)  {
      (data, response, error)  -> Void in
      
      let result = self.processFacilitiesRequest(data: data, error: error)
      completion(result)
      
    }
    task.resume()
  }
  
}