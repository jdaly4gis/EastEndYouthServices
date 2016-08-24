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


class ServiceDetailViewController: UIViewController,AGSMapViewLayerDelegate, AGSCalloutDelegate {
  
  let kBasemapLayerName = "Basemap Tiled Layer"
  var graphicsOverlay:AGSGraphicsLayer!
  var facilityPoint: AGSPoint!
  var currentStopGraphic:AGSStopGraphic!

    
    
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
    self.graphicsOverlay = AGSGraphicsLayer()
    self.mapView.addMapLayer(graphicsOverlay, withName:"Graphics Layer")
    
    facilityPoint = AGSGeometryEngine.defaultGeometryEngine().projectGeometry(AGSPoint(x:self.lon!, y: self.lat!, spatialReference: AGSSpatialReference.wgs84SpatialReference()), toSpatialReference: AGSSpatialReference.webMercatorSpatialReference()) as! AGSPoint

        print (facilityPoint.x, facilityPoint.y)
    self.mapView.zoomToGeometry(facilityPoint, withPadding: 0, animated: true);
    self.createSampleGraphics(facilityPoint.x, lon: facilityPoint.y)
    self.mapView.callout.delegate = self
//    self.addStop(facilityPoint)
//    self.addStop(AGSPoint(x:self.lon!, y: self.lat!, spatialReference: AGSSpatialReference.wgs84SpatialReference())
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
    
    
    func addStop(geometry:AGSPoint) -> AGSGraphic {
        
        //grab the geometry, then clear the sketch
        //Prepare symbol and attributes for the Stop/Barrier

        let symbol = self.stopSymbolWithNumber(1)

        let facSymbol = AGSGraphic(geometry: geometry, symbol:symbol, attributes:nil)
        
        //You can set additional properties on the stop here
        //refer to the conceptual helf for Routing task
        self.graphicsOverlay.addGraphic(facSymbol)
        return facSymbol
    }
    
    func stopSymbolWithNumber(stopNumber:UInt) -> AGSCompositeSymbol {
        let cs = AGSCompositeSymbol()
        
        // create outline
        let sls = AGSSimpleLineSymbol()
        sls.color = UIColor.blackColor()
        sls.width = 2
        sls.style = .Solid
        
        // create main circle
        let sms = AGSSimpleMarkerSymbol()
        sms.color = UIColor.greenColor()
        sms.outline = sls
        sms.size = CGSizeMake(20, 20)
        sms.style = .Circle
        cs.addSymbol(sms)
        
        //    // add number as a text symbol
        let ts = AGSTextSymbol(text: "\(stopNumber)", color: UIColor.blackColor())
        ts.vAlignment = .Middle
        ts.hAlignment = .Center
        ts.fontSize	= 16
        cs.addSymbol(ts)
        
        return cs
    }
    
    func createSampleGraphics(lat: Double, lon: Double) {

        
        let facilitySymbol = AGSSimpleMarkerSymbol()
        facilitySymbol.color = UIColor.yellowColor()
        facilitySymbol.size = CGSize(width:30, height:30)
        facilitySymbol.style = .Cross
        facilitySymbol.outline.color = UIColor.orangeColor()
        facilitySymbol.outline.width = 2
        
 
        let facilityPoint = AGSPoint(x: lat, y:lon, spatialReference: self.mapView.spatialReference)
 
        let facGraphic = AGSGraphic(geometry: facilityPoint, symbol: facilitySymbol, attributes: nil)

        self.graphicsOverlay.addGraphic(facGraphic)

    }
    
    func callout(callout: AGSCallout!, willShowForFeature feature: AGSFeature!, layer: AGSLayer!, mapPoint: AGSPoint!) -> Bool {

        let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        //clear the custom view.
        self.mapView.callout.customView = nil
       
        self.mapView.callout.frame = frame

        self.mapView.callout.autoAdjustWidth = true
        self.mapView.callout.width = 450

        self.mapView.callout.titleColor = UIColor.blueColor()
        self.mapView.callout.borderWidth = 2
        self.mapView.callout.borderColor = UIColor.cyanColor()
        self.mapView.callout.title = facility.F_Name
        self.mapView.callout.detail = facility.Address
        
        //hide the accessory view and also the left image view.
        self.mapView.callout.accessoryButtonHidden = true
        self.mapView.callout.image = nil
        
        return true
    }
    

    func callout(callout: AGSCallout!, willShowForLocationDisplay locationDisplay: AGSLocationDisplay!) -> Bool {
        var foo = "bar"
    return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


