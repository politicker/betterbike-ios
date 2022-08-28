//
//  Api.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import Foundation
import CoreLocation

enum NetworkError: Error {
	case badUrl
	case badRequest
	case unknownError
}

struct API {
	func fetchStations(lat: Double, lon: Double, completion: @escaping (Result<Home, NetworkError>) -> ()) {
		guard let url = URL(string: "http://localhost:8081") else {
			completion(.failure(.badUrl))
			return
		}
		
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "content-type")

		
		let json: [String: Any] = ["Lat": lat, "Lon": lon]
		var jsonData: Data?
		do {
			jsonData = try JSONSerialization.data(withJSONObject: json)
		} catch {
			completion(.failure(.badRequest))
		}

		request.httpMethod = "POST"
		request.httpBody = jsonData

		URLSession.shared.dataTask(with: request) { (data, _, _) in
			var response: Home? = nil
			do {
				response = try JSONDecoder().decode(Home.self, from: data!)
			} catch {
				completion(.failure(.unknownError))
			}
			
			DispatchQueue.main.async {
				guard let home = response else {
					completion(.failure(.unknownError))
					return
				}
				
				print(home)
				completion(.success(home))
			}
		}.resume()
	}
}
