//
//  Station.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import Foundation

class Station: Codable, Identifiable {
	var id: String
	var name: String
	var bikeCount: String
	var bikes: [Bike]
	var lat: Float
	var lon: Float
	
	// Transient properties
	var travelDuration: TimeInterval = 0
	var hasCalculatedTravelDuration: Bool = false
	
	
	enum CodingKeys: String, CodingKey {
		case id, name, bikeCount, bikes, lat, lon
	}
}
