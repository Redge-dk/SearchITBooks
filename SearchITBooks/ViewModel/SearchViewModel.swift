//
//  SearchViewModel.swift
//  SearchITBooks
//
//  Created by Regina on 6/29/25.
//
import Foundation

@MainActor
class SearchViewModel: ObservableObject {
	@Published var books: [BookInfo] = []
	@Published var error: Error?

	private let apiService = APIService()

	func search(keyword: String) {
		Task {
			do {
				let books = try await apiService.searchBooks(keyword: keyword)
				self.books = books
				self.error = nil
			} catch {
				self.books = []
				self.error = error
			}
		}
	}
}
