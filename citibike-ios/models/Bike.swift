//
//  BikeStatus.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import UIKit
import SwiftUI

struct Bike: Decodable, Identifiable {
	var id: String
	var range: String
	var batteryIcon: String
	var isNextGen: Bool
}
