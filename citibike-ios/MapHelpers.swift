//
//  MapHelpers.swift
//  default
//
//  Created by Harrison Borges on 9/3/22.
//

import Foundation
import MapKit

extension Double {
	func toRadians() -> CGFloat {
		return (  (CGFloat(self)) / 180.0 * CGFloat(Double.pi)  )
	}

	func toDegrees() -> CLLocationDegrees {
		return CLLocationDegrees(  self * CGFloat(180.0 / .pi)  )
	}
}

func geographicMidpoint(between coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
	guard coordinates.count > 1 else {
		return coordinates.first ?? // return the only coordinate
		CLLocationCoordinate2D(latitude: 0, longitude: 0) // return null island if no coordinates were given
	}

	var x = Double(0)
	var y = Double(0)
	var z = Double(0)

	for coordinate in coordinates {
		let lat = coordinate.latitude.toRadians()
		let lon = coordinate.longitude.toRadians()
		x += cos(lat) * cos(lon)
		y += cos(lat) * sin(lon)
		z += 1*sin(lat)
	}

	x /= Double(coordinates.count)
	y /= Double(coordinates.count)
	z /= Double(coordinates.count)

	let lon = atan2(y, x)
	let hyp = sqrt(x * x + y * y)
	let lat = atan2(z, hyp)

	return CLLocationCoordinate2D(latitude: lat.toDegrees(), longitude: lon.toDegrees())
}
