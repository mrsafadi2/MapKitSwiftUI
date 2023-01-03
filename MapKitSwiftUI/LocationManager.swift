//
//  LocationManager.swift
//  MapKitSwiftUI
//
//  Created by Mohammed Safadi Macbook Pro on 02/01/2023.
//

import Foundation
import CoreLocation
import MapKit
import Combine

final class LocationManager: NSObject, ObservableObject , MKMapViewDelegate,CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion(//center: CLLocationCoordinate2D(latitude: 42.0422448, longitude: -102.0079053),//span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    @Published var searchTrxt = ""
    @Published var mapView: MKMapView = .init()
    @Published var currentlocation:CLLocation?
    @Published var location: CLLocationCoordinate2D?
    @Published var places:[CLPlacemark] = []
    @Published var pickedlocation:CLLocation?
    @Published var pickedplacemarker:CLPlacemark?

    let loc1 = CLLocationCoordinate2D.init(latitude: 40.741895, longitude: -73.989308)
    let loc2 = CLLocationCoordinate2D.init(latitude: 40.728448, longitude: -73.717996)
    
    var cancellable:AnyCancellable?

    override init() {
        super.init()
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        requestLocation()
        
        cancellable = $searchTrxt
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != "" {
                    self.fetchPlaces(value: value)
                } else{
                    self.places  = []
                }
            })
    }

    // MARK: Used for get current user location
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    // MARK: Used for start monitor and updating location
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }

    
    // MARK: Used to get last location for accure and update his region
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentlocation = location
            self.location = location.coordinate
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
    }
    
    // MARK: Fetch Placemarkers serch
    func fetchPlaces(value:String) {
        Task{
            do{
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                await MainActor.run(body: {
                    self.places = response.mapItems.compactMap({ item -> CLPlacemark in
                        return item.placemark
                    })
                })
            }
            catch{
                
            }
        }
    }
    
    // MARK: Handel Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
    }
    
    // MARK: To add pin marker to map
    func addPintoMap(coordinate:CLLocationCoordinate2D){
        let pinMarker = MKPointAnnotation()
        pinMarker.coordinate = coordinate
        pinMarker.title = "My Current Location"
        
        mapView.addAnnotation(pinMarker)
    }
    
    // MARK: To Set pin marker draggable
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Deliver Pin")
        marker.isDraggable = true
        marker.canShowCallout = false
        
        return marker
    }
    
    // MARK: To update pin marker cordinates when change
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else{ return}
        self.pickedlocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePickedPlacemarker(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
    }
    
    func updatePickedPlacemarker(location: CLLocation){
        Task{
            do{
                guard let place =  try await geoCodeCoordinates(location: location) else {return}
                await MainActor.run(body: {
                    self.pickedplacemarker = place
                })
            }
            catch{
                
            }
        }
    }
    
    func geoCodeCoordinates(location:CLLocation) async throws->CLPlacemark? {
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        print("Place items -----: ")
        print(place?.country ?? "")
        print(place?.administrativeArea ?? "")
        print(place?.locality ?? "")

        return place
    }
    
 
    

}
