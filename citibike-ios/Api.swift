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
	case unknownError(String)
	case serverError(ServerError)
}

struct ServerError: Codable {
	var error: String
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
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			var viewData: Home? = nil
			
			guard let response = response as? HTTPURLResponse else {
				completion(.failure(.unknownError("could not unwrap response object")))
				return
			}
			
			if response.statusCode == 422 {
				do {
					let errorData = try JSONDecoder().decode(ServerError.self, from: data!)
					completion(.failure(.serverError(errorData)))
					return
				} catch {
					completion(.failure(.unknownError("could not decode server error")))
					return
				}
			}
			
			do {
				viewData = try JSONDecoder().decode(Home.self, from: data!)
			} catch {
				completion(.failure(.unknownError("could not decode server data")))
				return
			}
			
			DispatchQueue.main.async {
				guard let home = viewData else {
					completion(.failure(.unknownError("could not unwrap server data")))
					return
				}
				
				completion(.success(home))
			}
		}.resume()
	}
}
