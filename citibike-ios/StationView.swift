//
//  StationView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import SwiftUI
import MapKit


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
	var station: Station
	@State var travelTime: TimeInterval = 0
	@State var isLoading: Bool = true
	
	var destinationLat: Float
	var destinationLon: Float
	
	var travelTimeInMinutes: String {
		let minutes = (travelTime / 60)
		
		return String(format: "%.0f min", minutes)
	}

	var body: some View {
		if isLoading {
			Text("")
				.onAppear {
					if !station.hasCalculatedTravelDuration {
						getDirections()
					}
				}
		} else {
			Text(self.travelTimeInMinutes)
		}
	}

	func getDirections() {
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.720035, longitude: -73.9538756), addressDictionary: nil))
		request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(destinationLat), longitude: CLLocationDegrees(destinationLon)), addressDictionary: nil))
		request.transportType = .walking
		
		let directions = MKDirections(request: request)
		
		directions.calculate { response, error in
			guard let unwrappedResponse = response else {
				print(error ?? "error calculating directions")
				return
			}

			for route in unwrappedResponse.routes {
				self.travelTime = route.expectedTravelTime
				self.isLoading = false
				
				station.hasCalculatedTravelDuration = true
				station.travelDuration = travelTime

				print(route.expectedTravelTime)
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
					Text("·")
					WalkingDurationView(station: station, destinationLat: station.lat, destinationLon: station.lon)
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

