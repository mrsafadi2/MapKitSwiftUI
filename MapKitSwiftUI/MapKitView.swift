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
    @StateObject var locationManager = LocationManager()
    @State var region = MKCoordinateRegion()
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                MapViewRepresentable()
                    .environmentObject(locationManager)
                    .onReceive(locationManager.$region) { region in
                        self.region = region
                    }

                Map(coordinateRegion: $region, showsUserLocation: true)
//                    .edgesIgnoringSafeArea(.all)
//                    .onReceive(locationManager.$region) { region in
//                        self.region = region
//                    }
                
                VStack {
                    if let location = locationManager.location {
                        Text("Current location: \(location.latitude), \(location.longitude)")
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding()
                            .background(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Spacer()
                    LocationButton {
                        locationManager.requestLocation()
                    }
                    .frame(width: 180, height: 40)
                    .cornerRadius(30)
                    .symbolVariant(.fill)
                    .foregroundColor(.white)
                    
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
