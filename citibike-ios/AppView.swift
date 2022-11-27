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
			if viewModel.locationState == .failed {
				ErrorLocationView()
			} else if viewModel.fetchError != "" {
				ErrorView(message: viewModel.fetchError) {
					if let coordinate = viewModel.location {
						viewModel.refresh(coordinate: coordinate)
					}
				}
			} else {
				ListView(viewModel: viewModel)
					.onChange(of: scenePhase) { newPhase in
						if newPhase == .active {
							if let location = viewModel.location {
								viewModel.refresh(coordinate: location)
							}
						}
					}
			}
		}
	}
}

struct ListView: View {
	@ObservedObject var viewModel: ViewModel

	var body: some View {
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
				.listStyle(.plain)
				.buttonStyle(.plain)
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
		}
	}
}
