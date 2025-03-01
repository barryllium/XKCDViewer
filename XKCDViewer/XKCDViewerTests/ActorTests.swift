//
//  ActorTests.swift
//  XKCDViewerTests
//
//  Created by Brett Keck on 3/1/25.
//

import XCTest
@testable import XKCDViewer

@available(iOS 17.0, *)
@MainActor
final class ActorTests: XCTestCase {
    var comicCacheActor = ComicCacheActor.previewInstance()
    var viewModel: XKCDViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        
        viewModel = XKCDViewModel(cacheActor: comicCacheActor)
        viewModel.apiClient = MockAPIClient()
    }
    
    func testCacheInsertion() async throws {
        let data = Bundle.main.decode(XKCDComic.self, from: .item100)
        let comic = try? JSONDecoder().decode(XKCDComic.self, from: JSONEncoder().encode(data))
        
        var fetchedComic = await comicCacheActor.fetchComic(for: "\(comic!.number)")
        XCTAssertNil(fetchedComic)
        
        try await comicCacheActor.add(comic!)
        
        fetchedComic = await comicCacheActor.fetchComic(for: "\(comic!.number)")
        XCTAssertNotNil(fetchedComic)
    }
}
