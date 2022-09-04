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
		.foregroundColor(Color("Foreground"))
		.padding()
		.background(Color("Background"))
		.clipShape(Capsule())
	}
}

struct StationDetailView: View {
	var station: Station
	var userLocation: Location

	var location: Location {
		return Location(name: station.name, coordinate: CLLocationCoordinate2D(latitude: Double(station.lat), longitude: Double(station.lon)))
	}

	@State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: ViewModel.shared.latitude, longitude: ViewModel.shared.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

	var body: some View {
		VStack {
			Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: [location]) { location in
				MapPin(coordinate: location.coordinate)
			}
			.navigationBarBackButtonHidden(true)
			.navigationBarItems(leading: BackButton())
			.ignoresSafeArea()
		}
		.navigationBarBackButtonHidden(true)
	}
}
