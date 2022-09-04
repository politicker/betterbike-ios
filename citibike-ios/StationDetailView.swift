//
//  StationDetailView.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/29/22.
//
import SwiftUI
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


struct BackButton: View {
	@Environment(\.presentationMode) var mode: Binding<PresentationMode>

	var body: some View {
		Button("Back") {
			self.mode.wrappedValue.dismiss()
		}
		.foregroundColor(Color("Foreground"))
		.padding()
		.background(Color("Background"))
		.clipShape(Capsule())
	}
}


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
//			mapView.setVisibleMapRect(polyLine.boundingMapRect, animated: true)
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

struct StationDetailView: View {
	var station: Station
	var directions: StationRoute?

	var location: Location {
		return Location(name: station.name, coordinate: CLLocationCoordinate2D(latitude: Double(station.lat), longitude: Double(station.lon)))
	}

	var userLocation: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: ViewModel.shared.latitude, longitude: ViewModel.shared.longitude)
	}

	var polyLine: MKPolyline? {
		return directions?.directions.routes.first?.polyline
	}

	var mapCenter: CLLocationCoordinate2D {
		return geographicMidpoint(between: [location.coordinate, userLocation])
	}

	var body: some View {
		VStack {
			MapView(region: MKCoordinateRegion(center: mapCenter, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), annotation: location, polyLine: polyLine)
				.navigationBarBackButtonHidden(true)
				.navigationBarItems(leading: BackButton())
				.edgesIgnoringSafeArea(.all)
				.onAppear {

				}
		}
		.navigationBarBackButtonHidden(true)
	}
}
