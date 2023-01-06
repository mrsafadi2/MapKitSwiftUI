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

final class LocationManager: NSObject, ObservableObject , MKMapViewDelegate {
    private let locationManager = CLLocationManager()

    @Published var region = MKCoordinateRegion(center: .init(latitude: 24.6453905, longitude: 46.697795), latitudinalMeters: 500, longitudinalMeters: 500)

    @Published var searchTrxt = ""
    @Published var mapView: MKMapView = .init()
    @Published var currentlocation:CLLocation?
    @Published var location: CLLocationCoordinate2D?
    @Published var places:[CLPlacemark] = []
    @Published var pickedlocation:CLLocation?
    @Published var pickedplacemarker:CLPlacemark?
    
    var cancellable:AnyCancellable?

    override init() {
        super.init()
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        requestLocation()
        mapView.setRegion(region, animated: true)

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

    
}


extension LocationManager : CLLocationManagerDelegate {
    
    // MARK: Used to get last location for accure and update his region
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentlocation = location
            self.location = location.coordinate
            self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
         }
    }
    
    
    // MARK: Handel Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
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

    
    // MARK: To add pin marker to map
    func addPintoMap(coordinate:CLLocationCoordinate2D){
        let pinMarker = MKPointAnnotation()
        pinMarker.coordinate = coordinate
        pinMarker.title = "Selected Location"
        
        mapView.addAnnotation(pinMarker)
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
