//
//  StationView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import SwiftUI

struct StationView: View {
    @Binding var station: Station
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(station.name)
                        .fontWeight(.bold)
                    Spacer()
                }
                Spacer()
                VStack(alignment: .leading) {
                    ForEach(station.bikes) { bike in
                        HStack {
                            Image(systemName: bike.batteryIcon)
                                .tint(.green)
                                .foregroundColor(bike.batteryColor())
                            Text(bike.range)
                        }
                        Spacer()
                    }
                }
            }.padding()
            
            VStack {
                Text(station.bikeCount)
                Image(systemName: "bicycle")
                    .foregroundColor(.blue)
            }
        }
    }
}
