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
	@StateObject var viewModel = ViewModel.shared
	@Environment(\.scenePhase) var scenePhase
	
	init() {
		UITableView.appearance().separatorColor = .clear
	}
	
	var body: some View {
		ZStack {
			if viewModel.locationFailed {
				ErrorLocationView()
			} else if viewModel.fetchError != "" {
				ErrorView(message: viewModel.fetchError, refetch: viewModel.fetchStations)
			} else {
				NavigationView {
					VStack {
						List {
							ForEach($viewModel.stations) { station in
								let cellView = StationListCellView(
									station: station.wrappedValue,
									stationRoute: viewModel.stationRoutes[station.id]
								)
									.listRowSeparator(.hidden)

								if let userCoordinate = viewModel.location {
									NavigationLink(
										destination: StationMapView(
											station: station.wrappedValue,
											route: viewModel.stationRoutes[station.id],
											userCoordinate: userCoordinate
										)
									) {
										cellView
									}
								} else {
									cellView
								}

								Divider()
							}
							
							Text("Updated \(viewModel.lastUpdated)")
								.font(.subheadline)
								.foregroundColor(.gray)
								.frame(maxWidth: .infinity, alignment: .center)
						}
						.navigationBarHidden(true)
						.listStyle(.plain)
						.refreshable {
							viewModel.refresh()
						}
						.padding(.top)
					}
					.onAppear {
						viewModel.requestLocationPermission()
						viewModel.requestLocation()
					}.onChange(of: scenePhase) { newPhase in
						viewModel.reset()
					}
				}
				.buttonStyle(.plain)
				
				
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

