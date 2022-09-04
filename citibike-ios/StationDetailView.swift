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
	var directions: StationRoute?

	var location: Location {
		return Location(name: station.name, coordinate: CLLocationCoordinate2D(latitude: Double(station.lat), longitude: Double(station.lon)))
	}

	var userLocation: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: ViewModel.shared.latitude, longitude: ViewModel.shared.longitude)
	}

	var polyLine: MKPolyline? {
		return directions?.directions.routes.first?.polyline
	}

	var mapCenter: CLLocationCoordinate2D {
		return geographicMidpoint(between: [location.coordinate, userLocation])
	}

	var coordinateRegion: MKCoordinateRegion {
		return MKCoordinateRegion(center: mapCenter, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
	}

	var body: some View {
		VStack {
			MapView(region: coordinateRegion, annotation: location, polyLine: polyLine)
				.navigationBarBackButtonHidden(true)
				.navigationBarItems(leading: BackButton())
				.edgesIgnoringSafeArea(.all)
		}
		.navigationBarBackButtonHidden(true)
	}
}
