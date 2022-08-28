//
//  Home.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import Foundation



struct Home: Codable {
	var shortDate: String {
		let parser = DateFormatter()
		parser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

		if let date = parser.date(from: lastUpdated) {
			return date.timeAgoDisplay()
		}

		return ""
	}
	
	
	
	var lastUpdated: String
	var stations: [Station]
}


extension Date {
		func timeAgoDisplay() -> String {
				let formatter = RelativeDateTimeFormatter()
				formatter.unitsStyle = .full
				return formatter.localizedString(for: self, relativeTo: Date())
		}
}
