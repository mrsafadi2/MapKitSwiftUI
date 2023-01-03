//
//  MapView.swift
//  MapKitSwiftUI
//
//  Created by Mohammed Safadi Macbook Pro on 02/01/2023.
//

import SwiftUI
import MapKit

struct RouteMapView: View {

    var body: some View {
        VStack {
            RouteRepresentable().ignoresSafeArea()
        }
 
     }
}

struct RouteMapView_Previews: PreviewProvider {
    static var previews: some View {
        RouteMapView()
    }
}
