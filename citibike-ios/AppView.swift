//
//  AppView.swift
//  default
//
//  Created by Harrison Borges on 9/17/22.
//

import SwiftUI


struct AppView: View {
	@ObservedObject var viewModel: ViewModel
	@Environment(\.scenePhase) var scenePhase

	var body: some View {
		ZStack {
			Color.background
				.ignoresSafeArea(.all)
			if viewModel.locationFailed {
				ErrorLocationView()
			} else if viewModel.fetchError != "" {
				ErrorView(message: viewModel.fetchError) {
					if let coordinate = viewModel.location {
						viewModel.refresh(coordinate: coordinate)
					}
				}
			} else {
				NavigationView {
					VStack(spacing: 0) {
						List {
							ForEach($viewModel.stations) { station in
								let cellView = StationCellView(
									station: station.wrappedValue,
									stationRoute: viewModel.stationRoutes[station.id]
								)
								if let userCoordinate = viewModel.location {
									NavigationLink(
										destination: StationMapView(
											station: station.wrappedValue,
											route: viewModel.stationRoutes[station.id],
											userCoordinate: userCoordinate
										)
									)	{
										cellView
									}
								} else {
									cellView
								}
							}

							UpdatedAtView(lastUpdated: viewModel.lastUpdated)
								.listRowSeparator(.hidden)
						}
						.navigationBarHidden(true)
						.listStyle(.plain)
						.refreshable {
							if let coordinate = viewModel.location {
								viewModel.refresh(coordinate: coordinate)
							}
						}
						.padding(.top)
					}
					.onAppear {
						viewModel.requestLocation()
					}
					.onChange(of: scenePhase) { newPhase in
						if newPhase == .active {
							if let location = viewModel.location {
								viewModel.refresh(coordinate: location)
							}
						}
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
