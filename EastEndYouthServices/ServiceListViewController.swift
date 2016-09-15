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
import PopupDialog


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
    
    /*
    let title = "THIS IS THE DIALOG TITLE"
    let message = "<h1>This is the message section of the popup dialog default view</h1>"
    let image = UIImage(named: "pexels-photo-103290")
    
    // Create the dialog
    let popup = PopupDialog(title: title, message: message, image: image)
    
    // Create buttons
    let buttonOne = CancelButton(title: "CANCEL") {
        print("You canceled the car dialog.")
    }
    
    let buttonTwo = DefaultButton(title: "ADMIRE CAR") {
        print("What a beauty!")
    }
    
    let buttonThree = DefaultButton(title: "BUY CAR") {
        print("Ah, maybe next time :)")
    }
    
    // Add buttons to dialog
    // Alternatively, you can use popup.addButton(buttonOne)
    // to add a single button
    popup.addButton(buttonOne)
    
    // Present dialog
    self.presentViewController(popup, animated: true, completion: nil)
    
    */
    
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
    var tapGestureRecognizer: UITapGestureRecognizer!
   
    if searchController.active && searchController.searchBar.text != "" {
        facility = filteredFacilities[indexPath.row]
    } else {
        facility = allItems[indexPath.row]
    }

    cell.distanceView?.text = String(format: "%.1f", facility.DistFromCenter!) + " mile(s)"
    cell.titleView?.text = facility.F_Name
    cell.addressView?.text = facility.Address

    let browserLaunchImage = cell.launchBrowserIcon
    
    tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ServiceListViewController.browserLaunchImageTapped(_:)))
    browserLaunchImage.userInteractionEnabled = true
    browserLaunchImage.addGestureRecognizer(tapGestureRecognizer)
    
    let emailLaunchImage = cell.launchEmailIcon
    tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ServiceListViewController.emailLaunchImageTapped(_:)))
    emailLaunchImage.userInteractionEnabled = true
    emailLaunchImage.addGestureRecognizer(tapGestureRecognizer)
    

    let phoneLaunchImage = cell.launchTelIcon
    tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ServiceListViewController.phoneLaunchImageTapped(_:)))
    phoneLaunchImage.userInteractionEnabled = true
    phoneLaunchImage.addGestureRecognizer(tapGestureRecognizer)
    
    let directionsLaunchImage = cell.launchDirectionsIcon
    tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ServiceListViewController.directionsLaunchImageTapped(_:)))
    directionsLaunchImage.userInteractionEnabled = true
    directionsLaunchImage.addGestureRecognizer(tapGestureRecognizer)
    
    return cell
  }

    
    func directionsLaunchImageTapped(sender: UITapGestureRecognizer)  {
        let touch = sender.locationInView(tableView)
        
        if let indexPath = tableView.indexPathForRowAtPoint(touch) {
            let facility = allItems[indexPath.row]
            if facility.Lat! != "" && facility.Lon! != ""{

                
                let url:NSURL = NSURL(string: "https://www.google.com/maps/dir/Current+Location/" + facility.Lat! + "," + facility.Lon!)!
                UIApplication.sharedApplication().openURL(url)
                
            } else {
                
                let alertController = UIAlertController(title: "Coordinates Not Supplied", message: "Click OK to continue", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }    }

    func phoneLaunchImageTapped(sender: UITapGestureRecognizer)  {
        
        var phone: String!
        
        let touch = sender.locationInView(tableView)
        if let indexPath = tableView.indexPathForRowAtPoint(touch) {
            let facility = allItems[indexPath.row]
            if facility.Telephone! != "" {

                phone = facility.Telephone!
                phone = phone.stringByReplacingOccurrencesOfString(" " , withString: "")
                phone = phone.stringByReplacingOccurrencesOfString("(" , withString: "")
                phone = phone.stringByReplacingOccurrencesOfString(")" , withString: "")
                phone = phone.stringByReplacingOccurrencesOfString("-" , withString: "")

                let url:NSURL = NSURL(string: "tel://" + phone)!
                UIApplication.sharedApplication().openURL(url)
                
            } else {
                
                let alertController = UIAlertController(title: "Phone Number Not Supplied", message: "Click OK to continue", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
    }

    
    func emailLaunchImageTapped(sender: UITapGestureRecognizer)  {
    
        var email: String!
       
        let touch = sender.locationInView(tableView)
        if let indexPath = tableView.indexPathForRowAtPoint(touch) {
            let facility = allItems[indexPath.row]
            if facility.Email! != "" {
                email = facility.WebLink!
                
                let url = NSURL(string: "mailto:\(email)")
                UIApplication.sharedApplication().openURL(url!)
                
            } else {

                let alertController = UIAlertController(title: "Email Address Not Supplied", message: "Click OK to continue", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }

                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }

    }
   
    func browserLaunchImageTapped(sender: UITapGestureRecognizer)  {

        var website: String!
        
        let touch = sender.locationInView(tableView)
        if let indexPath = tableView.indexPathForRowAtPoint(touch) {
            let facility = allItems[indexPath.row]
            if facility.WebLink! != "" {
                    website = facility.WebLink!
            } else {
                website = "http://www.southamptontownny.gov"
            }
        }
        
        if let url = NSURL(string: website) {
            UIApplication.sharedApplication().openURL(url)
        }
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



 
