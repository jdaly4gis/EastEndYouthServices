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
import MapKit
import WebKit
import GoogleMaps

class ServiceDetailViewController: UIViewController, GMSMapViewDelegate {
  
  let kBasemapLayerName = "Basemap Tiled Layer"
//  var graphicsOverlay:AGSGraphicsLayer!
//  var facilityPoint: AGSPoint!
//  var currentStopGraphic:AGSStopGraphic!
    
    var london: GMSMarker?
    var londonView: UIImageView?
  @IBOutlet var mapView: GMSMapView!
  @IBOutlet var nameField: UILabel!
  @IBOutlet var addressField: UILabel!
  @IBOutlet var telField: UILabel!
  @IBOutlet var descriptionField: UILabel!
  @IBOutlet var websiteField: UILabel!
  @IBOutlet var feeField: UILabel!


        
    
  	
   let regionRadius: CLLocationDistance = 1000
   var lat: Double?
   var lon: Double?
  
  var facility: Facility! {
    didSet {
      navigationItem.title = facility.F_Name
      self.lat = Double(facility.Lat!)
      self.lon = Double(facility.Lon!)

    }
  }
  
    /*
  override func loadView() {


      let info = facility.Address! + "\n" + "Fee: " + facility.Fee! + "\n" + facility.Telephone! + "\n\n"  + facility.Desc!
      let camera = GMSCameraPosition.cameraWithLatitude(self.lat!, longitude: self.lon!, zoom: 14.0)
      let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
      mapView.myLocationEnabled = true
      mapView.mapType = kGMSTypeNormal
      mapView.myLocationEnabled = true
      view = mapView
    
    let items = ["Normal", "Terrain", "Satellite", "Hybrid"]
    let segmentedControl = UISegmentedControl(items: items)
    
    segmentedControl.frame = CGRectMake(0, 70, view.bounds.width, 40)
    segmentedControl.layer.cornerRadius = 5.0
    segmentedControl.addTarget(self, action: #selector(ServiceDetailViewController.mapType(_:)), forControlEvents: UIControlEvents.ValueChanged)
    view.addSubview(segmentedControl)


      // Creates a marker in the center of the map.
      let marker = GMSMarker()

      marker.position = CLLocationCoordinate2D(latitude: self.lat!, longitude: self.lon!)
      marker.title = facility.F_Name!
      marker.snippet = info
      marker.map = mapView
  }
*/

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let info = facility.Address! + "\n" + "Fee: " + facility.Fee! + "\n" + facility.Telephone! + "\n\n"  + facility.Desc!

        mapView = GMSMapView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        
        mapView.camera = GMSCameraPosition.cameraWithLatitude(self.lat!, longitude: self.lon!, zoom: 15.0)
        
        mapView.mapType = kGMSTypeNormal
        mapView.myLocationEnabled = true
        mapView.delegate = self
        
        view.addSubview(mapView)
        
        //Add a segmented control for selecting the map type.
        let items = ["Normal", "Terrain", "Satellite", "Hybrid"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0

        segmentedControl.frame = CGRectMake(0, 65, view.bounds.width, 50)
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.addTarget(self, action: #selector(ServiceDetailViewController.mapType(_:)), forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl.addTarget(self, action: #selector(ServiceDetailViewController.segColor(_:)), forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(segmentedControl)
        
 
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2D(latitude: self.lat!, longitude: self.lon!)
        marker.title = facility.F_Name!
        marker.snippet = info
        marker.map = mapView
        
    }

    
    func mapType(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = kGMSTypeNormal
        case 1:
            mapView.mapType = kGMSTypeTerrain
        case 2:
            mapView.mapType = kGMSTypeSatellite
        default:
            mapView.mapType = kGMSTypeHybrid
        }
    }
    
    func segColor(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sender.tintColor = UIColor.blueColor()
            sender.backgroundColor   = UIColor.clearColor()
        case 1:
            sender.tintColor = UIColor.blueColor()
            sender.backgroundColor   = UIColor.clearColor()
        case 2:
            sender.tintColor = UIColor.yellowColor()
            sender.backgroundColor = UIColor.orangeColor()
        default:
            sender.tintColor = UIColor.yellowColor()
            sender.backgroundColor = UIColor.orangeColor()        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeMapType(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Map Types", message: "Select map type:", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
           // self.mapView.mapType = kGMSTypeNormal
        }
        
        let terrainMapTypeAction = UIAlertAction(title: "Terrain", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            //self.mapView.mapType = kGMSTypeTerrain
        }
        
        let hybridMapTypeAction = UIAlertAction(title: "Hybrid", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            //self.mapView.mapType = kGMSTypeHybrid
        }
        
        let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(normalMapTypeAction)
        actionSheet.addAction(terrainMapTypeAction)
        actionSheet.addAction(hybridMapTypeAction)
        actionSheet.addAction(cancelAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
}




