//
//  MockAPIService.swift
//  SearchITBooks
//
//  Created by Regina on 6/30/25.
//
import Foundation
@testable import SearchITBooks

class MockAPIService: APIServiceProtocol {
	
	var searchResult: BookSearchResponse?
	var detailResult: BookDetailResponse?
	
	func searchBooks(keyword: String, page: Int) async throws -> BookSearchResponse {
		if let result = searchResult {
			return result
		} else {
			throw APIError.noData
		}
	}
	
	func fetchBookDetail(isbn13: String) async throws -> BookDetailResponse {
		if let result = detailResult {
			return result
		} else {
			throw APIError.noData
		}
	}
}
