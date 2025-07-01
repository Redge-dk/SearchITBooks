//
//  SearchITBooksUITests.swift
//  SearchITBooksUITests
//
//  Created by Regina on 6/29/25.
//

import XCTest

final class SearchITBooksUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	@MainActor
	func testSearchResultsAreDisplayed() {
		let app = XCUIApplication()
		app.launch()
		
		let searchField = app.searchFields.firstMatch
		XCTAssertTrue(searchField.exists)
		
		searchField.tap()
		searchField.typeText("Swift")
		app.keyboards.buttons["Search"].tap()

		let firstCell = app.tables.cells.firstMatch
		let exists = firstCell.waitForExistence(timeout: 5)
		
		XCTAssertTrue(exists, "검색 결과 셀이 나타나야 함")
	}
	
	@MainActor
	func testPaginationLoadsMoreResults() {
		let app = XCUIApplication()
		app.launch()
		
		let searchField = app.searchFields.firstMatch
		XCTAssertTrue(searchField.exists)

		searchField.tap()
		searchField.typeText("Swift")
		app.keyboards.buttons["Search"].tap()

		let tableView = app.tables["SearchTableView"]
		XCTAssertTrue(tableView.waitForExistence(timeout: 5))

		let startCount = tableView.cells.count

		tableView.swipeUp()
		sleep(2) // 다음 페이지 로딩 시간 대기

		let endCount = tableView.cells.count
		XCTAssertTrue(endCount > startCount, "스크롤 후 결과가 더 많아야 함")
	}

	@MainActor
	func testTapCellShowsDetailView() {
		let app = XCUIApplication()
		app.launch()

		let searchField = app.searchFields.firstMatch
		searchField.tap()
		searchField.typeText("Swift")
		app.keyboards.buttons["Search"].tap()

		let firstCell = app.tables.cells.firstMatch
		XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
		firstCell.tap()

		let detailTitle = app.staticTexts["DetailLabelTitle"]
		XCTAssertTrue(detailTitle.waitForExistence(timeout: 5), "디테일 화면으로 전환돼야 함")
	}
	
	@MainActor
	func testErrorViewAppearsOnFailedSearch() {
		let app = XCUIApplication()
		app.launch()
		
		let searchField = app.searchFields.firstMatch
		searchField.tap()
		searchField.typeText("k")
		app.keyboards.buttons["Search"].tap()

		let errorView = app.otherElements["SearchViewError"]
		XCTAssertTrue(errorView.waitForExistence(timeout: 3), "에러 뷰가 표시되어야 함")
	}

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
