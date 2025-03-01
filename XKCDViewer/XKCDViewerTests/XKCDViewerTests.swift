//
//  XKCDViewerTests.swift
//  XKCDViewerTests
//
//  Created by Brett Keck on 3/1/25.
//

import XCTest
@testable import XKCDViewer

@MainActor
final class XKCDViewerTests: XCTestCase {
    var viewModel: XKCDViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        
        viewModel = XKCDViewModel(cacheActor: NoCacheActor())
        viewModel.apiClient = MockAPIClient()
    }
    
    func testXKCDComic() {
        let data = Bundle.main.decode(XKCDComic.self, from: .item100)
        let comic = try? JSONDecoder().decode(XKCDComic.self, from: JSONEncoder().encode(data))
        
        XCTAssertNotNil(comic)
        
        XCTAssertEqual(comic!.month, "5")
        XCTAssertEqual(comic!.number, 100)
        XCTAssertEqual(comic!.link, "")
        XCTAssertEqual(comic!.year, "2006")
        XCTAssertEqual(comic!.news, "")
        XCTAssertEqual(comic!.safeTitle, "Family Circus")
        XCTAssertTrue(comic!.transcript.hasPrefix("[[Picture shows a pathway"))
        XCTAssertEqual(comic!.alt, "This was my friend David's idea")
        XCTAssertEqual(comic!.image, "https://imgs.xkcd.com/comics/family_circus.jpg")
        XCTAssertEqual(comic!.title, "Family Circus")
        XCTAssertEqual(comic!.day, "10")
        XCTAssertEqual(comic!.date, "May 10, 2006")
    }
    
    func testFetchItem100() async {
        await viewModel.fetchComic(number: "100")
        
        XCTAssertNotNil(viewModel.comic)
        XCTAssertFalse(viewModel.showNotFoundMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testFetchItem1000000NotFound() async {
        await viewModel.fetchComic(number: "1000000")
        
        XCTAssertNil(viewModel.comic)
        XCTAssertTrue(viewModel.showNotFoundMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    
    func testFetchItemInvalidUrl() async {
        await viewModel.fetchComic(number: "abcd")
        
        XCTAssertNil(viewModel.comic)
        XCTAssertTrue(viewModel.showErrorAlert)
        XCTAssertEqual(viewModel.errorAlertState, .invalidURL)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLoadComic() {
        viewModel.loadComic(number: "100")
        
        XCTAssertEqual(viewModel.navigationPath, ["100"])
    }
    
    func testClearComic() {
        viewModel.navigationPath = ["100"]
        viewModel.showAlert()
        viewModel.dismissComic()
        
        XCTAssertEqual(viewModel.navigationPath, [])
        XCTAssertNil(viewModel.comic)
        XCTAssertNil(viewModel.errorAlertState)
        XCTAssertFalse(viewModel.showErrorAlert)
        XCTAssertFalse(viewModel.isLoading)
    }
}
