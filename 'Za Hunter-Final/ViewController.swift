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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapVIew: MKMapView!
    
    let locationManager = CLLocationManager()
    var region = MKCoordinateRegion()
    var mapItems = [MKMapItem]()
    var selectedMapItem = MKMapItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        mapVIew.showsUserLocation = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        mapVIew.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        region = MKCoordinateRegion(center: center, span: span)
        mapVIew.setRegion(region, animated: true)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "pizza"
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
                for mapItem in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = mapItem.placemark.coordinate
                    annotation.title = mapItem.name
                    self.mapVIew.addAnnotation(annotation)
                    self.mapItems.append(mapItem)
                }
            }
        }
    }
    
    func mapVIew(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinView")
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapVIew(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for mapItem in mapItems {
            if mapItem.placemark.coordinate.latitude == view.annotation?.coordinate.latitude &&
                mapItem.placemark.coordinate.longitude == view.annotation?.coordinate.longitude {
                selectedMapItem = mapItem
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "ShowLocationDetailsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocationDetailsViewController {
            destination.selectedMapItem = selectedMapItem
        }
    }
}
