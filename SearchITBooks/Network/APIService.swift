//
//  APIService.swift
//  SearchITBooks
//
//  Created by Regina on 6/29/25.
//
import Foundation

class APIService {
	private let client = APIClient()

	func searchBooks(keyword: String, completion: @escaping (Result<[BookInfo], Error>) -> Void) {
		let encoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? keyword
		guard let url = URL(string: "https://api.itbook.store/1.0/search/\(encoded)") else {
			completion(.failure(APIError.invalidURL))
			return
		}

		client.request(url: url, type: BookSearchResponse.self) { result in
			switch result {
			case .success(let response):
				completion(.success(response.books))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	func searchBooks(keyword: String, page: Int) async throws -> BookSearchResponse {
		let encoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? keyword
		guard let url = URL(string: "https://api.itbook.store/1.0/search/\(encoded)") else {
			throw APIError.invalidURL
		}

		return try await client.request(url: url, responseType: BookSearchResponse.self)
	}
	
	func fetchBookDetail(isbn13: String) async throws -> BookDetailResponse {
		guard let url = URL(string: "https://api.itbook.store/1.0/books/\(isbn13)") else {
			throw APIError.invalidURL
		}
		
		return try await client.request(url: url, responseType: BookDetailResponse.self)
	}
	
}
