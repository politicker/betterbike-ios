//
//  Station.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import Foundation

struct Station: Codable, Identifiable {
	var id: String
	var name: String
	var bikeCount: String
	var bikes: [Bike]
	var lat: Float
	var lon: Float
}
