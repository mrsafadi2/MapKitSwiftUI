//
//  SelectionPlaceView.swift
//  MapKitSwiftUI
//
//  Created by Mohammed Safadi Macbook Pro on 02/01/2023.
//

import SwiftUI
import UIKit
 
struct SelectionPlaceView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        ZStack{
            MapViewRepresentable()
                .environmentObject(locationManager)
                .ignoresSafeArea()
            
            if let place = locationManager.pickedplacemarker {
                VStack(spacing:16){
                    Text("Confirm Locaiton")
                        .font(.title2.bold())
                    
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
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .padding(.vertical , 10)
                    
                    Button {
                         
                    } label: {
                        Text("Confirm Locaiton")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical , 12)
                            .background{
                                RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.green)
                            }
                            .overlay(alignment: .trailing){
                                Image(systemName: "arrow.right")
                                    .font(.title3.bold())
                                    .padding(.trailing)
                            }
                            .foregroundColor(.white)
                        
                    }

                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 12, style: .continuous).fill(.white)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    } 
}

struct SelectionPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionPlaceView()
    }
}
