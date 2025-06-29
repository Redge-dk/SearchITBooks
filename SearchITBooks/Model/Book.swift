//
//  Book.swift
//  SearchITBooks
//
//  Created by Regina on 6/29/25.
//

/*
 {
	 error: "0",
	 total: "422",
	 page: "1",
	 books: [
		 {
			 title: "SQL Queries for Mere Mortals, 4th Edition",
			 subtitle: "A Hands-On Guide to Data Manipulation in SQL",
			 isbn13: "9780134858333",
			 price: "$18.13",
			 image: "https://itbook.store/img/books/9780134858333.png",
			 url: "https://itbook.store/books/9780134858333"
		 },
		 {
			 title: "SQL Server 2019 Administration Inside Out",
			 subtitle: "",
			 isbn13: "9780135561089",
			 price: "$48.15",
			 image: "https://itbook.store/img/books/9780135561089.png",
			 url: "https://itbook.store/books/9780135561089"
		 }
	 ]
 }
 */

struct BookSearchResponse: Decodable {
	let error: String
	let total: Int
	let page: Int
	let books: [Book]
	
	private enum CodingKeys: String, CodingKey {
		case error, total, page, books
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.error = try container.decode(String.self, forKey: .error)
		self.total = Int(try container.decode(String.self, forKey: .total)) ?? 0
		self.page = Int(try container.decode(String.self, forKey: .page)) ?? 1
		self.books = try container.decode([Book].self, forKey: .books)
	}
}

struct Book: Decodable {
	let title: String
	let subtitle: String
	let isbn13: String
	let price: String
	let image: String
	let url: String
}
