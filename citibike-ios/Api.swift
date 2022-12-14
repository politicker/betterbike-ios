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

let url = Bundle.main.object(forInfoDictionaryKey: "API_URL") as! String

struct API {	
	func fetchStations(coordinate: CLLocationCoordinate2D) async -> Result<Home, NetworkError> {
		guard let url = URL(string: url) else {
			return .failure(.badUrl)
		}
		
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "content-type")
		
		let json: [String: Any] = ["Lat": coordinate.latitude, "Lon": coordinate.longitude]
		var jsonData: Data?
		do {
			jsonData = try JSONSerialization.data(withJSONObject: json)
		} catch {
			return .failure(.badRequest)
		}
		
		request.httpMethod = "POST"
		request.httpBody = jsonData
		
		let data: Data?
		let response: URLResponse?
		
		do {
			(data, response) = try await URLSession.shared.data(for: request)
		} catch {
			return .failure(.unknownError(error.localizedDescription))
		}

		guard let response = response as? HTTPURLResponse else {
			return .failure(.unknownError("could not unwrap response object"))
		}
		
		if response.statusCode == 422 {
			do {
				let errorData = try JSONDecoder().decode(ServerError.self, from: data!)
				return .failure(.serverError(errorData))
			} catch {
				return .failure(.unknownError("could not decode server error"))
			}
		}

		do {
			let viewData = try JSONDecoder().decode(Home.self, from: data!)
			return .success(viewData)
		} catch {
			return .failure(.unknownError("could not decode server data"))
		}
	}
}
