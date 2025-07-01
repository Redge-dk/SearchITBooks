//
//  DetailViewModel.swift
//  SearchITBooks
//
//  Created by Regina on 6/29/25.
//
import Foundation

@MainActor
class DetailViewModel: ObservableObject {
	@Published var book: BookInfo?
	@Published var error: Error?

	private let apiService: APIServiceProtocol

	init(service: APIServiceProtocol = APIService()) {
		self.apiService = service
	}

	func fetchDetail(isbn13: String) async {
		do {
			let response = try await apiService.fetchBookDetail(isbn13: isbn13)
			
			if response.error != "0" {
				self.book = nil
				self.error = APIError.error(response.error)
			} else {
				self.book = response.book
				self.error = nil
			}
			
		} catch {
			self.book = nil
			self.error = error
		}
	}
}
