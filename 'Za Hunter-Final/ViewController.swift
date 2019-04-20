//
//  ViewController.swift
//  'Za Hunter-Final
//
//  Created by Dylan Keenan on 4/20/19.
//  Copyright © 2019 Dylan Keenan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapVIew: MKMapView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        mapVIew.showsUserLocation = true
        
    }


}

