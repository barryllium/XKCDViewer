//
//  XKCDViewerTests.swift
//  XKCDViewerTests
//
//  Created by Brett Keck on 3/1/25.
//

import XCTest
@testable import XKCDViewer

final class XKCDViewerTests: XCTestCase {
    var viewModel: XKCDViewModel!
    
    override func setUp() {
        super.setUp()
        
        viewModel = XKCDViewModel()
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
        
        XCTAssertNotNil(viewModel.item)
        XCTAssertFalse(viewModel.showNotFoundAlert)
    }
    
    func testFetchItem1000000NotFound() async {
        await viewModel.fetchComic(number: "1000000")
        
        XCTAssertNil(viewModel.item)
        XCTAssertTrue(viewModel.showNotFoundAlert)
    }
    
    
    func testFetchItemNegative1InvalidUrl() async {
        await viewModel.fetchComic(number: "abcd")
        
        XCTAssertNil(viewModel.item)
        XCTAssertTrue(viewModel.showInvalidURLAlert)
    }
}
