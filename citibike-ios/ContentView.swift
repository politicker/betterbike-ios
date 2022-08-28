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
	
	@State var showSplash = true
	@State var splashOpacity: Double = 1
	
	@StateObject var locationManager = LocationManager()
	
	var body: some View {
		ZStack {
			VStack(alignment: .leading) {
				HStack {
					Spacer()
					Text("Updated \(lastUpdated)")
						.font(.subheadline)
					//				Spacer()
					//				if let location = locationManager.location {
					//					Text("Your location: \(location.latitude), \(location.longitude)")
					//				}
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
			SplashScreen()
				.opacity(splashOpacity)
		}
	}
	
	func fetchData() -> Void {
		API().fetchStations { response in
			self.lastUpdated = response.shortDate
			self.stations = response.stations
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				withAnimation(.easeIn(duration: 0.3)) {
						 self.splashOpacity = 0
				 }
			}
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
