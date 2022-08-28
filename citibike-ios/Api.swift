//
//  Api.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import Foundation

let defaultLatitude = ""
let defaultLongitude = ""

struct API {
	func fetchStations(lat: String = defaultLatitude, lon: String = defaultLongitude, completion: @escaping (Home) -> ()) {
		guard let url = URL(string: "http://localhost:8081") else { return }

		URLSession.shared.dataTask(with: url) { (data, _, _) in
			let response = try! JSONDecoder().decode(Home.self, from: data!)
			print(response)
			
			DispatchQueue.main.async {
				completion(response)
			}
		}.resume()
	}
}
