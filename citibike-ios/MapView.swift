//
//  MapView.swift
//  default
//
//  Created by Harrison Borges on 9/3/22.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
	let region: MKCoordinateRegion
	let annotation: Location
	let polyLine: MKPolyline?

	// Create the MKMapView using UIKit.
	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		mapView.region = region

		mapView.showsUserLocation = true
		mapView.addAnnotation(MKPointAnnotation(__coordinate: annotation.coordinate))

		if let polyLine = polyLine {
			mapView.addOverlay(polyLine)
		}

		return mapView
	}

	// We don't need to worry about this as the view will never be updated.
	func updateUIView(_ view: MKMapView, context: Context) {}

	// Link it to the coordinator which is defined below.
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

}

class Coordinator: NSObject, MKMapViewDelegate {
	var parent: MapView

	init(_ parent: MapView) {
		self.parent = parent
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let routePolyline = overlay as? MKPolyline {
			let renderer = MKPolylineRenderer(polyline: routePolyline)
			renderer.strokeColor = UIColor.systemBlue
			renderer.lineWidth = 10
			return renderer
		}
		return MKOverlayRenderer()
	}
}
