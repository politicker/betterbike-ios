//
//  StationView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import SwiftUI


struct BikeListView: View {
	var bikes: [Bike]
	
	var body: some View {
		VStack(alignment: .leading) {
			ForEach(bikes) { bike in
				HStack {
					Image(systemName: bike.batteryIcon)
						.foregroundColor(bike.batteryColor())
					Text(bike.range)
				}
				Spacer()
			}
		}
	}
}

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
				
				if station.bikes.count > 5 {
					BikeListView(bikes: Array(station.bikes[...4]))
				} else {
					BikeListView(bikes: station.bikes)
				}
			}
			
			VStack {
				Text(station.bikeCount)
				Image(systemName: "bicycle")
					.foregroundColor(.blue)
			}
		}
	}
}

