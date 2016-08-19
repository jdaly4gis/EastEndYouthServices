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
  
  @IBOutlet var mapView: AGSMapView!
  @IBOutlet var nameField: UILabel!
  @IBOutlet var addressField: UILabel!
  @IBOutlet var telField: UILabel!
  @IBOutlet var descriptionField: UILabel!
  @IBOutlet var websiteField: UILabel!
  @IBOutlet var feeField: UILabel!
  
   let regionRadius: CLLocationDistance = 1000
  
  var facility: Facility! {
    didSet {
      navigationItem.title = facility.F_Name
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Add a basemap tiled layer
    let url = NSURL(string: "http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer")
    let tiledLayer = AGSTiledMapServiceLayer(URL: url)
    self.mapView.addMapLayer(tiledLayer, withName: "Basemap Tiled Layer")

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

}


