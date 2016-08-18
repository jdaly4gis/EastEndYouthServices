/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

import CoreLocation

class ServiceListViewController: UITableViewController, CLLocationManagerDelegate {
  
  var facilityStore: FacilityStore!
  var allItems = [Facility]();
  let locationManager = CLLocationManager()
  
  var currLocation: CLLocation?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest // GPS
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
 
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 110
    
    // Start network activity indicator
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
 
    
    facilityStore.fetchFacilities()  {
      (facilitiesResult) -> Void in
      
      switch facilitiesResult {
      case let .Success(facilities):
        NSOperationQueue.mainQueue().addOperationWithBlock {
          self.allItems = facilities;
//          print ("Successfully found \(facilities.count) Youth Service facilities")
        }
      case let .Failure(error):
        print ("Error fetching facilities: \(error)")
      }
        
      self.do_table_refresh()
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
 }
  
 
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
    return allItems.count
 
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    
    let facility = allItems[indexPath.row]

    if let x = Double(facility.Lon!),
      y = Double(facility.Lat!) {

      let facLocation = CLLocation(latitude: y, longitude: x)

      let distanceBetween: CLLocationDistance = facLocation.distanceFromLocation(self.currLocation!)
      cell.textLabel?.text = facility.F_Name
      cell.detailTextLabel?.text = String(format: "%.1f", distanceBetween/1609.344) + " miles"
    } else  {
      cell.textLabel?.text = "N/A"
      cell.detailTextLabel?.text = "N/A"
    }

    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)  {
    if segue.identifier == "ShowService"  {
      
      if let row = tableView.indexPathForSelectedRow?.row  {

        let facility = allItems[row]
        let detailViewController = segue.destinationViewController as! ServiceDetailViewController
        detailViewController.facility = facility
      }
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

      let location = locations.last
      let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)

    // Get user's current location
      self.currLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
      self.locationManager.stopUpdatingLocation()
    
  }
  
 
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)  {
    print ("Errors:  " + error.localizedDescription)
  }
  
 
 
  func do_table_refresh()
  {
    dispatch_async(dispatch_get_main_queue(), {
      self.tableView.reloadData()
      return
    })
  }
  
}
