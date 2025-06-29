//
//  APIClient.swift
//  SearchITBooks
//
//  Created by Regina on 6/29/25.
//
import Foundation

class APIClient {
	
	//completion
	func request<T: Decodable>(url: URL, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard let data = data else {
				completion(.failure(APIError.noData))
				return
			}

			do {
				let decoded = try JSONDecoder().decode(T.self, from: data)
				completion(.success(decoded))
			} catch {
				completion(.failure(error))
			}
		}
		task.resume()
	}
	
	//async/await
	func request<T: Decodable>(url: URL, responseType: T.Type) async throws -> T {
		let (data, _) = try await URLSession.shared.data(from: url)

		do {
			let decoded = try JSONDecoder().decode(T.self, from: data)
			return decoded
		} catch {
			throw APIError.decodingFailed
		}
	}
}


