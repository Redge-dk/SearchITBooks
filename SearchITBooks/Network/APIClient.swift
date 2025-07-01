//
//  APIClient.swift
//  SearchITBooks
//
//  Created by Regina on 6/29/25.
//
import Foundation

class APIClient {

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


