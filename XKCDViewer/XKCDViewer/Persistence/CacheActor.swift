//
//  CacheActor.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import Foundation

protocol CacheActor: Sendable {
    func fetchComic(for id: String) async -> XKCDComic?
    func add(_ comic: XKCDComic) async throws
}

/* Used for when iOS version is < 17 (SwiftData not available)
   The class is never actually accessed, but a CacheActor must be
   passed into the XKCDViewModel instance */
actor NoCacheActor: CacheActor {
    func fetchComic(for id: String) -> XKCDComic? { return nil }
    
    func add(_ comic: XKCDComic) throws {}
}
