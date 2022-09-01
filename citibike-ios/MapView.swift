//
//  MapView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/31/22.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: View {
	@State var travelTime: TimeInterval = 0
	@State var isLoading: Bool = true
	@State var hasCalculated: Bool = false

	var body: some View {
		Text(self.isLoading ? "Loading" : String(self.travelTime))
			.onAppear {
				if !hasCalculated {
					getDirections()
				}
			}
	}

	func getDirections() {
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.720035, longitude: -73.9538756), addressDictionary: nil))
		request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.7229829, longitude: -73.951701), addressDictionary: nil))
		request.transportType = .walking
		
		let directions = MKDirections(request: request)
		
		directions.calculate { response, error in
			guard let unwrappedResponse = response else {
				print("error")
				return
			}

			for route in unwrappedResponse.routes {
				self.travelTime = route.expectedTravelTime
				self.isLoading = false
				self.hasCalculated = true
				
				print(route.expectedTravelTime)
			}
		}
	}
}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView(travelTime: 379)
	}
}
