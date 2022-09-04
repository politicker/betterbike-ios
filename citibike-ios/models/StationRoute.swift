//
//  StationRoute.swift
//  citibike-ios
//
//  Created by Quinn Shanahan on 9/3/22.
//

import Foundation
import CoreLocation
import CoreLocationUI
import MapKit

struct StationRoute {
	var directions: MKDirections.Response
	
	init(directions: MKDirections.Response) {
		self.directions = directions
	}
	
	var travelTimeInMinutes: String {
		guard let seconds = directions.routes.first?.expectedTravelTime else {
			return ""
		}

		let minutes = (seconds / 60)
		
	  return String(format: "%.0f", minutes)
	}
}
