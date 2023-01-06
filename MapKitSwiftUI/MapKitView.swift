//
//  MapKitView.swift
//  MapKitSwiftUI
//
//  Created by Mohammed Safadi Macbook Pro on 02/01/2023.
//

import SwiftUI
import CoreLocationUI
import MapKit

struct MapKitView: View {
    @StateObject var locationManager: LocationManager = .init()
    @State var region = MKCoordinateRegion()
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                MapViewRepresentable()
                    .environmentObject(locationManager)
                    .onReceive(locationManager.$region) { region in
                        self.region = region
                        locationManager.mapView.setRegion(region, animated: true)

                        locationManager.addPintoMap(coordinate: .init(latitude: region.center.latitude , longitude: region.center.longitude))
                    }
 
                VStack {
                    NavigationLink {
                        SearchView()
                    } label: {
                        Text("Search Location")
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(Capsule())

                    }
                    
                    NavigationLink {
                        RouteMapView().environmentObject(locationManager)
                    } label: {
                        Text("Route Map ")
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(Capsule())

                    }

                }
                .padding()
            }
            .navigationTitle("Map Kit SwiftUI")
        }
      }}

struct MapKitView_Previews: PreviewProvider {
    static var previews: some View {
        MapKitView()
    }
}
