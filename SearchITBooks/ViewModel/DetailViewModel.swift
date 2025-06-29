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

	private let apiService = APIService()

	func fetchDetail(isbn13: String) {
		Task {
			do {
				let detailedBook = try await apiService.fetchBookDetail(isbn13: isbn13)
				self.book = detailedBook
				self.error = nil
			} catch {
				self.book = nil
				self.error = error
			}
		}
	}
}
