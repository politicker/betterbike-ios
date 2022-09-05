//
//  StationView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import SwiftUI


struct BikeListView: View {
	var bikes: [Bike]
	var displayableBikes: [Bike] {
		if bikes.count > 5 {
			return Array(bikes[...4])
		}
		
		return bikes
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			ForEach(displayableBikes) { bike in
				HStack {
					Image(systemName: bike.batteryIcon)
						.foregroundColor(batteryColor(bike: bike))
						.font(.callout)
					Text(bike.range)
						.font(.callout)
				}
			}
		}
	}
	
	func batteryColor(bike: Bike) -> Color {
		switch bike.batteryIcon {
		case "battery.25":
			return Color.bikeBatteryLow
		case "battery.100":
			return Color.primaryGreen
		default:
			return Color("Foreground")
		}
	}
}

struct BikeCount: View {
	var count: String
	var body: some View {
		Text(count)
			.padding(10)
			.foregroundColor(Color.background)
			.background(
				Circle()
					.fill(Color.foreground)
			)
	}
}

struct StationCellView: View {
	var station: Station
	var stationRoute: StationRoute?
	
	var body: some View {
		HStack(alignment: .top) {
			BikeCount(count: station.bikeCount)
				.padding(.trailing, 6)
			
			VStack(alignment: .leading) {
				HStack {
					VStack(alignment: .leading) {
						Text(station.name)
							.font(.title3)
							.fontWeight(.bold)
						
						if let travelTime = stationRoute?.travelTimeInMinutes {
							Text("\(travelTime) min walk")
								.font(.body)
								.italic()
								.foregroundColor(Color.secondaryText)
						}
					}
				}
				
				BikeListView(bikes: station.bikes)
			}
		}
	}
}


struct StationCellView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Spacer()
				.frame(maxHeight: .infinity)
			
			StationCellView(
				station: Station(
					id: "test",
					name: "test",
					bikeCount: "1",
					bikes: [
						Bike(
							id: "test",
							range: "25 miles",
							batteryIcon: "battery.100"
						)
					],
					lat: 20.1,
					lon: 20.1
				)
			)
			
			Spacer()
				.frame(maxHeight: .infinity)
		}
	}
}
