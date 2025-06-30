//
//  SearchITBooksTests.swift
//  SearchITBooksTests
//
//  Created by Regina on 6/29/25.
//

import XCTest
@testable import SearchITBooks

final class SearchITBooksTests: XCTestCase {

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testExample() throws {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		// Any test you write for XCTest can be annotated as throws and async.
		// Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
		// Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
	}

	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}

	func testBookSearchResponseDecoding() throws {
		let json = """
		{
			"error": "0",
			"total": "422",
			"page": "1",
			"books": [
				{
					"title": "SQL Queries for Mere Mortals, 4th Edition",
					"subtitle": "A Hands-On Guide to Data Manipulation in SQL",
					"isbn13": "9780134858333",
					"price": "$18.13",
					"image": "https://itbook.store/img/books/9780134858333.png",
					"url": "https://itbook.store/books/9780134858333"
				},
				{
					"title": "SQL Server 2019 Administration Inside Out",
					"subtitle": "",
					"isbn13": "9780135561089",
					"price": "$48.15",
					"image": "https://itbook.store/img/books/9780135561089.png",
					"url": "https://itbook.store/books/9780135561089"
				}
			]
		}
		"""
		let data = json.data(using: .utf8)!
		let decoded = try JSONDecoder().decode(BookSearchResponse.self, from: data)
		XCTAssertEqual(decoded.books.count, 2)
		XCTAssertEqual(decoded.books.first?.title, "SQL Queries for Mere Mortals, 4th Edition")
	}

	func testBookDetailResponseDecoding() throws {
		let json = """
		{
			"error": "0",
			"title": "SQL Queries for Mere Mortals, 4th Edition",
			"subtitle": "A Hands-On Guide to Data Manipulation in SQL",
			"authors": "John L. Viescas",
			"publisher": "Addison-Wesley",
			"language": "English",
			"isbn10": "0134858336",
			"isbn13": "9780134858333",
			"pages": "960",
			"year": "2018",
			"rating": "4",
			"desc": "SQL Queries for Mere Mortals has earned worldwide praise as the clearest, simplest tutorial on writing effective queries with the latest SQL standards and database applications. Now, author John L. Viescas has updated this hands-on classic with even more advanced and valuable techniques.Step by step...",
			"price": "$18.13",
			"image": "https://itbook.store/img/books/9780134858333.png",
			"url": "https://itbook.store/books/9780134858333"
		}
		"""
		let data = json.data(using: .utf8)!
		let decoded = try JSONDecoder().decode(BookDetailResponse.self, from: data)
		XCTAssertEqual(decoded.book.title, "SQL Queries for Mere Mortals, 4th Edition")
		XCTAssertEqual(decoded.book.detail?.authors, "John L. Viescas")
	}
	
	func testBookDetailResponseDecodingWithPdf() throws {
		let json = """
		{
			"error": "0",
			"title": "Securing DevOps",
			"subtitle": "Security in the Cloud",
			"authors": "Julien Vehent",
			"publisher": "Manning",
			"language": "English",
			"isbn10": "1617294136",
			"isbn13": "9781617294136",
			"pages": "384",
			"year": "2018",
			"rating": "4",
			"desc": "An application running in the cloud can benefit from incredible efficiencies, but they come with unique security threats too. A DevOps team&#039;s highest priority is understanding those risks and hardening the system against them.Securing DevOps teaches you the essential techniques to secure your c...",
			"price": "$39.65",
			"image": "https://itbook.store/img/books/9781617294136.png",
			"url": "https://itbook.store/books/9781617294136",
			"pdf": {
				"Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf",
				"Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"
			}
		}
		"""
		let data = json.data(using: .utf8)!
		let decoded = try JSONDecoder().decode(BookDetailResponse.self, from: data)
		XCTAssertEqual(decoded.book.title, "Securing DevOps")
		XCTAssertEqual(decoded.book.detail?.authors, "Julien Vehent")
	}
		

	@MainActor
	func testPaginationLogic() async {
		let mock = MockAPIService()
		
		mock.searchResult = BookSearchResponse(error: "0", total: 20, page: 1, books: (1...10).map {
			BookInfo(title: "Book \($0)", subtitle: "Subtitle \($0)", isbn13: "\($0)", price: "$\($0)", image: "image:\($0)", url: "url:\($0)")
		   })
		
		let viewModel = SearchViewModel(service: mock)
		
		await viewModel.search(keyword: "keyword")
		
		XCTAssertFalse(viewModel.books.isEmpty, "검색 결과가 비어있음")
		let initialBooks = viewModel.books
		let initialPage = viewModel.currentPage
		
		mock.searchResult = BookSearchResponse(error: "0", total: 20, page: 2, books: (1...10).map {
			BookInfo(title: "Book \($0)", subtitle: "Subtitle \($0)", isbn13: "\($0)", price: "$\($0)", image: "image:\($0)", url: "url:\($0)")
		   })
		
		await viewModel.loadNextPage(currentIndex: initialBooks.count - 1)

		XCTAssertEqual(viewModel.currentPage, initialPage + 1, "currentPage가 증가해야 함")
		XCTAssertTrue(viewModel.books.count > initialBooks.count, "books가 append되어야 함")	}

}
