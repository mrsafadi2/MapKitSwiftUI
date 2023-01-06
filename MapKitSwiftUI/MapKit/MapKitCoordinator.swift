//
//  MapKitCoordinator.swift
//  MapKitSwiftUI
//
//  Created by Mohammed Safadi Macbook Pro on 06/01/2023.
//

import Foundation
import MapKit
import UIKit

final class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var mapView:MapViewRepresentable
    
    init( _ mapView: MapViewRepresentable ) {
        self.mapView = mapView
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let anotationView = views.first {
            if let anotaion = anotationView.annotation {
                if anotaion is MKPointAnnotation {
                    let  rejoin = MKCoordinateRegion(center: anotaion.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                    mapView.setRegion(rejoin, animated: true)
                }
            }
        }
    }

    
    // MARK: To Set pin marker draggable and custom image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKPointAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
            annotationView.canShowCallout = true
            annotationView.isDraggable = true
            annotationView.image = UIImage(named: "locationPin")
            return annotationView
        }else{
            let identifier = "AnnotationView"
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            annotationView?.annotation = annotation
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            return annotationView

        }
     }
    
    // MARK: To update pin marker cordinates when change
   func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
       guard let newLocation = view.annotation?.coordinate else{ return}
       self.mapView.locationManager.pickedlocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
       self.mapView.locationManager.updatePickedPlacemarker(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
   }


    
}
