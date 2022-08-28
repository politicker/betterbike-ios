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
		VStack(alignment: .leading) {
			HStack {
				Spacer()
				Text(lastUpdated)
			}.padding()
			List {
				ForEach($stations) { station in
					StationView(station: station)
				}.listStyle(InsetGroupedListStyle())
			}.refreshable {
				fetchData()
			}
		}.onAppear {
			fetchData()
		}
	}
	
	func fetchData() -> Void {
		API().fetchStations { response in
			self.lastUpdated = response.shortDate
				self.stations = response.stations
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
