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
	
	private(set) var currentPage = 1
	private(set) var totalCount = 0
	private(set) var isLoading = false
	private(set) var currentKeyword = ""

	private let apiService: APIServiceProtocol

	init(service: APIServiceProtocol = APIService()) {
		self.apiService = service
	}

	func search(keyword: String, page: Int = 1) async {
		guard isLoading == false else { return }
		isLoading = true
		
		defer { isLoading = false }
		
		do {
			let result = try await apiService.searchBooks(keyword: keyword, page: page)
			self.currentKeyword = keyword
			self.currentPage = page
			self.totalCount = result.total

			if page == 1 {
				self.books = result.books
			} else {
				self.books += result.books
			}
			self.error = nil
		} catch {
			if page == 1 {
				self.books = []
			}
			self.error = error
		}
	}
	
	func loadNextPage(currentIndex: Int) async {
		guard currentIndex == books.count - 1 else { return }
		guard books.count < totalCount else { return }
		await search(keyword: currentKeyword, page: currentPage + 1)
	}
	
	func reset() {
		self.books = []
		self.error = nil
		self.currentPage = 1
		self.totalCount = 0
		self.isLoading = false
		self.currentKeyword = ""
	}
}
