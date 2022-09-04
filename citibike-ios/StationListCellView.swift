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
						.foregroundColor(bike.batteryColor())
						.font(.callout)
					Text(bike.range)
						.font(.callout)
				}
			}
		}
	}
}

struct StationTitle: View {
	var station: Station

	var body: some View {
		Text(station.name)
			.font(.title3)
			.fontWeight(.bold)
	}
}

struct StationListCellView: View {
	var station: Station
	var stationRoute: StationRoute?

	var countSuffix: String {
		if Int(station.bikeCount) == 1 {
			return "Bike"
		}

		return "Bikes"
	}
	
	var body: some View {
		VStack(alignment: .leading) {
			StationTitle(station: station)

			HStack {
				Text("\(station.bikeCount) \(countSuffix)")
					.font(.body)
					.italic()
					.bold()
					.foregroundColor(Color.brandGreen)

				if let travelTime = stationRoute?.travelTimeInMinutes {
					Text("·")
					Text("\(travelTime) min walk")
						.font(.body)
						.italic()
				}
			}
			.padding(.bottom, 5)

			BikeListView(bikes: station.bikes)
		}
	}
}

