//
//  StationDetailView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/29/22.
//
import SwiftUI
import MapKit

struct BackButton: View {
	@Environment(\.presentationMode) var mode: Binding<PresentationMode>

	var body: some View {
		Button("Back") {
			self.mode.wrappedValue.dismiss()
		}
		.foregroundColor(Color.background)
		.padding()
		.background(Color.foreground)
		.clipShape(Capsule())
	}
}

struct StationMapView: View {
	var station: Station
	var route: StationRoute?
	var userCoordinate: CLLocationCoordinate2D

	var location: Location {
		return Location(name: station.name, coordinate: station.coordinate)
	}

	var polyLine: MKPolyline? {
		return route?.directions.routes.first?.polyline
	}

	var mapCenter: CLLocationCoordinate2D {
		return geographicMidpoint(between: [location.coordinate, userCoordinate])
	}

	var coordinateRegion: MKCoordinateRegion {
		// TODO: This hard-coded zoom level sometimes doesn't capture the full route
		return MKCoordinateRegion(
			center: mapCenter,
			span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
		)
	}

	var body: some View {
		VStack {
			MapView(region: coordinateRegion, annotation: location, polyLine: polyLine)
				.accentColor(.blue)
				.edgesIgnoringSafeArea(.all)
		}
	}
}
