//
//  MapViewRepresentable.swift
//  MapKitSwiftUI
//
//  Created by Mohammed Safadi Macbook Pro on 02/01/2023.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    @EnvironmentObject var locationManager:LocationManager
    typealias UIViewType = MKMapView

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    //let lineCoordinates: [CLLocation]
    func makeUIView(context: Context) -> MKMapView {
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 1000)
        let mapView = locationManager.mapView
            mapView.showsScale = true
            mapView.showsUserLocation = true
            mapView.setCameraZoomRange(zoomRange, animated: true)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {}

}


class MapViewCoordinator: NSObject, MKMapViewDelegate {
    
}
