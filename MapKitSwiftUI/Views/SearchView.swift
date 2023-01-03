//
//  SearchView.swift
//  MapKitSwiftUI
//
//  Created by Mohammed Safadi Macbook Pro on 02/01/2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject var locationManager: LocationManager = .init()
    @State var navigationTag:String?
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Find Location", text: $locationManager.searchTrxt)
            }
            .padding(.vertical , 12 )
            .padding(.horizontal)
            .background{
                RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(.gray)
            }
            .padding(.vertical , 10)
            if let places = locationManager.places , !places.isEmpty {
                List{
                    ForEach(places , id: \.self){ place in
                        Button{
                            if let currentlocation = place.location?.coordinate {
                                locationManager.mapView.region = .init(center: currentlocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                locationManager.addPintoMap(coordinate: currentlocation)
                                locationManager.updatePickedPlacemarker(location: .init(latitude: currentlocation.latitude, longitude: currentlocation.longitude))
                                navigationTag = "MapView"

                            }
                            

                        }label: {
                            HStack(spacing:15){
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.green)
                                
                                VStack(spacing: 6){
                                    Text(place.name ?? "").font(.title3.bold())
                                    
                                    Text(place.locality ?? "")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                            }
                        }
                     }
                }.listStyle(.plain)
            }else{
                Button {
                    if let currentlocation = locationManager.location {
                        locationManager.mapView.region = .init(center: currentlocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        locationManager.addPintoMap(coordinate: currentlocation)
                        locationManager.updatePickedPlacemarker(location: .init(latitude: currentlocation.latitude, longitude: currentlocation.longitude))
                        navigationTag = "MapView"

                    }
                } label: {
                    Label(title: {
                        Text("Use Current Location")
                    }, icon: {
                        Image(systemName: "location.north.circle.fill")
                    }).padding().background(Color.green).clipShape(Capsule())
                }

            }
            Spacer()
        }.frame(maxWidth:.infinity , alignment: .top).padding()
            .background{
                NavigationLink(tag: "MapView", selection: $navigationTag) {
                    SelectionPlaceView()
                        .environmentObject(locationManager)
                    
                } label: {
                    EmptyView().hidden()
                }

            }
            .navigationTitle("Search Locaiton")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
