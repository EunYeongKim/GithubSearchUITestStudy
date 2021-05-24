//
//  GithubSearchUITestStudyUITests.swift
//  GithubSearchUITestStudyUITests
//
//  Created by 60080252 on 2021/05/21.
//

import XCTest

class GithubSearchUITestStudyUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        
    }

    func test_검색결과가_존재하는지() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("EunYeongKim\n")
        
        let resultCellOfFirst = app.cells.firstMatch
        XCTAssertTrue(resultCellOfFirst.waitForExistence(timeout: 15.0))
    }
    
    func test_검색결과가_초기화되는지() {
        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("eunyeongKim\n")
        
        let resultCellOfFirst = app.cells.firstMatch
        XCTAssertTrue(resultCellOfFirst.waitForExistence(timeout: 15.0))
        
        if let stringValue = searchField.value as? String {
            searchField.tap()
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
            searchField.typeText(deleteString)
            XCTAssertFalse(resultCellOfFirst.waitForExistence(timeout: 1.0))
        }
    }

    func test_스크롤시_페이지네이션동작하는지() {
        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("Hello\n")
        
        let resultCells = app.cells
        XCTAssertTrue(resultCells.firstMatch.waitForExistence(timeout: 15.0))
        let firstResultCount = resultCells.count
        
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.exists)
        
        tableView.swipeUp()
        XCTAssertNotEqual(firstResultCount, resultCells.count)
    }
    
    func test_셀선택시_상세화면으로_이동하는지() {
        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("jangdta\n")
        
        let resultCellOfFirst = app.cells.firstMatch
        XCTAssertTrue(resultCellOfFirst.waitForExistence(timeout: 15.0))
        
        XCTAssertTrue(resultCellOfFirst.isHittable)
        resultCellOfFirst.tap()
        
        let safariVC = app.otherElements.webViews.firstMatch
        XCTAssertTrue(safariVC.waitForExistence(timeout: 15.0))
    }
}
