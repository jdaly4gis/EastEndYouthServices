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
import ArcGIS
import GoogleMaps

class ServiceDetailViewController: UIViewController, GMSMapViewDelegate {
  
  let kBasemapLayerName = "Basemap Tiled Layer"
  var graphicsOverlay:AGSGraphicsLayer!
  var facilityPoint: AGSPoint!
  var currentStopGraphic:AGSStopGraphic!
    
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
  
 
  override func loadView() {

 
      let info = facility.Address! + "\n" + "Fee: " + facility.Fee! + "\n" + facility.Telephone!
      let camera = GMSCameraPosition.cameraWithLatitude(self.lat!, longitude: self.lon!, zoom: 14.0)
      let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
      mapView.myLocationEnabled = true
      mapView.mapType = kGMSTypeNormal
      mapView.myLocationEnabled = true
      view = mapView
        
      // Creates a marker in the center of the map.
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: self.lat!, longitude: self.lon!)
      marker.title = facility.F_Name!
      marker.snippet = info
      marker.map = mapView
 
    
  }
    
    @IBAction func changeMapType(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Map Types", message: "Select map type:", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.mapView.mapType = kGMSTypeNormal
        }
        
        let terrainMapTypeAction = UIAlertAction(title: "Terrain", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.mapView.mapType = kGMSTypeTerrain
        }
        
        let hybridMapTypeAction = UIAlertAction(title: "Hybrid", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.mapView.mapType = kGMSTypeHybrid
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




