//
//  ContentView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

struct ContentView: View {
	@State var stations: [Station] = []
	@State var lastUpdated: String = ""
	
	@State var latitude: CLLocationDegrees = 0
	@State var longitude: CLLocationDegrees = 0
	
	@StateObject var locationManager = LocationManager()
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(lastUpdated)
				Spacer()
				if let location = locationManager.location {
					Text("Your location: \(location.latitude), \(location.longitude)")
				}
			}.padding()
			List {
				ForEach($stations) { station in
					StationView(station: station)
				}.listStyle(InsetGroupedListStyle())
			}.refreshable {
				fetchData()
			}
		}.onAppear {
			locationManager.requestAuthorisation(always: false)
			fetchData()
		} //.ignoresSafeArea(.all, edges: .top)
	}

	func fetchData() -> Void {
		API().fetchStations { response in
			self.lastUpdated = response.shortDate
			self.stations = response.stations
		}
	}
	
	func getCurrentLocation() -> Void {
		locationManager.requestLocation()
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
