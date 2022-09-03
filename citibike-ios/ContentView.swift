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
	@State var splashOpacity: Double = 1
	
	@StateObject var viewModel = ViewModel()
	
	var body: some View {
		ZStack {
			if viewModel.locationFailed {
				ErrorLocationView()
			} else if viewModel.fetchError != "" {
				ErrorView(message: viewModel.fetchError, refetch: viewModel.fetchStations)
			} else {
				VStack(alignment: .leading) {
					HStack {
						Spacer()
						Text("Updated \(viewModel.lastUpdated)")
							.font(.subheadline)
							.foregroundColor(.gray)
					}.padding()
					List {
						ForEach($viewModel.stations) { station in
							StationView(station: station)
								.listRowSeparator(.hidden)
							Divider()
						}
					}
					.listStyle(.plain)
					.refreshable {
						await viewModel.fetchStations()
					}
				}.onAppear {
					viewModel.requestLocation()
				}
				
				SplashScreen()
					.opacity(viewModel.stations.isEmpty ? 1 : 0)
					.animation(.easeOut(duration: 0.3), value: viewModel.stations.isEmpty)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

