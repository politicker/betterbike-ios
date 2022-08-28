//
//  BikeStatus.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import UIKit
import SwiftUI

struct Bike: Codable, Identifiable {
	var id: String
	var range: String
	var batteryIcon: String
	
	
	func batteryColor() -> Color {
		switch batteryIcon {
			case "battery.25":
				return Color.red
			case "battery.50":
				return Color.orange
			case "battery.75":
				return Color.yellow
			case "battery.100":
				return Color.green
			default:
				return Color.black
		}
	}
}
