//
//  ExploreMapViewRepresentable.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 08/03/2023.
//

import SwiftUI
import MapKit

struct ExploreMapViewRepresentable : UIViewRepresentable {
    
    let mapView = MKMapView()
//    let locationManager = LocationManager.shared
    @Binding var mapState : MapViewState
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none

        return mapView
    }
    
    func addAnnotation(latitude: Double, longitude: Double) {
        let tastyAnnoation = MKPointAnnotation()
        tastyAnnoation.title = "MyLocation"
        tastyAnnoation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(tastyAnnoation)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = locationViewModel.selectedExploreLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
            break
        case .showMenu:
            break
        case .polylineAdded:
            break
        }
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
            parent.mapView.setRegion(region, animated: true)
        }

        
        //MARK: - Helpers
        
        func addAndSelectAnnotation(withCoordinate coordinate : CLLocationCoordinate2D) {
            //MARK: - Need to apply remove annotations logic when the map changed to .no input and new lcoation is selected
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            
            let customAnnotation = Annotation("Marker", coordinate: anno.coordinate) {
                   ZStack {
                       Image(systemName: "applelogo")
                           .font(.title)
                   }
               }
                        
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
            
            // Use the customAnnotation if needed
               _ = customAnnotation
            
        }
        
        func configurePolyline(withDestinationCoordinate coordinate : CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else {return}
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 32, bottom: 150, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        
        func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
    }
    
}
