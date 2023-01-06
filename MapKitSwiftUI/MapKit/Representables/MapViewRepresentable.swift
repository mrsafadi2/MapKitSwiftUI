//
//  MapViewRepresentable.swift
//  MapKitSwiftUI
//
//  Created by Mohammed Safadi Macbook Pro on 02/01/2023.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
 
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }

     func makeUIView(context: Context) -> MKMapView {
         let mapView = locationManager.mapView
         mapView.showsScale = true
         mapView.showsUserLocation = true
         return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.delegate = context.coordinator
     }

}


