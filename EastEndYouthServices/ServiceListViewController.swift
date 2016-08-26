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
  var filteredFacilities = [Facility]()
   
  let locationManager = CLLocationManager()
  let searchController = UISearchController(searchResultsController:nil)
    

    
    
  var currLocation: CLLocation?
    
    
  func filteredContentForSearchText(searchText: String, scope: String = "All")  {

    filteredFacilities = allItems.filter { facility in
        let typeMatch = (scope == "All") || (facility.Hamlet! == scope)
        print (typeMatch, scope, facility.Hamlet!, searchText.lowercaseString)
        return typeMatch && facility.Address!.lowercaseString.containsString(searchText.lowercaseString)
     }

     tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest // GPS
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
 
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 65
    
    // Start network activity indicator
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    
    facilityStore.fetchFacilities()  {
      (facilitiesResult) -> Void in
      
      switch facilitiesResult {
      case let .Success(facilities):
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.allItems = self.getSortedByDistance(facilities)
            print ("Successfully found \(facilities.count) Youth Service facilities")
        }
      case let .Failure(error):
        print ("Error fetching facilities: \(error)")
      }
        
      self.do_table_refresh()
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
    
    searchController.searchBar.scopeButtonTitles = ["All", "East Hampton", "Riverhead", "Shelter Island", "Southampton", "Southold"]
    searchController.searchBar.delegate = self
 }
    
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if searchController.active && searchController.searchBar.text != "" {
        return filteredFacilities.count
    }
 
    return allItems.count
 
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ServiceCell", forIndexPath: indexPath) as! ServiceCell
    
    let facility: Facility
   
    if searchController.active && searchController.searchBar.text != "" {
        facility = filteredFacilities[indexPath.row]
    } else {
        facility = allItems[indexPath.row]
    }

    cell.distanceView?.text = String(format: "%.1f", facility.DistFromCenter!) + " mile(s)"
    cell.titleView?.text = facility.F_Name
    cell.addressView?.text = facility.Address


    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)  {
    if segue.identifier == "ShowService"  {
      
      if let row = tableView.indexPathForSelectedRow?.row  {
        let facilityDetail: Facility
        
        if searchController.active && searchController.searchBar.text != "" {
            facilityDetail = filteredFacilities[row]
        } else {
            facilityDetail = allItems[row]
        }

        let detailViewController = segue.destinationViewController as! ServiceDetailViewController
        detailViewController.facility = facilityDetail
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
    
    
    func getSortedByDistance(facilities: [Facility]) -> [Facility] {

        
        for object in facilities  {
            let lat = object.Lat!
            let lon = object.Lon!
            
            if let x = Double(lon),
                y = Double(lat),
                origin = self.currLocation
            {
                let facLocation = CLLocation(latitude: y, longitude: x)
                let distanceBetween: CLLocationDistance = facLocation.distanceFromLocation(origin)

                object.DistFromCenter = distanceBetween/1609.344
            }  else  {
                object.DistFromCenter = 0
            }
        }
        
        return facilities.sort { $0.DistFromCenter < $1.DistFromCenter }
    }
  
 
 
  func do_table_refresh()
  {
    dispatch_async(dispatch_get_main_queue(), {
      self.tableView.reloadData()
      return
    })
  }
  
}

extension ServiceListViewController: UISearchResultsUpdating  {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filteredContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension ServiceListViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)  {

        filteredContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}



protocol KeyboardDelegate {
    func keyWasTapped(character: String)
}

class Keyboard: UIView {
    
    var delegate: KeyboardDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let view = NSBundle.mainBundle().loadNibNamed("Keyboard", owner: self, options: nil)[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    @IBAction func keyTapped(sender: UIButton) {
        self.delegate?.keyWasTapped(sender.titleLabel!.text!)
    }
    
}
