//
//  ExploreMapViewRepresentable.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 08/03/2023.
//

import SwiftUI
import MapKit

struct ExploreMapViewRepresentable : UIViewRepresentable {
    
    let mapView: ExploreMapView
    
    func makeUIView(context: Context) -> some UIView {
        mapView.mapView.delegate = context.coordinator
        mapView.mapView.isRotateEnabled = false
        mapView.mapView.showsUserLocation = true
        mapView.mapView.userTrackingMode = .none

        return mapView.mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
}

extension ExploreMapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        //MARK: - Properties
        let parent : ExploreMapViewRepresentable
        var userLocationCoordinate : CLLocationCoordinate2D?
        var currentRegion : MKCoordinateRegion?
        
        //MARK: - LifeCycle
        init(parent: ExploreMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            if let userLocation = mapView.view(for: mapView.userLocation) {
                    userLocation.isHidden = true
               }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
                annotationView.markerTintColor = UIColor.blue
                return annotationView
        }

        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            
            let adjustedCenter = CLLocationCoordinate2D(
                latitude: userLocation.coordinate.latitude - 0.008, // Change this value to move the map up or down (When u decrease the map goes down if u increase the map goes up
                longitude: userLocation.coordinate.longitude
            )
            
            let region = MKCoordinateRegion(
                center: adjustedCenter,
                span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
            )
            
            self.currentRegion = region
            parent.mapView.mapView.setRegion(region, animated: true)
        }
        
    }
    
}
