//
//  StationRoute.swift
//  citibike-ios
//
//  Created by Quinn Shanahan on 9/3/22.
//

import Foundation

struct StationRoute {
	var expectedTravelTime: TimeInterval
	
	init(expectedTravelTime: TimeInterval) {
		self.expectedTravelTime = expectedTravelTime
	}
	
	var travelTimeInMinutes: String {
		let minutes = (expectedTravelTime / 60)
		
	  return String(format: "%.0f min", minutes)
	}
}
