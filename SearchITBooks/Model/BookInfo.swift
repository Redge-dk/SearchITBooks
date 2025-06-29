//
//  BookInfo.swift
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
	let books: [BookInfo]
	
	private enum CodingKeys: String, CodingKey {
		case error, total, page, books
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.error = try container.decode(String.self, forKey: .error)
		self.total = Int(try container.decode(String.self, forKey: .total)) ?? 0
		self.page = Int(try container.decode(String.self, forKey: .page)) ?? 1
		self.books = try container.decode([BookInfo].self, forKey: .books)
	}
}

/*
 {
	 error: "0",
	 title: "SQL Queries for Mere Mortals, 4th Edition",
	 subtitle: "A Hands-On Guide to Data Manipulation in SQL",
	 authors: "John L. Viescas",
	 publisher: "Addison-Wesley",
	 language: "English",
	 isbn10: "0134858336",
	 isbn13: "9780134858333",
	 pages: "960",
	 year: "2018",
	 rating: "4",
	 desc: "SQL Queries for Mere Mortals has earned worldwide praise as the clearest, simplest tutorial on writing effective queries with the latest SQL standards and database applications. Now, author John L. Viescas has updated this hands-on classic with even more advanced and valuable techniques.Step by step...",
	 price: "$18.13",
	 image: "https://itbook.store/img/books/9780134858333.png",
	 url: "https://itbook.store/books/9780134858333"
 }
 */
struct BookDetailResponse: Decodable {
	let error: String
	let book: BookInfo

	private enum CodingKeys: String, CodingKey {
		case error,
			 //BookInfo
			 title, subtitle, isbn13, price, image, url,
			 //BookDetailInfo
			 authors, publisher, language, isbn10, pages, year, rating, desc, pdf
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.error = try container.decode(String.self, forKey: .error)

		let detail = BookDetailInfo(
			authors: try container.decode(String.self, forKey: .authors),
			publisher: try container.decode(String.self, forKey: .publisher),
			language: try container.decode(String.self, forKey: .language),
			isbn10: try container.decode(String.self, forKey: .isbn10),
			pages: try container.decode(String.self, forKey: .pages),
			year: try container.decode(String.self, forKey: .year),
			rating: try container.decode(String.self, forKey: .rating),
			desc: try container.decode(String.self, forKey: .desc),
			pdf: try container.decodeIfPresent([String : String].self, forKey: .pdf) ?? [:]
		)

		self.book = BookInfo(
			title: try container.decode(String.self, forKey: .title),
			subtitle: try container.decode(String.self, forKey: .subtitle),
			isbn13: try container.decode(String.self, forKey: .isbn13),
			price: try container.decode(String.self, forKey: .price),
			image: try container.decode(String.self, forKey: .image),
			url: try container.decode(String.self, forKey: .url),
			detail: detail
		)
	}
}

struct BookInfo: Decodable {
	let title: String
	let subtitle: String
	let isbn13: String
	let price: String
	let image: String
	let url: String
	var detail: BookDetailInfo? = nil
}

struct BookDetailInfo: Decodable {
	let authors: String
	let publisher: String
	let language: String
	let isbn10: String
	let pages: String
	let year: String
	let rating: String
	let desc: String
	var pdf = [String: String]()
}
