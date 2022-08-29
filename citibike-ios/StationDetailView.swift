//
//  StationDetailView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/29/22.
//

import SwiftUI
import MapKit

struct StationDetailView: View {
	var station: Station
	// users location
	
	@State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.7250541, longitude: -73.9527657), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
	
	var locations: [Location] {
		return [
			Location(name: station.name, coordinate: CLLocationCoordinate2D(latitude: station.lat, longitude: station.lon)),
			Location(name: "You", coordinate: CLLocationCoordinate2D(latitude: 40.7250541, longitude: -73.9527657))
		]
	}
	
	var body: some View {
		VStack {
			NavigationView {
				Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
					MapAnnotation(coordinate: location.coordinate) {
						Text(location.name)
					}
				}
//				.navigationTitle("London Explorer")
			}
			Text("Station Detail")
		}
	}
}


//struct StationDetailView_Previews: PreviewProvider {
//	static var previews: some View {
//		StationDetailView(station: Station(from: "{}"))
//	}
//}
