//
//  DateExtension.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/28/22.
//

import Foundation

extension Date {
	func timeAgoDisplay() -> String {
		let formatter = RelativeDateTimeFormatter()
		formatter.unitsStyle = .full
		return formatter.localizedString(for: self, relativeTo: Date())
	}
}
