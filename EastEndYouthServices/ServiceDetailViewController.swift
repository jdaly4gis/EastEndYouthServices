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

class ServiceDetailViewController: UIViewController,AGSMapViewLayerDelegate {
  
  let kBasemapLayerName = "Basemap Tiled Layer"
    
    
  @IBOutlet var mapView: AGSMapView!
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
 
    // Do any additional setup after loading the view.
    let mapUrl = NSURL(string: "http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer")
    let tiledLyr = AGSTiledMapServiceLayer(URL: mapUrl);
    
    self.mapView.addMapLayer(tiledLyr, withName: kBasemapLayerName)
    
    self.mapView.zoomToGeometry(AGSGeometryEngine.defaultGeometryEngine().projectGeometry(AGSPoint(x:self.lon!, y: self.lat!, spatialReference: AGSSpatialReference.wgs84SpatialReference()), toSpatialReference: AGSSpatialReference.webMercatorSpatialReference()), withPadding: 0, animated: true);


  }
  
    func mapViewDidLoad(mapView: AGSMapView!) {
        self.mapView.locationDisplay.startDataSource()
    }
    
    
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    nameField.text = facility.F_Name
    addressField.text = facility.Address
    telField.text = facility.Telephone
//    descriptionField.text = facility.Desc
    websiteField.text = facility.WebLink
    feeField.text = facility.Fee
  }
    
    @IBAction func basemapChanged(sender: UISegmentedControl) {
        
        var basemapURL:NSURL!
        
        switch sender.selectedSegmentIndex {
        case 0:  //streets
            basemapURL = NSURL(string: "http://services.arcgisonline.com/arcgis/rest/services/World_Street_Map/MapServer")
        case 1:  //nat geo
            basemapURL = NSURL(string: "http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer")
        case 2:  //topo
            basemapURL = NSURL(string: "http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer")
        default:  //sat
            basemapURL = NSURL(string: "http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer")
        }
        
        //remove the existing basemap layer
        self.mapView.removeMapLayerWithName(kBasemapLayerName)
        
        //add new Layer
        let newBasemapLayer = AGSTiledMapServiceLayer(URL: basemapURL)
        self.mapView.insertMapLayer(newBasemapLayer, withName: kBasemapLayerName, atIndex: 0);
    }
    

}


