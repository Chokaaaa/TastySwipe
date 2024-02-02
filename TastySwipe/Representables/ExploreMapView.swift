//
//  ExploreMapView.swift
//  TastySwipe
//
//  Created by Gwinyai Nyatsoka on 2/2/2024.
//

import SwiftUI
import MapKit

class ExploreMapView: UIView {

    let mapView = MKMapView()
    
    func addAnnotation(latitude: Double, longitude: Double) {
        let tastyAnnoation = MKPointAnnotation()
        tastyAnnoation.title = "MyLocation"
        tastyAnnoation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(tastyAnnoation)
    }

}
