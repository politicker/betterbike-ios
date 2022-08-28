//
//  ContentView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import SwiftUI

struct ContentView: View {
	@State var stations: [Station] = []
	@State var lastUpdated: String = ""
	
    var body: some View {
			Text(lastUpdated)
				.padding()
			
			List(stations) { station in
				Text(station.name)
				Text(station.bikeCount)
			}.onAppear {
				API().fetchStations { response in
						 self.lastUpdated = response.lastUpdated
						 self.stations = response.stations
					 }
				 }
		}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
