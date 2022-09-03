//
//  StationView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import SwiftUI
import MapKit


struct StationView: View {
	@Binding var station: Station
	var viewModel: ViewModel
	
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				HStack {
					Text(station.name)
						.fontWeight(.bold)
					Text("·")
					WalkingDurationView(station: station, viewModel: viewModel)
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

struct WalkingDurationView: View {
	@State var isLoading: Bool = true
	var station: Station
	
	var viewModel: ViewModel
	
	var travelTimeInMinutes: String {
		let minutes = (station.travelDuration / 60)
		
		return String(format: "%.0f min", minutes)
	}
	
	var body: some View {
		if isLoading {
			Text("") // TODO: Make me an emptyview
				.task {
					if !station.hasCalculatedTravelDuration {
						await getDirections()
					}
				}
		} else {
			Text(self.travelTimeInMinutes)
		}
	}
	
	func getDirections() async {
		let travelTime = await viewModel.calculateExpectedTravelTime(to: station)
		
		guard let travelTime = travelTime else {
			return
		}
		
		DispatchQueue.main.async {
			station.hasCalculatedTravelDuration = true
			station.travelDuration = travelTime
		}
		
		self.isLoading = false
	}
}

